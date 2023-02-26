rem 以下のファイルが必要です
rem ・NESASM.EXE
rem ・rockman2.prg (ヘッダを切り落としたnes)

echo off
del Rockman2RB.NES
del Rockman2RB_VH.NES
nesasm.exe Rockman2RB.asm >out.txt
nesasm.exe Rockman2RB_VH.asm >>out.txt
echo **** Output ****
type out.txt
pause
