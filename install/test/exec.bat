@echo off
cls
SET "LT=^<"
SET "RT=^>"
SET "LINE=%LT%hr%RT%"
echo %LT%h3%RT% %1 %LT%/h3%RT%
call %1
@echo on