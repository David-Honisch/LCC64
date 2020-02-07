!include MUI.nsh
!include WinMessages.nsh
 
; Local bitmap path.
!define BITMAP_FILE forest.bmp
 
; --------------------------------------------------------------------------------------------------
; Installer Settings
; --------------------------------------------------------------------------------------------------
 
Name "Background Bitmap"
OutFile "bgbitmap.exe"
 
ShowInstDetails show
 
; --------------------------------------------------------------------------------------------------
; Modern UI Settings
; --------------------------------------------------------------------------------------------------
 
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_CUSTOMFUNCTION_GUIINIT MyGUIInit
 
; --------------------------------------------------------------------------------------------------
; Definitions
; --------------------------------------------------------------------------------------------------
 
!define LR_LOADFROMFILE     0x0010
!define LR_CREATEDIBSECTION 0x2000
!define IMAGE_BITMAP        0
 
!define SS_BITMAP           0x0000000E
!define WS_CHILD            0x40000000
!define WS_VISIBLE          0x10000000
!define HWND_TOP            0
!define SWP_NOSIZE          0x0001
!define SWP_NOMOVE          0x0002
 
!define IDC_BITMAP          1500
 
; typedef struct _RECT {
;   LONG left;
;   LONG top;
;   LONG right;
;   LONG bottom;
; } RECT, *PRECT;
!define stRECT "(i, i, i, i) i"
 
Var hBitmap
 
; --------------------------------------------------------------------------------------------------
; Pages
; --------------------------------------------------------------------------------------------------
 
!define MUI_PAGE_CUSTOMFUNCTION_SHOW WelcomePageShow
!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_CUSTOMFUNCTION_SHOW LicensePageShow
!insertmacro MUI_PAGE_LICENSE bgbitmap.nsi
#!define MUI_PAGE_CUSTOMFUNCTION_SHOW DirectoryPageShow
#!insertmacro MUI_PAGE_DIRECTORY
!define MUI_PAGE_CUSTOMFUNCTION_SHOW ComponentsPageShow
!insertmacro MUI_PAGE_COMPONENTS
!define MUI_PAGE_CUSTOMFUNCTION_SHOW InstFilesPageShow
!insertmacro MUI_PAGE_INSTFILES
!define MUI_PAGE_CUSTOMFUNCTION_SHOW FinishPageShow
!insertmacro MUI_PAGE_FINISH
 
; --------------------------------------------------------------------------------------------------
; Languages
; --------------------------------------------------------------------------------------------------
 
!insertmacro MUI_LANGUAGE English
 
; --------------------------------------------------------------------------------------------------
; Macros
; --------------------------------------------------------------------------------------------------
 
; Destroy a window.
!macro DestroyWindow HWND IDC
  GetDlgItem $R0 ${HWND} ${IDC}
  System::Call `user32::DestroyWindow(i R0)`
!macroend
 
; Give window transparent background.
!macro SetTransparent HWND IDC
  GetDlgItem $R0 ${HWND} ${IDC}
  SetCtlColors $R0 0xFFFFFF transparent
!macroend
 
; Refresh window.
!macro RefreshWindow HWND IDC
  GetDlgItem $R0 ${HWND} ${IDC}
  ShowWindow $R0 ${SW_HIDE}
  ShowWindow $R0 ${SW_SHOW}
!macroend
 
; --------------------------------------------------------------------------------------------------
; Functions
; --------------------------------------------------------------------------------------------------
 
Function MyGUIInit
 
  ; Extract bitmap image.
  InitPluginsDir
  ReserveFile `${BITMAP_FILE}`
  File `/ONAME=$PLUGINSDIR\bg.bmp` `${BITMAP_FILE}`
 
  ; Get the size of the window.
  System::Call `*${stRECT} .R0`
  System::Call `user32::GetClientRect(i $HWNDPARENT, i R0)`
  System::Call `*$R0${stRECT} (, , .R1, .R2)`
  System::Free $R0
 
  ; Create bitmap control.
  System::Call `kernel32::GetModuleHandle(i 0) i.R3`
  System::Call `user32::CreateWindowEx(i 0, t "STATIC", t "", i ${SS_BITMAP}|${WS_CHILD}|${WS_VISIBLE}, i 0, i 0, i R1, i R2, i $HWNDPARENT, i ${IDC_BITMAP}, i R3, i 0) i.R1`
  System::Call `user32::SetWindowPos(i R1, i ${HWND_TOP}, i 0, i 0, i 0, i 0, i ${SWP_NOSIZE}|${SWP_NOMOVE})`
 
  ; Set the bitmap.
  System::Call `user32::LoadImage(i 0, t "$PLUGINSDIR\bg.bmp", i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_CREATEDIBSECTION}|${LR_LOADFROMFILE}) i.s`
  Pop $hBitmap
  SendMessage $R1 ${STM_SETIMAGE} ${IMAGE_BITMAP} $hBitmap
 
  ; Set transparent backgrounds.
  !insertmacro SetTransparent $HWNDPARENT 3
  !insertmacro SetTransparent $HWNDPARENT 1
  !insertmacro SetTransparent $HWNDPARENT 2
  !insertmacro SetTransparent $HWNDPARENT 1034
  !insertmacro SetTransparent $HWNDPARENT 1037
  !insertmacro SetTransparent $HWNDPARENT 1038
 
  ; Remove unwanted controls.
  !insertmacro DestroyWindow  $HWNDPARENT 1256
  !insertmacro DestroyWindow  $HWNDPARENT 1028
  !insertmacro DestroyWindow  $HWNDPARENT 1039
 
