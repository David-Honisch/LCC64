@echo off
set "link=%1"
set "title=%2"
SET "LT=^<"
SET "RT=^>"
echo %LT%a href="%link%" %RT%
echo %title%
echo %LT%/a%RT%
@echo on