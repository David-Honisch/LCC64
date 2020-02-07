@echo off
set "RPATH=https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2Navigator2019/"
set "UPDATEFILE=appplugin.zip"
echo %LINE%
call %cd%\resources\htmlelem.bat p IMPORT_RUNNING
@echo off
call %cd%\resources\htmlelem.bat p SQLIMPORT_RUNNING
@echo off
REM dir /b /s *plugin* > plugins.csv
call %sexec% %dbfile% ".read %cd%\resources\plugins.sql"
REM pause
REM echo %LINE%
REM echo %cd%\plugins.csv
REM echo %LINE%
REM echo %LINE%
REM echo %LT%p%RT%DOWNLOADING %cd%\%UPDATEFILE%%LT%/p%RT%
REM del appplugin.zip
REM echo %LT%p%RT%DOWNLOADING %cd%\%UPDATEFILE%%LT%/p%RT%
REM call LC2MultiDownloader.exe "%RPATH%%UPDATEFILE%"  true autodownload
REM call extract.exe %UPDATEFILE%
REM @echo off
REM echo %LINE%
REM for /f "usebackq tokens=1-4 delims=," %%a in ("%cd%\plugins.csv") do (
      REM echo %%a %%b %%c %%d
	  REM if not exist %%a (
		REM call LC2MultiDownloader.exe %RPATH%%%a  true autodownload
	  REM ) else ( 
		REM echo %%a found.
	  REM )
REM )
echo %LINE%
call %cd%\resources\htmlelem.bat h3 IMPORT_DONE
@echo off
echo %LINE%
@echo on