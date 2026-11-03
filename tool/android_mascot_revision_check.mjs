import {readFileSync,writeFileSync} from 'node:fs';
import {adb,tap,wait} from './android_mascot_ui.mjs';
import {connectMascot} from './android_mascot_cdp.mjs';
const root='docs/client-revisions/2026-11-03/mascot-review-revisions/';
const u=readFileSync('output/r30-16-device-backup/vm-endpoint.txt','utf8').trim();
const vm=await(await fetch(u+'getVM')).json();
const isolateId=vm.result.isolates.find(i=>i.name==='main').id;
async function page(page){
  const result=await(await fetch(u+'ext.kifc.reviewPage?'+new URLSearchParams({isolateId,page,lang:'id'}))).json();
  if(result.error)throw new Error(JSON.stringify(result.error));
  await wait(1100);
}
function screenshot(name){
  adb('shell','screencap','-p','/data/local/tmp/kifc-mascot-revision.png');
  adb('pull','/data/local/tmp/kifc-mascot-revision.png',root+'android-'+name+'.png');
}
await page('triangleExplanation');tap('Lanjut');
const started=Date.now(),samples=[];
let firstTarget,readingStartMs,previousTime=0,restarted=false;
for(let i=0;i<38;i++){
  let c;
  try{
    c=await connectMascot();
    const state=await c.evaluate(`(()=>{const v=document.querySelector('model-viewer');if(v?.loaded&&!window.revisionMarker){window.revisionMarker='retained';window.extraModelLoads=0;v.addEventListener('load',()=>window.extraModelLoads++);}const s=v?.[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')],m=s?.getObjectByName('MESH-Meshy-LocalMouth-Talk');return {clip:v?.animationName,loaded:v?.loaded,paused:v?.paused,time:v?.currentTime,marker:window.revisionMarker,extraLoads:window.extraModelLoads,mouth:m?[...m.morphTargetInfluences]:null};})()`);
    if(state.loaded&&state.clip==='Talk'){
      if(!firstTarget){firstTarget=c.target.id;readingStartMs=Date.now()-started;}
      if(state.time<previousTime-1)restarted=true;
      previousTime=state.time;
    }
    samples.push({ms:Date.now()-started,target:c.target.id,...state});
  }catch(error){samples.push({ms:Date.now()-started,error:String(error)});}finally{c?.close();}
  if(i===7||i===18||i===32)screenshot('reading-'+i);
  await wait(350);
}
// AnimatedSwitcher briefly retains the outgoing triangle page; measure from
// the first loaded Talk on the reading page, including the next reading.
const loaded=samples.filter(x=>x.loaded&&x.marker&&x.ms>=readingStartMs-20);
const baseline=loaded.find(x=>x.clip==='Talk'&&x.time>.25);
const settled=baseline?loaded.filter(x=>x.ms>=baseline.ms):[];
const retention={scope:'After initial load settles through automatic continuation to the next reading',sameTarget:loaded.every(x=>x.target===firstTarget),initialLoadEvents:baseline?.extraLoads,noAdditionalLoad:!!settled.length&&settled.every(x=>x.extraLoads===baseline.extraLoads),clipRestartObserved:restarted,samples};
writeFileSync(root+'android-retention.json',JSON.stringify(retention,null,2));
if(!firstTarget||!loaded.length||!retention.sameTarget||!retention.noAdditionalLoad||!restarted)throw new Error('Renderer retention check failed');
await page('risk');tap('B. Hutan rawa gambut');
let happy;
for(let i=0;i<30;i++){
  let c;
  try{
    c=await connectMascot();
    happy=await c.evaluate(`(()=>{const v=document.querySelector('model-viewer');if(!v?.loaded)return null;const s=v[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')];return {clip:v.animationName,loaded:v.loaded,paused:v.paused,arm:s.getObjectByName('mixamorigRightArm')?.quaternion.toArray()};})()`);
  }catch{}finally{c?.close();}
  if(happy?.clip==='Happy')break;
  await wait(250);
}
if(happy?.clip!=='Happy'||happy.paused)throw new Error('Happy not playing');
screenshot('happy');
writeFileSync(root+'android-happy.json',JSON.stringify(happy,null,2));
await page('welcome');
console.log(JSON.stringify({sameTarget:retention.sameTarget,noAdditionalLoad:retention.noAdditionalLoad,clipRestartObserved:restarted,happy:happy.clip}));
