print("���X�g�[���}���X�e�[�W�̃p�C�v\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E���n�ʂ�V��̕\\�ʂɂ���p�C�v��␳����B\n�E�ߖT���ǂ̔��肾�ƘA�����Ă���Ɣ��肳���B\n�E�r���̏���t���Ȃǂ͂��Ȃ��̂ŁA�ʓr�ɕK�v�B\n")

require("lua/common")


local tTGDest = --�Ώ�
{
[0xC5]=1,[0xC7]=1,[0xC9]=1,[0xCA]=1,[0xCB]=1,[0xCC]=1,[0xCE]=1,[0xD1]=1,[0xD2]=1,[0xD8]=1,[0xD9]=1,[0xDA]=1,[0xDD]=1,[0xDE]=1,
}
local tTSurface =
{
0xC9,0xCA,0xD1,0xD2,0xCB,0xD8,0xCC,0xCB,
0xD2,0xD1,0xCA,0xC9,0xCB,0xCB,0xD8,0xCB,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		CorrectSurface_c(tTGDest,tTSurface,true,1)
--		CorrectCyclicTile({[]=1},{},1,2,2,2)
		updateundo()
	end --}

	return iRV
end --function
