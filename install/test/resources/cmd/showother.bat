@echo off
cls
call %cd%\resources\cmd\htmlelem.bat h1 UPDATES_OTHERS
@echo off
set "resdir=%cd%\resources\"
set "getlink=%resdir%cmd\getllink.bat"
set "sexec=%resdir%app\sqlite\sqlite3.exe"
set "dbfile=%cd%\release-builds\lc2search-win32-ia32\resources\lc.db"
set "table=importscripts"
echo %LT%textarea style="min-width:140px;height:100px;" %RT%
echo %LT%/textarea%RT%
%sexec% %dbfile% -html -line -csv "select url from %table% limit 10" > ~sql.csv
echo %LT%hr%RT%
for /f "usebackq tokens=1-4 delims=," %%a in ("%cd%\~sql.csv") do (
	REM echo %%a;
	REM echo call %getlink% "%%a" "%%a"
	call %getlink% %%a %%a
	echo %LT%hr%RT%
	@echo off
   REM call %sexec% %dbfile% "INSERT INTO %table% (first_name,name,url) values ('%%~na%%~xa','%%a',REPLACE('%%a','\','\\'));"
)

echo %LINE%
type %cd%\resources\html\clearbutton.html
type %cd%\resources\html\execbutton.html Refresh
@echo on