"""Summarize actual release-browser runs; no assumed TV or pass budgets."""
import json
from pathlib import Path
from statistics import median

root = Path('build/browser-perf')
groups = {}
for label, directory in [('before', 'final-before'), ('after', 'optimized-results'), ('png', 'png-optimized-results')]:
    runs = json.loads((root / directory / 'results.json').read_text())
    stages = {}
    for name in ['welcome', 'assembly', 'video-feedback', 'reading']:
        samples = [next(s for s in r['stages'] if s['name'] == name) for r in runs]
        stages[name] = {
            'raf_callback_hz_median': median(s['rafHz'] for s in samples),
            'raf_interval_p95_ms_median': median(s['p95Ms'] for s in samples),
            'main_thread_task_ms_per_second_median': median(s['taskMs'] * 1000 / s['duration'] for s in samples),
            'js_heap_used_bytes_median': median(s['heapUsed'] for s in samples),
        }
    resources = [r['evidence']['resources'] for r in runs]
    groups[label] = {'runs': len(runs), 'environment': runs[0]['environment'], 'stages': stages,
        'glb_requests_per_journey': [sum('.glb' in x['name'] for x in entries) for entries in resources],
        'viewer_js_requests_per_journey': [sum('model-viewer.min.js' in x['name'] for x in entries) for entries in resources],
        'mascot_resource_transfer_bytes_median': median(sum(x['transferSize'] for x in entries if '.glb' in x['name'] or 'model-viewer.min.js' in x['name']) for entries in resources),
        'first_model_load_ms': [r['evidence']['loads'][0]['time'] for r in runs if r['evidence']['loads']],
        'input_to_next_raf_ms': [n for r in runs for n in r['evidence']['inputs']],
        'rendered_dpr_values': sorted({s['renderedDpr'] for r in runs for s in r['evidence']['renderScales']}),
        'javascript_errors': [e for r in runs for e in r['errors']]}
before = groups['before']['stages']['reading']['main_thread_task_ms_per_second_median']
after = groups['after']['stages']['reading']['main_thread_task_ms_per_second_median']
result = {'scope': 'Desktop Chrome release-web benchmark; not QM43B-T emulation',
    'absolute_performance_budgets': 'NOT ASSESSED: no project.yaml FPS/memory/load budgets',
    'target_tv_performance': 'NOT ASSESSED: no target hardware measurements',
    'groups': groups, 'reading_main_thread_task_reduction_percent': (1 - after / before) * 100,
    'notes': ['rAF callback rate is not measured GLB rendered FPS or GPU time.',
              'TaskDuration is browser main-thread work, not total system CPU utilization.',
              'JS heap excludes total browser/native/GPU/WASM memory.',
              'Network cache disabled in fresh contexts; model-viewer decoded cache still reuses the GLB within each journey.',
              'Active reading measurement begins after the same visible phrase; PNG uses its production 4-second narration fallback.',
              'PNG is a diagnostic control, not a shipped visual replacement.']}
result['four_k_reading'] = {}
for label, directory in [('before', '4k-before'), ('after', '4k-optimized')]:
    run = json.loads((root / directory / 'results.json').read_text())[0]
    stage = next(s for s in run['stages'] if s['name'] == 'reading')
    result['four_k_reading'][label] = {
        'runs': 1, 'viewport': run['environment']['viewport'],
        'raf_callback_hz': stage['rafHz'], 'raf_interval_p95_ms': stage['p95Ms'],
        'main_thread_task_ms_per_second': stage['taskMs'] * 1000 / stage['duration'],
    }
(root / 'summary.json').write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print(json.dumps({'reading_main_thread_task_reduction_percent': result['reading_main_thread_task_reduction_percent'],
    'groups': {name: {'reading': g['stages']['reading'], 'glb_requests': g['glb_requests_per_journey'],
                    'load_ms': g['first_model_load_ms'], 'dpr_values': g['rendered_dpr_values']} for name, g in groups.items()}}, indent=2))
