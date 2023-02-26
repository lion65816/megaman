if "%~1"=="" goto EOF
%~d0
cd "%~dp0"
BinaryCutter "%~1" zzz_tmp0.bin 30010 4000
BinaryCutter "%~1" zzz_tmp0_.bin 3C010 4000
copy /b Header2.bin + zzz_tmp0.bin + zzz_tmp0_.bin Rockman2.nsf
pause
