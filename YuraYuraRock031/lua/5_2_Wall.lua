print("���X�g�[���}���X�e�[�W�̊��\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E�I�����W�F�̊�ǂ������␳����B\n�E32x32�̈ʒu��4�ʂ�Ɍ��߁A�V��ƉE���̕ǂ̂ݒ���\n")

require("lua/common")


local tTGDest = --�Ώ�
{
[0x02]=1,[0x03]=1,[0x0A]=1,[0x0B]=1,
}
local tTSurface =
{
0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,
0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		--�ʂɕ\�ʂ̕␳���g�����Ƃ͂Ȃ��̂����A�ʓ|�Ȃ̂ŗ��p
		CorrectSurface(tTGDest,tTSurface,true)
		CorrectCyclicTile({[0x02]=1},{0x02,0x03,0x0A,0x0B,},1,2,2,2)
		Correct2WayV_c({[0x02]=1},{nil,0x0A,nil,nil},true,1)
		Correct2WayV_c({[0x03]=1},{nil,0x0B,nil,nil},true,1)
		Correct2WayH_c({[0x03]=1},{nil,nil,0x02,nil},true,1)
		Correct2WayH_c({[0x0B]=1},{nil,nil,0x0A,nil},true,1)
--		CorrectCyclicTile({[]=1},{},1,2,2,2)
		updateundo()
	end --}

	return iRV
end --function
