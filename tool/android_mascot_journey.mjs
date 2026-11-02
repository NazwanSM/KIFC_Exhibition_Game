import {writeFileSync} from 'node:fs';
import {connectMascot} from './android_mascot_cdp.mjs';
import {adb,find,nodes,tap,tapTitle,wait,screenshot} from './android_mascot_ui.mjs';

// Run against the installed debug review APK; controls come from Android semantics.
const results=[];
const root='docs/client-revisions/2026-11-02/r30-16/';
async function inspect(label,clip,{capture=true}={}) {
  let value;
  for(let attempt=0;attempt<35;attempt++) {
    let c;
    try {
      c=await connectMascot();
      value=await c.evaluate(`(()=>{const v=document.querySelector('model-viewer');if(!v?.loaded)return null;const s=v[Object.getOwnPropertySymbols(v).find(x=>x.description==='scene')],m=s.getObjectByName('MESH-Meshy-LocalMouth-Talk');v.pause();let error=0;for(const t of [.137,1.213,7.43,16.29,29.7]){v.currentTime=t;error=Math.max(error,...m.morphTargetInfluences.map((x,i)=>Math.abs(x-[1,0,0][i])));}v.currentTime=.267;v.play();return {loaded:v.loaded,clip:v.animationName,duration:v.duration,paused:v.paused,maxMouthError:error,camera:v.getAttribute('camera-orbit')};})()`);
      if(value?.clip===clip)break;
    } catch(error) {value={error:String(error)};} finally {c?.close();}
    await wait(250);
  }
  if(value?.clip!==clip||value.paused||value.duration!==30||(clip!=='Wave'&&value.maxMouthError>1e-6))throw new Error(label+JSON.stringify(value));
  results.push({label,...value});writeFileSync(root+'android-journey.json',JSON.stringify(results,null,2));
  if(capture)screenshot(label);
  console.log(label+' '+clip);
}
const labels=()=>nodes().filter(n=>n.label);
const current=labels();
if(current.some(n=>n.label==='Mulai Tantangan')){tap('Mulai Tantangan');await wait(1000);}
await inspect('assembly-neutral','PointIdle');
let controls=labels();
const forest=controls.find(n=>n.label==='Area hutan untuk meletakkan unsur api');
function drop(label){const n=controls.find(n=>n.label===label);if(!n||!forest)throw new Error('Missing drag '+label);adb('shell','input','swipe',...n.center.map(Math.round).map(String),...forest.center.map(Math.round).map(String),'650');}
drop('Air');await inspect('assembly-wrong','FeedbackSilent');
drop('Percikan api');await wait(300);drop('Kayu kering');await wait(300);drop('O₂ Oksigen dari udara');await inspect('assembly-complete','Happy');
tapTitle();await inspect('triangle-explanation','PointIdle');
tap('Lanjut');await inspect('reading-one','PointIdle');
tap('Lanjut');await wait(300);tap('Lanjut');await wait(300);tap('Mulai Kuis');await wait(400);
tap('A. Hutan mangrove');await inspect('risk-wrong','FeedbackSilent');
tap('B. Hutan rawa gambut');await inspect('risk-correct','Happy');
tapTitle();await wait(400);tap('Faktor alam');await inspect('cause-wrong','FeedbackSilent');
tapTitle();await wait(400);tap('Aktivitas manusia');await inspect('cause-correct','Happy');
tapTitle();await wait(400);tap('Faktor alam');await inspect('cause-natural','Happy',{capture:false});
tapTitle();await wait(400);tap('Aktivitas manusia');await inspect('cause-last','Happy',{capture:false});
tapTitle();await inspect('peat-cards','PointIdle');
for(const i of [1,2,3])tap('Kartu '+i+'.',true);
tap('Kenali Dampaknya');await wait(5000);
tap('Selesai Memilih');await inspect('final-review','FeedbackSilent');
tap('Lihat Hasil Akhir');await wait(800);tap('Selesai');await inspect('closing','WaveSilent');
tap('Beranda');await inspect('returned-welcome','Wave');
console.log('Native journey passed: '+results.length+' checks');
