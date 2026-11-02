import {writeFileSync} from 'node:fs';
import {adb,wait} from './android_mascot_ui.mjs';
// Restrict logs to this app process. Keep the local VM auth path out of output.
await wait(1800);
const pid=adb('shell','pidof','id.kifc.fire_prevention_challenge').trim();
adb('forward','tcp:9223','localabstract:webview_devtools_remote_'+pid);
const log=adb('logcat','-d','--pid='+pid);
const match=[...log.matchAll(/Dart VM service is listening on http:\/\/127\.0\.0\.1:(\d+)\/(\S+)/g)].at(-1);
if(!match)throw new Error('Review VM service not available');
adb('forward','tcp:9224','tcp:'+match[1]);
writeFileSync('output/r30-16-device-backup/vm-endpoint.txt','http://127.0.0.1:9224/'+match[2]);
console.log('Connected app-local WebView and debug fixture service');
