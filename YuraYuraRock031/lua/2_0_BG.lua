print("���q�[�g�}���X�e�[�W�̔w�i\n")
print("(���p���@)�͈͑I����[0]:BG�̕����������␳\n����̐ݒ��������Ɏ��s���ĉ�����\n")
print("�E�ۂ݂�тт��i�H�j�w�i�������z�u�B�ǂ̔���̏�ɂ͉e���t���B\n")

local tTGDest =
{
[0x00]=1,
[0xA1]=1,
[0xA2]=1,
[0xA3]=1,
[0xA4]=1,
[0xA5]=1,
[0xA6]=1,
[0xA7]=1,
[0xA9]=1,
[0xAA]=1,
[0xAB]=1,

[0xB1]=1,
[0xB2]=1,
[0xB4]=1,
[0xB5]=1,
[0xB6]=1,
[0xB7]=1,
[0xB8]=1,
[0xB9]=1,
}
local tTGStd =
{
[0]=0x00,
0xA1,
0xA2,
0xA3,
0xA4,
0xA5,
0xA5,
0xA5,
0xA6,
0xA7,
0xA9,
0xAA,
0xAB,
0x00,
0x00,
0x00,
}
local tTGShadow =
{
[0]=0x00,
0xA1,
0xA2,
0xB8,
0xB4,
0xB5,
0xB5,
0xB5,
0xB6,
0xB7,
0xB1,
0xB2,
0xAB,
0x00,
0x00,
0x00,
}



function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		if y0>=0x10 or y1>=0x10 then --{
			print("���ʂ݂̂�I�����Ď��s���ĉ�����\n")
			return 0
		end --}
		iRV = 1
		for ix=x0,x1,1 do --{
		for iy=y0,y1,1 do --{
			if tTGDest[gettile(ix,iy)] then --{
				local iN=0
				local iT = math.floor(AND(getterrain(ix,iy+0x11),0xF0)/16)
				iN = tTGStd[iy]
				if iT==1 then
					iN = tTGShadow[iy]
				end
				settile(ix,iy,iN)
			end --}
		end --}
		end --}
		updateundo()
	end --}

	return iRV
end --function
