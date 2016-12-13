#! python3
# massNFSEnum.py - v1.0
# Author- David Sullivan
# revision 1.0- 12/13/2016
#
# Point masscan at a subnet and this will look for open NFS ports,
# clean up the output, then run showmount to view the shares.

import getopt, os, sys

#globals
ports = '2049'
target = ''
output = ''

def usage():
	print('MassScan to Enumerate NFS- python3')
	print()
	print('Usage: python3 massNFSEnum.py -t 192.168.1.0/24 -o output.txt')
	print('-t --target	-target network')
	print('-o --output	-output file location')
	print('-h --help	-print this help file')
	print('***Requires MassScan and NFS-Common to be installed***')
	sys.exit()

def masscan(ports, target, output):
	print('Running masscan against %s' % target)
	arguments = 'masscan -p %s %s > %s' % (ports,target,output)
	os.system(arguments)

def cleanup(ports, target, output):
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

def enumerator(ports, target, output):
	oList = []
	f = open(output, 'r')

	#import each line from the list into a variable
	for line in f:
		oList.append(line.rstrip())
	f.close()

	#overwrite save file to blank file
	out = open(output, 'w')
	out.write('')
	out.close()

	#run enum4linux against each argument
	for address in oList:
		print('Running showmount against %s' % (address))
		arguments = ('showmount -e %s >> %s' % (address,output))
		os.system(arguments)

def main():
	global ports, target, output

	#if no arguments given, run usage
	if not len(sys.argv[1:]):
		usage()

	#read the commandline options
	try:
		opts,args = getopt.getopt(sys.argv[1:],'o:ht:o',['output','target','help'])
	except getopt.GetoptError as err:
		print(str(err))
		usage()
	
	#handle arguments
	for o,a in opts:
		if o in ('-h','--help'):
			usage()
		elif o in ('-t','--target'):
			target = a
		elif o in ('-o','--output'):
			output = a
		else:
			assert False, ('Unhandled option')

	#call masscan with options
	masscan(ports, target, output)
	cleanup(ports, target, output)
	enumerator(ports, target, output)

	print('Results can be found in %s' % output)

main()


