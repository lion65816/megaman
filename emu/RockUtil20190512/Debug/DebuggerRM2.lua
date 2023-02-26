--------------------------------------------------

--ここの値を"*"などに変更しておくとデフォルトでOnにできる
local ShowCollision = "" ;
local ShowTerrainCollision = "" ;
local ShowTerrain = "" ;
local ShowCollision2 = "" ;
local EnableDragRock = "" ;

--------------------------------------------------
local tAddrTerrainTypePerStage = {[0]=0xCC44,0xCC47}
local tAddrHitBoxW = {[0]=0xD4E1,0xD4E4}
local tAddrHitBoxH = {[0]=0xD581,0xD584}
local tAddrHitBoxOffset = {[0]=0xD4DC,0xD4DF}
local tAddrDamage = {[0]=0xED3A,0xED5C}
local tAddrTerrainProc = {[0]=0x1ECBC0,0x1ECBC3}

local AddrTerrainTypePerStage = tAddrTerrainTypePerStage[RU.RomMegaman]
local AddrHitBoxW = tAddrHitBoxW[RU.RomMegaman]
local AddrHitBoxH = tAddrHitBoxH[RU.RomMegaman]
local AddrHitBoxOffset = tAddrHitBoxOffset[RU.RomMegaman]
local AddrDamage = tAddrDamage[RU.RomMegaman]
local AddrTerrainProc = tAddrTerrainProc[RU.RomMegaman]


local AddrHitBoxW1 = AddrHitBoxW+0x20
local AddrHitBoxH1 = AddrHitBoxH+0x20

--------------------------------------------------

OpenUI = function(t)
	IEUI = EUI.new()
	local x,y,w,h
	local x0=20
	local lh=20
	local w=30
	y = 10-lh
	------------------------------
	x = x0
	y = y + lh
	h = 16
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,ShowCollision.."Collision",BHToggleCollision) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,ShowTerrainCollision.."TCollision",BHToggleTerrainCollision) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,ShowTerrain.."Terrain",BHToggleTerrain) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,ShowCollision2.."Clsn(done)",BHToggleCollision2) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,EnableDragRock.."DragRock",BHToggleDragRock) )
	------------------------------
	x = x0
	y = y + lh
	IEUI:add( EUIButton.new(x,y,w,h,"F-Wep",BHFWep) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"N-Wep",BHNWep) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"Tiwn",BHTiwn) )
	x = x + w
	------------------------------
	w = 20
	for i=0,13,1 do
		if i%2==0 then
			x = x0
			y = y + lh
		end
		local str = string.format("%0X",i) ;
		IEUI:add( EUIButton.new(x,y,w,h,str.."-0",BHWarp) )
		x = x + w
		IEUI:add( EUIButton.new(x,y,w,h,str.."-1",BHWarp) )
		x = x + w
		IEUI:add( EUIButton.new(x,y,w,h,str.."-2",BHWarp) )
		x = x + w + 4
	end
	------------------------------
	x = x0
	y = y + lh
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,"ClrBRush",BHBossRushClr) )
	------------------------------
	x = x0
	y = y + lh
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,"SoundTest",BHSoundTest) )
	------------------------------
	x = x0
	y = y + lh
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,"Quit",Quit) )





	IEUI:add( EUIShortcut.new(0,0,0,0,"",CloseUI,RU.cMenuKey) )
end
CloseUI = function(t)
	IEUI = EUI.new()
	IEUI:add( EUIShortcut.new(0,0,0,0,"",OpenUI,RU.cMenuKey) )
end

