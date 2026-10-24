param(
  [string]$SdkRoot = 'D:/Android/Sdk',
  [string]$Serial = 'emulator-5554'
)
$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
$output = Join-Path $projectRoot 'build/android-review-tool'
New-Item -ItemType Directory -Path $output -Force | Out-Null
$androidJar = Join-Path $SdkRoot 'platforms/android-35/android.jar'
$uiJar = Join-Path $SdkRoot 'platforms/android-35/uiautomator.jar'
$junit = Get-ChildItem -LiteralPath "$env:USERPROFILE/.gradle/caches/modules-2/files-2.1/junit/junit/4.13.2" -Recurse -Filter 'junit-4.13.2.jar' | Select-Object -First 1
if (!$junit -or !(Test-Path -LiteralPath $androidJar) -or !(Test-Path -LiteralPath $uiJar)) { throw 'Android35 SDK and cached JUnit4.13.2 are required; no download is performed.' }
$classPath = "$androidJar;$uiJar;$($junit.FullName)"
& javac --release 8 -classpath $classPath -d $output (Join-Path $PSScriptRoot 'KifcDump.java')
if ($LASTEXITCODE) { throw 'Hierarchy helper compilation failed' }
$jar = Join-Path $output 'kifc-ui.jar'
& (Join-Path $SdkRoot 'build-tools/35.0.0/d8.bat') --min-api 21 --lib $androidJar --classpath $uiJar --classpath $junit.FullName --output $jar (Join-Path $output 'id/kifc/review/KifcDump.class')
if ($LASTEXITCODE) { throw 'Hierarchy helper dex build failed' }
$adb = Join-Path $SdkRoot 'platform-tools/adb.exe'
& $adb -s $Serial shell mkdir -p /data/local/tmp/local/tmp
& $adb -s $Serial push $jar /data/local/tmp/kifc-ui.jar
if ($LASTEXITCODE) { throw 'Could not install temporary shell test helper' }
