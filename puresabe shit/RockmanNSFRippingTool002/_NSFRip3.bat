if "%~1"=="" goto EOF
%~d0
cd "%~dp0"
BinaryCutter "%~1" zzz_tmp0.bin 2C010 6000
eipsp Dif3456.ips.bin zzz_tmp0.bin zzz_tmp1.bin
copy /b Header3.bin + zzz_tmp1.bin "%~n1.nsf"
