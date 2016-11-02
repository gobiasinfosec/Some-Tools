@echo off

::Input variables
ECHO Names in list must be in the following form DOMAIN\username
ECHO.
set /p name="Name of search list: "
ECHO -------------------------------------------------------
set /p save="Name of output file (will be appended with .txt): "
ECHO -------------------------------------------------------

ECHO Processing...

echo %DATE%_%TIME% Processing >> %save%.txt

::This query will the group permissions for each user in the file
for /F %%A in (%name%) do (
	echo ------------------------------------>> %save%.txt
	echo User: %%A >> %save%.txt
	echo ------------------------------------>> %save%.txt
	dsquery user -samid %%A | dsget user -memberof | dsget group -samid >> %save%.txt
        echo.
)

::Program is finished
ECHO Task Complete.
PAUSE