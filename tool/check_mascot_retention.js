async page => {
  await page.goto('http://127.0.0.1:8780/?page=karhutlaCards');
  await page.waitForFunction(()=>document.querySelector('model-viewer')?.loaded);
  await page.waitForTimeout(700);
  await page.evaluate(()=>{
    window.retainedMascot=document.querySelector('model-viewer');
    window.extraLoads=0;
    window.retainedMascot.addEventListener('load',()=>window.extraLoads++);
    document.querySelector('flt-semantics-placeholder').click();
  });
  const start=Date.now();
  await page.getByRole('button',{name:'Lanjut',exact:true}).click();
  await page.waitForFunction(()=>document.querySelector('model-viewer')?.animationName==='Talk');
  const result=await page.evaluate(()=>({sameNode:window.retainedMascot===document.querySelector('model-viewer'),loaded:window.retainedMascot.loaded,extraLoads:window.extraLoads,clip:window.retainedMascot.animationName,placeholder:document.body.innerText.includes('Menyiapkan narasi')}));
  result.transitionMs=Date.now()-start;
  if(!result.sameNode||!result.loaded||result.extraLoads||result.placeholder)throw new Error(JSON.stringify(result));
  await page.evaluate(r=>window.mascotRetentionResult=r,result);
}
