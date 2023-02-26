DC = {}

DC.iTimer = 0
DC.strTblFileName = string.format(
	"%sDeathCounter_%08X.lua" , RU.FilePath , RU.RomCRC32
	)

	--ログファイルを開きティウンログを取得
	local fhtest = io.open(DC.strTblFileName,"r")
	if fhtest then
		fhtest:close()
		dofile(DC.strTblFileName)
	end
	if not DC.DP then DC.DP={} end

	--起動時とティウン時に数秒間
	--デス位置を表示させるためのタイマーセット
DC.Update = function()
	DC.DP.updated = 1
	DC.iTimer = 240
end

	--ティウンログを記録
DC.Save = function()
	local fh = io.open(DC.strTblFileName,"w")
	fh:write("DC.DP="..tostring(DC.DP))
	fh:close()
end

	--デス位置追加
DC.Inc = function()
	local t = {}
	t.s = DC.GetStage()
	t.x = DC.GetX()
	t.y = DC.GetY()
	if t.y>=230 then
		t.y = 230
	end
	if t.y<=8 then
		t.y = 8
	end

	DC.DP[#DC.DP+1] = t
	for id,v in ipairs(DC.DP) do
		v.tx = nil
		v.ty = nil
	end
	DC.Save()
	DC.Update()
end --function

	--起動時デス位置表示
	DC.Update()

	--デス統計表示のためのテーブル
	DC.DeathStatPerStage = {}

	dofile(debug.getinfo(1).source:sub(2,-5).."RM"..RU.RomType..".lua")

	--メイン
DC.RDCProc = function()
	local tDp = {0,1,0,-1,0,1,0,-1,0,2,0,-2}
	local tInput = input.get()

	--デス位置表示タイマーONであるか、マウスが左上にあるとデス位置表示
	if DC.iTimer>1 or ( tInput.xmouse<16 and tInput.ymouse<16 ) then
		DC.iTimer = DC.iTimer - 1
		gui.text(10,10,#DC.DP)
		--更新時は表示する位置を決定
		if DC.DP.updated then
			DC.DP.updated = nil
			for id,v in ipairs(DC.DP) do
				v.tx = v.x + tDp[1+math.floor(math.random()*12)]
				v.ty = v.y + tDp[1+math.floor(math.random()*12)]
			end
		end
		--×マークを表示
		local iScX , iScY
		iScX = DC.GetScX()
		iScY = 0
		for id,v in ipairs(DC.DP) do
			if v.s == DC.GetStage() then
				local iX, iY
				iX = v.tx - iScX
				iY = v.ty - iScY
				if iX>=-10 and iX<=256+10 then
					gui.box ( iX-5 , iY-5 , iX+5 , iY+5 , "#FFFFFF40" , "#00000040" )
					gui.line( iX-3 , iY-3 , iX+3 , iY+3 , "#FF220080" )
					gui.line( iX-3 , iY+3 , iX+3 , iY-3 , "#FF220080" )
				end
			end
		end
	end
	
	--ステージ情報があり、マウスが右上にあるとデス統計表示
	if DC.StageNameTable and tInput.xmouse>=240 and tInput.ymouse<16  then
		--更新の必要があればデス統計テーブルを更新
		if DC.DeathStatPerStage.PrevDC ~= #DC.DP then
			DC.DeathStatPerStage = {}
			DC.DeathStatPerStage.PrevDC = #DC.DP
			for id,v in ipairs(DC.DP) do
				local st = v.s
				if not DC.DeathStatPerStage[st] then DC.DeathStatPerStage[st] = 1
				else DC.DeathStatPerStage[st] = DC.DeathStatPerStage[st] + 1 end
			end
		end
		--デス統計テーブルを利用し表示
		for id,v in pairs(DC.StageNameTable) do
			local iTmp = DC.DeathStatPerStage[id]
			if not iTmp then iTmp = 0 end
			gui.text( 24 , 8+id*8 , v )
			gui.text( 96 , 8+id*8 , iTmp )
		end
		local PosTotal = #DC.StageNameTable + 2
		gui.text( 24 , 8+PosTotal*8 , "Total" )
		gui.text( 96 , 8+PosTotal*8 , #DC.DP )
	end
	
end
	RU.Hook["DC.RDCProc"] = DC.RDCProc
