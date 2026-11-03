// Inspect the official Samsung simulator through its SDK debugging endpoint.
// This does not launch or substitute a desktop browser for the simulator.
import {mkdirSync, writeFileSync} from 'node:fs';
const targets = await (await fetch('http://127.0.0.1:9230/json/list')).json();
const target = targets.find(t => t.type === 'page' && t.url.endsWith('/ripple.html'));
if (!target) throw new Error('Official TV Simulator SDK target not found');
const socket = new WebSocket(target.webSocketDebuggerUrl);
await new Promise((resolve, reject) => {socket.onopen = resolve; socket.onerror = reject;});
let next = 0;
const pending = new Map();
const contexts = [], events = [];
socket.onmessage = ({data}) => {
  const message = JSON.parse(data);
  if (message.id) {
    const p = pending.get(message.id);
    if (p) {pending.delete(message.id); message.error ? p.reject(message.error) : p.resolve(message.result);}
  } else {
    if (message.method === 'Runtime.executionContextCreated') contexts.push(message.params.context);
    if (/exceptionThrown|loadingFailed|responseReceived/.test(message.method)) events.push(message);
  }
};
const send = (method, params = {}) => new Promise((resolve, reject) => {
  const id = ++next; pending.set(id, {resolve, reject});socket.send(JSON.stringify({id, method, params}));
});
try {
  await send('Runtime.enable');await send('Page.enable');await send('Network.enable');
  const version = await send('Browser.getVersion');
  const frames = await send('Page.getFrameTree');
  await new Promise(resolve => setTimeout(resolve, 200));
  const probes = [];
  for (const context of contexts.filter(c => c.auxData?.isDefault)) {
    const result = await send('Runtime.evaluate', {contextId:context.id, returnByValue:true,
      expression:`JSON.stringify({url:location.href,title:document.title,ready:document.readyState,
        viewport:[innerWidth,innerHeight],ua:navigator.userAgent,
        frames:[...document.querySelectorAll('iframe')].map(f=>({id:f.id,src:f.src})),
        body:document.body?.innerText.slice(0,1800),flutter:!!document.querySelector('flutter-view'),
        mascot:[...document.querySelectorAll('model-viewer')].map(m=>({loaded:m.loaded,clip:m.animationName,time:m.currentTime})),
        resources:performance.getEntriesByType('resource').map(r=>({url:r.name,duration:r.duration}))})`});
    probes.push({id:context.id,origin:context.origin,data:result.result?.value ? JSON.parse(result.result.value) : result});
  }
  const dir = 'docs/client-revisions/2026-11-03/r30-20/tizen';mkdirSync(dir,{recursive:true});
  const report = {source:'Official Samsung TV Web Simulator 10.0.6 SDK',version,frames,probes,events};
  writeFileSync(dir+'/simulator-probe.json',JSON.stringify(report,null,2));
  const shot = await send('Page.captureScreenshot',{format:'png'});
  writeFileSync(dir+'/simulator-current.png',Buffer.from(shot.data,'base64'));
  console.log(JSON.stringify({version,probes:probes.map(p=>({id:p.id,url:p.data.url,flutter:p.data.flutter,body:p.data.body?.slice(0,300),mascot:p.data.mascot,viewport:p.data.viewport}))},null,2));
} finally {socket.close();}
