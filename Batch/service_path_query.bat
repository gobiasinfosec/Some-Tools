@echo off
::This script will query the services on the machine and then query the service paths
::Errors when there is a service with spaces in it's name

::Query services, output names to a file, rewrite old results files
echo Querying services
sc query | findstr /i service_name > c:\temp\services.txt
echo. > c:\temp\services_brief.txt
echo. > c:\temp\sc_output.txt
echo. > c:\temp\sc_error.txt
echo. > c:\temp\services_clean.txt

::Make the output from step 1 usable by sc qc
echo Cleaning up output
for /F "tokens=2delims=:" %%i in (C:\temp\services.txt) do (
                echo.%%i >> c:\temp\services_brief.txt
)

for /F %%i in (c:\temp\services_brief.txt) do (call :var_con "%%i")

:: Run the query for the binary path names, output success and failures to different files
::Name of service will be found under result
echo Querying path names
for /F "delims=" %%i in (c:\temp\services_clean.txt) do (
                sc qc %%i | findstr /i binary_path_name >> c:\temp\sc_output.txt && echo.%%i >> c:\temp\sc_output.txt
                sc qc %%i | findstr /i /c:"[SC] OpenService FAILED 1060" >> c:\temp\sc_error.txt && echo.%%i >> c:\temp\sc_error.txt
)

echo Complete- Output can be found at c:\temp\sc_output.txt, errors at c:\temp\sc_error.txt
PAUSE

::Remove the space
:var_con
SET var=%1
SET var=%var:~1%
echo."%var%" >> c:\temp\services_clean.txt
