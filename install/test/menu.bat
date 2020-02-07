@echo off
SET "LT=^<"
SET "RT=^>"
cls
echo %LT%div class='container-fluid cm-container-white' %RT%
echo %LT%h3%RT%READING HOME%LT%/h3%RT%
type %cd%\resources\html\home.html
echo %LT%/div%RT%
timeout 0 > NUL
@echo on