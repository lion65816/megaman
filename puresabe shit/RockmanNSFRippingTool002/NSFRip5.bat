if "%~1"=="" goto EOF
%~d0
cd "%~dp0"
BinaryCutter "%~1" zzz_tmp0.bin 30010 6000
eipsp Dif3456.ips.bin zzz_tmp0.bin zzz_tmp1.bin
copy /b Header5.bin + zzz_tmp1.bin Rockman5.nsf
pause
