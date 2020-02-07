!define StrTrimNewLines "!insertmacro StrTrimNewLines Init ''"
!define UnStrTrimNewLines "!insertmacro StrTrimNewLines Init Un"
!macro StrTrimNewLines OutVar String
!verbose push
!verbose 3
!if "${OutVar}" == "Init"
	!undef ${String}StrTrimNewLines
	!define ${String}StrTrimNewLines "!insertmacro StrTrimNewLines "
	!if "${String}" != ""
	Function un.StrTrimNewLines
	!else
	Function StrTrimNewLines
	!endif
	!insertmacro StrTrimNewLines Func ''
	FunctionEnd
!else if "${OutVar}" == "Func"
	Exch $0
	Push $1
n:	StrCpy $1 $0 1 -1
	StrCmp $1 '$\r' +2
	StrCmp $1 '$\n' +1 e
	StrCpy $0 $0 -1
	Goto n
e:	Pop $1
	Exch $0
!else
	Push "${String}"
	!ifdef __UNINSTALL__
	Call un.StrTrimNewLines
	!else
	Call StrTrimNewLines
	!endif
	Pop "${OutVar}"
!endif
!verbose pop
!macroend
Function SplitFirstStrPart
  Exch $R0
  Exch
  Exch $R1
  Push $R2
  Push $R3
  StrCpy $R3 $R1
  StrLen $R1 $R0
  IntOp $R1 $R1 + 1
  loop:
    IntOp $R1 $R1 - 1
    StrCpy $R2 $R0 1 -$R1
    StrCmp $R1 0 exit0
    StrCmp $R2 $R3 exit1 loop
  exit0:
  StrCpy $R1 ""
  Goto exit2
  exit1:
    IntOp $R1 $R1 - 1
    StrCmp $R1 0 0 +3
     StrCpy $R2 ""
     Goto +2
    StrCpy $R2 $R0 "" -$R1
    IntOp $R1 $R1 + 1
    StrCpy $R0 $R0 -$R1
    StrCpy $R1 $R2
  exit2:
  Pop $R3
  Pop $R2
  Exch $R1 ;rest
  Exch
  Exch $R0 ;first
FunctionEnd
Function ReadINIFileKeys
      Exch $R0 ;INI file to write
      Exch
      Exch $R1 ;INI file to read
      Push $R2
      Push $R3
      Push $R4 ;uni var
      Push $R5 ;uni var
      Push $R6 ;last INI section
      ClearErrors ; So we don't error out for nonrelated reasons
      FileOpen $R2 $R1 r
 
      Loop:
       FileRead $R2 $R3   ;get next line into R3
       IfErrors Exit
 
       Push $R3
        Call StrTrimNewLines 
       Pop $R3
 
       StrCmp $R3 "" Loop   ;if blank line, skip
 
       StrCpy $R4 $R3 1   ;get first char into R4
       StrCmp $R4 ";" Loop   ;check it for semicolon and skip line if so(ini comment)
 
       StrCpy $R4 $R3 "" -1   ;get last char of line into R4
       StrCmp $R4 "]" 0 +6     ;if last char is ], parse section name, else jump to parse key/value
       StrCpy $R6 $R3 -1   ;get all except last char
       StrLen $R4 $R6     ;get str length
       IntOp $R4 $R4 - 1    ;subtract one from length
       StrCpy $R6 $R6 "" -$R4   ;copy all but first char to trim leading [, placing the section name in R6
      Goto Loop
 
       Push "="  ;push delimiting char
       Push $R3
        Call SplitFirstStrPart
       Pop $R4
       Pop $R5       
 
       WriteINIStr $R0 $R6 $R4 $R5      
 
      Goto Loop
      Exit:
 
      FileClose $R2
 
      Pop $R6
      Pop $R5
      Pop $R4
      Pop $R3
      Pop $R2
      Pop $R1
      Pop $R0
FunctionEnd
${StrTrimNewLines}
Section
;Call YESNO
 Push "read-from.ini"
 Push "write-to.ini"
 Call ReadINIFileKeys
SectionEnd
${UnStrTrimNewLines}
OutFile "LC2Navigator2019-Plugins-install.exe"