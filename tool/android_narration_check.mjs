import {readFileSync,writeFileSync} from 'node:fs';
import {tap,wait,adb} from './android_mascot_ui.mjs';
import {connectMascot} from './android_mascot_cdp.mjs';
const u=readFileSync('output/r30-16-device-backup/vm-endpoint.txt','utf8').trim();
const v=await(await fetch(u+'getVM')).json();
const id=v.result.isolates.find(i=>i.name==='main').id;
const lang=process.argv[2]||'id';
await fetch(u+'ext.kifc.reviewPage?'+new URLSearchParams({isolateId:id,page:'score',lang}));
await wait(900);tap(({id:'Selesai',en:'Closing Message',ko:'완료'})[lang]);
const start=Date.now(),results=[];
for(let i=0;i<20;i++){
  try {
    const c=await connectMascot();
    const sample=await c.evaluate("(()=>{const v=document.querySelector('model-viewer'),s=v[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')],m=s?.getObjectByName('MESH-Meshy-LocalMouth-Talk');return {clip:v.animationName,loaded:v.loaded,paused:v.paused,time:v.currentTime,mouth:m?[...m.morphTargetInfluences]:null}})()");
    results.push({ms:Date.now()-start,...sample});
    if(sample.clip==='Wave'&&sample.loaded&&!results.some(x=>x.screenshot)){
      adb('shell','screencap','-p','/data/local/tmp/kifc-narration.png');
      adb('pull','/data/local/tmp/kifc-narration.png','docs/client-revisions/2026-11-03/r30-17-18/closing-'+lang+'-android.png');
      results.at(-1).screenshot=true;
    }
    c.close();
  } catch(error){results.push({ms:Date.now()-start,error:String(error)});}
  await wait(350);
}
writeFileSync('docs/client-revisions/2026-11-03/r30-17-18/closing-'+lang+'-playback.json',JSON.stringify(results,null,2));
console.log(JSON.stringify(results));
