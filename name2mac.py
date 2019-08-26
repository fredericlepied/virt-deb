#!/usr/bin/env python

'''
'''

from hashlib import md5
import sys

h = md5()
h.update(sys.argv[1])
r = '525400' + h.hexdigest()[:6]

print(':'.join([r[i:i+2] for i in range(0, len(r), 2)]))

# name2mac.py ends here