TrackNO = 0x00
TrackLabel = {}
BHSoundTest = function(t)
	IEUI = EUI.new()
	IEUI:add( EUILabel.new(20,20,0,0,"Sound Test") )
	local x,y,w,h,str
	w = 15
	h = 20
	for i=0,0x3F,1 do
		x = 8+i%16*w
		y = 40+math.floor(i/16)*h
		str = string.format("%02X",i)
		IEUI:add( EUIButton.new(x,y,w,h,str,BHSoundTest_Do) )
	end
	y = y + h
	IEUI:add( EUIButton.new(8+w*0,y,w,h,"FE",BHSoundTest_Do) )
	IEUI:add( EUIButton.new(8+w*1,y,w,h,"FF",BHSoundTest_Do) )

	w = 26
	y = y + h + 10
	IEUI:add( EUIButton.new(8+w*0,y,w,h,"-10",BHSoundTest_Shift) )
	IEUI:add( EUIButton.new(8+w*1,y,w,h,"-01",BHSoundTest_Shift) )
	TrackLabel = EUILabel.new(8+w*2,y,w,h,"") 
	IEUI:add( TrackLabel )
	IEUI:add( EUIButton.new(8+w*3,y,w,h,"+01",BHSoundTest_Shift) )
	IEUI:add( EUIButton.new(8+w*4,y,w,h,"+10",BHSoundTest_Shift) )
	BHSoundTest_UpdateTrackLabel(t)

	IEUI:add( EUIShortcut.new(0,0,0,0,"",OpenUI,RU.cMenuKey) )
end
BHSoundTest_Do = function(t)
	if t then
		local iSNO
		iSNO = tonumber(string.sub(t.caption,1,2),16)
		TrackNO = iSNO
	end
	BHSoundTest_UpdateTrackLabel(t)

	memory.writebyte(0x0580,TrackNO) --オーディオキューの先頭
	memory.writebyte(0x0581,0xFE) --オーディオキューの先頭+1
	memory.writebyte(0x0066,2) --オーディオキューのポインタ
end
BHSoundTest_Shift = function(t)
	local iTmp = tonumber(t.caption:sub(2,3),16)
	if t.caption:sub(1,1)=="-" then iTmp = -iTmp end
	TrackNO = AND( TrackNO + iTmp , 0xFF )
	BHSoundTest_Do(nil)
end
BHSoundTest_UpdateTrackLabel = function(t)
	TrackLabel.caption = string.format("%02X",TrackNO)
end


BHToggleCollision = function(t)
	if ShowCollision == "" then ShowCollision = "*"
	else ShowCollision = "" end
	OpenUI(t)
end
BHToggleTerrainCollision = function(t)
	if ShowTerrainCollision == "" then
		ShowTerrainCollision = "*"
		Rexe.register( AddrTerrainProc , TerrainCollision_regexec , nil , "Debugger")
	else
		ShowTerrainCollision = ""
		Rexe.unregister( "Debugger" , AddrTerrainProc)
	end
	OpenUI(t)
end
BHToggleTerrain = function(t)
	if ShowTerrain == "" then ShowTerrain = "*"
	else ShowTerrain = "" end
	OpenUI(t)
end
BHToggleCollision2 = function(t)
	local cAddrHook1 = ({[0]=0x1FE605,0x1FE608})[RU.RomMegaman]
	local cAddrHook2 = ({[0]=0x17A5AF,0x17A5AF})[RU.RomMegaman]
	local cAddrHook3 = ({[0]=0x1FE567,0x1FE56A})[RU.RomMegaman]
	local cAddrHook4 = ({[0]=0x17A53D,0x17A53D})[RU.RomMegaman]

	if ShowCollision2 == "" then
		ShowCollision2 = "*"
		Rexe.register( cAddrHook1 , Collision2Hook1 , nil , "Debugger" )
		Rexe.register( cAddrHook2 , Collision2Hook2 , nil , "Debugger" )
		Rexe.register( cAddrHook3 , Collision2Hook3 , nil , "Debugger" )
		Rexe.register( cAddrHook4 , Collision2Hook4 , nil , "Debugger" )
	else
		ShowCollision2 = ""
		Rexe.unregister( "Debugger" , cAddrHook1 )
		Rexe.unregister( "Debugger" , cAddrHook2 )
		Rexe.unregister( "Debugger" , cAddrHook3 )
		Rexe.unregister( "Debugger" , cAddrHook4 )
	end
	OpenUI(t)
