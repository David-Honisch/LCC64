@echo off
cls
REM %cd%\resources\cmd\htmlelem.bat h1 HTML_ELEMENTS_IMPORT
REM @echo off
set "resdir=%cd%\resources\"
set "sexec=%resdir%app\sqlite\sqlite3.exe"
set "dbfile=%cd%\release-builds\lc2search-win32-ia32\resources\lc.db"
set "table=importscripts"
SET "QUERY=select * from %table% limit 1000000;"
SET "QUERY2=INSERT INTO %table% (name) values ('Test');"
set "RPATH=https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2Navigator2019/"
set "UPDATEFILE=plugins.sql"
echo %LINE%
echo %LT%p%RT% DELETING %UPDATEFILE% %LT%/p%RT%
echo %LINE%
DEL %cd%\%UPDATEFILE%
echo %LT%p%RT% DOWNLOADING %UPDATEFILE% %LT%/p%RT%
echo %LT%p%RT% FROM %RPATH% %LT%/p%RT%
echo %LT%p%RT% AND WRITING TO %cd%\%UPDATEFILE% %LT%/p%RT%
echo %LINE%
call %cd%\resources\cmd\dl.bat "%RPATH%%UPDATEFILE%"  true autodownload
@echo off
echo %LINE%
REM timeout 10>NUL
echo %LT%p%RT% EXECUTING %UPDATEFILE% %LT%/p%RT%
echo call %sexec% %dbfile% ".read .\%UPDATEFILE%"
call %sexec% %dbfile% ".read .\\%UPDATEFILE%"
@echo off
echo %LINE%
echo %LT%p%RT%IMPORTING %cd%\%UPDATEFILE% DONE %LT%/p%RT%
echo %LINE%
type %cd%\resources\html\clearbutton.html
type %cd%\resources\html\execbutton.html EXECUTE
call %cd%\resources\cmd\htmlelem.bat h3 IMPORT_DONE
@echo off
echo %LINE%
echo %LINE%
REM echo call %sexec% %dbfile% "%QUERY%"
REM call %sexec% %dbfile% "%QUERY%"
REM call %sexec% %dbfile% "%QUERY2%"
REM echo %LINE%
timeout 3 > NUL
@echo on