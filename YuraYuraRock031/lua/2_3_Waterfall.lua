print("���o�u���}���X�e�[�W�̑�\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E��̕������s���͗l�ɂQ��ނ̃^�C����z�u����B\n�E��ȊO�̕����̉��ɉe������B\n")

require("lua/common")

local tTGDest = --��
{
[0xDC]=1,
[0xDD]=1,
[0xE7]=1,
}
local tTGFixed =
{
0xE7,0xDC,0xE7,0xDC,
}

local tTGDest2 = --�����I�ɏC��
{
[0xDC]=1,
[0xDD]=1,
}
local tTGFixed2 =
{
0xDC,0xDD
}


function pEdit()
	local iRV=0
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayV(tTGDest,tTGFixed,true)
		CorrectCyclicTile(tTGDest2,tTGFixed2,1,1)
		updateundo()
	end --}

	return iRV
end --function
