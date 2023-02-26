AC = {}

AC.strTblFileName = string.format(
	"%sAchievement_%08X.lua" , RU.FilePath , RU.RomCRC32
	)
AC.strSessionFileName = string.format(
	"%sAchievementSession_%08X.lua" , RU.FilePath , RU.RomCRC32
	)
AC.DateSectionStarted = os.time()

AC.AlertData = {}
AC.Session = {}
AC.Session.Property =
{
    NA = {},
    BusterOnly = {},
    NoContinue = {},
    NoETank = {},
    NoMiss = {},
    NoDamage = {},
}
AC.Session.CategoryStatus = {}

AC.NAC = function(Key,Name,NameS) --New Achievement Condition
    local tbl = {}
    tbl.Key = Key
    tbl.Name = Name
    tbl.NameS = NameS
    return tbl
end
AC.NewSection = function(Key,Name,NameS)
    local tbl = {}
    tbl.Key = Key
    tbl.Name = Name
    tbl.NameS = NameS
    return tbl
end

AC.Alert = function(str)
	table.insert(AC.AlertData,str)
	if not AC.AlertData.timer then
		AC.AlertData.timer = 300
	end
end
AC.ConvertDateIntoYYYYMMDD_HHMMSS = function(date)
    local t = os.date("*t",date)
    return string.format("%04d/%02d/%02d %02d:%02d:%02d",t.year,t.month,t.day,t.hour,t.min,t.sec)
end
AC.ConvertFrameCountIntoHHMMSSFF = function(fc)
    local sec,f = math.modf(fc/60.0988)
    local h = math.floor(sec/3600)
    local m = math.floor(sec/60)%60
    local s = sec%60
    f = math.floor(f * 100)
    return string.format("%02d:%02d:%02d.%02d",h,m,s,f)
