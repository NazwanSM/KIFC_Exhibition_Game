async page => {
  await page.waitForFunction(() => document.querySelector('model-viewer')?.loaded);
  await page.evaluate(() => {
    document.querySelector('flt-semantics-placeholder')?.click();
    window.departedWelcome = document.querySelector('model-viewer');
    window.departedWelcome.play();
  });
  await page.getByRole('button', {name:'Mulai Tantangan',exact:true}).click();
  await page.waitForTimeout(800);
  const result = await page.evaluate(() => ({paused:window.departedWelcome.paused,
    connected:window.departedWelcome.isConnected,time:window.departedWelcome.currentTime}));
  if (!result.paused || result.connected) throw new Error('Wave still active after departure: '+JSON.stringify(result));
  console.log(JSON.stringify(result));
}
