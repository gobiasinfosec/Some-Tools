@echo off
::This will do a dir search on the users folder of any machines specified in the file
::Requires workstation admin

::Input variables
set /p computer_list="File containing computer names: "
set /p save="Name of output file (will be .txt): "




::This iterates each computer in the list and adds it using the net use command, then does a dir search on the directory to find interesting file names
for /F %%i in (%computer_list%) do (
	net use z: \\%%i\c$\users
	dir /s z:\*passwd* z:\*password* z:\*pass*.xls* >> %save%.txt
	net use /delete z:
)




::Program is finished
ECHO Task Complete.
PAUSE