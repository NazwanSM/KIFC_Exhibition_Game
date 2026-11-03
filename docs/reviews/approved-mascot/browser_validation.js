async page => {
  const results = await page.evaluate(async () => {
    const v=document.querySelector('model-viewer');
    const s=v[Object.getOwnPropertySymbols(v).find(s=>s.description==='scene')];
    v.pause(); v.animationCrossfadeDuration=0;
    const clips=[];
    for(const name of v.availableAnimations){
      v.animationName=name; await v.updateComplete;
      v.play(); v.currentTime=29.7;
      const start=v.currentTime;
      const hips=s.getObjectByName('mixamorigHips');
      const before=hips.position.toArray();
      await new Promise(r=>setTimeout(r,850));
      v.pause(); s.updateMatrixWorld(true);
      clips.push({name,duration:v.duration,start,end:v.currentTime,wrapped:v.currentTime<start,
        hipsDisplacement:Math.hypot(...hips.position.toArray().map((x,i)=>x-before[i]))});
    }
    return clips;
  });
  if(results.some(x=>x.duration!==30||!x.wrapped)) throw new Error(JSON.stringify(results));
  console.log(JSON.stringify({playback:results}));
  for(const [w,h] of [[411,731],[1080,1920],[2160,3840]]){
    await page.setViewportSize({width:w,height:h});
    for(const [language,code] of [['Bahasa Indonesia','id'],['English','en'],['한국어','ko']]){
      await page.getByRole('button',{name:language,exact:true}).click();
      await page.evaluate(async()=>{const v=document.querySelector('model-viewer');v.pause();v.animationCrossfadeDuration=0;v.animationName='Wave';await v.updateComplete;v.currentTime=1.213;});
      await page.screenshot({path:`docs/reviews/approved-mascot/welcome-${code}-${w}.png`});
    }
  }
  await page.getByRole('button',{name:'Bahasa Indonesia',exact:true}).click();
  await page.setViewportSize({width:1080,height:1920});
  for(const name of ['Idle','Talk','Wave','Happy','Feedback','PointIdle']){
    await page.evaluate(async name=>{const v=document.querySelector('model-viewer');v.pause();v.animationName=name;await v.updateComplete;v.currentTime=name==='Talk'?24.031:1.213;},name);
    await page.screenshot({path:`docs/reviews/approved-mascot/clip-${name}.png`});
  }
  await page.evaluate(async()=>{const v=document.querySelector('model-viewer');v.animationName='Wave';await v.updateComplete;v.play();});
}
