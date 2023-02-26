require "lib_input"
require "lib_EUI"
require "lib_Rexe"

IEUI = EUI.new()


RU = {}
RU.cMenuKey = "escape" --メニュー開閉のためのキー
RU.RomSize = 0
RU.RomType = 0
RU.RomCRC32 = 0x00000000
RU.RomMegaman = 0

RU.ReloadUI = nil
RU.LuaPath = debug.getinfo(1).source:sub(2,-1)
RU.LuaDir = RU.LuaPath:match("(.*\\)")
RU.FilePath = RU.LuaDir.."Files\\"
RU.ConfigPath = RU.FilePath.."config.lua"
RU.ExtensionPath = RU.FilePath.."Extension.lua"

RU.Config = {}

Extension = {}

------------------------------------------------------------------------------

RU.OpenMainUI = function(t)
	IEUI = EUI.new()
	local x,y,w,h
	local x0=20
	local lh=20
	local w=30
	x = x0
	y = 10
	h = 16
	w = 128
	------------------------------
	IEUI:add( EUIButton.new(x,y,w,h,"Debugger",RU.Debugger) )
	x = x0
	y = y + lh
	------------------------------
	IEUI:add( EUIButton.new(x,y,w,h,"DeathCounter"..RU.Config.EnableDeathCounter,RU.DeathCounter) )
	x = x + w
	w = 16
	if RU.Config.EnableDeathCounter~= "" then
		IEUI:add( EUIButton.new(x,y,w,h,">",RU.DeathCounter_Menu) )
	end
	w = 128
	x = x0
	y = y + lh
	------------------------------
	IEUI:add( EUIButton.new(x,y,w,h,"AutoTimer"..RU.Config.EnableAutoTimer,RU.AutoTimer) )
	x = x + w
	w = 16
	if RU.Config.EnableAutoTimer~= "" then
		IEUI:add( EUIButton.new(x,y,w,h,">",RU.AutoTimer_Menu) )
	end
	w = 128
	x = x0
	y = y + lh
	------------------------------
	IEUI:add( EUIButton.new(x,y,w,h,"Achievement"..RU.Config.EnableAchievement,RU.Achievement) )
	x = x + w
	w = 16
	if RU.Config.EnableAchievement~= "" then
		IEUI:add( EUIButton.new(x,y,w,h,">",RU.Achievement_Menu) )
	end
	w = 128
	x = x0
	y = y + lh
	------------------------------
	IEUI:add( EUIButton.new(x,y,w,h,"MuteMusic"..RU.Config.EnableMuteMusic,RU.MuteMusic) )
	x = x + w
	w = 16
	if RU.Config.EnableMuteMusic~= "" then
		IEUI:add( EUIButton.new(x,y,w,h,">",RU.MuteMusic_Menu) )
	end
	w = 128
	x = x0
	y = y + lh
	------------------------------
	IEUI:add( EUIButton.new(x,y,w,h,"FastPlaying"..RU.Config.EnableFastPlaying,RU.FastPlaying) )
	x = x0
	y = y + lh
	------------------------------
	IEUI:add( EUIButton.new(x,y,w,h,"LagSkip"..RU.Config.EnableLagSkip,RU.LagSkip) )
	x = x0
	y = y + lh
	------------------------------
	IEUI:add( EUIButton.new(x,y,w,h,"Set as default",RU.SetAsDefault) )
	x = x0
	y = y + lh
	------------------------------
	IEUI:add( EUILabel.new(x,y,0,0,"Press "..RU.cMenuKey.." to close/open menu.","#00000000") )
	x = x0
	y = y + lh
	------------------------------
	if Extension.HookInOpenMainUIFunction then
		x,y,x0,lh = Extension.HookInOpenMainUIFunction(x,y,x0,lh)
	end
	------------------------------

	IEUI:add( EUIShortcut.new(0,0,0,0,"",RU.CloseMainUI,RU.cMenuKey) )
	RU.ReloadUI = RU.OpenMainUI
end
RU.CloseMainUI = function(t)
	IEUI = EUI.new()
	IEUI:add( EUIShortcut.new(0,0,0,0,"",RU.OpenMainUI,RU.cMenuKey) )
	RU.ReloadUI = RU.CloseMainUI
end

------------------------------------------------------------------------------

