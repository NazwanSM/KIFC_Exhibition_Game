// Continue the same unmodified production session from the cause quiz.
import {writeFileSync} from 'node:fs';
import {connect} from './simulator_sdk.mjs';
const c=await connect(),steps=[],out=process.env.KIFC_TIZEN_EVIDENCE||'docs/client-revisions/2026-11-03/r30-20/tizen';
const wait=ms=>new Promise(r=>setTimeout(r,ms));
const state=()=>c.evaluate(`({text:document.body.innerText,buttons:[...document.querySelectorAll('[role=button]')].map(e=>e.getAttribute('aria-label')||e.innerText),models:[...document.querySelectorAll('model-viewer')].map(m=>({clip:m.animationName,time:m.currentTime,paused:m.paused,loaded:m.loaded})),media:(window.__reviewMedia||[]).map(m=>({src:m.currentSrc,paused:m.paused,time:m.currentTime}))})`);
async function record(name){steps.push({name,...await state()});writeFileSync(out+'/finish-journey.json',JSON.stringify(steps,null,2));console.log(name,steps.at(-1).buttons);}
async function click(label){await c.click(label);await wait(600);}
async function advance(){const p=await c.point(500,400);for(const type of ['mousePressed','mouseReleased'])await c.send('Input.dispatchMouseEvent',{type,...p,button:'left',clickCount:1});await wait(650);}
try{
  for(let i=0;i<4;i++){await click(i===2?'Faktor alam':'Aktivitas manusia');await record('cause-'+(i+1));await advance();}
  for(let i=1;i<=3;i++){const label=(await state()).buttons.find(s=>s.startsWith('Kartu '+i+'.'));if(!label)throw Error('Missing peat card '+i);await click(label);}
  await record('peat-information');await click('Kenali Dampaknya');await wait(4500);
  await record('active-impact');await click('Selesai Memilih');await record('impact-review');
  await click('Lihat Hasil Akhir');await record('score');
  await click('Selesai');await wait(1500);await record('closing-speaking');
  const screenshot=await c.send('Page.captureScreenshot',{format:'png'});writeFileSync(out+'/simulator-closing.png',Buffer.from(screenshot.data,'base64'));
  await wait(12000);await record('closing-after-voice');
  if((await state()).text.includes('Mulai Tantangan'))throw Error('Closing returned before 30 seconds');
  await wait(17500);await record('returned-welcome');
  if(!(await state()).text.includes('Mulai Tantangan'))throw Error('Closing did not return to welcome');
  console.log('Full production SDK journey completed');
}finally{c.close();}
