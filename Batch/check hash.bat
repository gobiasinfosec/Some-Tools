@echo off
::Requires Windows FCIV
::Gives both MD5 and SHA1 hashes

::Set Variables
set /p fciv="Path to fciv executable: "
set /p path="Path to file you want to check: "
set /p out="Output file name (will be saved to c:\temp\%name%_hash.txt): " 

:Run FCIV
"%fciv%" -both %path% >> c:\temp\%out%_hash.txt
