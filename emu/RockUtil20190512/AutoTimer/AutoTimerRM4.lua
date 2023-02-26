--セグメント分割
AT.Split = function(value)
	local stg = memory.readbyte(0x22)
	if value then stg = value end
	local tName = {"Bright","Toad","Drill","Pharaoh","Ring","Dust","Dive","Skull","Cossack1","Cossack2","Cossack3","Cossack4","Wily1","Wily2","Wily3","Wily4"}
	AT.SplitSegment( tName[stg+1] )
end

--計測終了
--ラスボスの待ちループ中で、矩形波2つと三角波とノイズの譜面が終了した時
AT.WaitToEnd = function()
	local tmp = 0
	tmp = tmp + memory.readbyte(0x754) + memory.readbyte(0x755)
	tmp = tmp + memory.readbyte(0x756) + memory.readbyte(0x757)
	if tmp == 0 and AT.Status ~= "Finished" then
		AT.Split(0xF)
		AT.End()
	end
end

	Rexe.register(({[0]=0x39807E,0x39808E})[RU.RomMegaman],AT.Start,nil,"AutoTimer")
	Rexe.register(0x35B811,AT.WaitToEnd,nil,"AutoTimer")
	Rexe.register(0x3C8841,AT.Split,nil,"AutoTimer")
	Rexe.register(0x3C884D,AT.Split,nil,"AutoTimer")
	Rexe.register(0x3C8A61,AT.Split,nil,"AutoTimer")
	
