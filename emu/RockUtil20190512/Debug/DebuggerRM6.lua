--------------------------------------------------

--ここの値を"*"などに変更しておくとデフォルトでOnにできる
local ShowCollision = "" ;
local ShowTerrainCollision = "" ;
local ShowTerrain = "" ;
local ShowCollision2 = "" ;
local EnableDragRock = "" ;

--------------------------------------------------
local cAddrScXhi = 0x56
local cAddrScXhe = 0x57
local cAddrOXlo = 0x049D
local cAddrOXhi = 0x0486
local cAddrOXhe = 0x046F
local cAddrOYlo = 0x04E2
local cAddrOYhi = 0x04CB
local cAddrOYhe = 0x04B4
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
--[[
	x = x0
	y = y + lh
	w = 28
	for i=0,2,1 do
		local str = string.format("CP:%0X",i) ;
		IEUI:add( EUIButton.new(x,y,w,h,str,BHCP) )
		x = x + w
	end
--]]
	------------------------------
	y = y + lh
	------------------------------
	x = x0
	y = y + lh
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,"ObjHP1",BHPbjHP1) )
	x = x + w
--	IEUI:add( EUIButton.new(x,y,w,h,"FlushObj",BHFlushObj) )
--	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ClrItmFlg",BHClrItmFlg) )
	x = x + w
--	IEUI:add( EUIButton.new(x,y,w,h,"ClrBRush",BHBRush) )
--	x = x + w
	------------------------------
