print("���E�b�h�}���X�e�[�W�̓y�ǂƓ��A���̔w�i\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E���F�̒n�ʂɑ΂��A��[�E���[�E�����������z�u�B\n�E�������F�̔w�i�̓V��ۂɉe������B\n�E�n�V�S�̉����ɂ��e�����Ă��܂��B\n")

require("lua/common")

local tTGDest = --�y��
{
[0x98]=1,
[0x99]=1,
[0x9A]=1,
[0xA0]=1,
}
local tTGFixed =
{
0xA0,0x9A,0xA0,0x98,
}

local tTGDest2 = --�y�ǂ������I�ɏC��
{
[0x98]=1,
[0x99]=1,
}
local tTGFixed2 =
{
0x98,0x99
}

local tTGDest3 = --���A���̔w�i
{
[0xE1]=1,
[0xE2]=1,
}
local tTGFixed3 =
{
0xE2,0xE1,0xE2,0xE1,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayV(tTGDest,tTGFixed,true)
		CorrectCyclicTile(tTGDest2,tTGFixed2,1,0)
		Correct2WayV(tTGDest3,tTGFixed3,true)
		updateundo()
	end --}

	return iRV
end --function
