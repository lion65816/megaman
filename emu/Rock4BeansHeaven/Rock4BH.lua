require "lib_input"
require "lib_Rexe"


--オペコード毎の命令長。pcを設定する性質のあるものは0に指定してある
--registerexecにより呼ばれる関数から呼び出した場合、
--そのアドレスの命令は実行されるが、
--オペランドが、この関数の引数のアドレス(の少し手前)から読み出されるようだ。
--これはFCEUX2.2.2での動作であり、他の環境では動かないだろう。

SetPC_tbl = {[0]=
0,2,1,1,1,2,2,1,1,2,1,1,1,3,3,1,
0,2,1,1,1,2,2,1,1,3,1,1,1,3,3,1,
0,2,1,1,2,2,2,1,1,2,1,1,3,3,3,1,
0,2,1,1,1,2,2,1,1,3,1,1,1,3,3,1,
0,2,1,1,1,2,2,1,1,2,1,1,0,3,3,1,
0,2,1,1,1,2,2,1,1,3,1,1,1,3,3,1,
0,2,1,1,1,2,2,1,1,2,1,1,0,3,3,1,
0,2,1,1,1,2,2,1,1,3,1,1,1,3,3,1,
1,2,1,1,2,2,2,1,1,1,1,1,3,3,3,1,
0,2,1,1,2,2,2,1,1,3,1,1,1,3,1,1,
2,2,2,1,2,2,2,1,1,2,1,1,3,3,3,1,
0,2,1,1,2,2,2,1,1,3,1,1,3,3,3,1,
2,2,1,1,2,2,2,1,1,2,1,1,3,3,3,1,
0,2,1,1,1,2,2,1,1,3,1,1,1,3,3,1,
2,2,1,1,2,2,2,1,1,2,1,1,3,3,3,1,
0,2,1,1,1,2,2,1,1,3,1,1,1,3,3,1,
}
SetPC = function(addr)
	memory.setregister("pc",addr-SetPC_tbl[memory.readbyte(memory.getregister("pc"))])
end

Beans = {}
Beans.Body = {}
Beans.Obj = {}
Beans.FrameCounter = 0
Beans.BeansCounter = 0
Beans.FireCounter = 0
Beans.Ended = false

Beans.PushReturnAddr = function(addr)
	local s = memory.getregister("s")
	memory.writebyte(0x100+s-1,addr-1)
	memory.writebyte(0x100+s,math.floor((addr-1)/256))
	memory.setregister("s",s-2)
end

Beans.FireProcess = function()
	local pad = memory.readbyte(0x16)
	if AND(pad,0x40) ~= 0 then
		SetPC(0x8D66)
		local x0 = memory.readbyte(0x330)+memory.readbyte(0x348)*256
		local y0 = memory.readbyte(0x378)+memory.readbyte(0x390)*256
		local vx0 = 0
		local vy0 = -2
		if y0 >= 0x8000 then
			y0 = -(XOR(y0,0xFFFF)+1)
		end
		if AND(memory.readbyte(0x0528),0x40) ~= 0 then
			x0 = x0 + 16
			vx0 = 4
		else
			x0 = x0 - 16
			vx0 = -4
		end
		if AND(pad,0x08)  ~= 0 then
			vy0 = -6
		elseif AND(pad,0x04) ~= 0 then
			vx0 = 0
			vy0 = 3
			if memory.readbyte(0x30) == 1 then
				local vy = memory.readbyte(0x03D8)+memory.readbyte(0x03F0)*256
				if vy >= 0x8000 then
					vy = vy + 0x100
				else
					vy = vy + 0x60
					if vy >= 0x800 then vy = 0x800 end
				end
				memory.writebyte(0x03D8,AND(vy,0xFF))
				memory.writebyte(0x03F0,math.floor(vy/256))
				memory.writebyte(0x0498,1)
			end
		end
		for i=1,3,1 do
			local Tmp = {}
			Tmp.x = x0
			Tmp.y = y0
			local angle = math.random()*2*math.pi
			local velocity = math.random()*2
			Tmp.vx = vx0 + math.cos(angle)*velocity
			Tmp.vy = vy0 + math.sin(angle)*velocity
			table.insert(Beans.Body,Tmp)
			Beans.BeansCounter = Beans.BeansCounter + 1
		end
		Beans.FireCounter = Beans.FireCounter + 1
	end
