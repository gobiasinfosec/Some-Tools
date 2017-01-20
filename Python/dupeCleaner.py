#! python 3
# dupeCleaner.py- Python3
# Takes the last word from each line in a file
# and then removes duplicates and sorts numerically
#
# Designed for parsing the output from masscan to a more usuable list

import os, sys

def usage():
	print('DupeCleaner- python3')
	print()
	print('Usage: python3 dupeCleaner.py targetFile')
	sys.exit()

def cleanup(output):
	oList = []
	f = open(output, 'r')
	print('Cleaning up output')

	#save the last word from each line to a string in a list
	for line in f:
		oList.append(line.split()[-1])
	f.close()

	#remove duplicates and put in numerical order by IP
	oList = list(set(oList))
	oList.sort(key=lambda s: list(map(int, s.split('.'))))

	#save/overwrite file
	out = open(output, 'w')
	for address in oList:
		out.write(address+'\n')
	out.close()

def main():
	global output

	# if no arguments given, run usage
	if not len(sys.argv[1:]):
		usage()

	# read the commandline options
	output = (sys.argv[1])

	# call masscan with options
	cleanup(output)

	# print results output
	print('Results can be found in %s' % output)

main()
