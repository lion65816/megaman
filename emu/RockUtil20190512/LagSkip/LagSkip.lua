LS = {}
	LS.Status = 0
	LS.TurboCount = 0

LS.Proc = function()
	if LS.TurboCount > 10 then
		LS.Status = 2
	end
	if LS.Status == 1 then
		emu.speedmode("turbo")
		LS.Status = 2
		LS.TurboCount = LS.TurboCount + 1
	elseif LS.Status == 2 then
		emu.speedmode("normal")
		LS.Status = 0
		LS.TurboCount = 0
	end
end
RU.Hook["LagSkip"] = LS.Proc

	dofile(debug.getinfo(1).source:sub(2,-5).."RM"..RU.RomType..".lua")


