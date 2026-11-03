import {writeFileSync} from 'node:fs';
import {pathToFileURL} from 'node:url';
import {resolve} from 'node:path';
import assert from 'node:assert/strict';
const name=process.env.PLAYWRIGHT_MODULE||'playwright';
const {chromium}=await import(/^[CD]:/.test(name)?pathToFileURL(resolve(name,'index.mjs')).href:name);
const browser=await chromium.launch({channel:'chrome',headless:true});
try {
  const page=await browser.newPage();
  await page.goto(process.env.SAMPLER_URL);
  await page.waitForFunction(()=>typeof globalThis.samplerCheck==='string',{},{timeout:20000});
  const result=await page.evaluate(()=>JSON.parse(globalThis.samplerCheck));
  writeFileSync(process.env.SAMPLER_RESULT,JSON.stringify(result,null,2));
  console.log(result);
  assert.equal(result.passed,true,'Browser audio sampling contract: '+result.failures.join('; '));
} finally {await browser.close();}
