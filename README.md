# 奶油小记 · CreamNote

裱花作品相册 + 每日快递取件码，离线安卓 App。

## 下载

[安装 CreamNote 1.0.0](releases/CreamNote-1.0.0.apk)，支持 Android 8 及以上。包名 `cn.creamnote.app`，versionCode 1。

## 功能

作品批量导入、保存原图、分类、收藏、搜索、记录心得、分享原图。取件码可手动录入或粘贴通知辅助提取，按日期保存，复制、标记已取、撤销、编辑。未取记录一直保留。支持通过系统分享接收图片和文字，以及 App 数据完整备份与恢复。

## 原始备份与签名

`backups/CreamNote-1.0.0-private-backup.aesgcm` 保留原始源码 ZIP、原 APK、原签名文件、原签名密码、alias 和证书。没有生成或替换签名。当前仓库公开，所以这些内容使用 AES-256-GCM 加密；恢复密钥文件单独交给所有者保管，不在此仓库。

恢复：安装 Python 3 与 cryptography，使用所有者的 `CreamNote-original-signing-recovery.json` 文件执行：

```sh
python3 -m pip install cryptography
python3 restore_backup.py --recovery /path/to/CreamNote-original-signing-recovery.json --backup backups/CreamNote-1.0.0-private-backup.aesgcm --output restored-originals.zip
```

输出 ZIP 内包括签名和密码。原始源码 ZIP 也逐字节保留在其中。

## 构建

Linux x86_64、Java 17、Python 3、网络。将恢复的 `creamnote.keystore` 放入 signing/，从原签名恢复文件取得密码，设置环境变量 `SIGNING_STOREPASS` 与 `SIGNING_KEYPASS`，然后运行 `bash build.sh`。脚本使用 Android API35、Build Tools35、ECJ，没有 Gradle 或第三方 Android 库。后续覆盖升级应沿用原签名并提高 versionCode。

## 数据与检查

作品和取件记录存本机，无联网功能。换手机或卸载前，在 App 右上角导出完整备份。源版本已通过编译、APK 签名检查和 Chromium 界面交互检查；本次仅备份，不更改 App 功能。原签名证书与 APK 签名证书已逐字节比对一致，原 APK 哈希匹配。

`BACKUP-MANIFEST.json` 与 `SHA256SUMS` 用于核对文件完整性。
