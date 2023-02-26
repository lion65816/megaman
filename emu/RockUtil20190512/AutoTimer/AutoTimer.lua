AT = {}
	if not ATO then
		ATO = {}
		ATO.lasttime = -1
		ATO.text = "-READY-"
		ATO.lasttext = ""
		ATO.needsUpdate = function()
			return os.time() - ATO.lasttime >= 1
		end
		ATO.update = function()
			if ATO.needsUpdate() and ATO.text ~= ATO.lasttext then
				ATO.fh = io.open( RU.FilePath.."timer.txt" , "w" )
				ATO.lasttime = os.time()
				ATO.lasttext = ATO.text
				ATO.fh:seek("set")
				ATO.fh:write(ATO.text)
				ATO.fh:flush()
				ATO.fh:close()
			end
		end
		ATO.update()
	end

AT.Status = "Ready"
AT.PlayFrames = 0
AT.RealTimeOrg = 0
AT.RealTime = 0
AT.Filename =  string.format(
	"%sAutoTimer_%08X.lua" , RU.FilePath , RU.RomCRC32
	)
AT.Seg = {}
AT.Message = ""
AT.MessageTimer = nil

AT.SubSetupTime = function(time)
	return string.format("%01d:%02d:%02d",
					time/3600%60,
					time/60%60,
					time%60)
end
AT.Proc = function()
	if AT.Status == "Running" then
		AT.PlayFrames = AT.PlayFrames + 1
		AT.RealTime = os.clock()-AT.RealTimeOrg
		if ATO.needsUpdate then
			local realtime = math.floor(AT.RealTime)
			local timebyframe = {math.modf(AT.PlayFrames/60.099)}
			if math.abs(realtime-timebyframe[1]) > 5 then
				ATO.text = string.format("%sr\n%sg",
					AT.SubSetupTime(realtime),AT.SubSetupTime(timebyframe[1]))
			else
				ATO.text = 
				string.format("%sr\n.",AT.SubSetupTime(realtime))
			end
			ATO.update()
		end
	elseif AT.Status == "Finished" then
		if ATO.needsUpdate then
			local realtime = AT.RealTime
			local timebyframe = {math.modf(AT.PlayFrames/60.099)}
			ATO.text = string.format("%s.%02dr\n%s.%02dg",
				AT.SubSetupTime(realtime),AT.RealTime*100%100,
				AT.SubSetupTime(timebyframe[1]),math.floor(timebyframe[2]*100))
			ATO.update()
		end
	elseif AT.Status == "Ready" then
		ATO.text = "-READY-"
		ATO.update()
	end
	--ラップタイム表示
	local tInput = input.get()
	if tInput.xmouse<16 and tInput.ymouse>=224  then
		local tModeName = {"Real Time","Game Time"}
		local mode = 1
		if tInput.xmouse<8 then mode = 2 end
		local x0 = 16
		local y = 8

		local timerstring = AT.SubSetupTime(math.floor(AT.RealTime))
		if mode == 2 then
			timerstring = AT.SubSetupTime(math.floor(AT.PlayFrames/60.099))
		end

		gui.text( x0 , y , "Time("..tModeName[mode]..")  " .. AT.Status .. "  "..timerstring )
		y = y + 8

		local prevlaptime = 0
		for k,v in ipairs(AT.Seg) do
			local laptime = 0
			if mode == 2 then laptime = math.floor(v.PlayFrames/60.099)
			else laptime = math.floor(v.RealTime) end
			gui.text( x0 , y , AT.SubSetupTime(laptime) .. " " .. AT.SubSetupTime(laptime-prevlaptime) .. " : " ..v.Label )
			prevlaptime = laptime
			y = y + 8
		end
	end
	if AT.MessageTimer then
		gui.text( 16 , 8 , AT.Message )
		AT.MessageTimer = AT.MessageTimer - 1
		if AT.MessageTimer <= 0 then
			AT.MessageTimer = nil
		end
	end
end
	RU.Hook["AT.Proc"] = AT.Proc

AT.SetMessage = function(msg,time)
	AT.Message = msg
	if not time then time = 180 end
	AT.MessageTimer = time
end
AT.Start = function()
	AT.PlayFrames = 0
	AT.RealTimeOrg = os.clock()
	AT.Seg = {}
	AT.Status = "Running"
	AT.SetMessage("AutoTimer : Start")
end
AT.End = function()
	AT.Status = "Finished"
	AT.SetMessage("AutoTimer : Finished")
end
AT.SplitSegment = function(label)
	local tmp = {}
	tmp.Label = label
	tmp.PlayFrames = AT.PlayFrames
	tmp.RealTime = AT.RealTime
	AT.Seg[#AT.Seg+1] = tmp
	AT.SetMessage("AutoTimer : Split : "..label)
end
AT.Save = function()
	local fh = io.open(AT.Filename,"w")
	fh:write("AT.Seg="..tostring(AT.Seg).."\n")
	fh:write('AT.Status="'..tostring(AT.Status)..'"\n')
	fh:write("AT.PlayFrames="..tostring(AT.PlayFrames).."\n")
	fh:write("AT.RealTime="..tostring(AT.RealTime).."\n")
	fh:close()
end
AT.Load = function()
	local fhtest = io.open(AT.Filename,"r")
	if fhtest then
		fhtest:close()
		dofile(AT.Filename)
		AT.RealTimeOrg = os.clock()-AT.RealTime
	end
end
	dofile(debug.getinfo(1).source:sub(2,-5).."RM"..RU.RomType..".lua")
