print("���^�b�v�}���X�e�[�W�̐A���ƃK���X�̕�\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E�K���X�̂悤�ȕǂƓ����ɂ���A���������␳����B\n�E���肪�ǂł���^�C���ƘA�����Ă���Ɣ��肳���B\n�E��{�I�ɂQ��ނ̃^�C�����s���͗l�ɔz�u����邪�ꕔ���݂��Ȃ����߂����Ȃ��Ă��Ȃ�")

require("lua/common")


local tTGDest = --�Ώ�
{
[0x11]=1,[0x13]=1,[0x15]=1,[0x16]=1,[0x9E]=1,[0x9F]=1,[0xA1]=1,
[0xA2]=1,[0xA5]=1,[0xA6]=1,[0xA9]=1,[0xAA]=1,[0xAD]=1,[0xAE]=1,[0xB4]=1,
[0xB5]=1,[0xB6]=1,[0xB7]=1,[0xBC]=1,[0xBD]=1,[0xBE]=1,[0xBF]=1,
}
local tTGFixed =
{
0x13,0x11,0x11,0x11,0x13,0x9F,0x9E,0xAD,0x13,0xB7,0xBF,0xA1,0x13,0xB5,0xBC,0x16,
}

local tTGDest2 = --7�����ʂ����ʒu�̕␳
{
[0x16]=1
}
local tTGFixed2 =
{
[0xFF-0x10+1]=0xA5,
[0xFF-0x20+1]=0xA9,
[0xFF-0x40+1]=0xAA,
[0xFF-0x80+1]=0xA6,
}

local tTGDest3 = --�����I�ɏC��/�Ǔ����̐A��
{
[0x15]=1,[0x16]=1,
}
local tTGFixed3 =
{
0x16,0x15
}

local tTGDest4 = --�����I�ɏC��/�E�̕�
{
[0xB4]=1,[0xBC]=1,
}
local tTGFixed4 =
{
0xB4,0xBC,
}

local tTGDest5 = --�����I�ɏC��/���̕�
{
[0xB5]=1,[0xBD]=1,
}
local tTGFixed5 =
{
0xBD,0xB5,
}

local tTGDest6 = --�����I�ɏC��/��
{
[0xA1]=1,[0xA2]=1,
}
local tTGFixed6 =
{
0xA2,0xA1,
}

local tTGDest7 = --�����I�ɏC��/�V��
{
[0xAD]=1,[0xAE]=1,
}
local tTGFixed7 =
{
0xAD,0xAE,
}

local tTGDest8 = --�����I�ɏC��/���񂾕���(��������)
{
[0xAA]=1,[0xBE]=1,
}
local tTGFixed8 =
{
0xBE,0xAA,
}
local tTGDest9 = --�����I�ɏC��/���񂾕���(���オ��)
{
[0xA6]=1,[0xB6]=1,
}
local tTGFixed9 =
{
0xA6,0xB6,
}


function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct4Way_c(tTGDest,tTGFixed,true,1)
		Correct8Way_c(tTGDest2,tTGFixed2,true,1)
		CorrectCyclicTile(tTGDest3,tTGFixed3,1,1)
		CorrectCyclicTile(tTGDest4,tTGFixed4,1,1)
		CorrectCyclicTile(tTGDest5,tTGFixed5,1,1)
		CorrectCyclicTile(tTGDest6,tTGFixed6,1,1)
		CorrectCyclicTile(tTGDest7,tTGFixed7,1,1)
		CorrectCyclicTile(tTGDest8,tTGFixed8,1,1)
		CorrectCyclicTile(tTGDest9,tTGFixed9,1,1)
		updateundo()
	end --}

	return iRV
end --function
