--セグメント分割
AT.Split = function(value)
	local stg = memory.readbyte(0x2A)
	if value then stg = value end
	local tName = {"Heat","Air","Wood","Bubble","Quick","Flash","Metal","Clash","Wily1","Wily2","Wily3","Wily4","Wily5","Wily6"}
	AT.SplitSegment( tName[stg+1] )
end

--計測開始
--タイトル画面でBGMが消えた瞬間
--かつ、自動でプロローグがループしたわけではない事
AT.MayStart = function()
	if memory.readbyte(0xBE) == 0 then
		AT.Start()
	end
end

--計測終了
--ラスボスの待ちループ中で、矩形波2つと三角波の譜面が終了した時
AT.WaitToEnd = function()
	local tmp = 0
	tmp = tmp + memory.readbyte(0x500) + memory.readbyte(0x501)
	tmp = tmp + memory.readbyte(0x51F) + memory.readbyte(0x520)
	tmp = tmp + memory.readbyte(0x53E) + memory.readbyte(0x53F)
	if tmp == 0 and AT.Status ~= "Finished" then
		AT.Split(0xD)
		AT.End()
	end
end

	Rexe.register(({[0]=0x1BA211,0x1BA247})[RU.RomMegaman],AT.MayStart,nil,3,"AutoTimer")
	Rexe.register(0x169FB1,AT.WaitToEnd,nil,2,"AutoTimer")
	Rexe.register(0x17A0D9,AT.Split,nil,3,"AutoTimer")
	Rexe.register(0x1699F7,AT.Split,nil,3,"AutoTimer")
