print("���g�}�z�[�N�}���X�e�[�W�̊��\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E�I�����W�F�̊�ǂ������␳����B\n�E�ߖT���ǂ̔��肾�ƘA�����Ă���Ɣ��肳���B\n")

require("lua/common")


local tTGDest = --�Ώ�
{
[0x61]=1,[0x62]=1,[0x63]=1,[0x64]=1,[0x65]=1,[0x66]=1,[0x69]=1,[0x6A]=1,[0x6B]=1,[0x6C]=1,[0x6F]=1,[0x70]=1,
}
local tTSurface =
{
0x69,0x6A,0x63,0x63,0x61,0x6B,0x6C,0x63,
0x6F,0x6F,0x63,0x63,0x6F,0x63,0x63,0x63,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		CorrectSurface_c(tTGDest,tTSurface,true,1)
		CorrectCyclicTile({[0x63]=1},{0x66,0x65,0x64,0x63,},1,2,2,2)
		CorrectCyclicTile({[0x61]=1},{0x62,0x61,},1,0,2,2)
		CorrectCyclicTile({[0x6F]=1},{0x6F,0x70,},1,0,2,2)
		CorrectCyclicTile({[0x6C]=1},{0x65,0x6C,},0,1,2,2)
		CorrectCyclicTile({[0x6B]=1},{0x66,0x6B,},0,1,2,2)
--		CorrectCyclicTile({[]=1},{},1,2,2,2)
		updateundo()
	end --}

	return iRV
end --function