RU.InitMessage = function()
	local Name = {[0]="Rockman","Mega Man"}
	if RU.InitMessageTimer then
		RU.InitMessageTimer = RU.InitMessageTimer - 1
		if RU.InitMessageTimer < 0 then RU.InitMessageTimer = nil end

		gui.text( 10 , 210 , "RockUtil.lua : "..Name[RU.RomMegaman]..RU.RomType.."  CRC32:"..string.format("%08X",RU.RomCRC32))
	else
		RU.Hook["RU.InitMessage"] =  nil
	end
end
RU.ErrorMessage = function()
	gui.text(10,10,"Error\nPlease put Rockman*.nes or Megaman*.nes\n(*=1,2,3,4,5,6) in \"Files\" directory.")
end
RU.SaveConfig = function()
	local fh = io.open(RU.ConfigPath,"w")
	fh:write("RU.Config="..tostring(RU.Config))
	fh:close()
end
RU.LoadConfig_sub = function(name)
	if not RU.Config[name] then RU.Config[name] = "" end
end
RU.LoadConfig = function()
	local fh = io.open(RU.ConfigPath,"r")
	if fh then
		fh:close()
		dofile(RU.ConfigPath)
	end
	RU.LoadConfig_sub("EnableDeathCounter")
	RU.LoadConfig_sub("EnableAutoTimer")
	RU.LoadConfig_sub("EnableMuteMusic")
	RU.LoadConfig_sub("EnableFastPlaying")
	RU.LoadConfig_sub("EnableLagSkip")
	RU.LoadConfig_sub("EnableAchievement")
end
RU.CmpFile = function(filename)
	local fh = io.open(filename,"rb")
	if not fh then
		print("Can't open "..filename)
		return 0
	end
	local CmpSize = fh:seek("end") - 0x10
	CmpSize = math.min(CmpSize,RU.RomSize)
	fh:seek("set")
	local Buf = {}
	Buf = fh:read("*a")
	local Match = 0
	for loc=0x10,CmpSize+0x0F,7 do --比較を間引きして高速化
		if rom.readbyte(loc) == string.byte(Buf,loc+1) then Match = Match + 1 end
	end
	fh:close()
	return Match/CmpSize
end
RU.CalculateCRC32 = function()
	if not RU.crc_table then
		--CRC32のためのテーブルを生成
		RU.crc_table = {}
		for i=0,255,1 do
			c = i
			for j=0,7,1 do
				if AND(c,1)~=0 then c = XOR( 0xEDB88320 , bit.rshift(c,1) )
				else c = bit.rshift(c,1)
				end
			end
			RU.crc_table[i] = c
		end
	end
	--CRC32を計算
	local c = 0xFFFFFFFF
	for iCnt=0x10,RU.RomSize+0x0F,1 do
		c = XOR( RU.crc_table[ AND( XOR( c , rom.readbyte(iCnt) ) , 0xFF ) ] , bit.rshift(c,8) )
	end
	return XOR( c , 0xFFFFFFFF )
end
RU.Init = function(t)
	RU.Hook = {}
	RU.InitMessageTimer = 180
	RU.Hook["RU.InitMessage"] = RU.InitMessage
	RU.LoadConfig()
	Rexe.init()

	RU.RomSize = rom.readbyte(0x4)*0x4000 + rom.readbyte(0x5)*0x2000

	RU.RomCRC32 = RU.CalculateCRC32()

	--シリーズナンバーの特定
	local BestRatio = 0
	for i=1,6,1 do
		for k,v in ipairs({"Rockman","Megaman"}) do
			local Ratio = RU.CmpFile(RU.FilePath..v..i..".nes")
			if Ratio>BestRatio then
				BestRatio = Ratio
				RU.RomType = i
				RU.RomMegaman = k-1
			end
		end
	end

	RU.ReloadUI = nil

	if RU.Config.EnableDeathCounter ~= "" then RU.DeathCounter(nil) end
	if RU.Config.EnableAutoTimer ~= "" then RU.AutoTimer(nil) end
	if RU.Config.Achievement ~= "" then RU.Achievement(nil) end
	if RU.Config.EnableMuteMusic ~= "" then RU.MuteMusic(nil) end
	if RU.Config.EnableFastPlaying ~= "" then RU.FastPlaying(nil) end
	if RU.Config.EnableLagSkip ~= "" then RU.LagSkip(nil) end

	RU.OpenMainUI(t)

	if RU.RomType == 0 then
		RU.Hook = {RU.ErrorMessage}
		IEUI = EUI.new()
	end

	if Extension.HookInInitFunction then
		Extension.HookInInitFunction()
	end
