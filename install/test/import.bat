@echo off
cls
SET "LT=^<"
SET "RT=^>"
SET "LINE=%LT%hr%RT%"
set "resdir=%cd%\resources\"
set "sexec=%resdir%\app\sqlite\sqlite3.exe"
set "dbfile=%cd%\release-builds\lc2search-win32-ia32\resources\lc.db"
set "table=importscripts"
REM set "importsql=.\\resources\\sql\\updates.sql"
set "importsql=.\\resources\\sql\\import.sql"
echo %LINE%
call %cd%\resources\cmd\htmlelem.bat h1 IMPORT
@echo off
type %cd%\resources\html\clearbutton.html
type %cd%\resources\html\execbutton.html Refresh
echo %LINE%
type %cd%\resources\html\tabmenu.html
echo %LT%textarea style="min-width:300px;height:300px;" %RT%
echo %LT%p%RT%Add Clear entry%LT%/p%RT%
echo %LINE%
call %sexec% %dbfile% .line "select * from application where person_id = (select MAX(person_id) from application);"
REM call %sexec% %dbfile% "INSERT INTO %table% (first_name,name,url) values ('_Clear','echo.','echo.');"
REM call %sexec% %dbfile% "INSERT INTO other (first_name,name,url) values ('Delete Database','deletedatabase.bat','deletedatabase.bat');"
echo %LINE%
echo %LT%h3%RT%READING SQL SCRIPT RUNNING%LT%/h3%RT%
echo %LINE%

echo call %sexec% %dbfile% ".read %importsql%"
call %sexec% %dbfile% ".read %importsql%"
echo %LT%h3%RT%DOWNLOAD PLUGINS RUNNING%LT%/h3%RT%
echo %LINE%
REM del import.csv
REM call %cd%\resources\cmd\plugins.bat
@echo off
echo %LINE%
REM echo %LT%h3%RT%DOWNLOAD RUNNING%LT%/h3%RT%
REM echo %LINE%
REM del import.csv
REM call %cd%\resources\download.bat
REM @echo off
REM echo %LINE%
echo %LT%h4%RT%IMPORT SERVICES%LT%/h4%RT%
REM call %cd%\resources\services.bat
@echo off
echo %LT%h4%RT%IMPORT DONE%LT%/h4%RT%
echo %LT%/textarea%RT%
REM type %cd%\resources\html\execbutton.html EXECUTE

type %cd%\resources\html\import.html
type %cd%\resources\html\footer.html

echo %LINE%
REM echo quit
REM echo exit
REM echo Bye
REM type %cd%\resources\html\import.html
call %cd%\resources\cmd\getscript.bat "%cd%\resources\html\core.js"
echo %LINE%
echo %LT%h4%RT%IMPORT DONE%LT%/h4%RT%
type %cd%\resources\html\clearbutton.html
timeout 3 > NUL
@echo on