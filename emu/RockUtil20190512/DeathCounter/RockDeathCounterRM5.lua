DC.GetStage = function()
	return memory.readbyte(0x6C)
end
DC.GetX = function()
	return memory.readbyte(0x0348)*256+memory.readbyte(0x0330)
end
DC.GetY = function()
	return memory.readbytesigned(0x0390)*256+memory.readbyte(0x0378)
end
DC.GetScX = function()
	return memory.readbyte(0xF9)*256+memory.readbyte(0xFC)
end
DC.GetScY = function()
	return 0
end

DC.MayInc1C = function()
	if memory.readbyte(0xF3) == 0x1C then DC.Inc() end
end

	Rexe.register(0x1C8332,DC.Inc,nil,"DeathCounter") --通常
	Rexe.register(0x1FE037,DC.Inc,nil,"DeathCounter") --転落

DC.StageNameTable = {[0]=
"Gravity",
"Wave",
"Stone",
"Gyro",
"Star",
"Charge",
"Napalm",
"Crystal",
"D1",
"D2",
"D3",
"D4",
"W1",
"W2",
"W3",
"W4",
}
