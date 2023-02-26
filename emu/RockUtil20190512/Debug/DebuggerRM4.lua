-------------------------------------------------

--ここの値を"*"などに変更しておくとデフォルトでOnにできる
local ShowCollision = "" ;
local ShowTerrainCollision = "" ;
local ShowTerrain = "" ;
local ShowCollision2 = "" ;
local EnableDragRock = "" ;

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
	IEUI:add( EUIButton.new(x,y,w,h,"Tiwn",BHTiwn) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"GOver",BHGameOver) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"Clear",BHStageClear) )
	x = x + w
	------------------------------
	x = x0
	y = y + lh
	w = 14
	for i=0,0xF,1 do
		if i==8 then
			x = x0
			y = y + h
		elseif i%4==0 and i~=0 then
			x = x + 4
		end
		local str = string.format("%02X",i) ;
		IEUI:add( EUIButton.new(x,y,w,h,str,BHStg) )
		x = x + w
	end
	IEUI:add( EUILabel.new(x,y,0,0,"<= Stage") )
	------------------------------
	x = x0
	y = y + lh
	w = 28
	for i=0,2,1 do
		local str = string.format("CP:%0X",i) ;
		IEUI:add( EUIButton.new(x,y,w,h,str,BHCP) )
		x = x + w
	end
	------------------------------
	y = y + lh
	------------------------------
	x = x0
	y = y + lh
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,"ObjHP1",BHPbjHP1) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"FlushObj",BHFlushObj) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ClrItmFlg",BHClrItmFlg) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ClrBRush",BHBRush) )
	x = x + w
	------------------------------
	x = x0
	y = y + lh
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,"Prog8Boss",BHProg8Boss) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ProgCossack",BHProgCossack) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ProgWily",BHProgWily) )
	x = x + w
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
	for i=0,0x4F,1 do
		x = 8+i%16*w
		y = 40+math.floor(i/16)*h
		str = string.format("%02X",i)
		IEUI:add( EUIButton.new(x,y,w,h,str,BHSoundTest_Do) )
	end
	y = y + h
	IEUI:add( EUIButton.new(8+w*0,y,w,h,"F0",BHSoundTest_Do) )
	IEUI:add( EUIButton.new(8+w*1,y,w,h,"F1",BHSoundTest_Do) )

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

	memory.writebyte(0x00DC,0xF1) --オーディオキューの先頭
	memory.writebyte(0x00DD,TrackNO) --オーディオキューの先頭+1
	memory.writebyte(0x00DA,2) --オーディオキューのポインタ
	memory.writebyte(0x00DB,0) --オーディオキューのポインタ
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
	if ShowTerrainCollision == "" then ShowTerrainCollision = "*"
	else ShowTerrainCollision = "" end
	OpenUI(t)
end
BHToggleTerrain = function(t)
	if ShowTerrain == "" then ShowTerrain = "*"
	else ShowTerrain = "" end
	OpenUI(t)
end
BHToggleCollision2 = function(t)
	if ShowCollision2 == "" then ShowCollision2 = "*"
	else ShowCollision2 = "" end
	OpenUI(t)
end
BHToggleDragRock = function(t)
	if EnableDragRock == "" then EnableDragRock = "*"
	else EnableDragRock = "" end
	OpenUI(t)
end

BHFWep = function(t)
	for i=0xB0,0xBD,1 do memory.writebyte(i,0x9C) end --ライフを含む
	memory.writebyte(0x00A1,9) --残機
	memory.writebyte(0x00A2,9) --E缶
end
BHNWep = function(t) --ロックマン4には不要
	for i=0xB2,0xBD,1 do memory.writebyte(i,0x00) end
end
BHTiwn = function(t)
	memory.writebyte(0x00A1,0x02) --残機
	memory.writebyte(0x0030,0x07) --ロックマンの状態
	memory.writebyte(0x0133,0x01) --フェードアウトまでの時間lo
	memory.writebyte(0x0134,0x00) --フェードアウトまでの時間hi
