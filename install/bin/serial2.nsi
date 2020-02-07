!define TEMP1 $R0 ;Temp variable
;Written by Rohit
;Include Modern UI
!include "MUI.nsh"
Name "serial Test"
OutFile "serial.exe"
InstallDir "$PROGRAMFILES\Modern UI Test"
!define MUI_ABORTWARNING
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${NSISDIR}\Contrib\Modern UI\License.txt"
Page custom SetCustom ValidateCustom ": Testing InstallOptions" ;Custom page. InstallOptions gets called in SetCustom.
Page instfiles
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH
 
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH
 
!insertmacro MUI_LANGUAGE "English"
 
;Things that need to be extracted on startup (keep these lines before ;any File command!)
 
;Use ReserveFile for your own InstallOptions INI files too!
 
ReserveFile "${NSISDIR}\Plugins\InstallOptions.dll"
ReserveFile "test.ini"
 
;Order of pages
Page custom SetCustom ValidateCustom ": Testing InstallOptions" ;Custom page. InstallOptions gets called in SetCustom.
 
Page instfiles
 
Section "Components"
 
 
  ;Get Install Options dialog user input
 
  ReadINIStr ${TEMP1} "$PLUGINSDIR\test.ini" "Field 1" "State"
  DetailPrint "Password X=${TEMP1}"
 
 
SectionEnd
 
Function .onInit
 
  ;Extract InstallOptions files
  ;$PLUGINSDIR will automatically be removed when the installer closes
 
  InitPluginsDir
  File /oname=$PLUGINSDIR\test.ini "test.ini"
 
FunctionEnd
 
Function SetCustom
 
  ;Display the InstallOptions dialog
 
  Push ${TEMP1}
 
    InstallOptions::dialog "$PLUGINSDIR\test.ini"
    Pop ${TEMP1}
 
  Pop ${TEMP1}
 
FunctionEnd
 
Function ValidateCustom
 
FileOpen $1 $EXEDIR\${TEMP1}.ini w
FileClose $1
 
  done:
 
FunctionEnd
 
 
;--------------------------------
;Installer Sections
 
Section "Dummy Section" SecDummy
 
  SetOutPath "$INSTDIR"
 
  ;ADD YOUR OWN FILES HERE...
 
  ;Store installation folder
  WriteRegStr HKCU "Software\serial Test" "" $INSTDIR
 
  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
 
SectionEnd
 
 
;--------------------------------
;Descriptions
 
  ;Language strings
  LangString DESC_SecDummy ${LANG_ENGLISH} "A test section."
 
  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
 
;--------------------------------
;Uninstaller Section
 
Section "Uninstall"
 
  ;ADD YOUR OWN FILES HERE...
 
  Delete "$INSTDIR\Uninstall.exe"
 
  RMDir "$INSTDIR"
 
  DeleteRegKey /ifempty HKCU "Software\serial Test"
 
SectionEnd