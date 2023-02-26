--------------------------------------------------

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
	IEUI:add( EUIButton.new(x,y,w,h,"N-Wep",BHNWep) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"Tiwn",BHTiwn) )
	x = x + w
	------------------------------
	x = x0
	y = y + lh
	w = 14
	for i=0,0x11,1 do
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
	for i=0,7,1 do
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
	IEUI:add( EUIButton.new(x,y,w,h,"ExitStg",BHExitStg) )
	------------------------------
	x = x0
	y = y + lh
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,"ClrBRush",BHBRush) )
	x = x + w
	------------------------------
	x = x0
	y = y + lh
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,"Prog8Boss",BHProg8Boss) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ProgDoc",BHProgDoc) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ProgBreak",BHProgBreak) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ProgWily",BHProgWily) )
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
	for i=0xA2,0xAD,1 do memory.writebyte(i,0x9C) end --ライフを含む
	memory.writebyte(0x00AE,0x99) --残機
	memory.writebyte(0x00AF,0x99) --E缶
end
BHNWep = function(t)
	for i=0xA3,0xAD,1 do memory.writebyte(i,0x00) end
	memory.writebyte(0xA9,0x9C) --ラッシュコイル
end
BHTiwn = function(t)
	memory.writebyte(0x00AE,0x02) --残機
	memory.writebyte(0x003C,0x01) --やられた扱いのメインループ脱出フラグ
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
	iStg = memory.readbyte(0x0022)

	local iPage
	iPage = rom.readbyte(0x10+iStg*0x2000+0x0AF8+iTmp-1)
	if( iTmp==0 )then iPage=0 end

	memory.writebyte(0x006F,iPage) --最大到達ページ
	BHTiwn(t)
end
BHExitStg = function(t)
	memory.writebyte(0x0059,0x01) --クリア扱いのメインループ脱出フラグ
end
BHFlushObj = function(t)
	for i=0x310,0x31F,1 do memory.writebyte(i,0x00) end
end
BHBRush = function(t)
	memory.writebyte(0x006E,0xFF) --ボスラッシュクリア情報
	BHFlushObj(t)
end
BHClrItmFlg = function(t)
	for i=0x150,0x16F,1 do memory.writebyte(i,0x00) end
end
BHPbjHP1 = function(t)
	for i=0x4F0,0x4FF,1 do memory.writebyte(i,0x01) end
end

BHProg8Boss = function(t)
	memory.writebyte(0x0061,0x00) --突入可能ステージ
	memory.writebyte(0x0060,0x00) --進捗
end
BHProgDoc = function(t)
	memory.writebyte(0x0061,0x3A) --突入可能ステージ
	memory.writebyte(0x0060,0x09) --進捗
end
BHProgBreak = function(t)
	memory.writebyte(0x0061,0xFF) --突入可能ステージ
	memory.writebyte(0x0060,0x12) --進捗
end
BHProgWily = function(t)
	memory.writebyte(0x0061,0xFF) --突入可能ステージ
	memory.writebyte(0x0060,0xFF) --進捗
end

BHDummy = function(t)
--コピペ用
end

--------------------------------------------------
--昔書いたやつのコピペだけど、あってるんじゃないの、たぶん

