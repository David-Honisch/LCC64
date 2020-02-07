@echo off
cls
call %cd%\resources\cmd\htmlelem.bat h1 UPDATES
@echo off
REM echo %LT%div class='container-fluid cm-container-white' %RT%
call %cd%\resources\cmd\update.config.bat h1 UPDATES
@echo off
echo %LT%p%RT% MENU %LT%/p%RT%
call %cd%\resources\cmd\getlnk.bat menu.bat menu.bat appcnt
@echo off
echo %LT%p%RT% EOF MENU %LT%/p%RT%
echo %LINE%
echo %LT%p%RT% DELETING %UPDATEFILE% %LT%/p%RT%
echo %LINE%
DEL %UPDATEFILE%
echo %LT%p%RT% DOWNLOADING %RPATH%%UPDATEFILE% %LT%/p%RT%
echo %LT%p%RT% AND WRITING TO %cd%\%UPDATEFILE% %LT%/p%RT%
echo %LINE%
REM call %cd%\resources\cmd\dl.bat "%RPATH%%UPDATEFILE%"  true autodownload
@echo off
REM call extract "%cd%\%UPDATEFILE%"
@echo off
echo %LINE%
echo %LT%p%RT% Creating %showhtml% %LT%/p%RT%
%sexec% %dbfile% -line -csv "select * from application limit 10"
%sexec% %dbfile% -html "select * from application limit 10" > %showhtml%
type %showhtml%



echo %LT%p%RT% EXECUTING %SQLFILE% %LT%/p%RT%
echo %sexec% %dbfile% ".read %SQLFILE%"
%sexec% %dbfile% ".read %SQLFILE%"
@echo off
echo %LINE%
echo %LT%p%RT%IMPORTING %cd%\%UPDATEFILE% DONE %LT%/p%RT%
echo %LINE%
type %resdir%\html\clearbutton.html
type %resdir%\html\execbutton.html EXECUTE
call %resdir%\cmd\htmlelem.bat h3 IMPORT_DONE
@echo off
echo %LINE%
echo %LINE%
REM echo call %sexec% %dbfile% "%QUERY%"
REM call %sexec% %dbfile% "%QUERY%"
REM call %sexec% %dbfile% "%QUERY2%"
REM echo %LINE%
REM echo %LT%/div%RT%
@echo on