
!ifdef HAVE_UPX
!packhdr tmp.dat "upx\upx -9 tmp.dat"
!endif

!ifdef NOCOMPRESS
SetCompress off
!endif


;--------------------------------
;Multilanguage Support
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Dutch.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\French.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\German.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Korean.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Russian.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Spanish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Swedish.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\TradChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\SimpChinese.nlf"
LoadLanguageFile "${NSISDIR}\Contrib\Language files\Slovak.nlf"
;--------------------------------
;--------------------------------
;Version Information

  VIProductVersion "1.2.3.4"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "LC2Navigator2019"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "LC2Navigator2019 Client"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "letztechance.org"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "no trademark"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© 2014 by David Honisch"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "LC2Navigator2019"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.0.0"

;--------------------------------

Name LC2Navigator2019-PluginInstaller
Caption "LC2Navigator2019-PluginInstaller Install (c)by http://www.letztechance.org"
Icon "${NSISDIR}\Contrib\Graphics\Icons\lc.ico"
OutFile "LC2Navigator2019-PluginInstaller.exe"
;SetDateSave on
SetDatablockOptimize on
CRCCheck on
;SilentInstall normal
;BGGradient FFFFFF A66E3C 000000
;InstallColors A66E3C FFFFFF
;XPStyle on
AutoCloseWindow false
ShowInstDetails show

!include Sections.nsh
 
Page components
Page instfiles
ShowInstDetails show
 
; This file will exist on most computers
Section /o "autoexec.bat detected" autoexec_detected
MessageBox MB_OK autoexec
SectionEnd
 
Section /o "Boot.ini detected" boot_detected
MessageBox MB_OK boot
SectionEnd
 
Section /o "non-existing file detected" missing_detected
MessageBox MB_OK missing
SectionEnd
 
Function .onInit
IfFileExists C:\autoexec.bat AutoexecExists PastAutoexecCheck
AutoexecExists:
  ; This is what is done by sections.nsh SelectSection macro
  SectionGetFlags "${autoexec_detected}" $0
  IntOp $0 $0 | ${SF_SELECTED}
  SectionSetFlags "${autoexec_detected}" $0
 
PastAutoexecCheck:
IfFileExists C:\boot.ini BootExists PastBootCheck
BootExists:
  ; Use the macro from sections.nsh
  !insertmacro SelectSection ${boot_detected}
 
PastBootCheck:
IfFileExists C:\xyz_missing.xyz MissingExists PastMissingCheck
MissingExists:
  !insertmacro SelectSection ${missing_detected}
 
PastMissingCheck:
FunctionEnd
Section Write
FileOpen $4 "$DESKTOP\SomeFile.txt" a
FileSeek $4 0 END
FileWrite $4 "$\r$\n" ; we write a new line
FileWrite $4 "hello"
FileWrite $4 "$\r$\n" ; we write an extra line
FileClose $4 ; and close the file
SectionEnd
Section Read
FileOpen $4 "$DESKTOP\SomeFile.txt" r
FileSeek $4 1000 ; we want to start reading at the 1000th byte
FileRead $4 $1 ; we read until the end of line (including carriage return and new line) and save it to $1
FileRead $4 $2 10 ; read 10 characters from the next line
FileClose $4 ; and close the file
SectionEnd