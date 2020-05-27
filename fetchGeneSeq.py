# This file used to fetch teh gene sequence from the genome file 
# based of the gene coordinates (start and end position) provided as command line arguments.
#
import sys
filename = sys.argv[3]+".fa" # path to the genome file
f = open(filename, "r")
seq = f.read()

start = int(sys.argv[1])
end = int(sys.argv[2])


sequence = seq[start:end]
print(sequence)
print(sys.argv[3])

#print(sys.argv[2])
