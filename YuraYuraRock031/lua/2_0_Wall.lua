print("���q�[�g�}���X�e�[�W�̔��ǁE�ԕ�\n")
print("(���p���@)�͈͑I����[0]:�����␳\n")
print("�E�Ԃ��ǂ͏�[�E���[�E�����Ń^�C�����ς��B\n�E�����ǂ����l�����A�����P�}�X�̏ꍇ�͍��E�̃^�C�������ă^�C�������߂�B\n")

require("lua/common")

local tTGDest1 =
{
[0x19]=1,
[0x18]=1,
[0x20]=1,
[0x28]=1,
}

local tPat1 =
{
0x19,0x28,0x18,0x20,
}

local tTGDest2 =
{
[0x5B]=1,
[0x5C]=1,
[0x5D]=1,
[0x5E]=1,
[0x5F]=1,
}

local tPat2 =
{
0x5E,0x5D,0x5B,0x5C,
}
local tTGDest2_2 =
{
[0x5D]=1,
[0x5F]=1,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()

	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayV(tTGDest1,tPat1,true)
		Correct2WayV(tTGDest2,tPat2,true)
		for itimeout=0,200,1 do --{
			local iBreak=1
			iBreak=1
			for ix=x0,x1,1 do --{
			for iy=y0,y1,1 do --{
				if gettile(ix,iy)==0x5E then --{
					if tTGDest2_2[gettile(ix-1,iy)] or 
					   tTGDest2_2[gettile(ix+1,iy)] then
						settile(ix,iy,0x5F)
						iBreak=0
					end
				end --}
			end --}
			end --}
			if iBreak==1 then break end
		end --}
		updateundo()
	end --}

	return iRV
end --function
