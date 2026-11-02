// Read this app's debug WebView, exposed only by the Android review entry point.
export async function connectMascot() {
  const endpoint = process.env.KIFC_CDP_ENDPOINT || 'http://127.0.0.1:9223';
  const targets = await (await fetch(endpoint + '/json')).json();
  const target = targets.filter(x => x.type === 'page' && /127\.0\.0\.1/.test(x.url)).at(-1);
  if (!target) throw new Error('No app WebView target');
  const ws = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise((resolve, reject) => { ws.addEventListener('open', resolve, {once:true}); ws.addEventListener('error', reject, {once:true}); });
  let id = 0;
  const pending = new Map();
  const events = [];
  ws.addEventListener('message', event => {
    const message = JSON.parse(event.data);
    if (!message.id) { events.push(message); return; }
    const handler = pending.get(message.id); if (!handler) return;
    pending.delete(message.id); clearTimeout(handler.timeout);
    if (message.error) handler.reject(message.error); else handler.resolve(message.result);
  });
  ws.addEventListener('close', () => {
    for (const item of pending.values()) { clearTimeout(item.timeout); item.reject(new Error('WebView target closed')); }
    pending.clear();
  });
  const call = (method, params={}) => new Promise((resolve,reject) => {
    const n = ++id;
    const timeout=setTimeout(()=>{pending.delete(n);reject(new Error('CDP timeout'));},12000);
    pending.set(n,{resolve,reject,timeout}); ws.send(JSON.stringify({id:n,method,params}));
  });
  return {
    target,
    events,
    command: call,
    async evaluate(expression) {
      const result=await call('Runtime.evaluate',{expression,awaitPromise:true,returnByValue:true});
      if(result.exceptionDetails)throw new Error(JSON.stringify(result.exceptionDetails));
      return result.result.value;
    },
    close() { ws.close(); },
  };
}
