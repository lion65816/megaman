DC.GetStage = function()
	return memory.readbyte(0x2A)
end
DC.GetX = function()
	return memory.readbyte(0x0440)*256+memory.readbyte(0x0460)
end
DC.GetY = function()
	return memory.readbytesigned(0xF9)*256+memory.readbyte(0x04A0)
end
DC.GetScX = function()
	return memory.readbyte(0x20)*256+memory.readbyte(0x1F)
end
DC.GetScY = function()
	return 0
end

	Rexe.register(0x1EC10B,DC.Inc,nil,"DeathCounter")

DC.StageNameTable = {[0]=
"Heat",
"Air",
"Wood",
"Bubble",
"Quick",
"Flash",
"Metal",
"Clash",
"W1",
"W2",
"W3",
"W4",
"W5",
"W6",
}
