local EmuYFix = 0 ;

local iAddrStage  = 0x22 ;
local iAddrScPage = 0xF9 ;
local iAddrScX    = 0xFC ;



while (1) do
	local iX , iY ;
	local tx ;
	local iScPage , iScX ;
	local iStage ;
	local iPage , iChipX ;

	local iNumPage , iNumTile , iNumChip ;
	local iHitValue ;
	local aColorTable =
{[0]=
	"#0000FF",
	"#FFFF00",
	"#00FF00",
	"#FF0000",
	"#008800",
	"#00FF88",
	"#0088FF",
	"#880000",
	"#008888",
	"#000000",
	"#008888",
	"#00FFFF",
	"#008888",
	"#000000",
	"#000000",
	"#000000",
};

	iStage  = memory.readbyte( iAddrStage ) ;
	iScPage = memory.readbyte( iAddrScPage ) ;
	iScX    = memory.readbyte( iAddrScX ) ;
	for iY=0,0xF,1 do
	for iX=0,0x10,1 do
		tx = iScPage*256 + iX*16 + iScX ;
		lx = AND(tx,0xF) ;
		iPage  = math.floor( tx/256 )%16 ;
		iChipX = math.floor( tx%256/16 ) ;
		iNumChip = memory.readbyte( 0x6000 + iPage*0x100 + iChipX*0x10 + iY ) ;
		iHitValue = memory.readbyte( 0x7400 + iNumChip ) ;
		iHitValue = math.floor(iHitValue/16) ;
		gui.box(iX*16-lx+0,iY*16+0+EmuYFix,iX*16-lx+15,iY*16+15+EmuYFix,aColorTable[iHitValue].."40") ;
	end --for
	end --for



	FCEU.frameadvance() ;
end