end
BHToggleDragRock = function(t)
	if EnableDragRock == "" then EnableDragRock = "*"
	else EnableDragRock = "" end
	OpenUI(t)
end

BHFWep = function(t)
	memory.writebyte(0x009A,0xFF) --クリアフラグ
	memory.writebyte(0x009B,0x07) --アイテムフラグ
	for i=0x9C,0xA6,1 do memory.writebyte(i,0x1C) end
	memory.writebyte(0x06C0,0x1C) --ライフ
end
BHNWep = function(t)
	memory.writebyte(0x009A,0x00) --クリアフラグ
	memory.writebyte(0x009B,0x00) --アイテムフラグ
end
BHTiwn = function(t)
	memory.writebyte(0x00A8,0x02) --残機
	memory.writebyte(0x04A0,0xF0) --Y座標
	memory.writebyte(0x00F9,0x00) --Y座標の画面単位
	memory.writebyte(0x001F,0x80) --画面をずらして無理やり転落死させる
end
BHWarp = function(t)
	local iStg , iCP
	iStg = tonumber(string.sub(t.caption,1,1),16)
	iCP = tonumber(string.sub(t.caption,3,3),16)

	local iBank , iCP_
	iBank = AND(iStg,7)
	iCP_  = iCP + math.floor(iStg/8)*3

	local iPage
	iPage = rom.readbyte(0x10+iBank*0x4000+0x3B06+iCP_)

	memory.writebyte(0x002A,iStg) --現在居るステージ
	memory.writebyte(0x0440,iPage) --チェックポイントがあると考えられる画面数
	memory.writebyte(0x0460,0x80) --ドット単位座標(ずれることがあるので一応)
	BHTiwn(t)
end
BHBossRushClr = function(t)
	memory.writebyte(0x00BC,0xFF) --クリアしたカプセル
end




BHDummy = function(t)
--コピペ用
end

--------------------------------------------------
--昔書いたやつのコピペだけど、あってるんじゃないの、たぶん

local function CollisionView()
	if ShowCollision=="" then return end
	local iCnt ;
	local iScX , iScY ;

	iScX = memory.readbyte(0x20)*256+memory.readbyte(0x1F) ;
	iScY = 0 ;

	for iCnt=0 , 0x1F , 1 do
		local iFlg , iX , iY ;
		iX = memory.readbyte(0x0440+iCnt)*256+memory.readbyte(0x0460+iCnt) ;
		iY = memory.readbyte(0x04A0+iCnt) ;
		iX = iX - iScX ;
		iY = iY - iScY ;

		iFlg = memory.readbyte(0x0420+iCnt) ;
		if( iFlg>=0x80 ) then
			local iT , iHP ;
			iT  = memory.readbyte(0x0400+iCnt) ;
			iHP = memory.readbyte(0x06C0+iCnt) ;

			if( iCnt<0x10 and iCnt~= 1 ) then
				local iHitSizeX , iHitSizeY ;
				local iTmp ;
				iTmp = memory.readbyte(0x0590+iCnt) ;
				iTmp = memory.readbyte(AddrHitBoxOffset+iTmp) ;
				iHitSizeX = memory.readbyte(AddrHitBoxW+iTmp)-0xC  + 4 ;
				iHitSizeY = memory.readbyte(AddrHitBoxH+iTmp)-0x14 + 4 ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "red" ) ;
				gui.text( iX , iY , string.format(
					"%02X\n%d",iT,iHP
				 )) ;
			else
				local iTmp , iHitSizeX , iHitSizeY ;
				local iDmg ;
				iTmp = memory.readbyte(0x06E0+iCnt) ;
				iHitSizeX = math.max(0, memory.readbyte(AddrHitBoxW1+iTmp) - 4 ) ;
				iHitSizeY = math.max(0, memory.readbyte(AddrHitBoxH1+iTmp) - 4 ) ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" ,  "green" ) ;
				if( iCnt~= 1 )then
					iDmg = memory.readbyte(AddrDamage+iT) ;
				else
					iT = memory.readbyte(0xB3) ;
					iDmg = rom.readbyte(0x2000*0x17+0x10+0x0993+iT)
				end --if
				gui.text( iX , iY , string.format(
					"%02X\n%d\n%d",iT,iHP,iDmg
				 )) ;
			end --if
		end --if
	end --for iCnt
