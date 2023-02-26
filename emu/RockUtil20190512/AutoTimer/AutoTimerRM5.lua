    --セグメント分割
AT.Split = function(value)
	local stg = memory.readbyte(0x6C)
	if value then stg = value end
	local tName = {"Gravity","Wave","Stone","Gyro","Star","Charge","Napalm","Crystal","Darkman1","Darkman2","Darkman3","Darkman4","Wily1","Wily2","Wily3","Wily4",}
	AT.SplitSegment( tName[stg+1] )
end
AT.End2 = function()
	AT.Split(0xF)
	AT.End()
end

Rexe.register(0x1780D4,AT.Start,nil,"AutoTimer")
Rexe.register(0x1B8833,AT.Split,nil,"AutoTimer") --Exit Warp
Rexe.register(0x1B89D3,AT.Split,nil,"AutoTimer") --Darkman 4
Rexe.register(0x1B8C9A,AT.End2,nil,"AutoTimer")

    