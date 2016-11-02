@echo off
::This will count the lines in a file



::Input variables
set /p file="File you want to count lines in: "

::This will count each new line then pipe it to find for the total
findstr /R /N "^" %file% | find /C ":"

::Program is finished
PAUSE
