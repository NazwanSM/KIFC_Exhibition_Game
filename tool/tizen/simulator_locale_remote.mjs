import {writeFileSync} from 'node:fs';
import {api,connect} from './simulator_sdk.mjs';
const c=await connect(),out='docs/client-revisions/2026-11-03/r30-20/tizen',steps=[];
const wait=ms=>new Promise(r=>setTimeout(r,ms));
async function record(name){const state=await c.evaluate(`({text:document.body.innerText,keys:window.__reviewKeys||[],active:document.activeElement?.outerHTML.slice(0,250),model:[...document.querySelectorAll('model-viewer')].map(m=>({loaded:m.loaded,clip:m.animationName,time:m.currentTime})),media:(window.__reviewMedia||[]).map(m=>({src:m.currentSrc,time:m.currentTime,paused:m.paused,volume:m.volume})),externalResources:performance.getEntriesByType('resource').filter(r=>/^https?:/.test(r.name)).map(r=>r.name)})`);steps.push({name,...state});writeFileSync(out+'/locale-remote.json',JSON.stringify(steps,null,2));console.log(name,state.model,state.text.slice(0,70).replaceAll('\n',' / '));}
try{
  await c.click('English');await wait(700);await record('english-welcome');
  await wait(20500);await record('english-idle-voice');
  await c.click('한국어');await wait(700);await record('korean-welcome');
  await wait(20500);await record('korean-idle-voice');
  await c.evaluate(`window.__reviewKeys=[];document.addEventListener('keydown',e=>window.__reviewKeys.push({key:e.key,code:e.code,keyCode:e.keyCode}));true`);
  for(const key of ['left','right','down','enter'])await api('/remote/press',{key});
  await api('/remote/stop',{});
  await wait(800);await record('sdk-remote-input');
  const result=await c.send('Page.captureScreenshot',{format:'png'});writeFileSync(out+'/simulator-korean.png',Buffer.from(result.data,'base64'));
}finally{c.close();}
