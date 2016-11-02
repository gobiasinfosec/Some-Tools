@echo off

::Browser Warning Message
ECHO ---------------------------------------
ECHO This will ping every site in the list
ECHO ---------------------------------------
ECHO.



::Input variables
set /p file="Filename for list of IPs/domains: "
set /p out="Name of Output file(will be .txt): "
ECHO Processing...


:Check the sites at who.is
for /F %%A in (%file%) DO ping %%A >> %out%.txt


::Program is finished
ECHO Task Complete.
PAUSE
