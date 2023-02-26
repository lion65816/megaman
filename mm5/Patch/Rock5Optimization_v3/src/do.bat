echo off
del rockman5Opt.NES
nesasm.exe rockman5Opt.asm >out.txt
echo **** Output ****
type out.txt
pause
