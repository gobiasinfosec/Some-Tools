#! Python3
# csv_converter.py- version 1.0- 10/5/2016
# author: David Sullivan
#
# This program is designed to open a CSV and read each line row by row
# and create a new csv that uses the first cell as a 'group' for the
# row and create new rows for each subsequent cell.
#
# eg. 1, 2, 3, 4 becomes:
# 1,2
# 1,3
# 1,4

#import csv module for working with csvs
import csv

#use variables to define the source and output files
source = input(r'Location of source file: ')
output = input(r'Output location and filename (.csv will be appended): ')

#open the source file and convert it to a useable list
source_file = open(source,'r')
source_list = list(csv.reader(source_file))

#create empty list and write converted data to new list
output_list = []
for x in range(len(source_list)):
    for y in range(len(source_list[x])):
        if y != 0:
            output_list.append([source_list[x][0],source_list[x][y]])

#write net list to new file
output_file = open(output+r'.csv','w',newline='')
write_output = csv.writer(output_file)
write_output.writerows(output_list)
output_file.close()
