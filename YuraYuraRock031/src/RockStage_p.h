#ifndef ROCK_STAGE_P_HEADER_INCLUDED
#define ROCK_STAGE_P_HEADER_INCLUDED

#include "RockStage.h"
//#define SPDF_SizePerData	8	//SpDataのFormatの定数

typedef struct RS_SpDataList_tag
{
	union
	{
		struct
		{
			int iAddrBase ;
			int iAddrDeltaS ;
			int iAddrDeltaD ;
			int iSize ;
			int iDataOffset ;
			int iEditMsg ;
			int iEditSize ;
			int iEditLine ;
			int iRV ;
		};
		int aiData[9] ;
	};
}RS_SpDataList;

#define SPOf1_RoomConnection 0x000
#define SPOf1_HitPattern     0x040
#define SPOf1_RevPage0       0x050
#define SPOf1_RevPage1       0x055
#define SPOf1_RevUDPage0     0x053
#define SPOf1_RevUDPage1     0x058
#define SPOf1_RevRoom        0x030
#define SPOf1_RevObjPID      0x038
#define SPOf1_RevPageLRPerRoom 0x60
#define SPOf1_BehindTile     0x78
#define SPOf1_VRAMOffset 0x240
#define SPOf1_VRAMBody   0x280

#define SPOf1_StageBorder    0x055
#define SPOf1_SizeOfGrpData  0xB
#define SPOf1_GrpLines       0x5
#define SPOf1_SizeOfRoomConnection 0x30

#define SPOf2_CP_Page      0x006
#define SPOf2_StageBorder  0x009
#define SPOf2_CP_ObjPID    (6*2)
#define SPOf2_CP_ItemPID   (6*3)
#define SPOf2_CP_NTLhi     (6*4)
#define SPOf2_CP_NTLlo     (6*5)
#define SPOf2_CP_NTRhi     (6*6)
#define SPOf2_CP_NTRlo     (6*7)
#define SPOf2_CP_Room      (6*8)
#define SPOf2_CP_PageL     (6*9)
#define SPOf2_CP_PageR     (6*10)

#define SPOf2_RoomConnection 0x050
#define SPOf2_HitPattern     0x070
#define SPOf2_BossPage1      0x074
#define SPOf2_BossPage2      0x075
#define SPOf2_ShutterPage1   0x076
#define SPOf2_ShutterPage2   0x077
#define SPOf2_Color1         0x080
#define SPOf2_Color2         0x100
#define SPOf2_VRAMOffset     0x180
#define SPOf2_VRAMBody       0x200

#define SPOf3_RoomConnection 0x000
#define SPOf3_RoomObjPatColor 0x020
#define SPOf3_VROM           0x040
#define SPOf3_RevPage        0x050
#define SPOf3_RevRoom        0x058
#define SPOf3_RevObjOffset   0x060

#define SPOf4_RoomConnection 0x000
#define SPOf4_Branch         0x030

#define SPOf5_RoomConnection 0x000
#define SPOf5_Branch         0x040

#define R1_MaxRoom 0x030
#define R2_MaxRoom 0x020
#define R3_MaxRoom 0x020
#define R4_MaxRoom 0x010
#define R5_MaxRoom 0x018
#define R3_MaxObjVROMBGColor 0x010
#define R3_MaxRevPoint 8
#define R3_MaxPageAlloc (0x040*3)



#endif /*ROCK_STAGE_P_HEADER_INCLUDED*/
