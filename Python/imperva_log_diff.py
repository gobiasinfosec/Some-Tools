#! Python3
# imperva_log_diff.py- version 1.0- 11/4/2016
# author: David Sullivan
#
# This program is designed to take CSV output from a SecureSphere failed
# login log, and look for differentials in the data. For example if there
# were multiple bad logins from the same account on different machines,
# it will parse them out. Or bad logins for multiple accounts from a single
# machine, it will parse that out as well and report on it.
#
#
# To do:
#   -give the use the ability to choose the fields they want to analyze
#   -allow comparison of more than 2 fields simultaneously

#import csv module for working with csv's
import csv

#use variables to define the source and output files
source = input(r'Location of source file: ')
output = input(r'Output location and filename (.txt will be appended): ')

#open the source file and convert it to a useable list
source_file = open(source,'r')
data_source = list(csv.reader(source_file))

#create empty list for storing data after analysis, cleaning up logs and output_file
compare_list = []
output_data = []
output_list = []
output_set = []

#create a function that will clean up data to smaller set
def cleanup(data_source):
    for n in data_source:
        compare_list.append((n[0],n[2]))
    return compare_list

#create a function that will parse the data look for differences
def diff_check(compare_list):
    output = []
    for n in range(len(compare_list)):
        for data_set in compare_list:
            if compare_list[n][1] == data_set[1] or compare_list[n][0] == data_set[0]:
                if compare_list[n] != data_set:
                    output.append((compare_list[n],data_set))
    output_set = list(set(output))
    return output_set

#create a function that will resort and remove duplicates
def dup_check(output_set):
    list_format = [list(x) for x in output_set]
    for l in list_format:
        l.sort()
    rehash = [tuple(x) for x in list_format]
    output_data = list(set(rehash))
    return output_data

#create a function to look for a result showing up more than 5 times
def multiple_check(compare_list):
    output = []
    for n in range(len(compare_list)):
        total = 0
        for data in compare_list:
            if data == compare_list[n]:
                total += 1
        if total >= 5:
            output.append((compare_list[n],total))
    multi_output = list(set(output))
    return multi_output

#create a function to output the results
def results(output_data):
    for n in output_data:
        if n[0][0] == n[1][0]:
            output_list.append(r'User: %s; Machines: %s, %s' % (n[0][0],n[0][1],n[1][1]))
        else:
            output_list.append(r'Users: %s, %s; Machine: %s' % (n[0][0],n[1][0],n[0][1]))
    for n in multi_output:
        output_list.append(r'Multiple Failures Detected: %s on %s, %s failed logins' % (n[0][0],n[0][1],n[1]))
    return output_list

#create a function to save the data to a csv
def save_results(output_list):
    output_file = open(output+r'.txt','w')
    for line in output_list:
        output_file.write(line + "\n")
    output_file.close()
    source_file.close()

#run the program
compare_list = cleanup(data_source)
output_set = diff_check(compare_list)
output_data = dup_check(output_set)
multi_output = multiple_check(compare_list)
output_list = results(output_data)
save_results(output_list)