end
AC.ShowCategory = function(t,x0,y)
    local height = (3+#t.Sections)*8
    gui.box(x0,y,x0+32+#t.Achievements[1]*t.Achievements[1].TableWidth,y+height,"#000000C0","#000000FF")
    gui.text(x0,y,t.Name,"","#000000FF")
    y = y + 8
    local mx,my = tInput.xmouse(),tInput.ymouse()
    local x1 = x0 + 32
    for sid,siv in ipairs(t.Sections) do
        gui.text(x0,y+16+(sid-1)*8,siv.NameS,"","#00000000")
    end
    for oid,ov in ipairs(t.Achievements[1]) do
        gui.box(x1-1,y,x1+t.Achievements[1].TableWidth-8,y+(2+#t.Sections)*8,"#00000000","#808080FF")
        gui.text(x1,y,ov.NameS,"","#00000000")
        local x2 = x1
        for iid,iv in ipairs(t.Achievements[2]) do
            gui.text(x2,y+8,iv.NameS,"","#00000000")
            for sid,siv in ipairs(t.Sections) do
                local ys = y+16+(sid-1)*8
                local key = t.Key.."_"..siv.Key.."_"..ov.Key.."_"..iv.Key
                local chr = ""
                local chrcolor = ""
                local backcolor = nil
                if AC.Acquired[key] then
                    local tar = AC.Acquired[key]
                    if mx>=x2 and my>=ys and mx<x2+8 and my<ys+8 then
                        local tmpmsg = t.Name
                        if siv.Name~="" then tmpmsg = tmpmsg.."("..siv.Name..") " end
                        if ov.Name~="*" and iv.Name~="*" then 
                            tmpmsg = tmpmsg..ov.Name.." & "..iv.Name
                        else
                            if ov.Name~="*" then tmpmsg = tmpmsg..ov.Name end
                            if iv.Name~="*" then tmpmsg = tmpmsg..iv.Name end
                        end
                        tmpmsg = tmpmsg.."\n"
                        tmpmsg = tmpmsg .. "Count  : " .. tar.Count
                        if tar.BestTime then tmpmsg = tmpmsg .. "  BestTime:" .. AC.ConvertFrameCountIntoHHMMSSFF(tar.BestTime) end
                        if tar.FMCount and tar.FMCount>0 then tmpmsg = tmpmsg .. "  Min.FreeMode:" .. tar.FMCount end
                        tmpmsg = tmpmsg .. "\n"
                        tmpmsg = tmpmsg .. "First  : " .. AC.ConvertDateIntoYYYYMMDD_HHMMSS(tar.FirstDate) .. "\n"
                        tmpmsg = tmpmsg .. "Recent : " .. AC.ConvertDateIntoYYYYMMDD_HHMMSS(tar.RecentDate) .. "\n"
                        AC.DetailWindow = tmpmsg
                    end
                    chr = "O"
                    chrcolor = "#FFFFFFFF"
                    if os.difftime(tar.RecentDate,AC.DateSectionStarted) > 0 then
                        backcolor = "#008800FF"
                        if tar.Count == 1 or os.difftime(tar.FirstDate,AC.DateSectionStarted) > 0 then
                            chrcolor = "#FF8800FF"
                        end
                    end
                else
                    chr = "x"
                    chrcolor = "#888888FF"
                    backcolor = "#00000000"
                end
                gui.text(x2,ys,chr,chrcolor,backcolor)
            end
            x2 = x2 + t.Achievements[2].TableWidth
        end
        x1 = x1 + t.Achievements[1].TableWidth
    end
    y = y + 8 * (#t.Sections+2+1)

    return x0,y
end
AC.SaveAcquired = function()
	local fh = io.open(AC.strTblFileName,"w")
	fh:write("AC.Acquired="..tostring(AC.Acquired))
	fh:close()
end
AC.ActivateCategory = function(n,sid)
	local tmp = AC.Category[n]
	local tstat = {}
    if not sid then sid = 1 end
    tstat.SectionID = sid
    tstat.Frames = 0
    tstat.FMCount = 0
	AC.Session.CategoryStatus[tmp.Key] = tstat
    for id,v in pairs(AC.Session.Property) do
        local found = false
        for aid,av in ipairs(tmp.Achievements) do
            for aaid,aav in ipairs(av) do
                if aav.Key == id then
                    found = true
                end
            end
        end
        if found then
            AC.Session.Property[id][tmp.Key] = true
        end
    end
end
AC.InactivateCategory = function(n)
    local tmp = AC.Category[n]
	AC.Session.CategoryStatus[tmp.Key] = nil
    for id,v in pairs(AC.Session.Property) do
        AC.Session.Property[id][tmp.Key] = nil
    end
end
AC.SleepCategory = function(n)
    local tmp = AC.Category[n]
    if AC.Session.CategoryStatus[tmp.Key] then
        AC.Session.CategoryStatus[tmp.Key].Sleeping = true
    end
end
AC.WakeCategory = function(n)
    local tmp = AC.Category[n]
    if AC.Session.CategoryStatus[tmp.Key] then
        AC.Session.CategoryStatus[tmp.Key].Sleeping = nil
    end
end
AC.AchieveCategory = function(n)
    local tmp = AC.Category[n]
	local tstat = AC.Session.CategoryStatus[tmp.Key]
    local strlife = ""
    local strweapon = ""
    local firstloop = true
    local countnew = 0
    local counttotal = 0
    if tstat then
        for oid,ov in ipairs(tmp.Achievements[1]) do
            if AC.Session.Property[ov.Key][tmp.Key] then
                if strlife == "" then
                    strlife = strlife .. "   " .. ov.Name
                else
                    strlife = strlife .. " & " .. ov.Name
                end
                for iid,iv in ipairs(tmp.Achievements[2]) do
                    if AC.Session.Property[iv.Key][tmp.Key] then
                        if firstloop then
                            if strweapon == "" then
                                strweapon = strweapon .. "   " .. iv.Name
                            else
                                strweapon = strweapon .. " & " .. iv.Name
                            end
                        end
                        local key = tmp.Key.."_"..tmp.Sections[tstat.SectionID].Key.."_"..ov.Key.."_"..iv.Key
                        local newt = AC.Acquired[key]
                        if not newt then
                            countnew = countnew + 1
                            AC.Acquired[key] = {}
                            newt = AC.Acquired[key]
                            newt.Count = 0
                            newt.FirstDate = os.time()
                        end
                        if not newt.BestTime or newt.BestTime > tstat.Frames then
                            newt.BestTime = tstat.Frames
                        end
                        if not newt.FMCount or newt.FMCount < tstat.FMCount then
                            newt.FMCount = tstat.FMCount
                        end
                        newt.Count = newt.Count + 1
                        newt.RecentDate = os.time()
                        counttotal = counttotal + 1
                    end
                end
                firstloop = false
            end
        end
        AC.InactivateCategory(n)
        if countnew > 0 then
            AC.Alert("Achievement:"..tmp.Name.."("..tmp.Sections[tstat.SectionID].Name..")".."  ("..countnew.."+"..(counttotal-countnew)..")\n"..strlife.."\n"..strweapon)
        end
        if counttotal > 0 then
            AC.SaveAcquired()
        end
    end
end
AC.LoseProperty = function(name)
    if not AC.Session.FMTimerEff then
        if type(name) ~= "table" then 
            name = {name}
        end
        for id,v in ipairs(name) do
            for iid,iv in pairs(AC.Session.Property[v]) do
                if not AC.Session.CategoryStatus[iid] or not AC.Session.CategoryStatus[iid].Sleeping then
                    AC.Session.Property[v][iid] = nil
                end
            end
        end
    end
end

	--ログファイルを開き実績情報を取得
	local fhtest = io.open(AC.strTblFileName,"r")
	if fhtest then
		fhtest:close()
		dofile(AC.strTblFileName)
	end
	if not AC.Acquired then AC.Acquired={} end

	dofile(debug.getinfo(1).source:sub(2,-5).."RM"..RU.RomType..".lua")

	--メイン
AC.Main = function()
	if AC.ShowTable then
		local x0 = 10
		local x = x0
		local y = 16
		if AC.TableHeight then
			local my = tInput.ymouse()
			if my < 16 then my = 16 end
			if my >= 224 then my = 223 end
			my = my - 8
			my = my / 224
			if AC.TableHeight >= 208 then
				y = -(AC.TableHeight-208)*my+16
			end
		end
		for id,v in pairs(AC.Category) do
			x,y = v.ShowTable(v,x,y)
		end
		if not AC.TableHeight then AC.TableHeight = y-16 end

	end
	--実績詳細窓
	if AC.DetailWindow then
		local winy0 = 0
		local winh = 8*6
		if tInput.ymouse() <128 then winy0 = 224-winh end
		gui.box(0,winy0,255,winy0+winh,"#000088FF","#000088FF")
		gui.text(0,winy0+8,AC.DetailWindow,"","#00000000")
	end
	AC.DetailWindow = nil
	--アラート
	local tar = AC.AlertData
	if tar.timer then
		gui.text(0,8,tar[1])
		tar.timer = tar.timer - 1
		if tar.timer<=0 then
			if tar[2] then
				tar.timer = 300
				table.remove(tar,1)
			else
				AC.AlertData = {}
			end
		end
    end
    --フレーム数計測
    for k,v in pairs(AC.Session.CategoryStatus) do
        v.Frames = v.Frames + 1
    end
    --Free Mode
    if not AC.Session.FMTimer then
        if tPad.Hold("select") then
            AC.Session.FMTimer = 0
        end
    elseif AC.Session.FMTimer >= 0 then
        if tPad.Hold("select") then
            AC.Session.FMTimer = AC.Session.FMTimer + 1
            if AC.Session.FMTimer >= 240 then
                AC.Session.FMTimer = 240
            end
            gui.box(20,210,20+60,219,"#FFFFFFFF","#000000FF")
            gui.box(20,210,20+AC.Session.FMTimer/4,219,"#0000FFFF","#000000FF")
        else
            if AC.Session.FMTimer == 240 then
                AC.Session.FMTimer = -60*8
                AC.Session.FMTimerEff = 240
                for k,v in pairs(AC.Session.CategoryStatus) do
                    v.FMCount = v.FMCount + 1
                end
            else
            AC.Session.FMTimer = nil
            end
        end
    else
        if AC.Session.FMTimerEff then
            AC.Session.FMTimerEff = AC.Session.FMTimerEff - 1
            gui.box(20,210,20+60,219,"#FFFFFFFF","#000000FF")
            gui.box(20,210,20+AC.Session.FMTimerEff/4,219,"#00FF00FF","#000000FF")
            gui.text(22,212,"Free Mode!","#000000FF","#00000000")
            if AC.Session.FMTimerEff==0 then
                AC.Session.FMTimerEff = nil
            end
        else
            AC.Session.FMTimer = AC.Session.FMTimer + 1
            gui.box(20,210,20-AC.Session.FMTimer/8,219,"#FFFFFFFF","#000000FF")
            if AC.Session.FMTimer == 0 then
                AC.Session.FMTimer = nil
            end
        end
    end
    
    --デバッグ用
	if AC.ShowDebugInfo then
		local y = 0
		for id,v in pairs(AC.Category) do
			local Tmps = v.Name
			local tstat = AC.Session.CategoryStatus[v.Key]
            if tstat then
                local strSleep = ""
                if tstat.Sleeping then strSleep = "(Sleep)" end 
                Tmps = Tmps .. "(Active:"..tstat.SectionID.."("..v.Sections[tstat.SectionID].Name.."))"..strSleep.."\n  " 
                local pcnt = 0
                for pid,pv in pairs(AC.Session.Property) do
                    if pv[v.Key] then
                        if pcnt == 4 then Tmps = Tmps .. "\n  " end
                        pcnt = pcnt + 1
                        Tmps = Tmps .. pid .. " "
                    end
                end
			else
				Tmps = Tmps .. "(Inactive)"
			end
			gui.text(0,y,Tmps)
			y = y + 24
		end
	end
end

	--メインメニューのボタン
AC.View = function()
	if not AC.ShowTable then AC.ShowTable = true else AC.ShowTable = nil end
end
AC.Save = function(t)
	local fh = io.open(AC.strSessionFileName,"w")
	fh:write("AC.Session="..tostring(AC.Session))
    fh:close()
    t.caption = "Done"
end
AC.Load = function(t)
	local fhtest = io.open(AC.strSessionFileName,"r")
	if fhtest then
		fhtest:close()
        dofile(AC.strSessionFileName)
        t.caption = "Done"
    else
        t.caption = "Err."
	end
end
AC.Debug = function()
	if not AC.ShowDebugInfo then AC.ShowDebugInfo = true else AC.ShowDebugInfo = nil end
end


if not AC.Category then
    AC.Main = function()
        gui.text(8,8,"Achievement : Not supported for RM/MM"..RU.RomType)
    end
end
	RU.Hook["AC.Main"] = AC.Main
