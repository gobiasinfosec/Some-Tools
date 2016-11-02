@echo off
::Runs net user against a list of users

::Input variables
set /p file="File with user list(cannot be quoted): "
set /p out="File to output results to(will append .txt): "

::This will run net user against all the users int he list and output it to the specified file
for /F %%A in (%file%) do net user %%A /domain >> %out%.txt

PAUSE