end --function

--------------------------------------------------
--こちらも昔書いたもののコピペ
local NOTerrainCollisionPoints = 0
TerrainCollision_regexec = function(add,size)
	local tx , ty ;
	local sx , sy ;
	tx = memory.readbyte(0x09)*256+memory.readbyte(0x08) ;
	ty = memory.readbyte(0x0A)
	sx = memory.readbyte(0x20)*256+memory.readbyte(0x1F) ;
	sy = 0 ;
	tx = tx - sx ;
	ty = ty - sy ;
	gui.box( tx-1 , ty-1 , tx+1 , ty+1 , "green" , "green" ) ;
	NOTerrainCollisionPoints = NOTerrainCollisionPoints + 1 ;
end --function

local function TerrainCollisionView()
	if ShowTerrainCollision=="" then
		return
	end
	gui.text( 8 , 8 , NOTerrainCollisionPoints )
	NOTerrainCollisionPoints = 0
end --function
--------------------------------------------------
--これも昔のコピペ
local function TerrainView()
	if ShowTerrain=="" then return end

	local iAddrStage  = 0x2A ;
	local iAddrScPage = 0x20 ;
	local iAddrScX    = 0x1F ;

	local iX , iY ;
	local tx ;
	local iScPage , iScX ;
	local iStage ;
	local iOffsetStage ;
	local iPage , iChipX ;

	local iNumPage , iNumTile , iNumChip ;
	local iHitValue ;
	local aColorTable =
{[0]=
	"#0000FF00",
	"#FFFF00FF",
	"#00FFFFFF",
	"#FF00FFFF",
};
	local aColorTable2 =
{[0]=
	"#0000FF00",
	"#FFFF0080",
	"#00FFFF80",
	"#FF00FF80",
};

	iStage  = memory.readbyte( iAddrStage ) ;
	iScPage = memory.readbyte( iAddrScPage ) ;
	iScX    = memory.readbyte( iAddrScX ) ;
	iOffsetStage = (AND(iStage,7)+0x00)*0x4000 + 0x10 ;

	for iY=0,0xF,1 do
	for iX=0,0x10,1 do
		tx = iScPage*256 + iX*16 + iScX ;
		iPage  = math.floor( tx/256 ) ;
		iChipX = math.floor( tx%256/16 ) ;
		iNumPage = iPage
		iNumTile = rom.readbyte( iOffsetStage+0x0500+iNumPage*0x40+  math.floor(iChipX/2)*8 + math.floor(iY/2) ) ;
		iNumChip = rom.readbyte( iOffsetStage + 0x0000 + 
					iNumTile*4 + (iY%2) + (iChipX%2)*2 ) ;
		iHitValue = math.floor(iNumChip/0x40) ;--rom.readbyte( iOffsetStage + 0x1100 + iNumChip ) ;
		
		local tmpx , tmpy ;
		tmpx = iX*16-iScX%16 ;
		tmpy = iY*16 ;
		gui.box(tmpx+0,tmpy+0,tmpx+15,tmpy+15,aColorTable2[iHitValue],aColorTable[iHitValue]) ;
	end --for
	end --for

	local iWallObjs = memory.readbyte( 0x55 )
	local TblObjWallMask = { [0xF0]=0x0F , [0xE0]=0x1F , [0xC0]=0x3F , [0x80]=0x7F }
	for iO=0,iWallObjs-1,1 do
		local iSuf = memory.readbyte( 0x56+iO )
		local iMx = memory.readbyte( 0x610+iSuf )
		local iX  = memory.readbyte( 0x650+iSuf )
		local iMy = memory.readbyte( 0x630+iSuf )
		local iY  = memory.readbyte( 0x670+iSuf )
		local iT  = memory.readbyte( 0x4F0+iSuf )
		local iX0,iX1,iY0,iY1
		iX0 = iX
		iX1 = TblObjWallMask[iMx]
		iY0 = iY
		iY1 = TblObjWallMask[iMy]
		if iX1 and iY1 then
			iX1 = iX1 + iX0
			iY1 = iY1 + iY0
			iX0 = iX0 - iScX
			iX1 = iX1 - iScX
			gui.box(iX0,iY0,iX1,iY1,"#FFFF0040","#FFFF00FF")
			gui.line(iX0,iY0,iX1,iY1,"#FFFF00FF")
			gui.box(iX0+256,iY0,iX1+256,iY1,"#FFFF0040","#FFFF00FF")
			gui.line(iX0+256,iY0,iX1+256,iY1,"#FFFF00FF")
		else
			iX0 = iX0 - iScX
			gui.text(iX0,iY0,"Invalid Mask Value!")
			gui.text(iX0+256,iY0,"Invalid Mask Value!")
		end
	end


