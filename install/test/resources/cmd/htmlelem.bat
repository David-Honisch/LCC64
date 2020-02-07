@echo off
SET "LT=^<"
SET "RT=^>"
SET "XV=%1"
SET "XT=%2"
SET "CROW=%LT%%XV%%RT%%XT%%LT%/%XV%%RT%"
echo %CROW%
@echo on