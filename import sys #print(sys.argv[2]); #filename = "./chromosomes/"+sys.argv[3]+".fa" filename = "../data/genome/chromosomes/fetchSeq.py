# This program is used to fetch the upstream and downstream sequence for
# a genomic variant by taking possion and the desired length as command line input

import sys

filename = sys.argv[1]+".fa" # path to the genome sequences file
f = open(filename, "r")
pos = int(sys.argv[2])
seqLen = int(sys.argv[3])
start = pos-seqLen
end = pos+seqLen
seq = f.read()
ref = seq[pos-1]
upstraem = seq[pos-seqLen:pos-1]
dnstraem = seq[pos:pos+seqLen]
print(upstraem)
print(ref)
print(dnstraem)
#print(sys.argv[1])
