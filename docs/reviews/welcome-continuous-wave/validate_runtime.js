async page => {
  await page.evaluate(async()=>{for(const r of await navigator.serviceWorker.getRegistrations())await r.unregister();for(const k of await caches.keys())await caches.delete(k);});
  await page.goto('http://127.0.0.1:8765/?wave=continuous-final');
  await page.waitForFunction(() => document.querySelector('model-viewer')?.loaded);
  const validation=await page.evaluate(async()=>{
    const v=document.querySelector('model-viewer');
    if(!v.src.endsWith('manggala_welcome_wave_30s.glb'))throw new Error('Wrong asset: '+v.src);
    const s=v[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')];
    const clipDurations={};v.pause();v.animationCrossfadeDuration=0;
    for(const name of v.availableAnimations){v.animationName=name;await v.updateComplete;clipDurations[name]=v.duration;}
    v.animationName='Wave';await v.updateComplete;v.play();v.pause();
    const h=s.getObjectByName('mixamorigHead'),arm=s.getObjectByName('mixamorigRightArm');
    const body=s.getObjectByName('MESH-Meshy-LocalMouth-Talk');
    const samples=[];let faceError=0;
    const cam=h.position.clone();s.camera.getWorldPosition(cam);
    for(let frame=0;frame<=900;frame++){
      v.currentTime=frame===900?29.999999:frame/30;s.updateMatrixWorld(true);
      const anchor=h.position.clone().set(0,.12,0);h.localToWorld(anchor);
      const q=h.quaternion.clone();h.getWorldQuaternion(q);
      const forward=anchor.clone().set(0,0,1).applyQuaternion(q).normalize();
      const aim=cam.clone().sub(anchor).normalize();
      faceError=Math.max(faceError,Math.acos(Math.min(1,Math.max(-1,forward.dot(aim))))*180/Math.PI);
      if(frame%7===0)samples.push({t:v.currentTime,arm:arm.quaternion.toArray(),mouth:[...body.morphTargetInfluences]});
    }
    const variation=(key,i)=>Math.max(...samples.map(x=>x[key][i]))-Math.min(...samples.map(x=>x[key][i]));
    v.play();v.currentTime=29.75;await new Promise(r=>setTimeout(r,1000));
    const afterWrap=v.currentTime;
    const r=await fetch(v.src,{cache:'no-store'}),bytes=await r.arrayBuffer();
    const hash=[...new Uint8Array(await crypto.subtle.digest('SHA-256',bytes))].map(x=>x.toString(16).padStart(2,'0')).join('');
    const result={clipDurations,faceErrorDeg:faceError,framesChecked:901,mouthTargets:body.morphTargetDictionary,
      armVariation:Math.max(...[0,1,2,3].map(i=>variation('arm',i))),
      mouthVariation:Math.max(...[0,1,2].map(i=>variation('mouth',i))),afterWrap,
      assetBytes:bytes.byteLength,sha256:hash,camera:v.cameraOrbit,fov:v.getFieldOfView()};
    if(Object.keys(clipDurations).length!==6||Object.values(clipDurations).some(x=>x!==30)||faceError>.1||result.mouthVariation<.1||result.armVariation<.01||afterWrap>=2||hash!=='cb8e5d8cca8af20aa458442f0c38b5c69b30a23eb9002ecbc04c3ca59e57b46e')throw new Error(JSON.stringify(result));
    return result;
  });
  await page.evaluate(r=>window.welcomeWaveValidation=r,validation);
  await page.evaluate(()=>document.querySelector('flt-semantics-placeholder')?.click());
  for(const [w,h] of [[411,731],[1080,1920],[2160,3840]]){
    await page.setViewportSize({width:w,height:h});
    await page.evaluate(()=>{const v=document.querySelector('model-viewer');v.pause();v.currentTime=.267;});
    await page.screenshot({path:`docs/reviews/welcome-continuous-wave/welcome-${w}.png`});
  }
  await page.evaluate(()=>{window.departedWelcome=document.querySelector('model-viewer');window.departedWelcome.play();});
  await page.getByRole('button',{name:'Mulai Tantangan',exact:true}).click();
  const immediate=await page.evaluate(()=>window.departedWelcome.paused);
  await page.waitForTimeout(800);
  const departed=await page.evaluate(()=>({paused:window.departedWelcome.paused,connected:window.departedWelcome.isConnected,source:window.departedWelcome.getAttribute('src')}));
  if(!immediate||!departed.paused||departed.connected||departed.source!==null)throw new Error('Departure '+JSON.stringify({immediate,departed}));
  await page.getByRole('button',{name:'Kembali',exact:true}).click();
  await page.waitForFunction(()=>document.querySelector('model-viewer')?.loaded);
  const returned=await page.evaluate(()=>({count:document.querySelectorAll('model-viewer').length,paused:document.querySelector('model-viewer').paused,clip:document.querySelector('model-viewer').animationName}));
  if(returned.count!==1||returned.paused||returned.clip!=='Wave')throw new Error('Return '+JSON.stringify(returned));
  await page.evaluate(r=>window.welcomeWaveValidation={...window.welcomeWaveValidation,...r},{immediatePaused:immediate,departed,returned});
}
