import {readFileSync,writeFileSync} from 'node:fs';
import {adb,tap,wait} from './android_mascot_ui.mjs';
import {connectMascot} from './android_mascot_cdp.mjs';
const lang=process.argv[2]||'id';
const root='docs/client-revisions/2026-11-03/r30-19/';
const u=readFileSync('output/r30-16-device-backup/vm-endpoint.txt','utf8').trim();
const vm=await(await fetch(u+'getVM')).json();
const id=vm.result.isolates.find(i=>i.name==='main').id;
await fetch(u+'ext.kifc.reviewPage?'+new URLSearchParams({isolateId:id,page:'triangleExplanation',lang}));
await wait(1200);tap(({id:'Lanjut',en:'Continue',ko:'계속'})[lang]);
const start=Date.now(),samples=[];
for(let i=0;i<26;i++){
  try {
    const c=await connectMascot();
    const s=await c.evaluate("(()=>{const v=document.querySelector('model-viewer'),s=v[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')],m=s?.getObjectByName('MESH-Meshy-LocalMouth-Talk');return {clip:v.animationName,loaded:v.loaded,paused:v.paused,time:v.currentTime,mouth:m?[...m.morphTargetInfluences]:null}})()");
    samples.push({ms:Date.now()-start,...s});c.close();
  }catch(e){samples.push({ms:Date.now()-start,error:String(e)});}
  if(i===5||i===13||i===22){
    const name=`${lang}-${i}.png`;
    adb('shell','screencap','-p','/data/local/tmp/kifc-reading.png');
    adb('pull','/data/local/tmp/kifc-reading.png',root+name);
  }
  await wait(350);
}
writeFileSync(root+lang+'-samples.json',JSON.stringify(samples,null,2));
console.log(JSON.stringify({lang,samples:samples.length,clips:[...new Set(samples.map(x=>x.clip).filter(Boolean))]}));
