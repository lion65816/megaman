--[[
�I��͈͂̃^�C�������X�g�A�b�v����Lua�B
�e�[�u�������̂ɕ֗��B
�R���\�[���ƁAtool_MakeTileTable.txt�ɏo�͂����B
�o�͐�̓J�����g�f�B���N�g���ł���A����Lua�̃f�B���N�g���ł͂Ȃ��B
--]]

local tUsed={}
	local fh = io.open("tool_MakeTileTable.txt" ,"w")
	local str = ""

	local x0,y0,x1,y1 = getselectedrect()
	for iy=y0,y1,1 do --{
	for ix=x0,x1,1 do --{
		tUsed[gettile(ix,iy)]=1
		str = string.format("0x%02X,",gettile(ix,iy))
		print(str)
		fh:write(str)
	end --}
	end --}
	print("\n\n")
	fh:write("\n\n")
	for i=0,255,1 do --{
		if tUsed[i] then
			str = string.format("[0x%02X]=1,",i)
			print(str)
			fh:write(str)
		end
	end --}
	print("\n")
	fh:write("\n")

	fh:close()

