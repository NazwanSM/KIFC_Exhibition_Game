async page => {
  for(const [w,h] of [[411,731],[1080,1920],[2160,3840]]){
    await page.setViewportSize({width:w,height:h});
    for(const [language,code] of [['Bahasa Indonesia','id'],['English','en'],['한국어','ko']]){
      await page.getByRole('button',{name:language,exact:true}).click();
      await page.waitForTimeout(700);
      await page.evaluate(async()=>{const v=document.querySelector('model-viewer');v.pause();v.animationCrossfadeDuration=0;v.animationName='Wave';await v.updateComplete;v.currentTime=1.213;});
      await page.screenshot({path:`docs/reviews/approved-mascot/welcome-${code}-${w}.png`});
    }
  }
  await page.getByRole('button',{name:'Bahasa Indonesia',exact:true}).click();
  await page.waitForTimeout(700);
  const delivery=await page.evaluate(async()=>{const r=await fetch('assets/assets/models/manggala_user_approved.glb',{cache:'no-store'});const b=await r.arrayBuffer();const hash=await crypto.subtle.digest('SHA-256',b);return {status:r.status,bytes:b.byteLength,sha256:[...new Uint8Array(hash)].map(x=>x.toString(16).padStart(2,'0')).join('')};});
  if(delivery.status!==200||delivery.sha256!=='58a6ef5974fd64720c84b93898013f9e096cad94c2682f8bba3dde2c834b4356')throw new Error(JSON.stringify(delivery));
  await page.evaluate(async()=>{const v=document.querySelector('model-viewer');v.animationName='Wave';await v.updateComplete;v.play();});
}
