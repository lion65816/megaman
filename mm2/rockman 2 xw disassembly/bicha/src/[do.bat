echo off

del rockman2.NES
nesasm.exe rockman2.asm >out.txt
echo **** Output ****
type out.txt

pause
