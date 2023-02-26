DC.GetStage = function()
	return memory.readbyte(0x22)
end
DC.GetX = function()
	return memory.readbyte(0x0380)*256+memory.readbyte(0x0360)
end
DC.GetY = function()
	return memory.readbytesigned(0x03E0)*256+memory.readbyte(0x03C0)
end
DC.GetScX = function()
	return memory.readbyte(0xF9)*256+memory.readbyte(0xFC)
end
DC.GetScY = function()
	return 0
end
	Rexe.register(({[0]=0x1ED781,0x1ED789})[RU.RomMegaman],DC.Inc,nil,"DeathCounter") --通常
	Rexe.register(({[0]=0x1FF0CD,0x1FF0D5})[RU.RomMegaman],DC.Inc,nil,"DeathCounter") --転落

DC.StageNameTable = {[0]=
"Needle",
"Magnet",
"Gemini",
"Hard",
"Top",
"Snake",
"Spark",
"Shadow",
"Needle2",
"Gemini2",
"Spark2",
"Shadow2",
"W1",
"W2",
"W3",
"W4",
"W5",
"W6",
}
