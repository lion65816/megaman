
DestTable =
{[0]=
	0x0ED4A8 , "NMI" , "" , "" ,
	0x0ED54C , "Audio" , "" , "" ,
	0x0ED56E , "-" , "" , "" ,
	0x0A91CC , "F-Wait" , "" , "" ,
	0x0A915E , "?" , "" , "" ,
	0x0A9165 , "Pause" , "" , "" ,
	0x0A9187 , "?" , "" , "" ,
	0x0A918A , "Rockman" , "" , "" ,
	0x0A918D , "?" , "" , "" ,
	0x0A919A , "-" , "" , "" ,
	0x0A91A7 , "Weapon?" , "" , "" ,
	0x0A91AA , "Boss" , "" , "" ,
	0x0A91B3 , "HitProc>R" , "" , "" ,
	0x0A91B6 , "HitProc>E" , "" , "" ,
	0x0A91B9 , "?" , "" , "" ,
	0x0A98F2 , "Obj02" , "" , "" ,
	0x0A98F2 , "Obj03" , "" , "" ,
	0x0A98F2 , "Obj04" , "" , "" ,
	0x0A98F2 , "Obj05" , "" , "" ,
	0x0A98F2 , "Obj06" , "" , "" ,
	0x0A98F2 , "Obj07" , "" , "" ,
	0x0A98F2 , "Obj08" , "" , "" ,
	0x0A98F2 , "Obj09" , "" , "" ,
	0x0A98F2 , "Obj0A" , "" , "" ,
	0x0A98F2 , "Obj0B" , "" , "" ,
	0x0A98F2 , "Obj0C" , "" , "" ,
	0x0A98F2 , "Obj0D" , "" , "" ,
	0x0A98F2 , "Obj0E" , "" , "" ,
	0x0A98F2 , "Obj0F" , "" , "" ,
	0x0A98F2 , "Obj10" , "" , "" ,
	0x0A98F2 , "Obj11" , "" , "" ,
	0x0A98F2 , "Obj12" , "" , "" ,
	0x0A98F2 , "Obj13" , "" , "" ,
	0x0A98F2 , "Obj14" , "" , "" ,
	0x0A98F2 , "Obj15" , "" , "" ,
	0x0A98F2 , "Obj16" , "" , "" ,
	0x0A98F2 , "Obj17" , "" , "" ,
	0x0A98F2 , "Obj18" , "" , "" ,
	0x0A98F2 , "Obj19" , "" , "" ,
	0x0A98F2 , "Obj1A" , "" , "" ,
	0x0A98F2 , "Obj1B" , "" , "" ,
	0x0A98F2 , "Obj1C" , "" , "" ,
	0x0A98F2 , "Obj1D" , "" , "" ,
	0x0A98F2 , "Obj1E" , "" , "" ,
	0x0A9995 , "Obj1F" , "" , "" ,
	0x0A91BC , "?" , "" , "" ,
	0x0A91BF , "Sprite" , "" , "" ,
	0x0A91C2 , "?" , "" , "" ,
	0x0A91C9 , "P-Wait" , "" , "" ,
	0xFFFFFF , "END"
} ;

AddrPrg8  = 0x42 ;
AddrPrgA  = 0x42 ;
AddrPrgCf = 0x0E0000 ;
DPrgVal8  = 0 ;
DPrgValA  = 1 ;
PrgvalMul = 2 ;



	dofile("_Sub_CycCnt.lua")

	while 1 do
		Output_List() ;
		FCEU.frameadvance() ;
	end
