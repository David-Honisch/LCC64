OutFile "LC2Env.exe"
!define JAVA_HOME "d:\JDK1.6"
!define APP_HOME "d:\application"
 
Section "Add Env Var"
ReadEnvStr $R0 "PATH"
messagebox mb_ok '$R0'
StrCpy $R0 "$R0;${JAVA_HOME};${APP_HOME}"
System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("PATH", R0).r2'
ReadEnvStr $R0 "PATH"
messagebox mb_ok '$R0'
SectionEnd