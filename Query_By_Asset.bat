@echo off
::Quick dsquery script that just asks for the machine name


:Ask
set /P name=Please type the computer name: 

::This is the query
dsquery computer -name "%name%"* | dsget computer -desc

PAUSE