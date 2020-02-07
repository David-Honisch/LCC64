@echo off
set "resdir=%cd%\resources\"
set "sexec=%resdir%app\sqlite\sqlite3.exe"
set "dbfile=%cd%\release-builds\lc2search-win32-ia32\resources\lc.db"
set "table=importscripts"
SET "QUERY=select * from %table% limit 1000000;"
SET "QUERY2=INSERT INTO %table% (name) values ('Test');"
set "RPATH=https://raw.githubusercontent.com/David-Honisch/Microsoft-Windows/master/LC2Navigator2019/"
set "UPDATEFILE=appplugin.zip"
set "SQLFILE=.\\resources\\sql\\updates.sql"
set "showhtml=..\html\~show.html"
@echo on