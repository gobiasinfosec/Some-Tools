::This script will search the NTFS permissions on a share for the specified user in a list of users
::Each users permissions will be output to a new file
::This is a time consuming process, especially on large shares or with a number of users

@echo off
ECHO -------------------------------------------------------
ECHO -                                                     -
ECHO -     ENUMERATE USER PERMISSIONS ON A DIRECTORY       -
ECHO -                                                     -
ECHO -------------------------------------------------------
ECHO -    This program must be run as an administrator     -
ECHO -------------------------------------------------------
ECHO -   You must have SubInACL installed from Microsoft   -
ECHO -------------------------------------------------------

ECHO To run correctly, please put files in the following directory c:\enum_share
cd c:\enum_share
ECHO -------------------------------------------------------




::Input variables
ECHO.
ECHO Names in list must be in the following form DOMAIN\username
ECHO Put in the full path to where the file is (eg. C:\file.txt)
ECHO.
set /p list="Name of search list: "
ECHO -------------------------------------------------------
ECHO.
ECHO Do not put the trailing \ after the foldername
ECHO.
set /p search="Share to search (eg. \\server\share): "
ECHO -------------------------------------------------------
ECHO.
ECHO Each username will be appended to the output file name and given .txt extension
ECHO The final output file will be titled (user_output_complete.txt)
ECHO.
set /p save="Name of output file: "
ECHO -------------------------------------------------------




::This turns on delay expanded variables and clears the screen
setlocal ENABLEDELAYEDEXPANSION
CLS



::This runs each line of the argument list against the share to find permissions
::It will export any matches and failures to the output file
ECHO Querying...
for /F %%A in (%list%) do (
	call :var_ex %%A
	"c:\Program Files (x86)\Windows Resource Kits\Tools\subinacl.exe" /testmode /outputlog=!var2!_%save%.txt /subdirectories=directoriesonly "%search%"\*.* /findsid="%%A"
)



ECHO.
ECHO ---------------------------------------------------------------
::This will now parse the output file for directories and put them in a new output file
ECHO Searching...
for /F %%A in (%list%) do (
	call :var_ex %%A
	cmd /a /c TYPE !var2!_%save%.txt > !var2!_%save%_ansi.txt
	FINDSTR /i /r /c:"+File" !var2!_%save%_ansi.txt >> !var2!_%save%_directories.txt
)



ECHO.
ECHO ---------------------------------------------------------------
::This will convert the output from the last step to a usable form
ECHO Converting...
FOR /F "tokens=*" %%A IN (!var2!_%save%_directories.txt) DO (call :var_con "%%A")


::Program is finished
ECHO Task Complete.
PAUSE


::This is the conversion process
:var_con
SET "var3="%1""
SET "var3=%var3:"=%"
SET "var4=%var3:~6,999%"
ECHO "%var4%" >> !var2!_%save%_complete.txt
GOTO loop


::This creates a variable based on the user name
:var_ex
SET var=%1
SET var2=%var:~4,10%


::This prevents labels from running over eachother
:loop
