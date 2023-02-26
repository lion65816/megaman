print("���A�C�X�}���X�e�[�W�̕�\n")
print("(���p���@)�͈͑I����[0]:�����␳���s\n")
print("�E�����K�̂悤�Ȓn�ʂ��C���B\n�E�ߖT���ǂ�X���ƘA�����Ă���Ɣ��肳���B\n")

require("lua/common")

local tTGDest = --�Ώ�
{
[0x20]=1,[0x21]=1,[0x28]=1,[0x29]=1,
}
local tPat =
{
0x20,0x28,0x20,0x28,
}



function TerrainCond(ix,iy) --{
	local iTmp = getterrain(ix,iy)
	if not iTmp then return nil end
	iTmp = math.floor(iTmp/16) ;
	return (iTmp~=0)
end --}

local function Correct2WayV_sub(tDest,tPat,bOut) --{
	local x0,y0,x1,y1 = getselectedrect()
	for ix=x0,x1,1 do --{
	for iy=y0,y1,1 do --{
		if tDest[gettile(ix,iy)] then --{
			local iN=0
			local tx,ty
			tx,ty = SetShiftPosition(ix,iy,0,-1,bOut)
			if TerrainCond(tx,ty)==true then iN=OR(iN,1) end
			tx,ty = SetShiftPosition(ix,iy,0,1,bOut)
			if TerrainCond(tx,ty)==true then iN=OR(iN,2) end
			iN = tPat[iN+1]
			if iN then settile(ix,iy,iN) end
		end --}
	end --}
	end --}
end --}


function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayV_sub(tTGDest,tPat,true)
		CorrectCyclicTile({[0x20]=1},{0x20,0x21,},1,0)
		CorrectCyclicTile({[0x28]=1},{0x28,0x29,},1,0)
		updateundo()
	end --}

	return iRV
end --function
