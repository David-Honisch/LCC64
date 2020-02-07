@echo off
set "link=%1"
set "linktitle=%2"
set "contentid=%3"
SET "LT=^<"
SET "RT=^>"
echo %LT%a href="#%link%" onclick="new HttpRequest().execCMD('call exec.bat %link%', '%contentid%')" %RT%
echo %linktitle%
echo %LT%/a%RT%
@echo on