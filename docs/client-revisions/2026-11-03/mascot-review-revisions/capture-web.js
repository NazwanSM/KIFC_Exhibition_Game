async page => {
  const results=[];
  for(const [w,h] of [[360,640],[411,731],[720,1280],[1080,1920],[2160,3840]]){
    await page.setViewportSize({width:w,height:h});
    for(const lang of ['id','en','ko'])for(const card of (w===1080?[0,1,2]:[0])){
      await page.goto(`http://127.0.0.1:8781/?page=karhutlaCards&lang=${lang}&card=${card}`);
      await page.waitForFunction(()=>[...document.querySelectorAll('model-viewer')].some(v=>v.loaded),null,{timeout:20000});
      await page.waitForTimeout(900);
      const filename=`docs/client-revisions/2026-11-03/mascot-review-revisions/web-${lang}-${w}-card${card+1}.jpg`;
      await page.screenshot({path:filename,type:'jpeg',quality:72});
      results.push({lang,viewport:[w,h],card:card+1,filename,source:'Flutter web review; silent timeline'});
    }
  }
  await page.evaluate(r=>window.readingCaptures=r,results);
}
