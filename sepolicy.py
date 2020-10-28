#!/bin/python3
# Usages: ./sepolicy.py log_filename

from sys import argv

logs=open(argv[1], "r").readlines()
avc_list = []

for lines in logs:
    if 'avc:' in lines:
        if 'denied' in lines:
            avc_list.append(lines)

fix = []
for item in avc_list:
    allow1 = item.split('scontext=u:r:')[1].split(':')[0]
    allow2 = item.split('scontext=u:r:')[1].split(':')[3]
    allow3 = item.split('tclass=')[1].split()[0]
    allow4 = item.split('denied')[1].split('for')[0].strip()
    fix.append(f'allow {allow1} {allow2}:{allow3} {allow4}')
fix = list(dict.fromkeys(fix))
for item in fix:
    print (item)