end
Beans.FireProcess_end = function()
	if Beans.FireCounter % 2 == 0 then
		memory.setregister("x",0x21)
		SetPC(0x9147)
	else
		SetPC(0x8DD4)
	end
end
Beans.Process = function()
	for k,v in pairs(Beans.Body) do
		v.x = v.x + v.vx
		v.y = v.y + v.vy
		v.vy = v.vy + 0.25
		if v.y >= 240 then
			Beans.Body[k] = nil
		end
	end
end
Beans.Draw = function()
	local Cnt=0
	if Beans.DrawTimer then
		Beans.DrawTimer = Beans.DrawTimer - 1
		if Beans.DrawTimer == 0 then Beans.DrawTimer = nil end
		local scx = memory.readbyte(0xFC)+memory.readbyte(0xF9)*256
		for k,v in pairs(Beans.Body) do
			gui.box(v.x-3-scx,v.y-2,v.x+3-scx,v.y+2,"#FFDD88","#000000")
			Cnt = Cnt + 1
		end
	end
	if Cnt>0 then gui.text(0,8,Cnt) end
end
Beans.BurstChaser = function()
	SetPC(0x8390)
end
Beans.BurstChaser_2 = function()
	Beans.PushReturnAddr(0x832D)
	Beans.SkipBurstChaser_3 = true
	SetPC(0x83D3)
end
Beans.BurstChaser_3 = function()
	if Beans.SkipBurstChaser_3 then
		Beans.SkipBurstChaser_3 = nil
		SetPC(0x83EF)
	end
end
Beans.BurstChaser_4 = function()
	Beans.PushReturnAddr(0x849A)
	Beans.SkipBurstChaser_3 = true
	SetPC(0x83D3)
end
Beans.BurstChaser_5 = function()
	Beans.PushReturnAddr(0x8658) --偶然うまく復帰できる
	Beans.SkipBurstChaser_3 = true
	SetPC(0x83D3)
end
Beans.Registance={[0]=
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 

10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 

10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 

10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
10,10,10,10, 10,10,10,10, 10,10,10,10, 10,10,10,10, 
}
Beans.Extra={[0]=
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x01,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,

0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x02,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x02,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,

0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,

0x00,0x00,0x00,0x00, 0x01,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00, 0x00,0x00,0x00,0x00,
}
Beans.HitProc = function()
	local x = memory.getregister("x")
	local Type = memory.readbyte(0x300+x)
	local ObjFlag = memory.readbyte(0x0528+x)
	local OHitFlag = memory.readbyte(0x0408+x)
	local Dmg = rom.readbyte(0x10+0x20*0x2000+0x1700+Type)
	local PCUpdated = false
	if AND(Beans.Extra[Type],1)~=0 then Dmg=1 end
	if ObjFlag>=0x80 and AND(ObjFlag,0x04)==0 and (Dmg~=0 or AND(OHitFlag,0x40)==0x40 ) then
		local ONOHitSize = AND(OHitFlag,0x3F)
		local OW = memory.readbyte(0xFB1C+ONOHitSize)
		local OH = memory.readbyte(0xFADC+ONOHitSize)
		local OX = memory.readbyte(0x330+x)+memory.readbyte(0x348+x)*256
		local OY = memory.readbyte(0x378+x)+memory.readbyte(0x390+x)*256
		local Hits = 0
		if AND(Beans.Extra[Type],2)~=0 then --盾
			OHitFlag = AND(OHitFlag,0xBF)
			OW = OW * 2 / 3
			local DX = OW
			if AND(ObjFlag,0x40)==0 then DX = -DX end
			if memory.readbyte(0x95)%2==0 then
				OHitFlag = OR(OHitFlag,0x40)
				DX = -DX
			else
			end
			OX = OX + DX
