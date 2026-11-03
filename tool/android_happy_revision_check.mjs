import {readFileSync,writeFileSync} from 'node:fs';
import {adb,tap,wait} from './android_mascot_ui.mjs';
import {connectMascot} from './android_mascot_cdp.mjs';
const root='docs/client-revisions/2026-11-03/mascot-review-revisions/';
const u=readFileSync('output/r30-16-device-backup/vm-endpoint.txt','utf8').trim();
const vm=await(await fetch(u+'getVM')).json();
const isolateId=vm.result.isolates.find(i=>i.name==='main').id;
await fetch(u+'ext.kifc.reviewPage?'+new URLSearchParams({isolateId,page:'risk',lang:'id'}));
await wait(900);tap('B. Hutan rawa gambut');
let c;
for(let i=0;i<35;i++){
  try{c=await connectMascot();if(await c.evaluate("document.querySelector('model-viewer')?.loaded"))break;c.close();c=null;}catch{}
  await wait(200);
}
if(!c)throw new Error('Happy renderer unavailable');
const expression="(()=>{const v=document.querySelector('model-viewer'),s=v[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')];return {clip:v.animationName,loaded:v.loaded,paused:v.paused,time:v.currentTime,arm:s.getObjectByName('mixamorigRightArm').quaternion.toArray()};})()";
const before=await c.evaluate(expression);await wait(650);const after=await c.evaluate(expression);c.close();
if(after.clip!=='Happy'||after.paused||before.arm.every((x,i)=>Math.abs(x-after.arm[i])<1e-5))throw new Error('Happy not animating');
adb('shell','screencap','-p','/data/local/tmp/kifc-happy-revision.png');
adb('pull','/data/local/tmp/kifc-happy-revision.png',root+'android-happy.png');
writeFileSync(root+'android-happy.json',JSON.stringify({before,after},null,2));
await fetch(u+'ext.kifc.reviewPage?'+new URLSearchParams({isolateId,page:'welcome',lang:'id'}));
console.log('Happy animation verified; returned to welcome');
