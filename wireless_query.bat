@echo off

::This batch file should be run as administrator
::It will query the machine for saved wireless networks and print the password in plaintext

::Cleanup old files. 
echo. > c:\temp\network_ids_clean.txt 
echo. > c:\temp\network_output.txt

::Get Saved Network User Profiles
echo Running
netsh wlan show all | findstr /c:"SSID name" > c:\temp\network_ids.txt


::Cleanup Network User Profiles
for /F "tokens=2delims=::" %%i in (c:\temp\network_ids.txt) do (
                echo.%%i >> c:\temp\network_ids_clean.txt 
)

PAUSE

:: Pull password for each network
echo Querying path names
for /F "delims=" %%i in (c:\temp\network_ids_clean.txt) do (
		echo %%i
                netsh wlan show profile name=%%i key=clear | findstr /c:"SSID name" >> c:\temp\network_output.txt
                netsh wlan show profile name=%%i key=clear | findstr /c:"Authentication" >> c:\temp\network_output.txt
                netsh wlan show profile name=%%i key=clear | findstr /c:"Key Content" >> c:\temp\network_output.txt
		echo --------------------------------------------------- >> c:\temp\network_output.txt

)

echo Complete- Output can be found at c:\temp\network_output.txt
PAUSE
