DC.GetStage = function()
	return memory.readbyte(0x51)
end
DC.GetX = function()
	return memory.readbyte(0x046F)*256+memory.readbyte(0x0486)
end
DC.GetY = function()
	return memory.readbytesigned(0x04B4)*256+memory.readbyte(0x04CB)
end
DC.GetScX = function()
	return memory.readbyte(0x57)*256+memory.readbyte(0x56)
end
DC.GetScY = function()
	return 0
end

DC.MayInc38 = function()
	if memory.readbyte(0x4A) == 0x38 then DC.Inc() end
end

	Rexe.register(0x388E62,DC.Inc,nil,"DeathCounter") -- 通常
	Rexe.register(0x388F08,DC.Inc,nil,"DeathCounter") -- 転落

DC.StageNameTable = {[0]=
"Blizzard",
"Wind",
"Plant",
"Flame",
"Yamato",
"Tomahawk",
"Knight",
"Centaur",
"X1",
"X2",
"X3",
"X4",
"W1",
"W2",
"W3",
"W4",
}
