print("���J�b�g�}���X�e�[�W�̕�\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E�΂̕ǂ̓������s���͗l�ɔz�u����[���p�̃^�C���ɒu��������\n")

require("lua/common")

local tTGDest = --��
{
[0x22]=1,
[0x28]=1,
[0x29]=1,
}
local tTGFixed =
{
0x22,0x28,0x22,0x28,
}

local tTGDest2 = --�ǂ������I�ɏC��
{
[0x29]=1,
[0x28]=1,
}
local tTGFixed2 =
{
0x29,0x28,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayV(tTGDest,tTGFixed,true)
		CorrectCyclicTile(tTGDest2,tTGFixed2,1,1)
		updateundo()
	end --}

	return iRV
end --function
