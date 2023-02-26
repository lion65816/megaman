--セグメント分割
AT.Split = function(value)
	local stg = memory.readbyte(0x51)
	if value then stg = value end
	local tName = {"Blizzard","Wind","Plant","Flame","Yamato","Tomahawk","Knight","Centaur","X1","X2","X3","X4","Wily1","Wily2","Wily3","Wily4",}
	AT.SplitSegment( tName[stg+1] )
end

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

AT.MaySplit = function(value)
	local stg = memory.readbyte(0x51)
	if value then stg = value end
    local tName = {"Blizzard","Wind","Plant","Flame","Yamato","Tomahawk","Knight","Centaur","X1","X2","X3","X4","Wily1","Wily2","Wily3","Wily4",}
    if stg ~= 0xE then
        AT.SplitSegment( tName[stg+1] )
    end
end

Rexe.register(({[0]=0x3ECEDF,0x3ECEE3})[RU.RomMegaman],AT.Start,nil,"AutoTimer")
Rexe.register(0x3EDFC5,AT.MaySplit,nil,"AutoTimer")
Rexe.register(0x398CD1,AT.Split,nil,"AutoTimer") --X4
Rexe.register(0x398EC3,AT.Split,nil,"AutoTimer") --W3
Rexe.register(0x399182,AT.WaitToEnd,nil,"AutoTimer")