local function CollisionView()
	if ShowCollision=="" then return end
	local CRockW = 0x8 ;
	local CRockH = 0xD ;
	local CWepW  = 0x4 ;
	local CWepH  = 0x4 ;
	local iCnt ;
	local iScX , iScY ;

	iScX = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	iScY = 0 ;

	gui.text( 8 , 16 , string.format(
		"%d",AND(memory.readbyte(0xA2),0x7F)
	 )) ;

	for iCnt=0 , 0x1F , 1 do
		local iFlg , iX , iY ;
		iX = memory.readbyte(0x0380+iCnt)*256+memory.readbyte(0x0360+iCnt) ;
		iY = memory.readbyte(0x03C0+iCnt) ;
		iX = iX - iScX ;
		iY = iY - iScY ;

		iFlg = memory.readbyte(0x0300+iCnt) ;
		if( iFlg>=0x80 ) then
			local iT , iHP ;
			iT  = memory.readbyte(0x0320+iCnt) ;
			iHP = AND( memory.readbyte(0x04E0+iCnt) ,0x1F ) ;

			if( iCnt==0 ) then
				local iHitSizeX , iHitSizeY ;
				iHitSizeX = CRockW ;
				iHitSizeY = CRockH ;
				if( memory.readbyte(0x05C0) == 0x10 )then
					iHitSizeY = iHitSizeY - 8 ;
				end --if
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "#FF33FF" ) ;
			elseif( iCnt<=3 ) then
				local iHitSizeX , iHitSizeY ;
				local iTmp ;
				iHitSizeX = CWepW ;
				iHitSizeY = CWepH ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "#00FF00" ) ;
			elseif( iCnt<=0xF ) then
				local iHitSizeX , iHitSizeY ;
				iHitSizeX = 2 ;
				iHitSizeY = 2 ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "orange" ) ;
			else
				local iTmp , iHitSizeX , iHitSizeY ;
				local iDmg ;
				iTmp = AND( memory.readbyte(0x480+iCnt) , 0x1F ) ;
				iHitSizeX = math.max(0, memory.readbyte(0xFB5B+iTmp) - CRockW ) ;
				iHitSizeY = math.max(0, memory.readbyte(0xFB3B+iTmp) - CRockH ) ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" ,  "#FF33FF" ) ;
				iHitSizeX = math.max(0, memory.readbyte(0xFC23+iTmp) - CWepW ) ;
				iHitSizeY = math.max(0, memory.readbyte(0xFC03+iTmp) - CWepH ) ;
				gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" ,  "#00FF00" ) ;
				iDmg = rom.readbyte(0x2000*0x0A+0x10+iT)
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
	local iObjNo ;
	local iHitNo ;
	local iNumOfHits ;
	local iAddr ;
	local iX , iY ;
	local iTx , iTy ;
	local iDx , iDy ;
	local iScX , iScY ;
	local iCnt ;
	iObjNo = memory.getregister( "x" ) ;
	iHitNo = memory.getregister( "y" ) ;
	iAddr = memory.readbyte(0xEBDA+iHitNo)+0xEC08 ;
	iNumOfHits = memory.readbyte( iAddr )+1 ; 
	iDx = memory.readbytesigned( iAddr+2 ) ;
	iDy = memory.readbytesigned( iAddr+1 ) ;
	iScX = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	iScY = 0 ;

	iX = memory.readbyte(0x0380+iObjNo)*256+memory.readbyte(0x0360+iObjNo) ;
	iY = memory.readbyte(0x03E0+iObjNo)*256+memory.readbyte(0x03C0+iObjNo) ;
	iX = iX + iDx ;
	iY = iY + iDy ;

	for iCnt=0,iNumOfHits-1,1 do
		iTx = iX - iScX ;
		iTy = iY - iScY ;
		gui.box( iTx-1 , iTy-1 , iTx+1 , iTy+1 , "green" ) ;
		NumOfPoints = NumOfPoints + 1 ;
		iX  = iX + memory.readbytesigned( iAddr+3+iCnt ) ;
	end --for
end --function

local function TerrainCollision_FuncVBar(add,size)
	NumOfVBars = NumOfVBars + 1 ;
	local iObjNo ;
	local iHitNo ;
	local iNumOfHits ;
	local iAddr ;
	local iX , iY ;
	local iTx , iTy ;
	local iDx , iDy ;
	local iScX , iScY ;
	local iCnt ;
	iObjNo = memory.getregister( "x" ) ;
	iHitNo = memory.getregister( "y" ) ;
	iAddr = memory.readbyte(0xECD9+iHitNo)+0xECFF ;
	iNumOfHits = memory.readbyte( iAddr )+1 ; 
	iDx = memory.readbytesigned( iAddr+1 ) ;
	iDy = memory.readbytesigned( iAddr+2 ) ;
	iScX = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	iScY = 0 ;

	iX = memory.readbyte(0x0380+iObjNo)*256+memory.readbyte(0x0360+iObjNo) ;
	iY = memory.readbyte(0x03E0+iObjNo)*256+memory.readbyte(0x03C0+iObjNo) ;
	iX = iX + iDx ;
	iY = iY + iDy ;

	for iCnt=0,iNumOfHits-1,1 do
		iTx = iX - iScX ;
		iTy = iY - iScY ;
		gui.box( iTx-1 , iTy-1 , iTx+1 , iTy+1 , "green" ) ;
		NumOfPoints = NumOfPoints + 1 ;
		iY  = iY + memory.readbytesigned( iAddr+3+iCnt ) ;
	end --for
end --function



