
DestTable =
{[0]=
	0x1ECFED , "NMI" , "" , "" ,
	0x1ED08A , "Audio" , "" , "" ,
	0x1ED0C3 , "-" , "" , "" ,
	0x1C81B3 , "F-Wait" , "" , "" ,
	0x1C8171 , "Stat-ML/?" , "" , "" ,
	0x1C8178 , "SubProc" , "" , "" ,
	0x1C8181 , "?" , "" , "" ,
	0x1C8184 , "RockProc" , "" , "" ,
	0x1C8187 , "RockWepProc" , "" , "" ,
	0x1C818A , "PlaceObj" , "" , "" ,
	0x1C818D , "BossProc" , "" , "" ,
	0x1C8190 , "ObjProc" , "" , "" ,
	0x1C926F , "Obj10" , "" , "" ,
	0x1C926F , "Obj11" , "" , "" ,
	0x1C926F , "Obj12" , "" , "" ,
	0x1C926F , "Obj13" , "" , "" ,
	0x1C926F , "Obj14" , "" , "" ,
	0x1C926F , "Obj15" , "" , "" ,
	0x1C926F , "Obj16" , "" , "" ,
	0x1C926F , "Obj17" , "" , "" ,
	0x1C926F , "Obj18" , "" , "" ,
	0x1C926F , "Obj19" , "" , "" ,
	0x1C926F , "Obj1A" , "" , "" ,
	0x1C926F , "Obj1B" , "" , "" ,
	0x1C926F , "Obj1C" , "" , "" ,
	0x1C926F , "Obj1D" , "" , "" ,
	0x1C926F , "Obj1E" , "" , "" ,
	0x1C926F , "Obj1F" , "" , "" ,
	0x1C92A1 , "-" , "" , "" ,
	0x1C8193 , "Sprite" , "" , "" ,
	0x1C81B0 , "P-Wait" , "" , "" ,
	0xFFFFFF , "END"
} ;

AddrPrg8  = 0x69 ;
AddrPrgA  = 0x69 ;
AddrPrgCf = 0x1E0000 ;
DPrgVal8  = 0 ;
DPrgValA  = 1 ;
PrgvalMul = 2 ;



	dofile("_Sub_CycCnt.lua")

	while 1 do
		Output_List() ;
		FCEU.frameadvance() ;
	end
