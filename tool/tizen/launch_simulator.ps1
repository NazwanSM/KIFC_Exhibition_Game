param([string]$SdkRoot = 'D:\KIFC-tizen-tools')
$ErrorActionPreference = 'Stop'
$simulatorPath = Join-Path $SdkRoot 'sdk\data\tools\sec-tv-simulator\simulator.exe'
if (!(Test-Path -LiteralPath $simulatorPath)) {
    throw 'Run python tool/tizen/setup_simulator.py first.'
}
Start-Process -FilePath $simulatorPath `
    -ArgumentList '--platform tizen --tizentvversion 10.0 --resolution 1920x1080 --remote-debugging-port=9230 --disableInspector' `
    -WorkingDirectory (Split-Path -Parent $simulatorPath) -WindowStyle Hidden
