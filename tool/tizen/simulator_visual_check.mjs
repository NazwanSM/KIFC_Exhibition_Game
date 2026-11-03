import {mkdirSync,writeFileSync} from 'node:fs';
import {api,connect} from './simulator_sdk.mjs';
const wait=ms=>new Promise(r=>setTimeout(r,ms));
await api('/display/scale',{scale:.25});
await api('/app/launch',{appId:'KIFCGameTV'});await wait(2500);
const c=await connect(),out='docs/client-revisions/2026-11-03/r30-20/tizen/opaque-sdk';mkdirSync(out,{recursive:true});
async function shot(name){const r=await c.send('Page.captureScreenshot',{format:'png'});writeFileSync(out+'/'+name+'.png',Buffer.from(r.data,'base64'));}
try{
  await c.evaluate('document.querySelector("flt-semantics-placeholder")?.click();true');await wait(500);
  await c.click('English');await wait(1000);await shot('english');
  await c.click('한국어');await wait(1000);await shot('korean');
  writeFileSync(out+'/state.json',JSON.stringify(await c.evaluate('({text:document.body.innerText,model:[...document.querySelectorAll("model-viewer")].map(m=>({loaded:m.loaded,clip:m.animationName})),viewport:[innerWidth,innerHeight]})'),null,2));
}finally{c.close();}
