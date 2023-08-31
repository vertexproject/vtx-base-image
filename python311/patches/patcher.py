import os
import sys

import pprint
import hashlib
import subprocess

# Assumes the patch file is relative to LOCALDIR

patches = (
    {'path': '/usr/lib/python3.11/asyncio/timeouts.py',
     'sha256': 'cf14e3b302f0935aa0bda757a4bd1509ce660eb3b6856283fbc4c9ca531f8095',
     'patch': '3113_timeout.diff',
     'ref': 'Apply fix for https://github.com/python/cpython/issues/102780'},
)

LOCALDIR = os.path.split(__file__)[0]

def main(argv):
    print(f'Applying {len(patches)}...')
    for pnfo in patches:
        print('Processing patch:')
        pprint.pprint(pnfo, width=80)
        fpath = pnfo.get('path')
        if not os.path.exists(fpath):
            print(f'Path {fpath} missing')
            return 1
        patchfile = os.path.join(LOCALDIR, pnfo.get('patch'))
        if not os.path.exists(patchfile):
            print(f'Patchfile {patchfile} missing')
            return 1

        with open(fpath, 'rb') as fd:
            sha256 = hashlib.sha256(fd.read()).hexdigest()

        if sha256 != pnfo.get('sha256'):
            print(f'Expected {pnfo.get("sha256")}, got {sha256}')
            return 1

        args = ['patch', fpath, patchfile]
        try:
            proc = subprocess.run(args, capture_output=True, check=True)
        except subprocess.CalledProcessError:
            print(f'Patch error: {args}')
            return 1
        finally:
            print('Patch: stdout')
            print(proc.stdout)
            print('Patch: stderr')
            print(proc.stderr)

    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
