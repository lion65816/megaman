FP = {}
	FP.Timer = 0
	FP.TurboCount = 0
	FP.Status = "normal"
	FP.RE = {}






FP.Proc = function()
	local Mode = "normal"
	if FP.Timer >= 1 then
		if FP.TurboCount < 60 then
			Mode = "turbo"
			FP.TurboCount = FP.TurboCount + 1
		else
			FP.TurboCount = 0
		end
		gui.text(128-28,8,"Skip:"..FP.Timer)
		FP.Timer = FP.Timer - 1
	else
		FP.TurboCount = 0
	end
	if FP.Status ~= Mode then
		emu.speedmode(Mode)
	end
	FP.Status = Mode
end


	RU.Hook["FP.Proc"] = FP.Proc

FP.SetTimer = function(value)
	FP.Timer = value
end

FP.registerexec = function(Addr,SkipTime)
	Rexe.register(Addr,FP.SetTimer,SkipTime,"FastPlaying")
end

	dofile(debug.getinfo(1).source:sub(2,-5).."RM"..RU.RomType..".lua")


