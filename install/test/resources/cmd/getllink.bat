@echo off
set "link=%1"
set "title=%2"
SET "LT=^<"
SET "RT=^>"
rem <input id="btnClear" type="button" value="Refresh" onclick="new HttpRequest().execCMD('call import.bat', 'cnt')"></input>
echo %LT%a href="#%link%" onclick="new HttpRequest().execCMD('call exec.bat %link%', 'appcnt')" %RT%
echo %title%
echo %LT%/a%RT%
@echo on