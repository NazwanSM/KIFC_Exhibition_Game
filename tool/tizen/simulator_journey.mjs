// Production WGT smoke journey in the official Samsung TV Web Simulator.
import {mkdirSync,writeFileSync} from 'node:fs';
import {execFileSync} from 'node:child_process';
import {connect,api} from './simulator_sdk.mjs';
const out=process.env.KIFC_TIZEN_EVIDENCE||'docs/client-revisions/2026-11-03/r30-20/tizen';mkdirSync(out,{recursive:true});
const c=await connect(),steps=[];
const wait=ms=>new Promise(r=>setTimeout(r,ms));
const read=()=>c.evaluate(`(()=>{const serialize=e=>({tag:e.tagName,src:e.currentSrc,time:e.currentTime,paused:e.paused,muted:e.muted,volume:e.volume,loop:e.loop,error:e.error?.message});const walk=r=>[...r.querySelectorAll('*')].flatMap(e=>[...(e instanceof HTMLMediaElement?[serialize(e)]:[]),...(e.shadowRoot?walk(e.shadowRoot):[])]);const m=document.querySelector('model-viewer'),s=m?.[Object.getOwnPropertySymbols(m).find(x=>x.description==='scene')],mouth=s?.getObjectByName('MESH-Meshy-LocalMouth-Talk');return {text:document.body.innerText,viewport:[innerWidth,innerHeight],model:m?{loaded:m.loaded,clip:m.animationName,time:m.currentTime,paused:m.paused,mouth:mouth?[...mouth.morphTargetInfluences]:null}:null,media:walk(document),trackedMedia:(window.__reviewMedia||[]).map(serialize),resources:performance.getEntriesByType('resource').map(r=>r.name)}})()`);
async function until(predicate,ms=30000){const end=Date.now()+ms;let state;while(Date.now()<end){try{state=await read();if(predicate(state))return state;}catch(error){if(!String(error).includes('execution context is missing'))throw error;}await wait(250);}throw new Error('Timeout: '+JSON.stringify(state));}
async function record(name){const state=await read();steps.push({name,...state});writeFileSync(out+'/journey.json',JSON.stringify({source:'Official Samsung TV Web Simulator 10.0.6; installed production WGT; real pointer input',steps,events:c.events},null,2));console.log(name,state.model?.clip,state.text.slice(0,65).replaceAll('\n',' / '));}
async function shot(name){const frame=await c.send('Page.captureScreenshot',{format:'png'});writeFileSync(out+'/'+name+'.png',Buffer.from(frame.data,'base64'));}
async function click(label){await c.click(label);await wait(700);}
async function drag(label){
  const points=await c.evaluate(`(()=>{const e=[...document.querySelectorAll('[role=img]')].find(e=>(e.getAttribute('aria-label')||e.innerText).includes(${JSON.stringify(label)})),t=document.querySelector('[role=group][aria-label*="Area hutan"]');if(!e||!t)throw Error('Missing drag '+${JSON.stringify(label)});const p=r=>({x:r.x+r.width/2,y:r.y+r.height/2});return {from:p(e.getBoundingClientRect()),to:p(t.getBoundingClientRect())}})()`);
  const from=await c.point(points.from.x,points.from.y),to=await c.point(points.to.x,points.to.y);
  await c.send('Input.dispatchMouseEvent',{type:'mouseMoved',...from});
  await c.send('Input.dispatchMouseEvent',{type:'mousePressed',...from,button:'left',buttons:1,clickCount:1});
  for(let i=1;i<=16;i++){await c.send('Input.dispatchMouseEvent',{type:'mouseMoved',x:from.x+(to.x-from.x)*i/16,y:from.y+(to.y-from.y)*i/16,button:'left',buttons:1});await wait(20);}
  await c.send('Input.dispatchMouseEvent',{type:'mouseReleased',...to,button:'left',buttons:0,clickCount:1});await wait(600);
}
try{
  await until(s=>s.model?.loaded);
  await c.evaluate(`(()=>{window.__reviewMedia=[];const play=HTMLMediaElement.prototype.play;HTMLMediaElement.prototype.play=function(...args){if(!window.__reviewMedia.includes(this))window.__reviewMedia.push(this);return play.apply(this,args);};return true})()`);
  await c.evaluate('document.querySelector("flt-semantics-placeholder")?.click();true');await wait(250);
  await record('local-package-welcome');await shot('simulator-welcome-local');
  if((await read()).resources.some(url=>/^https?:/.test(url)))throw Error('WGT attempted an HTTP dependency during local boot');
  // The script can resume after the production Start button was already used.
  if((await read()).text.includes('Mulai Tantangan'))await click('Mulai Tantangan');
  await until(s=>s.text.includes('Pilih tiga unsur api.'));
  await record('assembly');await drag('Percikan api');await drag('Kayu kering');await drag('Oksigen dari udara');
  await until(s=>s.text.includes('3/3 unsur'));await record('assembly-complete');await shot('simulator-assembly-complete');
  await wait(900);const a=await read();await wait(650);const b=await read();
  if(!b.media.some(v=>v.tag==='VIDEO'&&!v.paused))throw Error('Fire video did not play');
  // Samsung Simulator overrides HTML media volume; verify the silent source.
  const streams=JSON.parse(execFileSync('ffprobe',['-v','error','-show_streams','-of','json','assets/animations/forest-burn-loop.mp4'],{encoding:'utf8'})).streams;
  if(streams.some(s=>s.codec_type==='audio'))throw Error('Documentary video unexpectedly contains audio');
  steps.push({name:'silent-video-source',audioTracks:0,domMuted:b.media[0]?.muted,domVolume:b.media[0]?.volume});
  steps.push({name:'video-motion',before:a.media,after:b.media});
  // Separate background tap; never use the answer gesture as continuation.
  const p=await c.point(500,400);for(const type of ['mousePressed','mouseReleased'])await c.send('Input.dispatchMouseEvent',{type,...p,button:'left',clickCount:1});await wait(650);
  await until(s=>s.text.includes('Api Dapat Muncul Saat Tiga Unsur Bertemu'));await record('explanation');await shot('simulator-explanation');
  await click('Lanjut');await until(s=>s.model?.loaded&&s.model.clip==='Talk');
  const r1=await read();await wait(850);const r2=await read();steps.push({name:'reading-progress',before:r1,after:r2});
  if(r1.model.time===r2.model.time)throw Error('Skeletal animation clock did not advance');
  if(JSON.stringify(r1.model.mouth)===JSON.stringify(r2.model.mouth))throw Error('Mouth morph did not change');
  await record('reading-definition');await shot('simulator-reading');
  await click('Lanjut');await click('Lanjut');await click('Mulai Kuis');
  await until(s=>s.text.includes('Hutan rawa gambut'));await record('unanswered-risk');
  if((await read()).model?.clip==='Talk')throw Error('Narration remained active on the quiz');
  await click('A. Hutan mangrove');await record('wrong-feedback');await shot('simulator-feedback');
  await click('B. Hutan rawa gambut');await record('correct-feedback');
  await record('finished-smoke');
  writeFileSync(out+'/journey-result.json',JSON.stringify({passed:true,steps:steps.map(s=>s.name),scope:'Production WGT pointer drag, video, reading skeletal/morph playback, skip-to-unanswered quiz, wrong/right feedback',remoteOnlyGame:false},null,2));
}catch(error){await record('failure').catch(()=>{});throw error;}finally{c.close();}
