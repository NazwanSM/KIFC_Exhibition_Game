async page => {
  await page.evaluate(() => {
    const v=document.createElement('model-viewer');v.id='mascot-poster-export';
    v.src='assets/assets/models/manggala_game_states.glb';
    v.setAttribute('camera-orbit','-0.3977650321286112rad 1.4829576043125434rad 3.5m');
    v.setAttribute('camera-target','0.14820505678653717m 0.9663659296929836m -0.07670897245407104m');
    for(const a of ['field-of-view','min-field-of-view','max-field-of-view'])v.setAttribute(a,'0.6661117646972256rad');
    v.style.cssText='position:fixed;left:0;top:0;width:2100px;height:1009px;z-index:99999;background:transparent';
    document.body.append(v);
  });
  await page.waitForFunction(()=>document.getElementById('mascot-poster-export').loaded);
  for(const [name,clip] of [['idle','Idle'],['welcome','Wave'],['presenting','PointIdle'],['talking','TalkSilent'],['success','Happy'],['hintSafety','FeedbackSilent'],['farewell','WaveSilent']]){
    await page.evaluate(async clip=>{const v=document.getElementById('mascot-poster-export');v.animationCrossfadeDuration=0;v.animationName=clip;await v.updateComplete;v.pause();v.currentTime=0;await new Promise(requestAnimationFrame);await new Promise(requestAnimationFrame);},clip);
    const downloadPromise=page.waitForEvent('download');
    await page.evaluate(async name=>{
      const v=document.getElementById('mascot-poster-export');const image=new Image();image.src=v.toDataURL('image/png');await image.decode();
      const canvas=document.createElement('canvas');canvas.width=Math.round(image.height*.75);canvas.height=image.height;
      canvas.getContext('2d').drawImage(image,(image.width-canvas.width)/2,0,canvas.width,canvas.height,0,0,canvas.width,canvas.height);
      const a=document.createElement('a');a.href=canvas.toDataURL('image/png');a.download=name+'.png';a.click();
    },name);
    const download=await downloadPromise;await download.saveAs('assets/images/mascot3d/'+name+'.png');
  }
  await page.evaluate(()=>document.getElementById('mascot-poster-export').remove());
}
