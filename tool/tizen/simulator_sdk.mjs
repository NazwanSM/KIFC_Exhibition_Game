// Public Samsung Simulator API plus its documented remote-debugging endpoint.
export const api = async (route, body) => {
  const response = await fetch('http://localhost:38888'+route, body === undefined ? {} : {
    method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(body)});
  const value = await response.json();if (!value.success) throw new Error(JSON.stringify(value));return value;
};
export async function connect() {
  const target = (await (await fetch('http://127.0.0.1:9230/json/list')).json())
    .find(t=>t.type==='page'&&t.url.endsWith('/ripple.html'));
  const socket = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise((resolve,reject)=>{socket.onopen=resolve;socket.onerror=reject;});
  const pending=new Map(),contexts=[],events=[];let sequence=0;
  socket.onmessage=({data})=>{const message=JSON.parse(data);if(message.id){const p=pending.get(message.id);if(p){pending.delete(message.id);message.error?p.reject(message.error):p.resolve(message.result);}}else{
    if(message.method==='Runtime.executionContextCreated')contexts.push(message.params.context);
    if(message.method==='Runtime.executionContextDestroyed'){
      const index=contexts.findIndex(c=>c.id===message.params.executionContextId);if(index>=0)contexts.splice(index,1);
    }
    if(/exceptionThrown|loadingFailed|requestWillBeSent/.test(message.method))events.push(message);
  }};
  const send=(method,params={})=>new Promise((resolve,reject)=>{const id=++sequence;
    const timer=setTimeout(()=>{pending.delete(id);reject(new Error('SDK debug timeout: '+method));},15000);
    pending.set(id,{resolve:r=>{clearTimeout(timer);resolve(r);},reject:e=>{clearTimeout(timer);reject(e);}});
    socket.send(JSON.stringify({id,method,params}));});
  await send('Runtime.enable');await send('Page.enable');await send('Network.enable');
  await new Promise(r=>setTimeout(r,100));
  async function evaluate(expression) {
    const tree=await send('Page.getFrameTree');
    const flatten=t=>[t.frame,...(t.childFrames||[]).flatMap(flatten)];
    const frame=flatten(tree.frameTree).find(f=>f.url.includes('/app/KIFCGameTV/'));
    const context=contexts.filter(c=>c.auxData?.isDefault&&c.auxData.frameId===frame?.id).at(-1);
    if(!context)throw new Error('Installed WGT execution context is missing');
    const r=await send('Runtime.evaluate',{contextId:context.id,expression,returnByValue:true,awaitPromise:true});
    if(r.exceptionDetails)throw new Error(JSON.stringify(r.exceptionDetails));return r.result.value;
  }
  async function point(x,y) {
    const root=contexts.find(c=>c.auxData?.isDefault&&c.origin.startsWith('chrome-extension:'));
    const frame=await send('Runtime.evaluate',{contextId:root.id,returnByValue:true,
      expression:'document.querySelector("iframe").getBoundingClientRect().toJSON()'});
    const viewport=await evaluate('({width:innerWidth,height:innerHeight})');
    return {x:frame.result.value.x+x*frame.result.value.width/viewport.width,
      y:frame.result.value.y+y*frame.result.value.height/viewport.height};
  }
  async function click(label) {
    const box=await evaluate(`(()=>{const e=[...document.querySelectorAll('[role=button]')].find(e=>(e.getAttribute('aria-label')||e.innerText)===${JSON.stringify(label)});if(!e)throw Error('Missing control: '+${JSON.stringify(label)});const r=e.getBoundingClientRect();return {x:r.x+r.width/2,y:r.y+r.height/2}})()`);
    const p=await point(box.x,box.y);
    for(const type of ['mousePressed','mouseReleased'])await send('Input.dispatchMouseEvent',{type,...p,button:'left',clickCount:1});
  }
  return {send,evaluate,events,contexts,point,click,close:()=>socket.close()};
}
