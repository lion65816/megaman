echo off
del out.nes
nesasm.exe src\[]main.asm >out.txt
echo **** Output ****
type out.txt
move src\[]main.nes .\Rock6Opt.nes
pause
