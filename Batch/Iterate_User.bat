::This is designed to be used with the powershell script to enumerate share drive NTFS permissions
::You run users or groups against the output of that script to see if they have explicit permissions on the share
::This will output the line that the permission was found on
::To do- Design this to output the line that shows which folder the permission was found on

@echo off
::Input variables
set /p list="Name of search list: "
set /p search="File you would like to search: "
set /p save="Name of output file: "


::This runs each line of the argument list against the target list, not case sensitive
::It will export any matches, along with which line it was found on to the output file
ECHO Processing...
for /F %%A in (%list%) do FINDSTR /i /n /r /c:"%%A" %search% >> %save%

::Program is finished
ECHO Task Complete.
PAUSE
