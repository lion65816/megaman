print("���{���o�[�}���X�e�[�W�̔������ɐL�т���\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E���̍��E�[��␳�B\n�ߖT���ǂ̔��肾�ƘA�����Ă���Ɣ��肳���B\n")

require("lua/common")

local tTGDest = --��
{
[0x21]=1,[0x60]=1,[0x62]=1,
}
local tPat =
{
0x21,0x62,0x60,0x21
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayH_c(tTGDest,tPat,true,1)
		updateundo()
	end --}

	return iRV
end --function
