async page => {
  await page.addInitScript(()=>{
    window.readingAudio=[];
    const play=HTMLMediaElement.prototype.play;
    HTMLMediaElement.prototype.play=function(){
      if((this.currentSrc||this.src).includes('/narration/prepared/')) window.readingAudio.push(this);
      return play.apply(this,arguments);
    };
  });
  await page.setViewportSize({width:1080,height:1920});
  await page.reload();
  await page.waitForSelector('flt-semantics-placeholder',{state:'attached'});
  await page.evaluate(()=>document.querySelector('flt-semantics-placeholder').click());
  await page.getByRole('button',{name:'Lanjut',exact:true}).click();
  async function started(key){
    await page.waitForFunction(k=>window.readingAudio.some(a=>a.src.includes(k)&&!a.paused&&a.currentTime>.2),key,{timeout:18000});
    return page.evaluate(k=>{const a=window.readingAudio.find(x=>x.src.includes(k));return {src:a.src,time:a.currentTime,paused:a.paused}},key);
  }
  const first=await started('karhutla-definition');
  await page.waitForTimeout(1500);
  await page.screenshot({path:'docs/client-revisions/2026-11-03/r30-19/web-id-audio-active.png'});
  const second=await started('karhutla-cause');
  await page.getByRole('button',{name:'Lanjut',exact:true}).click();
  const third=await started('karhutla-prevention');
  await page.getByRole('button',{name:'Mulai Kuis',exact:true}).click();
  await page.waitForTimeout(700);
  await page.getByRole('button',{name:'B. Hutan rawa gambut',exact:true}).waitFor();
  const final=await page.evaluate(()=>({voice:window.readingAudio.map(a=>({src:a.src,paused:a.paused})),text:document.body.innerText}));
  if(final.voice.some(a=>!a.paused))throw new Error('Narration continued after leaving reading');
  if(!final.text.includes('Hutan rawa gambut'))throw new Error('Risk question not reached');
  await page.evaluate(r=>window.readingAudioResults=r,{first,second,third,final});
}
