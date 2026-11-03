async page => {
  await page.addInitScript(() => {
    window.voiceEvents=[]; window.voiceElements=[];
    const original=HTMLMediaElement.prototype.play;
    HTMLMediaElement.prototype.play=function(){
      const e={src:this.currentSrc||this.src,at:Date.now(),result:'pending'};
      window.voiceEvents.push(e);
      if(e.src.includes('/narration/'))window.voiceElements.push(this);
      const result=original.apply(this,arguments);
      result.then(()=>e.result='playing',error=>e.result=String(error));
      return result;
    };
  });
  await page.reload();
  await page.waitForSelector('flt-semantics-placeholder',{state:'attached'});
  await page.waitForTimeout(2500);
  const before=await page.evaluate(()=>window.voiceEvents.filter(x=>x.src.includes('/narration/')));
  if(before.length)throw new Error('Narration autoplayed before interaction');
  await page.evaluate(()=>document.querySelector('flt-semantics-placeholder').click());
  await page.getByRole('button',{name:'English',exact:true}).click();
  await page.waitForFunction(()=>window.voiceEvents.some(x=>x.src.includes('/narration/prepared/en/welcome.mp3')&&x.result==='playing'),null,{timeout:32000});
  const during=await page.evaluate(()=>window.voiceEvents.filter(x=>x.src.includes('/narration/')));
  await page.screenshot({path:'docs/client-revisions/2026-11-03/r30-17-18/welcome-en-web-1080.png'});
  await page.getByRole('button',{name:'Start Challenge',exact:true}).click();
  await page.waitForTimeout(700);
  const stopped=await page.evaluate(()=>window.voiceElements.every(a=>a.paused));
  if(!stopped)throw new Error('Narration remained playing after navigation');
  await page.evaluate(r=>window.narrationTestResults=r,{before,during,stopped});
}
