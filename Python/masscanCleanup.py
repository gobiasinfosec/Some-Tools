#! python3
# masscanCleanup.py -Author David Sullivan 12/9/2016
# Takes the last word from each line in a file and then removes duplicates and sorts numerically
# Designed for parsing output from masscan

#input file location
infile = input(r'Target file location(will be overwritten): ')

#empty list to resort data
output = []

#open the file
f = open(infile, 'r')

#save the last word from each line to a string in a list
for line in f:
  output.append(line.split()[-1])
f.close()

#remove duplicates
output = list(set(output))

#put in numerical order
output.sort(key=lambda s: list(map(int, s.split('.'))))

#save/overwrite file
out = open(infile, 'w')
for word in output:
  out.write(word+'\n')
out.close()
