// Inspect this app's debug WebView through an adb-forwarded DevTools endpoint.
import {readFileSync} from 'node:fs';
import {connectMascot} from './android_mascot_cdp.mjs';
const connection=await connectMascot();
const expression = process.argv[2] ? readFileSync(process.argv[2], 'utf8') : `(() => {
 const v=document.querySelector('model-viewer'); return v ? {loaded:v.loaded,clip:v.animationName,paused:v.paused,time:v.currentTime,duration:v.duration,src:v.src,clips:v.availableAnimations,camera:v.cameraOrbit,fov:v.getFieldOfView()} : null;
})()`;
try { console.log(JSON.stringify({url:connection.target.url,value:await connection.evaluate(expression)},null,2)); }
finally { connection.close(); }
