#!/bin/python3
import sys

file=open(sys.argv[1], "r")
logs=file.readlines()

avc_list = []
for lines in logs:
    if 'avc:' in lines:
        if 'denied' in lines:
            avc_list.append(lines)
for item in avc_list:
    allow1 = item.split('scontext=u:r:')[1].split(':')[0]
#    print (allow1)
    allow2 = item.split('scontext=u:r:')[1].split(':')[3]
 #   print (allow2)
    allow3 = item.split('tclass=')[1].split()[0]
  #  print (allow3)
    allow4 = item.split('denied')[1].split('for')[0].strip()
   # print (allow4)
    print (f'allow {allow1} {allow2}:{allow3} {allow4}')
