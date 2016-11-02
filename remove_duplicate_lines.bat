@echo off
:: This will remove duplicate lines from a file and output it as a text file


SetLocal EnableDelayedExpansion

::Input variables
set /p file="File with duplicates: "
set /p output="Name of output file (will be.txt): "

::append $ to the beginning of unique variable and output to a new file
for /F "delims==" %%a in ('set $ 2^>nul') DO set "%%a="

for /f "delims==" %%a in (%file%) DO set $%%a=Y
(for /F "delims==" %%a in ('set $ 2^>Nul') DO echo %%a) > %output%.txt

::Remove first character from output file
FOR /F "delims=*" %%A IN (%output%.txt) DO (
	set line=%%A
	echo.!line:~1! >> %output%_complete.txt
)


::Program is finished
ECHO Task Complete.
PAUSE
