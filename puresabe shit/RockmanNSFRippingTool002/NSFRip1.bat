if "%~1"=="" goto EOF
%~d0
cd "%~dp0"
BinaryCutter "%~1" zzz_tmp0.bin 10010 4000
BinaryCutter "%~1" zzz_tmp0_.bin 1C010 4000
copy /b Header1.bin + zzz_tmp0.bin + zzz_tmp0_.bin Rockman1.nsf
pause