end --function
--------------------------------------------------
--コピペ
local function DragRock()
	if( tInput.Hold("rightclick") and EnableDragRock ~= "" )then
		local iScX , iScY ;
		iScX = memory.readbyte(0x20)*256+memory.readbyte(0x1F) ;
		iScY = 0 ;
		local iX , iY ;
		iX = iScX + tInput.xmouse() ;
		iY =        tInput.ymouse() ;
		memory.writebyte(0x0440,math.floor(iX/256))
		memory.writebyte(0x0460,iX%256)
		memory.writebyte(0x04A0,iY)
		memory.writebyte(0x00F9,0x00) --Y座標の画面単位
		memory.writebyte(0x004B,60) --無敵時間
	end --if
end
--------------------------------------------------
--これは新しく書いた
local Collision2Times = 0

Collision2Hook1 = function()
	local x = memory.getregister("x")

	local objx = memory.readbyte(0x2E)
	local objy = memory.readbyte(0x00)
	local objhs = memory.readbyte(0x08)

	local wepx = memory.readbyte(0x06E0+x)
	local wepy = memory.readbyte(0x04A0+x)
	local wephs = memory.readbyte(0x0590+x)
	wephs = memory.readbyte(AddrHitBoxOffset+wephs)

	--バスターのサイズを(4,4)とするための調整
	local objw = memory.readbyte(AddrHitBoxW+objhs)-2-4
	local objh = memory.readbyte(AddrHitBoxH+objhs)-4-4
	local wepw = memory.readbyte(AddrHitBoxW+wephs)-0xC+4
	local weph = memory.readbyte(AddrHitBoxH+wephs)-0x14+4

	local dx = math.abs(objx-wepx)
	local dy = math.abs(objy-wepy)
	
	gui.box(objx-objw,objy-objh,objx+objw,objy+objh,"#00000000","#FF0000FF")
	gui.box(wepx-wepw,wepy-weph,wepx+wepw,wepy+weph,"#00000000","#FF0000FF")
	gui.line(objx,objy,wepx,wepy,"#FF0000C0")

	Collision2Times = Collision2Times + 1
