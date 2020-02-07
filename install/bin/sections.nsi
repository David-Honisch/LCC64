!include "Sections.nsh"
 
Name "SectionGetFlags"
OutFile "section_get_flags.exe"
 
Page components ; will get warning because no instfiles page
 
# This is the first section which has index=0
Section "!Required Read-only Bold" SectionZero
  SectionIn RO
SectionEnd
 
# This is the second section which has index=1
Section /o "Section Index One to show MsgBox" ControlsMsgBoxSection
SectionEnd
 
# This section does not have a section_index_output id,
#   so it can be examined below with SectionGetFlags 2 $SectionVar
Section /o !Optional "Section Index Two"
SectionEnd
 
;--------------------------------
Function .onInstSuccess
  # Get flags of second section (which is index #1) into register $0
  SectionGetFlags ${ControlsMsgBoxSection} $0
 
  # Get flags of third section (which is index #2) into register $1
  SectionGetFlags 2 $1
 
  # Just show what the contents of the registers $0 and $1
  # and section.nsh values
  MessageBox MB_OK "Reg-Zero: $0 $\r$\n \
                    SfSelected: ${SF_SELECTED} $\r$\n \
                    Reg-One: $1 $\r$\n \
                    SfBold:  ${SF_BOLD}"
 
  # Do a binary AND of $0 and SF_SELECTED and put results in $0
  IntOp $0 $0 & ${SF_SELECTED}
 
  # Register $0 has results of GetSectionFlags of 2nd section
  #   being AND'ed with SF_SELECTED. It will be either 0 or SF_SELECTED.
  # Check whether second section was selected
  IntCmp $0 ${SF_SELECTED} ShowMessageBox PastShowMessageBox
 
  ShowMessageBox:
    # Check whether third section is shown in bold and put results in $1
    IntOp $1 $1 & ${SF_BOLD}
    MessageBox MB_OK "Section selected$\r$\n \
                      Is 2nd section bold?: $1"
  PastShowMessageBox:
FunctionEnd