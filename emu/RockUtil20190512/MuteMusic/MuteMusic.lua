MM = {}
	MM.EnableExternalPlayer = ""
	MM.DfnFilename = string.format(
		"%sExternalPlayer_%08X.lua" , RU.FilePath , RU.RomCRC32
		)
	MM.InfoFilename = RU.FilePath .. "ExternalPlayerInfo.txt"
	MM.CmdFilename = RU.FilePath .. "ExternalPlayerCmd.txt"

	if RU.RomType == 1 or RU.RomType == 2 then

MM.HitAudioRegister = function()
	if AND(memory.readbyte(0xE1),bit.lshift(1,math.floor(memory.getregister("x")/4))) == 0 then
	   local Tbl = {[0]=0x10,0x10,0x00,0x10}
		memory.setregister("a",Tbl[math.floor(memory.getregister("x")/4)])
	end
end

	elseif RU.RomType >= 3 then

MM.HitAudioRegister = function()
	if memory.getregister("x") >= 0x28 and AND(memory.getregister("y"),3) == 0 then
	   local Tbl = {[0]=0x10,0x10,0x00,0x10}
		memory.setregister("a",Tbl[math.floor(memory.getregister("y")/4)])
	end
end
	end

	Rexe.register( ({0x0893F6,0x1883EC,0x1680FA,0x1E80FA,0x1880FA,0x3480FA})[RU.RomType] , MM.HitAudioRegister , nil , "MuteMusic" )


MM.ExternalPlayer = function(t)
	if MM.EnableExternalPlayer == "" then

		local fhtest = io.open(MM.DfnFilename,"r")
		if fhtest then
			fhtest:close()
			dofile(MM.DfnFilename)

			MM.PrevMusic = -1
			RU.Hook["MM.ExtPlayer"] = MM.ExtPlayer
			MM.EnableExternalPlayer = "Enabled"
			t.caption = "Enabled"
		else
			local fh = io.open(MM.DfnFilename,"w")
			fh:write('MM.Dfn={\n')
			fh:write('CommandF="",\n')
			fh:write('CommandB="",\n')
			fh:write('Method=1,--0:printのみ(デバッグ) 1:io.popen 2:Files/ExternalPlayerCmd.txtに出力\n')
			fh:write('AudioFilePath="",\n')
			for i=0,0xFF,1 do
				fh:write(string.format('[0x%02X]="",[0x1%02X]="",\n',i,i))
			end
			fh:write('}\n')
			fh:close()
			print("Definition file : "..MM.DfnFilename)
			t.caption = "Check Dfn."
		end
	else
		MM.DisposeExternalPlayer()
		MM.EnableExternalPlayer = ""
		t.caption = "Disabled"
	end
end
MM.DisposeExternalPlayer = function()
	RU.Hook["MM.ExtPlayer"] = nil
	MM.PlayMusic(({0xFF,0xFF,0xF0,0xF0,0xF0,0xF0})[RU.RomType])
end
MM.PlayMusic = function(i)
	if MM.Dfn and MM.Dfn[i] and MM.Dfn[i]~="" then
		local cmd = MM.Dfn.CommandF.." "..MM.Dfn.AudioFilePath..MM.Dfn[i].." "..MM.Dfn.CommandB
		local fh = io.open(MM.InfoFilename,"w")
		if MM.Dfn[0x100+i] then
			fh:write(MM.Dfn[0x100+i])
		end
		fh:close()
		if MM.Dfn.Method == 0 then
			print(cmd) ;
		elseif MM.Dfn.Method == 1 then
			io.popen(cmd,'r')
		elseif MM.Dfn.Method == 2 then
			local fh = io.open(MM.CmdFilename,"w")
			fh:write(cmd)
			fh:flush()
			fh:close()
		end
	end
end

if RU.RomType == 1 then
	MM.CurrentMusic = 0xFF
	MM.PrevTrack = 0x00
	MM.MuteMusic = function()
		if memory.getregister("a") == 0xFF then
			MM.CurrentMusic = 0xFF
		end
	end
	MM.MayUpdateMusic = function()
		MM.PrevTrack = memory.getregister("a")
	end
	MM.UpdateMusic = function()
		MM.CurrentMusic = MM.PrevTrack
	end
	Rexe.register( 0x089024 , MM.MuteMusic , nil , "MuteMusic" )
	Rexe.register( 0x08902F , MM.MayUpdateMusic , nil , "MuteMusic" )
	Rexe.register( 0x089050 , MM.UpdateMusic , nil , "MuteMusic" )
	MM.GetCurrentMusic = function()
		return MM.CurrentMusic
	end
elseif RU.RomType == 2 then
	MM.CurrentMusic = 0xFF
	MM.PrevTrack = 0x00
	MM.MuteMusic = function()
		if memory.getregister("a") == 0xFF then
			MM.CurrentMusic = 0xFF
		end
	end
	MM.MayUpdateMusic = function()
		MM.PrevTrack = memory.getregister("a")
	end
	MM.UpdateMusic = function()
		MM.CurrentMusic = MM.PrevTrack
	end
	Rexe.register( 0x188024 , MM.MuteMusic , nil , "MuteMusic" )
	Rexe.register( 0x18802F , MM.MayUpdateMusic , nil , "MuteMusic" )
	Rexe.register( 0x18804F , MM.UpdateMusic , nil , "MuteMusic" )
	MM.GetCurrentMusic = function()
		return MM.CurrentMusic
	end
elseif RU.RomType == 3 then
	MM.GetCurrentMusic = function()
		return memory.readbyte(0xD9)
	end
elseif RU.RomType == 4 then
	MM.GetCurrentMusic = function()
		return memory.readbyte(0xD9)
	end
elseif RU.RomType == 5 then
	MM.GetCurrentMusic = function()
		return memory.readbyte(0xD9)
	end
elseif RU.RomType == 6 then
	MM.CurrentMusic = 0xF0
	MM.CmdMusic = function()
		if memory.getregister("a") == 0xF0 then
			MM.CurrentMusic = 0xF0
		end
	end
	MM.UpdateMusic = function()
		MM.CurrentMusic = memory.getregister("x") / 2
	end
	Rexe.register( 0x34810A , MM.CmdMusic , nil , "MuteMusic" )
	Rexe.register( 0x34816E , MM.UpdateMusic , nil , "MuteMusic" )
	MM.GetCurrentMusic = function()
		return MM.CurrentMusic
	end
end

MM.ExtPlayer = function()
	local tmp = MM.GetCurrentMusic()
	if tmp ~= MM.PrevMusic then
		MM.PrevMusic = tmp
		MM.PlayMusic(tmp)
	end
end

