rem �ȉ��̃t�@�C�����K�v�ł�
rem �ENESASM.EXE
rem �Erockman2.prg (�w�b�_��؂藎�Ƃ���nes)

echo off
del Rockman2RB.NES
del Rockman2RB_VH.NES
nesasm.exe Rockman2RB.asm >out.txt
nesasm.exe Rockman2RB_VH.asm >>out.txt
echo **** Output ****
type out.txt
pause