--			local scx = memory.readbyte(0xFC)+memory.readbyte(0xF9)*256
--			local color = "#FFDD88"
--			if AND(OHitFlag,0x40)==0 then color = "#FF0000" end
--			gui.box(OX-OW-scx,OY-OH,OX+OW-scx,OY+OH,color,"#000000")
		end
		for k,v in pairs(Beans.Body) do
			if math.abs(OX-v.x)<OW and math.abs(OY-v.y)<OH then
				Beans.Body[k] = nil
				Hits = Hits + 1
			end
		end
		if not Beans.Obj[x] then Beans.Obj[x] = 0 end
		if Hits~=0 then
			if Dmg~=0 and AND(OHitFlag,0x40)==0x40 then
				Beans.Obj[x] = Beans.Obj[x] + Hits
				local EffDmg = 0
				if Beans.Registance[Type]<=Beans.Obj[x] then
					EffDmg = math.floor(Beans.Obj[x]/Beans.Registance[Type])
					Beans.Obj[x] = Beans.Obj[x] - EffDmg * Beans.Registance[Type]
				end
				if memory.readbyte(0x0146)==x and memory.readbyte(0x0132)>=0x80 then
					memory.writebyte(0x05B8+x,0)
				end
				memory.writebyte(0x12,EffDmg)
				memory.setregister("y",1)
				Beans.PushReturnAddr(0x815F)
				SetPC(0x830C)
				PCUpdated = true
			else
				memory.writebyte(0x10,1)
				SetPC(0x8162)
				PCUpdated = true
			end
		end
	end
	if not PCUpdated then
		SetPC(0x81B2)
	end
end
Beans.Reflected = function()
	SetPC(0x81B2)
end
Beans.SetFlicker = function()
	local x = memory.getregister("x")
	local Cnt = memory.readbyte(0x95)
	if Cnt%2~=0 then
		local Flicker = memory.readbyte(0x05B8+x)
		memory.writebyte(0x05B8+x,Flicker-2)
	end
end
Beans.Flush = function()
	Beans.Body = {}
	Beans.Obj = {}
	memory.writebyte(0x0498,0)
end
Beans.ReserveDraw = function()
	Beans.DrawTimer = 5
end
Beans.RandomFire = function(cnt,x)
	if not x then x = memory.getregister("x") end
	local x0 = memory.readbyte(0x330+x)+memory.readbyte(0x348+x)*256
	local y0 = memory.readbyte(0x378+x)+memory.readbyte(0x390+x)*256
	for i=1,cnt,1 do
		local Tmp = {}
		Tmp.x = x0
		Tmp.y = y0
		local angle = math.random()*2*math.pi
		local velocity = math.random()*(cnt+20)/12
		Tmp.vx = math.cos(angle)*velocity
		Tmp.vy = -2 + math.sin(angle)*velocity
		table.insert(Beans.Body,Tmp)
		Beans.BeansCounter = Beans.BeansCounter + 1
	end
end
Beans.RockTiwn = function()
	Beans.RandomFire(128,0)
end
Beans.SlideJump = function()
	if AND(memory.readbyte(0x10),0x10)==0 then
		SetPC(0x837D)
	else
		SetPC(0x839D)
	end
end
Beans.DustPress = function()
	for i=0x680,0x6BF,1 do memory.writebyte(i,0xFF) end
end
Beans.Skeleton = function()
	local x = memory.getregister("x")
	memory.writebyte(0x450+x,1)
end
Beans.DisplayStatus = function()
	local fc = Beans.FrameCounter
	local min = math.floor(fc/3600)%60
	local sec = math.floor(fc/60)%60
	local frac = fc%60/60*100 
	gui.text(20,8,string.format("Time :%02d:%02d.%02d",min,sec,frac))
	gui.text(20,16,"Beans:"..Beans.BeansCounter)
