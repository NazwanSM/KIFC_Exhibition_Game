// Release-web benchmark. Supply PLAYWRIGHT_MODULE when Playwright is not local.
// Browser timings are desktop evidence, never a Samsung TV hardware simulation.
import {mkdirSync, writeFileSync} from 'node:fs';
import {pathToFileURL} from 'node:url';
import {resolve} from 'node:path';
const moduleName = process.env.PLAYWRIGHT_MODULE || 'playwright';
const {chromium} = await import(moduleName.startsWith('C:') || moduleName.startsWith('D:')
  ? pathToFileURL(resolve(moduleName, 'index.mjs')).href : moduleName);
const base = process.env.PERF_URL || 'http://127.0.0.1:8792/before/';
const out = process.env.PERF_OUT || 'build/browser-perf/results-before';
const repeats = Number(process.env.PERF_REPEATS || 3);
const width = Number(process.env.PERF_WIDTH || 1080);
const height = Number(process.env.PERF_HEIGHT || 1920);
const cpuRate = Number(process.env.PERF_CPU_RATE || 1);
mkdirSync(out, {recursive:true});
const browser = await chromium.launch({channel:'chrome',headless:process.env.PERF_HEADED !== '1'});
const all = [];
try {
  for (let run = 0; run < repeats; run++) {
    const context = await browser.newContext({viewport:{width,height},deviceScaleFactor:1,
      reducedMotion:'no-preference',serviceWorkers:'block'});
    const page = await context.newPage();
    const cdp = await context.newCDPSession(page);
    await cdp.send('Network.enable');
    await cdp.send('Network.setCacheDisabled',{cacheDisabled:true});
    await cdp.send('Performance.enable');
    if(cpuRate !== 1) await cdp.send('Emulation.setCPUThrottlingRate',{rate:cpuRate});
    await page.addInitScript(() => {
      window.__mascotPerf={loads:[],longTasks:[],renderScales:[],inputs:[],nodes:0};
      new PerformanceObserver(list => {
        for(const e of list.getEntries())window.__mascotPerf.longTasks.push({start:e.startTime,duration:e.duration});
      }).observe({type:'longtask',buffered:true});
      const attached = new WeakSet();
      const observer=new MutationObserver(() => {
        for(const m of document.querySelectorAll('model-viewer')) {
          if(attached.has(m))continue;attached.add(m);window.__mascotPerf.nodes++;
          m.addEventListener('load',()=>window.__mascotPerf.loads.push({id:m.id,time:performance.now(),clip:m.animationName}));
          m.addEventListener('render-scale',e=>window.__mascotPerf.renderScales.push({...e.detail,time:performance.now()}));
        }
      });
      observer.observe(document,{childList:true,subtree:true});
      document.addEventListener('pointerup',()=>{
        const start=performance.now();requestAnimationFrame(()=>window.__mascotPerf.inputs.push(performance.now()-start));
      },true);
    });
    const errors=[];page.on('pageerror',e=>errors.push(e.message));
    await page.goto(base+'?run='+run,{waitUntil:'load'});
    await page.waitForFunction(()=>document.querySelector('flt-glass-pane'));
    await page.evaluate(()=>document.querySelector('flt-semantics-placeholder')?.click());
    await page.getByRole('button',{name:'Mulai Tantangan',exact:true}).waitFor({timeout:45000});
    const has3d = await page.locator('model-viewer').count()>0;
    if(has3d)await page.waitForFunction(()=>document.querySelector('model-viewer')?.loaded,{},{timeout:45000});
    await page.waitForTimeout(800);
    const environment=await page.evaluate(()=>{
      const c=document.createElement('canvas'),g=c.getContext('webgl2'),e=g?.getExtension('WEBGL_debug_renderer_info');
      const gpu=e?g.getParameter(e.UNMASKED_RENDERER_WEBGL):null;g?.getExtension('WEBGL_lose_context')?.loseContext();
      return {ua:navigator.userAgent,cores:navigator.hardwareConcurrency,gpu,viewport:[innerWidth,innerHeight],dpr:devicePixelRatio,visibility:document.visibilityState};
    });
    const stages=[];
    async function measure(name,ms=5000) {
      const profile = name === 'reading' && process.env.PERF_CPU_PROFILE === '1';
      if(profile){await cdp.send('Profiler.enable');await cdp.send('Profiler.start');}
      const before=(await cdp.send('Performance.getMetrics')).metrics;
      const sample=await page.evaluate(ms=>new Promise(resolve=>{
        const started=performance.now(),values=[];let last=started;
        function tick(now){values.push(now-last);last=now;if(now-started>=ms){
          const sorted=values.slice().sort((a,b)=>a-b),pct=p=>sorted[Math.min(sorted.length-1,Math.floor(sorted.length*p))];
          const m=document.querySelector('model-viewer');
          resolve({duration:now-started,rafCount:values.length,rafHz:values.length*1000/(now-started),p50Ms:pct(.5),p95Ms:pct(.95),p99Ms:pct(.99),over33ms:values.filter(v=>v>33.5).length,visibility:document.visibilityState,
            model:m?{loaded:m.loaded,clip:m.animationName,time:m.currentTime,paused:m.paused,rect:m.getBoundingClientRect().toJSON()}:null});
        }else requestAnimationFrame(tick)}requestAnimationFrame(tick);
      }),ms);
      const after=(await cdp.send('Performance.getMetrics')).metrics;
      if(profile){const result=await cdp.send('Profiler.stop');writeFileSync(out+'/'+run+'-reading.cpuprofile',JSON.stringify(result.profile));}
      const get=(a,n)=>a.find(x=>x.name===n)?.value||0;
      stages.push({name,...sample,taskMs:(get(after,'TaskDuration')-get(before,'TaskDuration'))*1000,
        scriptMs:(get(after,'ScriptDuration')-get(before,'ScriptDuration'))*1000,
        layoutMs:(get(after,'LayoutDuration')-get(before,'LayoutDuration'))*1000,
        heapUsed:get(after,'JSHeapUsedSize'),domNodes:get(after,'Nodes')});
      console.log(run,name,'rAF',sample.rafHz.toFixed(1),'p95',sample.p95Ms.toFixed(1),'task',stages.at(-1).taskMs.toFixed(0));
    }
    async function shot(name){await page.screenshot({path:out+'/'+run+'-'+name+'.png'});}
    async function fixedMascot(){if(has3d){await page.evaluate(()=>{const m=document.querySelector('model-viewer');m.pause();m.currentTime=1.25;});await page.waitForTimeout(150);}}
    if(process.env.PERF_VISUAL_ONLY === '1') {
      for(const [lang,label] of [['id','Bahasa Indonesia'],['en','English'],['ko','한국어']]) {
        await page.getByRole('button',{name:label,exact:true}).click();
        await page.waitForTimeout(800);await fixedMascot();await shot('welcome-'+lang);
      }
      all.push({run,base,environment,has3d,source:'fixed Wave time=1.25, welcome three languages'});
      writeFileSync(out+'/visual.json',JSON.stringify(all,null,2));
      await context.close();continue;
    }
    await measure('welcome');await fixedMascot();await shot('welcome');
    await page.getByRole('button',{name:'Mulai Tantangan',exact:true}).click();
    await page.getByText('Pilih tiga unsur api.',{exact:true}).waitFor();
    if(has3d)await page.waitForFunction(()=>document.querySelector('model-viewer')?.loaded);
    await measure('assembly');
    for(const label of ['Percikan api','Kayu kering','Oksigen dari udara']) {
      const from=page.getByRole('img',{name:label,exact:false});
      const target=page.getByRole('group',{name:/Area hutan/});
      const a=await from.boundingBox(),b=await target.boundingBox();
      await page.mouse.move(a.x+a.width/2,a.y+a.height/2);await page.mouse.down();
      await page.mouse.move(b.x+b.width/2,b.y+b.height/2,{steps:20});await page.mouse.up();
      await page.waitForTimeout(350);
    }
    await page.getByText('3/3 unsur',{exact:false}).waitFor();
    await measure('video-feedback');await shot('video-feedback');
    await page.mouse.click(width*.5,height*.22);
    await page.getByRole('button',{name:'Lanjut',exact:true}).waitFor();
    await page.getByRole('button',{name:'Lanjut',exact:true}).click();
    if(has3d)await page.waitForFunction(()=>document.querySelector('model-viewer')?.loaded&&document.querySelector('model-viewer')?.animationName==='Talk');
    // PNG mode starts narration via its production fallback deadline. Compare
    // active narration in both modes, not its initial silent waiting period.
    await page.waitForFunction(()=>document.body.innerText.includes('Kebakaran hutan adalah'),{},{timeout:15000});
    await measure('reading',7000);await fixedMascot();await shot('reading');
    const evidence=await page.evaluate(()=>({...window.__mascotPerf,resources:performance.getEntriesByType('resource').filter(r=>/glb|model-viewer|canvaskit|main.dart/.test(r.name)).map(r=>({name:r.name,start:r.startTime,end:r.responseEnd,duration:r.duration,transferSize:r.transferSize,encodedBodySize:r.encodedBodySize})),text:document.body.innerText}));
    const result={run,base,environment,has3d,cpuRate,stages,evidence,errors};
    all.push(result);writeFileSync(out+'/results.json',JSON.stringify(all,null,2));
    await context.close();
  }
} finally {await browser.close();}
