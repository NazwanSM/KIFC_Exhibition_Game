import {readFileSync,writeFileSync} from 'node:fs';
import {adb,tap,wait} from './android_mascot_ui.mjs';
const u=readFileSync('output/r30-16-device-backup/vm-endpoint.txt','utf8').trim();
const vm=await(await fetch(u+'getVM')).json();
const id=vm.result.isolates.find(i=>i.name==='main').id;
await fetch(u+'ext.kifc.reviewPage?'+new URLSearchParams({isolateId:id,page:'welcome',lang:'id'}));
await wait(1000);tap('English');
const pid=adb('shell','pidof','id.kifc.fire_prevention_challenge').trim();
const samples=[];
for(let t=0;t<14;t++){
  await wait(2000);
  const lines=adb('shell','dumpsys','audio').split('\n').filter(s=>s.includes('/'+pid+' ')&&s.includes('state:started'));
  samples.push({seconds:(t+1)*2,activePlayers:lines.length});
}
writeFileSync('build/r30-18-android-playback.json',JSON.stringify(samples,null,2));
console.log(JSON.stringify(samples));
