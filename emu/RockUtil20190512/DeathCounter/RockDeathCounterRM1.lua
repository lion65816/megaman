DC.GetStage = function()
	return memory.readbyte(0x31)
end
DC.GetX = function()
	return memory.readbyte(0x0460)*256+memory.readbyte(0x0480)
end
DC.GetY = function()
	return memory.readbyte(0x0600)
end
DC.GetScX = function()
	return memory.readbyte(0x1B)*256+memory.readbyte(0x1A)
end
DC.GetScY = function()
	return 0
end

	Rexe.register(0x0EC219,DC.Inc,nil,"DeathCounter")
	
DC.StageNameTable = {[0]=
"Cut",
"Ice",
"Bomb",
"Fire",
"Elc",
"Guts",
"W1",
"W2",
"W3",
"W4",
}