FunctionEnd
 
; Refresh parent window controls.
; Has to be done for some controls if they have a
; transparent background.
Function RefreshParentControls
 
  !insertmacro RefreshWindow  $HWNDPARENT 1037
  !insertmacro RefreshWindow  $HWNDPARENT 1038
 
FunctionEnd
 
; For welcome page.
Function WelcomePageShow
 
  ; Set transparent backgrounds.
  SetCtlColors $MUI_HWND 0xFFFFFF transparent
  !insertmacro SetTransparent $MUI_HWND 1200
  !insertmacro SetTransparent $MUI_HWND 1201
  !insertmacro SetTransparent $MUI_HWND 1202
 
FunctionEnd
 
; For license page.
Function LicensePageShow
 
  ; Set transparent backgrounds.
  FindWindow $MUI_HWND "#32770" "" $HWNDPARENT
  SetCtlColors $MUI_HWND 0xFFFFFF transparent
  !insertmacro SetTransparent $MUI_HWND 1040
  !insertmacro SetTransparent $MUI_HWND 1000
  !insertmacro SetTransparent $MUI_HWND 1006
  !insertmacro SetTransparent $MUI_HWND 1034
  !insertmacro SetTransparent $MUI_HWND 1035
 
  ; Refresh controls.
  Call RefreshParentControls
 
FunctionEnd
 
; For directory page.
Function DirectoryPageShow
 
  ; Set transparent backgrounds.
  FindWindow $MUI_HWND "#32770" "" $HWNDPARENT
  SetCtlColors $MUI_HWND 0xFFFFFF transparent
  !insertmacro SetTransparent $MUI_HWND 1019
  !insertmacro SetTransparent $MUI_HWND 1001
  !insertmacro SetTransparent $MUI_HWND 1024
  !insertmacro SetTransparent $MUI_HWND 1008
  !insertmacro SetTransparent $MUI_HWND 1023
  !insertmacro SetTransparent $MUI_HWND 1006
  !insertmacro SetTransparent $MUI_HWND 1020
 
  ; Remove group box text. $R0 still contains HWND of 1020 :)
  SendMessage $R0 ${WM_SETTEXT} 0 STR:
 
  ; Refresh controls.
  Call RefreshParentControls
 
FunctionEnd
 
; For components page.
Function ComponentsPageShow
 
  ; Set transparent backgrounds.
  FindWindow $MUI_HWND "#32770" "" $HWNDPARENT
  SetCtlColors $MUI_HWND 0xFFFFFF transparent
  !insertmacro SetTransparent $MUI_HWND 1017
  !insertmacro SetTransparent $MUI_HWND 1022
  !insertmacro SetTransparent $MUI_HWND 1021
  !insertmacro SetTransparent $MUI_HWND 1023
  !insertmacro SetTransparent $MUI_HWND 1006
  !insertmacro SetTransparent $MUI_HWND 1032
 
  ; Refresh controls.
  Call RefreshParentControls
 
FunctionEnd
 
; For instfiles page.
Function InstFilesPageShow
 
  ; Set transparent backgrounds.
  FindWindow $MUI_HWND "#32770" "" $HWNDPARENT
  SetCtlColors $MUI_HWND 0xFFFFFF transparent
  !insertmacro SetTransparent $MUI_HWND 1027
  !insertmacro SetTransparent $MUI_HWND 1004
  !insertmacro SetTransparent $MUI_HWND 1006
  !insertmacro SetTransparent $MUI_HWND 1016
 
  ; Refresh controls.
  Call RefreshParentControls
 
FunctionEnd
 
; For finish page.
Function FinishPageShow
 
  ; Set transparent backgrounds.
  SetCtlColors $MUI_HWND 0xFFFFFF transparent
  !insertmacro SetTransparent $MUI_HWND 1200
  !insertmacro SetTransparent $MUI_HWND 1201
  !insertmacro SetTransparent $MUI_HWND 1202
  !insertmacro SetTransparent $MUI_HWND 1203
  !insertmacro SetTransparent $MUI_HWND 1204
  !insertmacro SetTransparent $MUI_HWND 1205
  !insertmacro SetTransparent $MUI_HWND 1206
 
FunctionEnd
 
; Free loaded resources.
Function .onGUIEnd
 
  ; Destroy the bitmap.
  System::Call `gdi32::DeleteObject(i s)` $hBitmap
 
FunctionEnd
 
; --------------------------------------------------------------------------------------------------
; Dummy section
; --------------------------------------------------------------------------------------------------
 
Section "Dummy Section"
SectionEnd