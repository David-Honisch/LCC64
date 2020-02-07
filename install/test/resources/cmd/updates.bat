@echo off
cls
echo %LT%div class='container-fluid cm-container-white' %RT%
call %cd%\resources\cmd\updatesnofluid.bat
echo %LT%/div%RT%
@echo on