end
BHGameOver = function(t)
	memory.writebyte(0x00A1,0x00) --残機
	memory.writebyte(0x0030,0x07) --ロックマンの状態
	memory.writebyte(0x0133,0x01) --フェードアウトまでの時間lo
	memory.writebyte(0x0134,0x00) --フェードアウトまでの時間hi
end
BHStageClear = function(t)
	memory.writebyte(0x0030,0x08) --ロックマンの状態
	memory.writebyte(0x0133,0x01) --フェードアウトまでの時間lo
	memory.writebyte(0x0134,0x00) --フェードアウトまでの時間hi
end
BHStg = function(t)
	local iTmp
	iTmp = tonumber(string.sub(t.caption,1,2),16)
	memory.writebyte(0x0022,iTmp) --現在居るステージ
	BHClrItmFlg(t)
	BHTiwn(t)
end
BHCP = function(t)
	local iTmp,iStg
	iTmp = tonumber(string.sub(t.caption,4,4),16)
	memory.writebyte(0x001F,iTmp) --チェックポイント
	BHTiwn(t)
end
BHFlushObj = function(t)
	for i=0x10,0x17,1 do
		memory.writebyte(0x5A0+i,0x00) --処理アドレスhi
		memory.writebyte(0x300+i,0x00) --種類
		memory.writebyte(0x5B8+i,0x00) --点滅
		memory.writebyte(0x450+i,0x00) --HP
		memory.writebyte(0x438+i,0xFF) --配置ID
	end
end
BHBRush = function(t)
	memory.writebyte(0x00AC,0xFF) --ボスラッシュクリア情報
	BHFlushObj(t)
end
BHClrItmFlg = function(t)
	for i=0x100,0x11F,1 do memory.writebyte(i,0x00) end
end
BHPbjHP1 = function(t)
	for i=0x458,0x467,1 do memory.writebyte(i,0x01) end
end

BHProg8Boss = function(t)
	memory.writebyte(0x00A9,0x00) --クリア済み8ボス
	memory.writebyte(0x00AA,0x00) --後半の進捗
end
BHProgCossack = function(t)
	memory.writebyte(0x00A9,0xFF) --クリア済み8ボス
	memory.writebyte(0x00AA,0x00) --後半の進捗
end
BHProgWily = function(t)
	memory.writebyte(0x00A9,0xFF) --クリア済み8ボス
	memory.writebyte(0x00AA,0x0F) --後半の進捗
end

BHDummy = function(t)
--コピペ用
end

--------------------------------------------------
--昔書いたやつのコピペだけど、あってるんじゃないの、たぶん

local function CollisionView()
	if ShowCollision=="" then return end
	local CRockW = 0x6 ;
	local CRockH = 0xA ;
	local CWepW  = 0x0 ;
	local CWepH  = 0x0 ;
	local iCnt ;
	local iScX , iScY ;

	iScX = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	iScY = 0 ;

	gui.text( 8 , 16 , string.format(
		"%d",AND(memory.readbyte(0xB0),0x7F)
	 )) ;
	for iCnt=0 , 0x17 , 1 do
		local iX , iY ;
		iX = memory.readbyte(0x0348+iCnt)*256+memory.readbyte(0x0330+iCnt) ;
		iY = memory.readbyte(0x0378+iCnt) ;
		iX = iX - iScX ;
		iY = iY - iScY ;

		local iT ;
		iT  = memory.readbyte(0x0300+iCnt) ;

		if( iT ~= 0 ) then
			if( iCnt==0 ) then
				local iHitSizeX , iHitSizeY ;
				iHitSizeX = CRockW ;
				iHitSizeY = CRockH ;
				if( memory.readbyte(0x0558) == 0x10 )then
					iHitSizeY = iHitSizeY - 8 ;
				end --if
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "#FF33FF" ) ;
			elseif( iCnt<=4 ) then
				local iHitSizeX , iHitSizeY ;
				local iTmp ;
				iTmp = memory.readbyte(0x0408+iCnt) * 2 ;
				iHitSizeX = CWepW + memory.readbyte(0xFACE+iTmp+1) ;
				iHitSizeY = CWepH + memory.readbyte(0xFACE+iTmp+0) ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "#00FF00" ) ;
			elseif( iCnt<=0x7 ) then
				local iHitSizeX , iHitSizeY ;
				iHitSizeX = 2 ;
				iHitSizeY = 2 ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "orange" ) ;
			else
				local iTmp , iHitSizeX , iHitSizeY ;
				local iHP , iDmg ;
				iTmp = AND( memory.readbyte(0x0408+iCnt) , 0x3F ) ;
				iHitSizeX = math.max(0, memory.readbyte(0xF9F4+iTmp) - CRockW ) ;
				iHitSizeY = math.max(0, memory.readbyte(0xF9B4+iTmp) - CRockH ) ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" ,  "#FF33FF" ) ;
				iHitSizeX = math.max(0, memory.readbyte(0xFB1C+iTmp) - CWepW ) ;
				iHitSizeY = math.max(0, memory.readbyte(0xFADC+iTmp) - CWepH ) ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" ,  "#00FF00" ) ;
				iDmg = rom.readbyte(0x2000*0x3A+0x0413+0x10+iT)
				iHP = memory.readbyte(0x0450+iCnt) ;
				gui.text( iX , iY , string.format(
					"%02X\n%d\n%d",iT,iHP,iDmg
				 )) ;
			end --if
		end --if
	end --for iCnt
