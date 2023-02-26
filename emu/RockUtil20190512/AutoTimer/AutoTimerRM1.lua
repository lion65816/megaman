--セグメント分割
AT.Split = function(value)
	local stg = memory.readbyte(0x31)
	if value then stg = value end
	local tName = {"Cut","Ice","Bomb","Fire","Elec","Guts","Wily1","Wily2","Wily3","Wily4"}
	AT.SplitSegment( tName[stg+1] )
end

--計測終了
--ラスボスの待ちループ中で、矩形波2つと三角波の譜面が終了した時
AT.WaitToEnd = function()
	if AT.EndStat then
		if AT.EndStat>0 then
			AT.EndStat = AT.EndStat - 1
		else
			local tmp = 0
			tmp = tmp + memory.readbyte(0x500) + memory.readbyte(0x501)
			tmp = tmp + memory.readbyte(0x51F) + memory.readbyte(0x520)
			tmp = tmp + memory.readbyte(0x53E) + memory.readbyte(0x53F)
			if tmp == 0 then
				AT.EndStat = nil
				AT.Split(0x9)
				AT.End()
			end
		end
	end
end
AT.EndFlag = function()
	AT.EndStat = 10
end
	
	Rexe.register(({[0]=0x0FFA4C,0x0FFA16})[RU.RomMegaman],AT.Start,nil,"AutoTimer")
	Rexe.register(0x0EC073,AT.Split,nil,"AutoTimer")
	Rexe.register(0x0EC06B,AT.EndFlag,nil,"AutoTimer")
	Rexe.register(0x0ED124,AT.WaitToEnd,nil,"AutoTimer")

