print("���v�����g�}���X�e�[�W�̎��؂̗t\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E���؂̗t�������␳����B\n�E�����݂̂ŊO���̕����͕ʓr����t����K�v������B\n���[�͊�̍�������{�Ƃ��A�قȂ鍂���ɂ͓K�؂ɔz�u���ĂȂ��K�v������B\n")

require("lua/common")


local tTGDest = --�Ώ�
{
[0x40]=1,[0x41]=1,[0x42]=1,[0x43]=1,[0x45]=1,[0x46]=1,[0x48]=1,[0x49]=1,[0x4A]=1,[0x4B]=1,[0x4C]=1,[0x4D]=1,[0x4E]=1,[0x4F]=1,[0x50]=1,[0x51]=1,[0x52]=1,[0x53]=1,[0x54]=1,[0x57]=1,[0x6F]=1,
}
local tTSurface =
{
0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40,
0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40,
}



function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		CorrectSurface(tTGDest,tTSurface,true)
		for ix=x0,x1,1 do --{
		for iy=y0,y1,1 do --{
			if gettile(ix,iy)==0x40 then --{
				local tx,ty
				tx,ty = SetShiftPosition(ix,iy,0,1,true)
				if not tTGDest[gettile(tx,ty)] then --{
	local tx2,ty2
	tx,ty   = SetShiftPosition(ix,iy,-1,0,true)
	tx2,ty2 = SetShiftPosition(ix,iy,1,0,true)
	if not tTGDest[gettile(tx,ty)] then
		settile(ix,iy,0x4E)
		settile(ix,iy-1,0x46)
	elseif not tTGDest[gettile(tx2,ty2)] then
		settile(ix,iy,0x4D)
		settile(ix,iy-1,0x45)
	else
		settile(ix,iy,0x50)
	end
				end --}
			end --}
		end --}
		end --}


		CorrectCyclicTile({[0x40]=1},{0x40,0x41,0x42,0x43,0x48,0x49,0x4A,0x4B,0x42,0x43,0x40,0x41,0x4A,0x4B,0x48,0x49,},1,4,4,4)
		CorrectCyclicTile({[0x50]=1},{0x52,0x53,0x50,0x51,0x52,0x53,0x50,0x51,0x50,0x51,0x52,0x53,0x50,0x51,0x52,0x53,},1,4,4,4)
		CorrectCyclicTile({[0x4E]=1},{0x4E,0x57,},0,1,2,2)
		CorrectCyclicTile({[0x4D]=1},{0x4D,0x54,},0,1,2,2)
		CorrectCyclicTile({[0x46]=1},{0x4F,0x46,},0,1,2,2)
		CorrectCyclicTile({[0x45]=1},{0x4C,0x45,},0,1,2,2)
--		CorrectCyclicTile({[]=1},{},1,2,2,2)
		updateundo()
	end --}

	return iRV
end --function