end
Beans.StartGame = function()
	Beans.FrameCounter = 0
end
Beans.ClearStage = function()
	Beans.DisplayStatus()
end
Beans.ClearGame = function()
	Beans.Ended = true
end
Beans.Trampoline = function()
	if memory.readbyte(0x30)==0x07 then
		SetPC(0xDC45)
	else
		local vital = memory.readbyte(0xB0)
		vital = vital - 4
		if vital <= 0x80 then
			vital = 0x80
			memory.writebyte(0x30,7)
			SetPC(0xDC21)
		else
			memory.writebyte(0x03D8,0)
			memory.writebyte(0x03F0,9)
			memory.writebyte(0x0498,1)
			memory.writebyte(0x3C,120)
			SetPC(0xDC45)
		end
		memory.writebyte(0xB0,vital)
	end
end
Beans.ResetCoilFlag = function()
	memory.writebyte(0x0498,0)
end
Beans.SpikeGuard = function()
	if memory.readbyte(0x3C) ~= 0 then
		SetPC(0x8014)
	else
		local vital = memory.readbyte(0xB0)
		vital = vital - 4
		if vital <= 0x80 then
			vital = 0x80
			SetPC(0x8011)
		else
			memory.writebyte(0x3C,120)
			SetPC(0x8014)
		end
		memory.writebyte(0xB0,vital)
	end
end
Rexe.register(0x3C8CBD,Beans.FireProcess,nil,"")
Rexe.register(0x3C8D83,Beans.FireProcess_end,nil,"")
Rexe.register(0x3EC757,Beans.Process,nil,"")
Rexe.register(0x3C8382,Beans.BurstChaser,nil,"BurstChaser")
Rexe.register(0x3C8329,Beans.BurstChaser_2,nil,"")
Rexe.register(0x3C83E5,Beans.BurstChaser_3,nil,"")
Rexe.register(0x3C8496,Beans.BurstChaser_4,nil,"")
Rexe.register(0x3C8654,Beans.BurstChaser_5,nil,"")
Rexe.register(0x3A809F,Beans.HitProc,nil,"")
Rexe.register(0x3A8167,Beans.Reflected,nil,"")
Rexe.register(0x3A8382,Beans.SetFlicker,nil,"SetFlicker")
Rexe.register(0x3EC6C7,Beans.Flush,nil,"")
Rexe.register(0x3ECEE1,Beans.Flush,nil,"")
Rexe.register(0x3EDB3A,Beans.ReserveDraw,nil,"")
Rexe.register(0x35AE7C,Beans.RandomFire,128,"")
Rexe.register(0x3A8243,Beans.RockTiwn,nil,"")
Rexe.register(0x3A9F85,Beans.RandomFire,48,"")
Rexe.register(0x3BBB6C,Beans.RandomFire,2,"")
Rexe.register(0x3C8379,Beans.SlideJump,nil,"")
Rexe.register(0x3DAEC8,Beans.DustPress,nil,"")
Rexe.register(0x3BAAD1,Beans.Skeleton,nil,"")
Rexe.register(0x39807C,Beans.StartGame,nil,"")
Rexe.register(0x3C87A7,Beans.ClearStage,nil,"")
Rexe.register(0x35B7C2,Beans.ClearGame,nil,"")
Rexe.register(0x3EDC19,Beans.Trampoline,nil,"")
Rexe.register(0x3C8130,Beans.ResetCoilFlag,nil,"")
Rexe.register(0x3A800D,Beans.SpikeGuard,nil,"")






while 1 do
	UpdateInput()
	if not Beans.Ended then
		Beans.FrameCounter = Beans.FrameCounter + 1
	end
	if Beans.Ended or Beans.FrameCounter<240 or tPad.Hold("select") then
		Beans.DisplayStatus()
	end

	if memory.readbyte(0x390) == 0xFF and memory.readbyte(0x378) < 0xD0 then
		memory.writebyte(0x378,0xD0)
	end
	Beans.Draw()
	FCEU.frameadvance()
end
