--------------------------------------------------

--ここの値を"*"などに変更しておくとデフォルトでOnにできる
local ShowCollision = "" ;
local ShowTerrainCollision = "" ;
local ShowTerrain = "" ;
local ShowCollision2 = "" ;
local EnableDragRock = "" ;

--------------------------------------------------
local tAddrDamage = {[0]=0xFEBD,0xFE89}
local tAddrDamageBoss = {[0]=0xFEEF,0xFE89}
local tAddrHitBoxW = {[0]=0xFAE9,0xFAB5}
local tAddrHitBoxH = {[0]=0xFBB7,0xFB83}


local AddrDamage = tAddrDamage[RU.RomMegaman]
local AddrDamageBoss = tAddrDamageBoss[RU.RomMegaman]
local AddrHitBoxW = tAddrHitBoxW[RU.RomMegaman]
local AddrHitBoxH = tAddrHitBoxH[RU.RomMegaman]

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
	for i=0,9,1 do
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
	memory.writebyte(0x0045,2) --オーディオキューのポインタ
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
		Rexe.register( 0x0ECCB7 , TerrainCollision_regexec , nil , "Debugger")
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
	local cAddrHook1 = 0x0EC9F0

	if ShowCollision2 == "" then
		ShowCollision2 = "*"
		Rexe.register( cAddrHook1 , Collision2Hook1 , nil , "Debugger" )
	else
		ShowCollision2 = ""
		Rexe.unregister( "Debugger" , cAddrHook1 )
	end
	OpenUI(t)
end
BHToggleDragRock = function(t)
	if EnableDragRock == "" then EnableDragRock = "*"
	else EnableDragRock = "" end
	OpenUI(t)
end

BHFWep = function(t)
	memory.writebyte(0x005D,0xFE) --クリアフラグ
	for i=0x6A,0x71,1 do memory.writebyte(i,0x1C) end --ライフと武器EN
end
BHNWep = function(t)
	memory.writebyte(0x005D,0x00) --クリアフラグ
end
BHTiwn = function(t)
	memory.writebyte(0x00A6,0x02) --残機
	memory.writebyte(0x0600,0xF0) --Y座標
	memory.writebyte(0x001A,0x80) --画面をずらして無理やり転落死させる
	memory.writebyte(0x0027,0x00) --部屋を広くする
	memory.writebyte(0x0028,0x3F) --部屋を広くする
