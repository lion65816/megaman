--セグメント分割
AT.Split = function(value)
	local stg = memory.readbyte(0x22)
	if value then stg = value end
	local tName = {"Needle","Magnet","Gemini","Hard","Top","Snake","Spark","Shadow","Needle2","Gemini2","Spark2","Shadow2","Wily1","Wily2","Wily3","Wily4","Wily5","Wily6"}
	AT.SplitSegment( tName[stg+1] )
end

--計測終了
--ラスボスの待ちループ中で、矩形波2つと三角波の譜面が終了した時
AT.WaitToEnd = function()
	local tmp = 0
	tmp = tmp + memory.readbyte(0x754) + memory.readbyte(0x755)
	tmp = tmp + memory.readbyte(0x756) + memory.readbyte(0x757)
	if tmp == 0 and AT.EndStatus and AT.Status ~= "Finished" then
		AT.EndStatus = AT.EndStatus + 1
		if AT.EndStatus >= 2  then
			AT.EndStatus = nil
			AT.Split(0x11)
			AT.End()
		end
	end
end

AT.MaySplit = function()
	local stg = memory.readbyte(0x22)
	if stg ~= 0x11 then AT.Split() end
end
AT.Fanfare = function()
	AT.EndStatus = 0
end
	Rexe.register(({[0]=0x1890A0,0x1890D0})[RU.RomMegaman],AT.Start,nil,"AutoTimer")
	Rexe.register(({[0]=0x1EDC1C,0x209AF8})[RU.RomMegaman],AT.MaySplit,nil,"AutoTimer") --8ボス/ドクロ/Wily1,2,3,5,6
	Rexe.register(({[0]=0x1EDF6B,0x1EDF73})[RU.RomMegaman],AT.SplitSegment,"Breakman","AutoTimer") --Breakman
	Rexe.register(({[0]=0x1EDDB2,0x1EDDBA})[RU.RomMegaman],AT.Split,nil,"AutoTimer") --Wily4
	Rexe.register(0x12B27A,AT.WaitToEnd,nil,2,"AutoTimer") --土下座ワイリー(終了判定)
	Rexe.register(({[0]=0x1EDA96,0x1EDA9E})[RU.RomMegaman],AT.Fanfare,nil,"AutoTimer") --ファンファーレ