local function TerrainCollisionView()
	if ShowTerrainCollision=="" then
		memory.registerexec( 0xFEC3, 1 , nil ) ;
		memory.registerexec( 0xE8CE, 1 , nil ) ;
		memory.registerexec( 0xE9DB, 1 , nil ) ;
		return
	end
	gui.text( 8 ,  8 , "H:" .. NumOfHBars ) ;
	gui.text( 8 , 16 , "V:" .. NumOfVBars ) ;
	gui.text( 8 , 24 , "P:" .. NumOfPoints ) ;
	memory.registerexec( 0xFEC3, 1 , TerrainCollision_FuncStartCount ) ;
	memory.registerexec( 0xE8CE, 1 , TerrainCollision_FuncHBar ) ;
	memory.registerexec( 0xE9DB, 1 , TerrainCollision_FuncVBar ) ;
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
	"#000000",
	"#00FF00",
	"#FF0000",
	"#0080FF",
	"#FF80FF",
	"#0000FF",
	"#000000",
	"#000000",
	"#000000",
	"#000000",
	"#000000",
	"#000000",
	"#000000",
};
	local aColorTable2 =
{[0]=
	"#0000FF00",
	"#FFFF0080",
	"#00FF0080",
	"#00000000",
	"#00FF00C0",
	"#FF000080",
	"#0080FF40",
	"#FF00FF80",
	"#0000FF80",
	"#00000080",
	"#00000080",
	"#00000080",
	"#00000080",
	"#00000080",
	"#00000080",
	"#00000080",
};

	iStage  = memory.readbyte( iAddrStage ) ;
	iStage2  = memory.readbyte( 0xC8B9 + iStage ) ;
	iScPage = memory.readbyte( iAddrScPage ) ;
	iScX    = memory.readbyte( iAddrScX ) ;
	iOffsetStage  = (iStage +0x00)*0x2000 + 0x10 ;
	iOffsetStage2 = (iStage2+0x00)*0x2000 + 0x10 ;
	for iY=0,0xF,1 do
	for iX=0,0x10,1 do
		tx = iScPage*256 + iX*16 + iScX ;
		iPage  = math.floor( tx/256 ) ;
		iChipX = math.floor( tx%256/16 ) ;
		iNumPage = rom.readbyte( iOffsetStage  + 0x0A00 + iPage )
		iNumTile = rom.readbyte( iOffsetStage2 + 0x0F00 + 
					iNumPage*0x40 + math.floor(iY/2)*8 + math.floor(iChipX/2) ) ;
		iNumChip = rom.readbyte( iOffsetStage2 + 0x1700 + 
					iNumTile*4 + (iY%2)*2 + (iChipX%2) ) ;
		iHitValue = rom.readbyte( iOffsetStage2 + 0x1F00 + iNumChip ) ;
		iHitValue = math.floor(iHitValue/16) ;
		
		local tmpx , tmpy ;
		tmpx = iX*16-iScX%16 ;
		tmpy = iY*16 ;
		gui.box(tmpx+0,tmpy+0,tmpx+15,tmpy+15,aColorTable2[iHitValue],aColorTable[iHitValue]) ;
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
		memory.writebyte(0x0360,iX%256)
		memory.writebyte(0x0380,math.floor(iX/256))
		memory.writebyte(0x03C0,iY)
		memory.writebyte(0x03E0,0)
		memory.writebyte(0x0039,60) --無敵時間
		iTmp = OR(memory.readbyte(0x05E0),0x80)
		memory.writebyte(0x05E0,iTmp) --点滅
	end --if
end
--------------------------------------------------
--これは新しく書いた
local Collision2Times = 0

local function Collision2Hook1()
	local x = memory.getregister("x")

	--自機のサイズを16x26と仮定する
	local rockx = memory.readbyte(0x0380)*256+memory.readbyte(0x0360)
	local rocky = memory.readbyte(0x03C0)
	local rockw = 8
	local rockh = 13

	local objx = memory.readbyte(0x0380+x)*256+memory.readbyte(0x0360+x)
	local objy = memory.readbyte(0x03C0+x)
	local objhs = AND(memory.readbyte(0x0480+x),0x1F)
	local objw = memory.readbyte(0xFB5B+objhs)-rockw
	local objh = memory.readbyte(0xFB3B+objhs)-rockh
	
	--スライディング補正
	if memory.readbyte(0x05C0) == 0x10 then
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

	--自機武器のサイズを8x8と仮定する
	local wepx = memory.readbyte(0x01)*256+memory.readbyte(0x00)
	local wepy = memory.readbyte(0x02)
	local wepw = 4
	local weph = 4

	local objx = memory.readbyte(0x0380+x)*256+memory.readbyte(0x0360+x)
	local objy = memory.readbyte(0x03C0+x)
	local objhs = AND(memory.readbyte(0x0480+x),0x1F)
	local objw = memory.readbyte(0xFC23+objhs)-wepw
	local objh = memory.readbyte(0xFC03+objhs)-weph

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
	local cAddrHook1 = 0xFAF6
	local cAddrHook2 = 0xFBD2

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
