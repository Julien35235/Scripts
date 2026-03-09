@ECHO OFF
echo %windir% >> config.txt
echo %temp% >> config.txt
echo %PROCESSOR_ARCHITECTURE% >> config.txt
echo %PROCESSOR_IDENTIFIER% >> config.txt
echo %NUMBER_OF_PROCESSORS% >> config.txt
echo %Path% >> config.txt
echo %ProgramData% >> config.txt
echo %ProgramFiles(x86)% >> config.txt
echo %ProgramW6432% >> config.txt 
echo %USERDOMAIN% >> config.txt 
echo %USERNAME% >> config.txt 
echo %OS% >> config.txt
echo %COMPUTERNAME% >> config.txt
echo %OWERSHELL_DISTRIBUTION_CHANNEL% >> config.txt 
echo %HOMEPATH% >> config.txt 
echo %VER% >> config.txt 
ipconfig /all
systeminfo
echo %date% >> config.txt 
echo %time% >> config.txt 

