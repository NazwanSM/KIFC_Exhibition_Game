async page => {
  await page.emulateMedia({reducedMotion: 'no-preference'});
  const results=[];
  await page.evaluate(async()=>{for(const r of await navigator.serviceWorker.getRegistrations())await r.unregister();for(const k of await caches.keys())await caches.delete(k);});
  const cases=[['welcome','Wave'],['triangleBuild','PointIdle'],['triangleExplanation','PointIdle'],['karhutlaCards','PointIdle'],['peatCharacteristics','PointIdle'],['finalReview','FeedbackSilent'],['closing','WaveSilent']];
  for(const [w,h] of [[360,640],[720,1280]]){
    await page.setViewportSize({width:w,height:h});
    for(const lang of ['id','en','ko']){
      for(const [screen,clip] of cases){
        await page.goto(`http://127.0.0.1:8766/?page=${screen}&lang=${lang}`);
        await page.waitForFunction(clip=>[...document.querySelectorAll('model-viewer')].some(v=>v.loaded&&v.animationName===clip),clip,{timeout:15000});
        const data=await page.evaluate(clip=>{
          const v=[...document.querySelectorAll('model-viewer')].find(v=>v.loaded&&v.animationName===clip);v.pause();v.currentTime=1.213;
          const s=v[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')];s.updateMatrixWorld(true);
          const m=s.getObjectByName('MESH-Meshy-LocalMouth-Talk');
          const rect=v.getBoundingClientRect();
          return {clip,duration:v.duration,mouth:[...m.morphTargetInfluences],renderSize:[v.clientWidth,v.clientHeight],displaySize:[rect.width,rect.height]};
        },clip);
        if(data.duration!==30)throw new Error('Invalid duration');
        if(clip!=='Wave'&&data.mouth.some((x,i)=>Math.abs(x-[1,0,0][i])>1e-6))throw new Error('Unvoiced mouth moving '+JSON.stringify(data));
        if(w>=1080&&data.renderSize[1]<data.displaySize[1]*.95)throw new Error('Low resolution '+JSON.stringify(data));
        await page.screenshot({path:`docs/client-revisions/2026-11-02/r30-16/${screen}-${lang}-${w}.jpg`,type:'jpeg',quality:72});
        results.push({screen,lang,viewport:[w,h],...data});
      }
    }
  }
  await page.evaluate(r=>window.mascotExtraCaptureResults=r,results);
}