end

------------------------------------------------------------------------------


RU.Debugger = function(t)
	dofile(RU.LuaDir.."Debug/Debugger.lua")
end


RU.ToggleMode = function(t,mode,onluapath,offluapath)
	if t then
		if RU.Config[mode] == "" then
			RU.Config[mode] = " : Enabled"
		else
			RU.Config[mode] = ""
		end
	end
	if RU.Config[mode] ~= "" then
		dofile(RU.LuaDir..onluapath)
	else
		dofile(RU.LuaDir..offluapath)
	end
	if RU.ReloadUI then RU.ReloadUI() end
end
RU.DeathCounter = function(t)
	RU.ToggleMode(t,"EnableDeathCounter","DeathCounter/RockDeathCounter.lua","DeathCounter/Disable.lua")
end
RU.AutoTimer = function(t)
	RU.ToggleMode(t,"EnableAutoTimer","AutoTimer/AutoTimer.lua","AutoTimer/Disable.lua")
end
RU.Achievement = function(t)
	RU.ToggleMode(t,"EnableAchievement","Achievement/Achievement.lua","Achievement/Disable.lua")
end
RU.MuteMusic = function(t)
	RU.ToggleMode(t,"EnableMuteMusic","MuteMusic/MuteMusic.lua","MuteMusic/Disable.lua")
end
RU.FastPlaying = function(t)
	RU.ToggleMode(t,"EnableFastPlaying","FastPlaying/FastPlaying.lua","FastPlaying/Disable.lua")
end
RU.LagSkip = function(t)
	RU.ToggleMode(t,"EnableLagSkip","LagSkip/LagSkip.lua","LagSkip/Disable.lua")
end--}

RU.DeathCounter_Menu = function(t)
	IEUI:add( EUIButton.new(t.x,t.y,48,t.h,"Delete",RU.DeathCounter_Delete) )
	IEUI:delete(t)
end
RU.DeathCounter_Delete = function(t)
	dofile("DeathCounter/Delete.lua")
	t.caption = "DELETED!"
end

RU.AutoTimer_Menu = function(t)
	IEUI:add( EUIButton.new(t.x+32*0,t.y,32,t.h,"Save",AT.Save) )
	IEUI:add( EUIButton.new(t.x+32*1,t.y,32,t.h,"Load",AT.Load) )
	IEUI:delete(t)
end

RU.Achievement_Menu = function(t)
	local w = 24
	IEUI:add( EUIButton.new(t.x+w*0,t.y,w,t.h,"View",AC.View) )
	IEUI:add( EUIButton.new(t.x+w*1,t.y,w,t.h,"Save",AC.Save) )
	IEUI:add( EUIButton.new(t.x+w*2,t.y,w,t.h,"Load",AC.Load) )
	IEUI:add( EUIButton.new(t.x+w*3,t.y,w,t.h,"Dbg",AC.Debug) )
	IEUI:delete(t)
end

RU.MuteMusic_Menu = function(t)
	IEUI:add( EUIButton.new(t.x,t.y,64,t.h,"Ext.Player"..MM.EnableExternalPlayer,MM.ExternalPlayer) )
	IEUI:delete(t)
end

RU.SetAsDefault = function(t)
	RU.SaveConfig()
end
------------------------------------------------------------------------------
RU.HookProc = function(t)
	for k,v in pairs(t) do
		local ty = type(v)
		if ty == "table" then
			RU.HookProc(v)
		elseif ty == "function" then
			v()
		end
	end
end

-------------------------------------------------------------------------------
	--Extension
	local fhtest = io.open(RU.ExtensionPath,"r")
	if fhtest then
		fhtest:close()
		dofile(RU.ExtensionPath)
	end

	RU.Init(nil)
while 1 do
	UpdateInput()
	RU.HookProc(RU.Hook)
	IEUI:Main()
	FCEU.frameadvance()
	if emu.framecount() == 0 and RU.RomCRC32 ~= RU.CalculateCRC32() then
		RU.Init(nil)
	end
end