end --function

--------------------------------------------------
--こちらも昔書いたもののコピペ
	local NumOfHBars = 0 ;
	local NumOfVBars = 0 ;
	local NumOfPoints  = 0 ;
local function TerrainCollision_FuncStartCount(add,size)
	local x ;
	x = memory.getregister( "x" ) ;
	if( x==0 ) then
		NumOfHBars = 0 ;
		NumOfVBars = 0 ;
		NumOfPoints  = 0 ;
	end --if
end --function
local function TerrainCollision_FuncHBar(add,size)
	NumOfHBars = NumOfHBars + 1 ;
	local ObjNo ;
	local HitNo ;
	local NumOfHits ;
	local ptr ;
	local tx , ty ;
	local ttx , tty ;
	local dx , dy ;
	local sx , sy ;
	local cnt ;
	ObjNo = memory.getregister( "x" ) ;
	HitNo = memory.getregister( "y" ) ;
	ptr = memory.readbyte(0xd6de+HitNo)*256 + 
	      memory.readbyte(0xd69e+HitNo) ;
	NumOfHits = memory.readbyte( ptr )+1 ; 
	dx = memory.readbytesigned( ptr+2 ) ;
	dy = memory.readbytesigned( ptr+1 ) ;
	sx = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	sy = 0 ;
	tx = memory.readbyte(0x0348+ObjNo)*256 + memory.readbyte(0x0330+ObjNo) ;
	ty = memory.readbyte(0x0390+ObjNo)*256 + memory.readbyte(0x0378+ObjNo) ;
	tx = tx + dx ;
	ty = ty + dy ;

	for cnt=0,NumOfHits-1,1 do
		ttx = tx - sx ;
		tty = ty - sy ;
		tty = tty ;
		gui.box( ttx-1 , tty-1 , ttx+1 , tty+1 , "green" ) ;
		NumOfPoints = NumOfPoints + 1 ;
		tx  = tx + memory.readbytesigned( ptr+3+cnt ) ;
	end --for
end --function

local function TerrainCollision_FuncVBar(add,size)
	NumOfVBars = NumOfVBars + 1 ;
	local ObjNo ;
	local HitNo ;
	local NumOfHits ;
	local ptr ;
	local tx , ty ;
	local ttx , tty ;
	local dx , dy ;
	local sx , sy ;
	local cnt ;
	ObjNo = memory.getregister( "x" ) ;
	HitNo = memory.getregister( "y" ) ;
	ptr = memory.readbyte(0xd848+HitNo)*256 + 
	      memory.readbyte(0xd808+HitNo) ;
	NumOfHits = memory.readbyte( ptr )+1 ; 
	dx = memory.readbytesigned( ptr+1 ) ;
	dy = memory.readbytesigned( ptr+2 ) ;
	sx = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	sy = 0 ;
	tx = memory.readbyte(0x0348+ObjNo)*256 + memory.readbyte(0x0330+ObjNo) ;
	ty = memory.readbyte(0x0390+ObjNo)*256 + memory.readbyte(0x0378+ObjNo) ;
	tx = tx + dx ;
	ty = ty + dy ;

	for cnt=0,NumOfHits-1,1 do
		ttx = tx - sx ;
		tty = ty - sy ;
		tty = tty ;
		gui.box( ttx-1 , tty-1 , ttx+1 , tty+1 , "green" ) ;
		NumOfPoints = NumOfPoints + 1 ;
		ty  = ty + memory.readbytesigned( ptr+3+cnt ) ;
	end --for
