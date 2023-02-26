if "%~1"=="" goto EOF
%~d0
cd "%~dp0"
BinaryCutter "%~1" zzz_tmp0.bin 3C010 4000
BinaryCutter "%~1" zzz_tmp0_.bin 3A010 2000
eipsp Dif3456.ips.bin zzz_tmp0.bin zzz_tmp1.bin
copy /b Header4.bin + zzz_tmp1.bin + zzz_tmp0_.bin "%~n1.nsf"
