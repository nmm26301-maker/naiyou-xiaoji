#!/usr/bin/env python3
"""Recover the byte-exact original archive with the owner's separate recovery file."""
import argparse,base64,hashlib,json,sys
from pathlib import Path
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

def main():
 p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--recovery',required=True,type=Path);p.add_argument('--backup',required=True,type=Path);p.add_argument('--output',required=True,type=Path);a=p.parse_args()
 if a.output.exists():p.error('Output already exists; choose a new filename.')
 r=json.loads(a.recovery.read_text(encoding='utf-8'));blob=a.backup.read_bytes()
 if hashlib.sha256(blob).hexdigest()!=r['backup_sha256']:p.error('Backup hash does not match the recovery record.')
 magic=b'CREAMNOTE-BACKUP-1\n'
 if not blob.startswith(magic):p.error('Unknown backup format.')
 key=base64.b64decode(r['recovery_key_base64'],validate=True)
 if len(key)!=32:p.error('Invalid recovery key.')
 try:plain=AESGCM(key).decrypt(blob[len(magic):len(magic)+12],blob[len(magic)+12:],magic)
 except Exception:p.error('Recovery key is wrong, or the backup has been modified.')
 with a.output.open('xb') as f:f.write(plain)
 a.output.chmod(0o600)
 print('Recovered original backup:',a.output)
if __name__=='__main__':main()