end
BHWarp = function(t)
	local iStg , iCP
	iStg = tonumber(string.sub(t.caption,1,1),16)
	iCP = tonumber(string.sub(t.caption,3,3),16)

	local iPage = 0
	if iCP == 1 then
		iPage = memory.readbyte(0xC2D4+iStg)
	elseif iCP == 2 then
		iPage = memory.readbyte(0xC2E0+iStg)
	end

	memory.writebyte(0x0031,iStg) --現在居るステージ
	memory.writebyte(0x0460,iPage) --画面数(自機)
	memory.writebyte(0x1B,iPage) --画面数(スクロール)
	BHTiwn(t)
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

	iScX = memory.readbyte(0x1B)*256+memory.readbyte(0x1A) ;
	iScY = 0 ;

	for iCnt=0 , 0x1F , 1 do
		local iFlg , iX , iY ;
		iX = memory.readbyte(0x0460+iCnt)*256+memory.readbyte(0x0480+iCnt) ;
		iY = memory.readbyte(0x0600+iCnt) ;
		iX = iX - iScX ;
		iY = iY - iScY ;

		iFlg = memory.readbyte(0x0420+iCnt) ;
		if( iY<0xF8 ) then
			local iT , iPT , iHR , iHP , iDmg ;
			iT  = memory.readbyte(0x0400+iCnt) ;
			iPT = memory.readbyte(0x06E0+iCnt) ;
			if( iT==0xFF )then
				iHR = iPT + 0x83 ;
				iDmg = memory.readbyte(AddrDamage+iPT) ;
			else
				iHR = iT ;
				iDmg = memory.readbyte(AddrDamageBoss+memory.readbyte(0xAC)) ;
				if( iCnt==1 )then
					iDmg = 4 ;
				end --if
			end --if
			iHP = memory.readbyte(0x06C0+iCnt) ;

			local iHW , iHH ;
			iHW = memory.readbyte(AddrHitBoxW+iHR) ;
			iHH = memory.readbyte(AddrHitBoxH+iHR) ;

			if( iCnt<0x10 and iCnt~= 1 ) then
				gui.box( iX-iHW , iY-iHH , iX+iHW , iY+iHH , "clear" , "green" ) ;
				gui.text( iX , iY , string.format(
					"%02X\n%d",iT,iHP
				 )) ;
			else
				gui.box( iX-iHW , iY-iHH , iX+iHW , iY+iHH , "clear" ,  "red" ) ;
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
	tx = memory.readbyte(0x0C)*256+memory.readbyte(0x0D) ;
	ty = memory.readbyte(0x0E)
	sx = memory.readbyte(0x1B)*256+memory.readbyte(0x1A) ;
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

	local iAddrStage  = 0x31 ;
	local iAddrScPage = 0x1B ;
	local iAddrScX    = 0x1A ;

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
	"#FF00FFFF",
	"#00FFFFFF",
	"#FF00FF",
	"#000000",
	"#000000",
	"#000000",
	"#000000",
	"#00FFFF",
	"#000000",
	"#000000",
	"#000000",
	"#000000",
	"#000000",
	"#FF8800",
};
	local aColorTable2 =
{[0]=
	"#0000FF00",
	"#FFFF0080",
	"#FF00FF80",
	"#00FFFF80",
	"#FF00FF80",
	"#00000080",
	"#00000080",
	"#00000080",
	"#00000080",
	"#00FFFF80",
	"#00000080",
	"#00000080",
	"#00000080",
	"#00000080",
	"#00000080",
	"#FF880080",
};

	iStage  = memory.readbyte( iAddrStage ) ;
	iScPage = memory.readbyte( iAddrScPage ) ;
	iScX    = memory.readbyte( iAddrScX ) ;
	if( iStage>= 6 )then iStage=iStage-6; end
	iOffsetStage = (AND(iStage,7)+0x00)*0x4000 + 0x10 ;

	for iY=0,0xF,1 do
	for iX=0,0x10,1 do
		tx = iScPage*256 + iX*16 + iScX ;
		iPage  = math.floor( tx/256 ) ;
		iChipX = math.floor( tx%256/16 ) ;
		iNumPage = rom.readbyte( iOffsetStage + 0x0C00 + iPage )
		iNumTile = rom.readbyte( iOffsetStage + 0x0C30 + iNumPage*2+1 )*256+
				rom.readbyte( iOffsetStage + 0x0C30 + iNumPage*2 )-0x8000 ;
		iNumTile = rom.readbyte( iOffsetStage+iNumTile +  math.floor(iChipX/2)*8 + math.floor(iY/2) ) ;
		iNumChip = rom.readbyte( iOffsetStage + 0x0000 + 
					iNumTile*4 + (iY%2) + (iChipX%2)*2 ) ;
		iHitValue = math.floor(iNumChip/0x40) ;

		local tmpx , tmpy ;
		tmpx = iX*16-iScX%16 ;
		tmpy = iY*16 ;
		gui.box(tmpx+0,tmpy+0,tmpx+15,tmpy+15,aColorTable2[iHitValue],aColorTable[iHitValue]) ;
	end --for
	end --for

	--追加壁
	local iMaxWall = memory.readbyte( 0x720 ) ;
	local iAddr    = 0x721 ;
	for iCnt=0,iMaxWall-1,1 do
		local aColorTable =
{
[0]=
"#0000FFFF",
"#FFFF00FF",--壁
"#FF8000FF",--持てる壁
"#FF00FFFF",--シャッター
"#FFFF0080",--持てる壁を持った後
}
		local aColorTable2 =
{
[0]=
"#0000FF60",
"#FFFF0060",--壁
"#FF800060",--持てる壁
"#FF00FF60",--シャッター
"#FFFF0040",--持てる壁を持った後
}
		local strColor = aColorTable[memory.readbyte( iAddr+0 )] ;
		local strColor2 = aColorTable2[memory.readbyte( iAddr+0 )] ;
		local iX0,iX1,iY0,iY1 ;
		iX0 = memory.readbyte( iAddr+1 )*256 + 
				memory.readbyte( iAddr+2 ) +
					- iScPage*256 - iScX ;
		iX1 = memory.readbyte( iAddr+1 )*256 + 
				AND(memory.readbyte( iAddr+4 )-1,0xFF) +
					- iScPage*256 - iScX ;
		iY0 = memory.readbyte( iAddr+3 ) ;
		iY1 = memory.readbyte( iAddr+5 ) - 1 ;
		if( strColor ~= nil )then
			gui.box(iX0,iY0,iX1,iY1,strColor2,strColor) ;
			gui.line(iX0,iY0,iX1,iY1,strColor2,strColor) ;
		else
			gui.text(iX0,iY0,memory.readbyte( iAddr+0 )) ;
		end --if
		iAddr = iAddr + 6 ;
	end --for

end --function
--------------------------------------------------
local function DragRock()
	if( tInput.Hold("rightclick") and EnableDragRock ~= "" )then
		local iScX , iScY ;
		iScX = memory.readbyte(0x1B)*256+memory.readbyte(0x1A) ;
		iScY = 0 ;
		local iX , iY ;
		iX = iScX + tInput.xmouse() ;
		iY =        tInput.ymouse() ;
		memory.writebyte(0x0460,math.floor(iX/256))
		memory.writebyte(0x0480,iX%256)
		memory.writebyte(0x0600,iY)
		memory.writebyte(0x0055,61) --無敵時間
	end --if
end
--------------------------------------------------
local Collision2Times = 0

Collision2Hook1 = function ()
	local x = memory.getregister("x")

	local xx = memory.readbyte(0x0460+x)*256+memory.readbyte(0x0480+x)
	local xy = memory.readbyte(0x0600+x)
	local xw = memory.readbyte(0x0E)
	local xh = memory.readbyte(0x0D)

	local objx0 = memory.readbyte(0x00)
	local objx1 = memory.readbyte(0x01)
	local objy0 = memory.readbyte(0x02)
	local objy1 = memory.readbyte(0x03)
	if objx1<objx0 then objx1=objx0 end
	if objy1>objy0 then objy1=objy0 end
	xx = xx - (memory.readbyte(0x1B)*256+memory.readbyte(0x1A))

	gui.box(objx0,objy0,objx1,objy1,"#00000000","#00FF00FF")
	gui.box(xx-xw,xy-xh,xx+xw,xy+xh,"#00000000","#FF0000FF")
	gui.line((objx0+objx1)/2,(objy0+objy1)/2,xx,xy,"#FF8000C0")

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
