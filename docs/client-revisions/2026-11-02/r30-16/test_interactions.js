async page => {
  await page.emulateMedia({reducedMotion: 'no-preference'});
  const results=[];
  await page.evaluate(async()=>{for(const r of await navigator.serviceWorker.getRegistrations())await r.unregister();for(const k of await caches.keys())await caches.delete(k);});
  await page.setViewportSize({width:1080,height:1920});
  async function open(screen){await page.goto('http://127.0.0.1:8766/?page='+screen);await page.waitForSelector('flt-semantics-placeholder',{state:'attached'});await page.evaluate(()=>document.querySelector('flt-semantics-placeholder').click());await page.waitForSelector('flt-semantics',{state:'attached'});}
  async function clip(name){await page.waitForFunction(name=>[...document.querySelectorAll('model-viewer')].some(v=>v.loaded&&v.animationName===name),name,{timeout:15000});}
  async function inspect(label,name,silent=true){
    await clip(name);
    const r=await page.evaluate(({label,name,silent})=>{
      const v=[...document.querySelectorAll('model-viewer')].find(v=>v.loaded&&v.animationName===name);v.pause();
      const s=v[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')],mesh=s.getObjectByName('MESH-Meshy-LocalMouth-Talk');
      let maxMouthError=0;for(const t of [.137,1.213,7.43,16.29,29.7]){v.currentTime=t;maxMouthError=Math.max(maxMouthError,...mesh.morphTargetInfluences.map((x,i)=>Math.abs(x-[1,0,0][i])));}
      const out={label,clip:name,maxMouthError};if(silent&&maxMouthError>1e-6)throw new Error(JSON.stringify(out));
      v.currentTime=.267;v.play();window.oldMascot=v;return out;
    },{label,name,silent});results.push(r);
    await page.screenshot({path:`docs/client-revisions/2026-11-02/r30-16/${label}.jpg`,type:'jpeg',quality:78});
  }
  async function assertOldStopped(){await page.waitForTimeout(450);const r=await page.evaluate(()=>({paused:window.oldMascot.paused,src:window.oldMascot.getAttribute('src')}));if(!r.paused||r.src!==null)throw new Error('Old player active '+JSON.stringify(r));}
  await open('welcome');await inspect('welcome-playing','Wave',false);
  await page.getByRole('button',{name:'Mulai Tantangan',exact:true}).click();await assertOldStopped();await clip('PointIdle');
  const forest=page.getByRole('group',{name:'Area hutan untuk meletakkan unsur api',exact:true});
  async function drop(name){const a=await page.getByRole('img',{name:name==='Oksigen dari udara'?/Oksigen dari udara/:name,exact:true}).boundingBox(),b=await forest.boundingBox();if(!a||!b)throw new Error('Missing drag target '+name);await page.mouse.move(a.x+a.width/2,a.y+a.height/2);await page.mouse.down();await page.mouse.move(b.x+b.width/2,b.y+b.height/2,{steps:18});await page.mouse.up();await page.waitForTimeout(220);}
  await drop('Air');await inspect('assembly-wrong','FeedbackSilent');
  await drop('Percikan api');await clip('PointIdle');await drop('Kayu kering');await drop('Oksigen dari udara');await inspect('assembly-complete','Happy');
  await forest.click();await assertOldStopped();await inspect('triangle-explanation-active','PointIdle');
  await page.getByRole('button',{name:'Lanjut',exact:true}).click();await assertOldStopped();await inspect('reading-after-navigation','PointIdle');
  await open('risk');await page.getByRole('button',{name:'A. Hutan mangrove',exact:true}).click();await inspect('risk-wrong','FeedbackSilent');
  await page.getByRole('button',{name:'B. Hutan rawa gambut',exact:true}).click();await assertOldStopped();await inspect('risk-correct','Happy');
  await open('causeQuiz');await page.getByRole('button',{name:'Faktor alam',exact:true}).click();await inspect('cause-wrong','FeedbackSilent');
  await open('causeQuiz');await page.getByRole('button',{name:'Aktivitas manusia',exact:true}).click();await inspect('cause-correct','Happy');
  await open('peatCharacteristics');await clip('PointIdle');
  for(const i of [1,2,3])await page.getByRole('button',{name:new RegExp('^Kartu '+i+'\\.')}).click();
  if(!await page.getByRole('button',{name:'Kenali Dampaknya',exact:true}).isEnabled())throw new Error('Peat cards blocked');await inspect('peat-cards-open','PointIdle');
  await open('closing');await inspect('closing-playing','WaveSilent');await page.getByRole('button',{name:'Beranda',exact:true}).click();await assertOldStopped();await inspect('returned-welcome','Wave',false);
  await page.emulateMedia({reducedMotion:'reduce'});await page.waitForTimeout(450);
  if(await page.locator('model-viewer').count())throw new Error('Reduced motion still creates renderer');
  const reducedStopped=await page.evaluate(()=>window.oldMascot.paused);
  if(!reducedStopped)throw new Error('Reduced motion left player running');
  results.push({label:'reduced-motion',renderers:0,oldPaused:true});
  await page.screenshot({path:'docs/client-revisions/2026-11-02/r30-16/reduced-motion.jpg',type:'jpeg',quality:78});
  await page.emulateMedia({reducedMotion:'no-preference'});await clip('Wave');
  await page.evaluate(async()=>{for(const r of await navigator.serviceWorker.getRegistrations())await r.unregister();for(const k of await caches.keys())await caches.delete(k);});
  await open('karhutlaCards');await clip('PointIdle');
  await page.evaluate(()=>{const v=document.querySelector('model-viewer');window.failedViewer=v;v.src='assets/assets/models/missing-review-asset.glb';});
  await page.waitForFunction(()=>!document.querySelector('model-viewer'),{},{timeout:8000});
  await page.screenshot({path:'docs/client-revisions/2026-11-02/r30-16/renderer-failure-fallback.jpg',type:'jpeg',quality:78});
  results.push({label:'renderer-error',fallback:true,renderers:0});
  await page.evaluate(r=>window.mascotInteractionResults=r,results);
}