end --function



local function TerrainCollisionView()
	if ShowTerrainCollision=="" then
		memory.registerexec( 0xFEDD, 1 , nil ) ;
		memory.registerexec( 0xD2FC, 1 , nil ) ;
		memory.registerexec( 0xD428, 1 , nil ) ;
		return
	end
	gui.text( 8 ,  8 , "H:" .. NumOfHBars ) ;
	gui.text( 8 , 16 , "V:" .. NumOfVBars ) ;
	gui.text( 8 , 24 , "P:" .. NumOfPoints ) ;
	memory.registerexec( 0xFEDD, 1 , TerrainCollision_FuncStartCount ) ;
	memory.registerexec( 0xD2FC, 1 , TerrainCollision_FuncHBar ) ;
	memory.registerexec( 0xD428, 1 , TerrainCollision_FuncVBar ) ;
end --function
--------------------------------------------------
--これも昔のコピペ
local function TerrainView()
	if ShowTerrain=="" then return end

local iAddrStage  = 0x22 ;
local iAddrScPage = 0xF9 ;
local iAddrScX    = 0xFC ;

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
	"#FFFF00",
	"#00FF00",
	"#FF0000",
	"#00FF00",
	"#00FF80",
	"#0000FF",
	"#FF80FF",
	"#FF8000",
	"#000000",
	"#FF8000",
	"#00FFFF",
	"#FF8000",
	"#000000",
	"#000000",
	"#000000",
};
	local aColorTable2 =
{[0]=
	"#0000FF00",
	"#FFFF0080",
	"#00FF0080",
	"#FF000080",
	"#00FF00C0",
	"#00FF8080",
	"#0000FF80",
	"#FF00FF80",
	"#FF800080",
	"#00000080",
	"#FF800080",
	"#00FFFF80",
	"#FF800080",
	"#00000080",
	"#00000080",
	"#00000080",
};
	local aTextTable =
{[0]=
	nil,nil,nil,nil,
	nil,nil,nil,nil,
	">",nil,"<",nil,
	"v",nil,nil,nil,
}
	iStage  = memory.readbyte( iAddrStage ) ;
	iScPage = memory.readbyte( iAddrScPage ) ;
	iScX    = memory.readbyte( iAddrScX ) ;
	iOffsetStage = (iStage+0x20)*0x2000 + 0x10 ;
	for iY=0,0xF,1 do
	for iX=0,0x10,1 do
		tx = iScPage*256 + iX*16 + iScX ;
		lx = AND(tx,0xF)
		iPage  = math.floor( tx/256 ) ;
		iChipX = math.floor( tx%256/16 ) ;
		iNumPage = rom.readbyte( iOffsetStage + 0x1500 + iPage )
		iNumTile = rom.readbyte( iOffsetStage + 0x0900 + 
					iNumPage*0x40 + math.floor(iY/2)*8 + math.floor(iChipX/2) ) ;
		iNumChip = rom.readbyte( iOffsetStage + 0x0500 + 
					iNumTile*4 + (iY%2)*2 + (iChipX%2) ) ;
		iHitValue = rom.readbyte( iOffsetStage + 0x0400 + iNumChip ) ;
		iHitValue = math.floor(iHitValue/16) ;
		gui.box(iX*16-lx+0,iY*16+0,iX*16-lx+15,iY*16+15,aColorTable2[iHitValue],aColorTable[iHitValue]) ;
		if aTextTable[iHitValue] then
			gui.text(iX*16-lx+0,iY*16+0,aTextTable[iHitValue],"#000000C0","#00000000") ;
		end
	end --for
	end --for
