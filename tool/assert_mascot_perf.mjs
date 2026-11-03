// Assert observed browser behavior, not source text or assumed performance.
import {readFileSync} from 'node:fs';
import assert from 'node:assert/strict';
const runs=JSON.parse(readFileSync(process.argv[2],'utf8'));
assert(runs.length>0,'No browser measurements');
for(const run of runs) {
  assert.equal(run.errors.length,0,'Browser JavaScript errors');
  if(!run.has3d)continue;
  const glb=run.evidence.resources.filter(r=>r.name.includes('manggala_game_states.glb'));
  assert.equal(glb.length,1,'The same GLB must not be fetched through both Flutter warmup and model-viewer');
  const js=run.evidence.resources.filter(r=>r.name.includes('model-viewer.min.js'));
  assert.equal(js.length,1,'The already imported viewer module must not be loaded as unused Flutter bytes');
  for(const s of run.stages)assert.equal(s.model?.loaded,true,'Model missing in '+s.name);
  assert(run.evidence.loads.some(m=>m.clip==='Talk'),'Narrated Talk was not exercised');
}
console.log('Browser mascot loading checks passed for '+runs.length+' runs.');
