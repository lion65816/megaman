print("���n�[�h�X�e�[�W�̊��\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E���F�̊�ǂ������␳����B\n�E���肪�ǂł���^�C���ƘA�����Ă���Ɣ��肳���B\n�i���i�[���̑��i�H�j�ɂ������Ă��܂��̂ŗv�C���j\n")

require("lua/common")


local tTGDest = --�Ώ�
{
[0x01]=1,[0x02]=1,[0x03]=1,[0x04]=1,[0x06]=1,[0x07]=1,[0x09]=1,[0x0A]=1,[0x0B]=1,[0x0C]=1,[0x0E]=1,[0x0F]=1,[0x10]=1,[0x11]=1,[0x12]=1,[0x13]=1,[0x14]=1,[0x15]=1,[0x16]=1,[0x17]=1,[0x18]=1,[0x19]=1,[0x1A]=1,[0x1B]=1,[0x1C]=1,[0x1D]=1,[0x1E]=1,[0x1F]=1,[0x20]=1,[0x21]=1,[0x22]=1,[0x23]=1,[0x28]=1,[0x29]=1,[0x2A]=1,[0x2B]=1,
}
local tTSurface =
{
0x14,0x15,0x06,0x06,0x01,0x10,0x11,0x06,0x1C,0x1D,0x06,0x06,0x09,0x00,0x00,0x00,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		CorrectSurface_c(tTGDest,tTSurface,true,1)
		CorrectCyclicTile({[0x06]=1},{0x06,0x07,0x0E,0x0F,},1,2,2,2)
		CorrectCyclicTile({[0x14]=1},{0x14,0x16,0x22,0x20,},1,2,2,2)
		CorrectCyclicTile({[0x15]=1},{0x17,0x15,0x21,0x23,},1,2,2,2)
		CorrectCyclicTile({[0x1C]=1},{0x2A,0x28,0x1C,0x1E,},1,2,2,2)
		CorrectCyclicTile({[0x1D]=1},{0x29,0x2B,0x1F,0x1D,},1,2,2,2)

		CorrectCyclicTile({[0x01]=1},{0x01,0x02,0x03,0x04,},1,2,2,2)
		CorrectCyclicTile({[0x09]=1},{0x0B,0x0C,0x09,0x0A,},1,2,2,2)
		CorrectCyclicTile({[0x10]=1},{0x10,0x12,0x18,0x1A,},1,2,2,2)
		CorrectCyclicTile({[0x11]=1},{0x13,0x11,0x1B,0x19,},1,2,2,2)

		updateundo()
	end --}

	return iRV
end --function