end
--------------------------------------------------
local function DragRock()
	if( tInput.Hold("rightclick") and EnableDragRock ~= "" )then
		local iScX , iScY ;
		iScX = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
		iScY = 0 ;
		local iX , iY ;
		iX = iScX + tInput.xmouse() ;
		iY =        tInput.ymouse() ;
		memory.writebyte(0x0330,iX%256)
		memory.writebyte(0x0348,math.floor(iX/256))
		memory.writebyte(0x0378,iY)
		memory.writebyte(0x0390,0)
		memory.writebyte(0x003C,62) --無敵時間
	end --if
end
--------------------------------------------------
--これは新しく書いた
local Collision2Times = 0

local function Collision2Hook1()
	local x = memory.getregister("x")

	--自機のサイズを12x20と仮定する
	local rockx = memory.readbyte(0x0348)*256+memory.readbyte(0x0330)
	local rocky = memory.readbyte(0x0378)
	local rockw = 6
	local rockh = 10

	local objx = memory.readbyte(0x0348+x)*256+memory.readbyte(0x0330+x)
	local objy = memory.readbyte(0x0378+x)
	local objhs = AND(memory.readbyte(0x0408+x),0x3F)
	local objw = memory.readbyte(0xF9F4+objhs)-rockw
	local objh = memory.readbyte(0xF9B4+objhs)-rockh
	
	--スライディング補正
	if memory.readbyte(0x0558) == 0x10 then
		rockh = rockh - 8
	end

	local scx = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	local scy = 0 ;

	objx = objx - scx
	rockx = rockx - scx
	objy = objy - scy
	rocky = rocky - scy

	gui.box(objx-objw,objy-objh,objx+objw,objy+objh,"#00000000","#FF0000FF")
	gui.box(rockx-rockw,rocky-rockh,rockx+rockw,rocky+rockh,"#00000000","#FF0000FF")
	gui.line(objx,objy,rockx,rocky,"#FF000080")

	Collision2Times = Collision2Times + 1

end --function

local function Collision2Hook2()
	local x = memory.getregister("x")
	local y = memory.getregister("y")

	--バスターのサイズを0x0と仮定する
	local wepx = memory.readbyte(0x0348+y)*256+memory.readbyte(0x0330+y)
	local wepy = memory.readbyte(0x0378+y)
	local wephs = memory.readbyte(0x0408+y)
	local wepw = memory.readbyte(0xFACE+wephs*2+1)
	local weph = memory.readbyte(0xFACE+wephs*2+0)

	local objx = memory.readbyte(0x0348+x)*256+memory.readbyte(0x0330+x)
	local objy = memory.readbyte(0x0378+x)
	local objhs = AND(memory.readbyte(0x0408+x),0x3F)
	local objw = memory.readbyte(0xFB1C+objhs)
	local objh = memory.readbyte(0xFADC+objhs)

	local scx = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	local scy = 0 ;

	objx = objx - scx
	wepx = wepx - scx
	objy = objy - scy
	wepy = wepy - scy

	gui.box(objx-objw,objy-objh,objx+objw,objy+objh,"#00000000","#008000FF")
	gui.box(wepx-wepw,wepy-weph,wepx+wepw,wepy+weph,"#00000000","#008000FF")
	gui.line(objx,objy,wepx,wepy,"#008000A0")

	Collision2Times = Collision2Times + 1

end --function


local function Collision2View()
	local cAddrHook1 = 0xF95D
	local cAddrHook2 = 0xFA59

	if ShowCollision2=="" then
		memory.registerexec( cAddrHook1, 1 , nil )
		memory.registerexec( cAddrHook2, 1 , nil )
		return
	end

	memory.registerexec( cAddrHook1, 1 , Collision2Hook1 )
	memory.registerexec( cAddrHook2, 1 , Collision2Hook2 )
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
