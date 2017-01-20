#! python3
# massClean.py - v1.0
# Author- David Sullivan
# revision 1.0- 1/20/2017
#
# Runs masscan against its target list and automatically cleans up the
# the data to a more useable format
#
# Revision 1.0 - Initial creation of script

import getopt, os, sys, datetime

#globals
ports = ''
target = ''
output = ''
time = (str(datetime.datetime.now()).split(' ')[0])

def usage():
    print('MassScan Clean Output (Only Output IPs)- python3')
    print()
    print('Usage: python3 massEnum.py -t 192.168.1.0/24 -p 21 -o output.txt')
    print('-t --target	-target network')
    print('-p --port    -ports to scan')
    print('-o --output	-output file location')
    print('-h --help	-print this help file')
    print('***Requires MassScan to be installed***')
    sys.exit()

def masscan(ports, target, output):
    print('Running masscan against %s' % target)
    arguments = 'masscan -p %s %s > %s' % (ports,target,output)
    os.system(arguments)

def cleanup(ports, target, output):
    oList = []
    newList = []

    #Build a working list to compare ports against
    compareList = ports.split(',')
    for portno in range(len(compareList)):
        compareList[portno] = ('%s/tcp' % compareList[portno])

    f = open(output, 'r')
    print('Cleaning up output')

    #extract the IP address and Port from each line
    for line in f:
        oList.append([(line.split()[3]),(line.split()[-1])])
    f.close()

    #sort the results to different output files based on port
    for portno in compareList:
        for result in range(len(oList)):
            if oList[result][0] == portno:
                newList.append(oList[result][1])

        #remove duplicates and put in numerical order by IP
        newList = list(set(newList))
        newList.sort(key=lambda s: list(map(int, s.split('.'))))

        #save/overwrite file
        out = open(('%s_%s' % (output, (portno.split('/')[0]))), 'w')
        for address in newList:
          out.write(address+'\n')
        out.close()
        newList = []


def main():
    global ports, target, output, time

    #if no arguments given, run usage
    if not len(sys.argv[1:]):
        usage()

    #read the commandline options
    try:
        opts,args = getopt.getopt(sys.argv[1:],'o:p:ht:o',['output','target','port','help'])
    except getopt.GetoptError as err:
        print(str(err))
        usage()
	
    #handle arguments
    for o,a in opts:
        if o in ('-h','--help'):
            usage()
        elif o in ('-t','--target'):
            target = a
        elif o in ('-p','--port'):
            ports = a
        elif o in ('-o','--output'):
            output = a
        else:
            assert False, ('Unhandled option')

    #add timestamp and range to output
    output = ('%s_%s_%s' % (output, time,('%s-%s' % ((target.split('/')[0]),(target.split('/')[1])))))

    #call masscan with options
    masscan(ports, target, output)
    cleanup(ports, target, output)

    print('Results can be found in %s_%s (with appended port results)' % (output))

main()


