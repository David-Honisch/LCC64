OutFile "LC2Text.exe"
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