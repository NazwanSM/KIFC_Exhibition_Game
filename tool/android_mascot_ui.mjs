import {execFileSync} from 'node:child_process';
export const serial='08990372CC017362';
export const adb=(...args)=>execFileSync('adb',['-s',serial,...args],{encoding:'utf8',timeout:20000});
export const wait=ms=>new Promise(r=>setTimeout(r,ms));
const decode=s=>s.replace(/&quot;/g,'"').replace(/&apos;/g,"'").replace(/&#10;/g,' ').replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/\s+/g,' ').trim();
export function nodes(){
  const dump=adb('shell','uiautomator','dump','/data/local/tmp/kifc-layout.xml');
  if(!dump.includes('dumped to'))throw new Error('Android hierarchy not fresh: '+dump);
  const xml=adb('exec-out','cat','/data/local/tmp/kifc-layout.xml');
  return [...xml.matchAll(/<node\s+([^>]+)>/g)].map(match=>{
    const a=Object.fromEntries([...match[1].matchAll(/([\w-]+)="([^"]*)"/g)].map(x=>[x[1],decode(x[2])]));
    const b=[...(a.bounds||'').matchAll(/\d+/g)].map(x=>+x[0]);
    return {...a,label:a['content-desc']||a.text||'',box:b,center:b.length===4?[(b[0]+b[2])/2,(b[1]+b[3])/2]:null};
  });
}
export function find(label,partial=false){
  const list=nodes(); const n=list.find(n=>partial?n.label.includes(label):n.label===label);
  if(!n?.center)throw new Error('Missing Android control '+label+'; labels='+JSON.stringify(list.filter(x=>x.label).map(x=>x.label)));
  return n;
}
export function tap(label,partial=false){const n=find(label,partial);adb('shell','input','tap',...n.center.map(x=>String(Math.round(x))));}
export function tapTitle(){adb('shell','input','tap','200','400');}
export function screenshot(name){
  const remote='/data/local/tmp/kifc-r30-16.png';adb('shell','screencap','-p',remote);
  adb('pull',remote,'docs/client-revisions/2026-11-02/r30-16/android-'+name+'.png');
}
