DC.GetStage = function()
	return memory.readbyte(0x22)
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

DC.MayInc3A = function()
	if memory.readbyte(0xF3) == 0x3A then DC.Inc() end
end

	Rexe.register(0x3A824E,DC.Inc,nil,"DeathCounter")
	Rexe.register(0x3EDC25,DC.Inc,nil,"DeathCounter")

DC.StageNameTable = {[0]=
"Bright",
"Toad",
"Drill",
"Pharaoh",
"Ring",
"Dust",
"Dive",
"Skull",
"C1",
"C2",
"C3",
"C4",
"W1",
"W2",
"W3",
"W4",
}