end --function
Collision2Hook2 = function()
if memory.readbyte(0x69)~=0x0B then return end

	local x = memory.getregister("x")

	local objx = memory.readbyte(0x0461)
	local objy = memory.readbyte(0x04A1)
	local objhs = memory.readbyte(0x06E1)

	local wepx = memory.readbyte(0x06E0+x)
	local wepy = memory.readbyte(0x04A0+x)
	local wephs = memory.readbyte(0x0590+x)
	wephs = memory.readbyte(AddrHitBoxOffset+wephs)

	--バスターのサイズを(4,4)とするための調整
	local objw = memory.readbyte(AddrHitBoxW+objhs)-2-4
	local objh = memory.readbyte(AddrHitBoxH+objhs)-4-4
	local wepw = memory.readbyte(AddrHitBoxW+wephs)-0xC+4
	local weph = memory.readbyte(AddrHitBoxH+wephs)-0x14+4

	local dx = math.abs(objx-wepx)
	local dy = math.abs(objy-wepy)
	
	gui.box(objx-objw,objy-objh,objx+objw,objy+objh,"#00000000","#FF0000FF")
	gui.box(wepx-wepw,wepy-weph,wepx+wepw,wepy+weph,"#00000000","#FF0000FF")
	gui.line(objx,objy,wepx,wepy,"#FF0000C0")

	Collision2Times = Collision2Times + 1
end --function
Collision2Hook3 = function()
	local x = memory.getregister("x")

	local objx = memory.readbyte(0x002E)
	local objy = memory.readbyte(0x04A0+x)
	local objhs = memory.readbyte(0x06E0+x)

	local rockx = memory.readbyte(0x002D)
	local rocky = memory.readbyte(0x04A0)
	local rockhs = 0

	--バスターのサイズを(4,4)とするための調整
	local objw = memory.readbyte(AddrHitBoxW+objhs)-2-4
	local objh = memory.readbyte(AddrHitBoxH+objhs)-4-4
	local rockw = memory.readbyte(AddrHitBoxW+rockhs)-0xC+4
	local rockh = memory.readbyte(AddrHitBoxH+rockhs)-0x14+4

	local dx = math.abs(objx-rockx)
	local dy = math.abs(objy-rocky)
	
	gui.box(objx-objw,objy-objh,objx+objw,objy+objh,"#00000000","#00FFFFFF")
	gui.box(rockx-rockw,rocky-rockh,rockx+rockw,rocky+rockh,"#00000000","#00FFFFFF")
	gui.line(objx,objy,rockx,rocky,"#00FFFFC0")

	Collision2Times = Collision2Times + 1
end --function
Collision2Hook4 = function()
	if memory.readbyte(0x69)~=0x0B then return end

	local x = memory.getregister("x")

	local objx = memory.readbyte(0x0461)
	local objy = memory.readbyte(0x04A1)
	local objhs = memory.readbyte(0x06E1)

	local rockx = memory.readbyte(0x0460)
	local rocky = memory.readbyte(0x04A0)
	local rockhs = 0

	--バスターのサイズを(4,4)とするための調整
	local objw = memory.readbyte(AddrHitBoxW+objhs)-2-4
	local objh = memory.readbyte(AddrHitBoxH+objhs)-4-4
	local rockw = memory.readbyte(AddrHitBoxW+rockhs)-0xC+4
	local rockh = memory.readbyte(AddrHitBoxH+rockhs)-0x14+4

	local dx = math.abs(objx-rockx)
	local dy = math.abs(objy-rocky)
	
	gui.box(objx-objw,objy-objh,objx+objw,objy+objh,"#00000000","#00FFFFFF")
	gui.box(rockx-rockw,rocky-rockh,rockx+rockw,rocky+rockh,"#00000000","#00FFFFFF")
	gui.line(objx,objy,rockx,rocky,"#00FFFFC0")

	Collision2Times = Collision2Times + 1
end --function

local function Collision2View()
	if ShowCollision2=="" then
		return
	end
	gui.text(50,8,"Collision Detection(done):"..Collision2Times)
	Collision2Times = 0
end --function
--------------------------------------------------
Quit = function()
	RU.Hook["Debug"] = nil
	Rexe.unregister( "Debugger" )
	RU.ReloadUI()
end

	OpenUI(nil)
	TblHook = {}
	TblHook["DragRock"] = DragRock
	TblHook["CollisionView"] = CollisionView
	TblHook["TerrainCollisionView"] = TerrainCollisionView
	TblHook["TerrainView"] = TerrainView
	TblHook["Collision2View"] = Collision2View
	RU.Hook["Debug"] = TblHook
