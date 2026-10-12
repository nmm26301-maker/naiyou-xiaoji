#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
: "${SIGNING_STOREPASS:?Set original signing store password}"
: "${SIGNING_KEYPASS:?Set original signing key password}"
mkdir -p toolchain build/classes build/dex output
python3 - <<'PY'
from pathlib import Path
import urllib.request,zipfile
files={
 'platform-35_r02.zip':'https://dl.google.com/android/repository/platform-35_r02.zip',
 'build-tools_r35_linux.zip':'https://dl.google.com/android/repository/build-tools_r35_linux.zip',
 'ecj.jar':'https://repo.maven.apache.org/maven2/org/eclipse/jdt/ecj/3.38.0/ecj-3.38.0.jar'}
for n,u in files.items():
 p=Path('toolchain')/n
 if not p.exists():urllib.request.urlretrieve(u,p)
 if n.endswith('.zip'):
  with zipfile.ZipFile(p) as z:z.extractall('toolchain')
PY
chmod +x toolchain/android-15/aapt toolchain/android-15/d8 toolchain/android-15/zipalign toolchain/android-15/apksigner
java -jar toolchain/ecj.jar -1.8 -encoding UTF-8 -warn:none -bootclasspath toolchain/android-35/android.jar:toolchain/android-15/core-lambda-stubs.jar -d build/classes app/src/cn/creamnote/app/*.java
toolchain/android-15/d8 --lib toolchain/android-35/android.jar --min-api 26 --output build/dex build/classes/cn/creamnote/app/*.class
toolchain/android-15/aapt package -f -M app/AndroidManifest.xml -S app/res -A app/assets -I toolchain/android-35/android.jar -F build/unsigned.apk
python3 - <<'PY'
import zipfile
with zipfile.ZipFile('build/unsigned.apk','a') as z:z.write('build/dex/classes.dex','classes.dex')
PY
toolchain/android-15/zipalign -f -p 4 build/unsigned.apk build/aligned.apk
toolchain/android-15/apksigner sign --ks signing/creamnote.keystore --ks-pass "env:SIGNING_STOREPASS" --key-pass "env:SIGNING_KEYPASS" --out output/CreamNote-1.0.0.apk build/aligned.apk
toolchain/android-15/apksigner verify --verbose output/CreamNote-1.0.0.apk
