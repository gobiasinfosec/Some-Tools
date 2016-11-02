@echo off

::Input variables
set /p name="Username you want to enumerate: "
set /p save="Name of output file (will be .txt): "

ECHO Processing...

::This query will enumerate a single user's group permissions
echo ------------------------------------> %save%.txt
echo User: %name% >> %save%.txt
echo ------------------------------------>> %save%.txt
dsquery user -samid %name% | dsget user -memberof | dsget group -samid >> %save%.txt

::Program is finished
ECHO Task Complete.
PAUSE