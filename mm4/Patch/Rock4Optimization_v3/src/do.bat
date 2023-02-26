echo off
del rockman4Opt.NES
nesasm.exe rockman4Opt.asm >out.txt
echo **** Output ****
type out.txt
pause