--[[
	x = x0
	y = y + lh
	w = 50
	IEUI:add( EUIButton.new(x,y,w,h,"Prog8Boss",BHProg8Boss) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ProgCossack",BHProgCossack) )
	x = x + w
	IEUI:add( EUIButton.new(x,y,w,h,"ProgWily",BHProgWily) )
	x = x + w
--]]
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
	for i=0,0x65,1 do
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

	memory.writebyte(0x00B0,0xF1) --オーディオキューの先頭
	memory.writebyte(0x00B1,TrackNO) --オーディオキューの先頭+1
	memory.writebyte(0x00D9,2) --オーディオキューのポインタ
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
	for i=0x0688,0x0691,1 do memory.writebyte(i,0x1B) end
	memory.writebyte(0x03E5,0x1B) --ライフ
	memory.writebyte(0x00A9,0x09) --残機
	memory.writebyte(0x06A1,0x09) --E缶
end
BHTiwn = function(t)
	memory.writebyte(0x00A9,0x02) --残機
	memory.writebyte(0x00F0,0x02) --ゲーム処理脱出フラグ
end
BHGameOver = function(t)
	memory.writebyte(0x00A9,0xFF) --残機
	memory.writebyte(0x00F0,0x03) --ゲーム処理脱出フラグ
end
BHStageClear = function(t)
	memory.writebyte(0x00F0,0x01) --ゲーム処理脱出フラグ
end
BHStg = function(t)
	local iTmp
	iTmp = tonumber(string.sub(t.caption,1,2),16)
	memory.writebyte(0x0051,iTmp) --現在居るステージ
	BHClrItmFlg(t)
	memory.writebyte(0xEF,0x00)   --
	memory.writebyte(0x0686,0x00) --
	memory.writebyte(0x0684,0x00) --
	memory.writebyte(0x06A0,0x00) --
	memory.writebyte(0x0685,0x00) --
	memory.writebyte(0x069E,0x00) --
	for i=0x0340,0x0340+0x1F,1 do memory.writebyte(i,0x00) end
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
	for i=0x0650,0x066F,1 do memory.writebyte(i,0x00) end
end
BHPbjHP1 = function(t)
	for i=0x03E5+8,0x03E5+0x16,1 do memory.writebyte(i,0x00) end
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
local function CollisionView()
	if ShowCollision=="" then return end
	local CRockW = 0x6 ;
	local CRockH = 0xA ;
	local CWepW  = 0x0 ;
	local CWepH  = 0x0 ;
	local iCnt ;
	local iScX , iScY ;

	iScX = memory.readbyte(cAddrScXhe)*256+memory.readbyte(cAddrScXhi) ;
	iScY = 0 ;

	gui.text( 8 , 16 , string.format(
		"%d",memory.readbyte(0x03E5)+1
	 )) ;

	for iCnt=0x16 , 0 , -1 do
		local iT ;
		iT  = memory.readbyte(0x03A0+iCnt) ;

		if( iT ~= 0 ) then
			local iX , iY ;
			iX = memory.readbyte(0x046F+iCnt)*256+memory.readbyte(0x0486+iCnt) ;
			iY = memory.readbyte(0x04CB+iCnt) ;
			iX = iX - iScX ;
			iY = iY - iScY ;

			local iHitRectNum , iHitSizeX , iHitSizeY ;
			iHitRectNum = memory.readbyte(0x059A+iCnt) ;
			iHitSizeX = memory.readbyte(0xF7E0+iHitRectNum) ;
			iHitSizeY = memory.readbyte(0xF849+iHitRectNum) ;

			if( iCnt==0 ) then
				iY = iY + memory.readbyte(0x059A) ;
			end --if
			gui.box( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "green" ) ;
			local iHP , iDmg ;
			iDmg = AND( memory.readbyte(0x0583+iCnt) , 0x0F ) ;
			iHP = memory.readbyte(0x03E5+iCnt)+1 ;
			local iDamage = memory.readbyte(0x0583+iCnt) ;
--			gui.text( iX , iY , string.format(
--				"%02X\n%d\n%d",iT,iHP,iDmg
--			 )) ;
			gui.text( iX , iY , string.format(
				"%02X", iDamage
			 )) ;
		end --if
	end --for iCnt
end --function

--------------------------------------------------
	local NumOfPoints  = 0 ;
local function TerrainCollision_FuncStartCount(add,size)
	NumOfPoints  = 0 ;
end --function
local function TerrainCollision_Func(add,size)
	local tx , ty ;
	local sx , sy ;
	tx = memory.readbyte(0x4F)*256+memory.readbyte(0x4D) ;
	ty = memory.readbyte(0x4E)

	sx = memory.readbyte(0x57)*256+memory.readbyte(0x56) ;
	sy = 0 ;
	tx = tx - sx ;
	ty = ty - sy ;
	gui.box( tx-1 , ty-1 , tx+1 , ty+1 , "green" ) ;

	local s = memory.getregister("s")+0x100 ;
	s = memory.readbyte(s+2)*256+memory.readbyte(s+1)-2 ;
	
--	gui.text( 8 , 16+8*NumOfPoints , string.format(
--		"%04X",s
--	 )) ;
	NumOfPoints = NumOfPoints + 1 ;
end --function
local function TerrainCollisionView()
	if ShowTerrainCollision=="" then
		memory.registerexec( 0xE420, 1 , nil ) ;
		memory.registerexec( 0xD9FB, 1 , nil ) ;
		return
	end
	gui.text( 8 , 8 , "P:" .. NumOfPoints ) ;
	memory.registerexec( 0xE420, 1 , TerrainCollision_FuncStartCount ) ;
	memory.registerexec( 0xD9FB, 1 , TerrainCollision_Func ) ;
end --function
--------------------------------------------------
--これも昔のコピペ
local function TerrainView()
	if ShowTerrain=="" then return end

	local iX , iY ;
	local tx ;
	local iScPage , iScX ;
	local iPage , iChipX ;

	local iNumPage , iNumTile , iNumChip ;
	local iHitValue ;
	
	local iStage = memory.readbyte(0x51)
	local iTerrainSet = memory.readbyte(0xDB03+iStage)
	local iAddrX16Dfn = memory.readbyte(0x63)*0x100
	local iAddrX32Dfn = memory.readbyte(0x67)*0x100
	local iAddrPageDfn = memory.readword(0x52)
	local iPrg8 = memory.readbyte(0x6E)
	local iPrgA = memory.readbyte(0x6F)
	local aColorTable =
{[0]=
	"#0000FF00",
	"#FFFF00",
	"#808080",
	"#00FF00",
	"#00FF00",
	"#33FFFF",
	"#0000FF",
	"#FFFF00",

	"#0000FF",
	"#808080",
	"#FF8000",
	"#FFFF00",
	"#FFFF00",
	"#FFFF00",
	"#FF8000",
	"#FF0000",

	"#000000",
	"#FF00FF",
	"#000000",
	"#FF00FF",
	"#000000",
	"#FF00FF",
	"#000000",
	"#FFFF00",

	"#000000",
	"#FFFF00",
	"#000000",
	"#FFFF00",
	"#000000",
	"#FFFF00",
	"#000000",
	"#FFFF00",
};
	local aColorTable2 =
{[0]=
	"#0000FF00",
	"#FFFF0080",
	"#0000FF40",
	"#00FF00C0",
	"#00FF0080",
	"#00FFFF80",
	"#0000FF40",
	"#FFFF0080",

	"#0000FF80",
	"#FFFF0080",
	"#FF800080",
	"#FFFF0080",
	"#FFFF0080",
	"#FFFF0080",
	"#FF800080",
	"#FF000080",

	"#00000080",
	"#FF00FF80",
	"#00000080",
	"#FF00FF80",
	"#00000080",
	"#FF00FF80",
	"#00000080",
	"#FFFF0080",

	"#00000080",
	"#FFFF0080",
	"#00000080",
	"#FFFF0080",
	"#00000080",
	"#FFFF0080",
	"#00000080",
	"#FFFF0080",
};
	local aTextTable =
{[0]=
	nil,nil,"oil",nil,
	nil,nil," h"," h",
	nil,"oil"," ^\n ^"," *",
	"~~~","ice"," v\n v",nil,

	" w"," <>\n <>",nil,"\nvvv",
	nil,"^^^",nil,"<<<",
	nil,">>>",nil," *\n l",
	nil," f",nil," w",
}
	iScPage = memory.readbyte( cAddrScXhe ) ;
	iScX    = memory.readbyte( cAddrScXhi ) ;
	for iY=0,0xF,1 do
	for iX=0,0x10,1 do
		tx = iScPage*256 + iX*16 + iScX ;
		lx = AND(tx,0xF)
		iPage  = math.floor( tx/256 ) ;
		iChipX = math.floor( tx%256/16 ) ;
		
		iNumTile = rom.readbyte( 0x10 + iPrgA*0x2000 + 
					AND(iAddrPageDfn,0x1FFF) +
					math.floor(iY/2)*0x100 +
					math.floor(tx/32) )
		iNumChip = rom.readbyte( 0x10 + iPrg8*0x2000 + 
					AND(iAddrX32Dfn,0x1FFF) +
					iNumTile*4 + (iY%2)*2 + (iChipX%2) ) ;
		if AND(memory.readbyte(0x0340+math.floor(iNumChip/8)),bit.lshift(1,iNumChip%8)) ~= 0 then
			iHitValue = rom.readbyte( 0x10 +  iPrg8*0x2000 + 
						AND(0x1B00,0x1FFF) +
						0x0400 + iNumChip ) ;
		else
			iHitValue = rom.readbyte( 0x10 +  iPrg8*0x2000 + 
						AND(iAddrX16Dfn,0x1FFF) +
						0x0400 + iNumChip ) ;
		end --if
		iHitValue = math.floor(iHitValue/16) ;
		iHitValue = memory.readbyte( 0xDB13 + iTerrainSet*0x10 + iHitValue)
		gui.box(iX*16-lx+0,iY*16+0,iX*16-lx+15,iY*16+15,aColorTable2[iHitValue],aColorTable[iHitValue]) ;
		if aTextTable[iHitValue] then
			gui.text(iX*16-lx+0,iY*16+0,aTextTable[iHitValue],"#000000C0","#00000000") ;
		end
--		gui.text(iX*16-lx+0,iY*16+0,string.format("%0X",iHitValue))
	end --for
	end --for
end
--------------------------------------------------
local function DragRock()
	if( tInput.Hold("rightclick") and EnableDragRock ~= "" )then
		local iScX , iScY ;
		iScX = memory.readbyte(cAddrScXhe)*256+memory.readbyte(cAddrScXhi) ;
		iScY = 0 ;
		local iX , iY ;
		iX = iScX + tInput.xmouse() ;
		iY =        tInput.ymouse() ;
		memory.writebyte(cAddrOXhi,iX%256)
		memory.writebyte(cAddrOXhe,math.floor(iX/256))
		memory.writebyte(cAddrOYhi,iY)
		memory.writebyte(cAddrOYhe,0)
		memory.writebyte(0x00A2,62) --無敵時間
	end --if
end
--------------------------------------------------
--これは新しく書いた
local Collision2Times = 0

local function Collision2Hook1()
	--便宜的にrock<>objとなっているが、自機との判定とは限らない
	local rockx = memory.readword(0x00)
	local rocky = memory.readword(0x02)
	local rockhs = memory.readbyte(0x08)

	local objx = memory.readword(0x04)
	local objy = memory.readword(0x06)

	local objhs = memory.readbyte(0x0A)

	local rockw = memory.readbyte(0xF7E0+rockhs)
	local rockh = memory.readbyte(0xF849+rockhs)
	local objw = memory.readbyte(0xF7E0+objhs)
	local objh = memory.readbyte(0xF849+objhs)
	
	local scx = memory.readbyte(cAddrScXhe)*256+memory.readbyte(cAddrScXhi) ;
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

local function Collision2View()
	local cAddrHook1 = 0xF73E

	if ShowCollision2=="" then
		memory.registerexec( cAddrHook1, 1 , nil )
		return
	end

	memory.registerexec( cAddrHook1, 1 , Collision2Hook1 )
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
