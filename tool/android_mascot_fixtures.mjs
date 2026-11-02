import {readFileSync,writeFileSync} from 'node:fs';
import {connectMascot} from './android_mascot_cdp.mjs';
import {adb,nodes,wait,screenshot} from './android_mascot_ui.mjs';
const root='docs/client-revisions/2026-11-02/r30-16/';
const endpoint=readFileSync('output/r30-16-device-backup/vm-endpoint.txt','utf8').trim();
const vm=await(await fetch(endpoint+'getVM')).json();
const isolate=vm.result.isolates.find(i=>i.name==='main').id;
const results=[];
async function page(name,lang='id') {
  const q=new URLSearchParams({isolateId:isolate,page:name,lang});
  const response=await(await fetch(endpoint+'ext.kifc.reviewPage?'+q)).json();
  if(response.error)throw new Error(JSON.stringify(response.error));
  await wait(700);
}
async function state(label,clip) {
  let data;
  for(let i=0;i<45;i++) {
    let c;
    try {
      c=await connectMascot();
      data=await c.evaluate(`(()=>{const v=document.querySelector('model-viewer');if(!v?.loaded)return null;v.pause();const s=v[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')],m=s.getObjectByName('MESH-Meshy-LocalMouth-Talk');let maxMouthError=0;for(const t of [.137,1.213,7.43,16.29,29.7]){v.currentTime=t;maxMouthError=Math.max(maxMouthError,...m.morphTargetInfluences.map((x,i)=>Math.abs(x-[1,0,0][i])));}v.currentTime=.267;v.play();return {loaded:v.loaded,clip:v.animationName,paused:v.paused,duration:v.duration,maxMouthError,camera:v.getAttribute('camera-orbit')};})()`);
      if(data?.clip===clip)break;
    } catch(error) {data={error:String(error)};} finally {c?.close();}
    await wait(250);
  }
  if(data?.clip!==clip||data.paused||data.duration!==30||(clip!=='Wave'&&data.maxMouthError>1e-6))throw new Error(label+JSON.stringify(data));
  await wait(350);screenshot(label);
  results.push({label,source:'actual Android debug APK; fixture-selected real Flutter page',...data});
  writeFileSync(root+'android-fixtures.json',JSON.stringify(results,null,2));
  console.log(label+' '+clip);
}
for(const lang of ['id','en','ko']) {
  await page('risk',lang);
  const choice=nodes().find(n=>n.label.startsWith('B.'));
  if(!choice)throw new Error('Missing correct peat answer '+lang);
  adb('shell','input','tap',...choice.center.map(x=>String(Math.round(x))));
  await state('risk-correct-'+lang,'Happy');
  await page('finalReview',lang);await state('final-review-'+lang,'FeedbackSilent');
  await page('closing',lang);await state('closing-'+lang,'WaveSilent');
}
await page('welcome');await state('welcome-final','Wave');
// Leave the review device on the normal welcome page, with its looping Wave.
writeFileSync(root+'android-fixtures.json',JSON.stringify(results,null,2));
console.log('Native fixture verification passed: '+results.length+' screens');
