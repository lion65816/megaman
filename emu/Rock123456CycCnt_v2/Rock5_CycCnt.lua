
DestTable =
{[0]=
	0x1EC000 , "NMI" , "" , "" ,
	0x1EC125 , "--" , "" , "" ,
	0x1EC15F , "Audio" , "" , "" ,
	0x1EC162 , "--" , "" , "" ,
	0x1EDF4A , "F-Wait" , "" , "" ,
	0x1EDE73 , "StartML" , "" , "" ,
	0x1EDE89 , "Pause" , "" , "" ,
	0x1EDEAC , "Rockman" , "" , "" ,
	0x1EDEB4 , "--" , "" , "" ,
	0x1C8004 , "Obj1" , "" , "" ,
	0x1C8004 , "Obj2" , "" , "" ,
	0x1C8004 , "Obj3" , "" , "" ,
	0x1C8004 , "Obj4" , "" , "" ,
	0x1C8004 , "Obj5" , "" , "" ,
	0x1C8004 , "Obj6" , "" , "" ,
	0x1C8004 , "Obj7" , "" , "" ,
	0x1C8004 , "Obj8" , "" , "" ,
	0x1C8004 , "Obj9" , "" , "" ,
	0x1C8004 , "ObjA" , "" , "" ,
	0x1C8004 , "ObjB" , "" , "" ,
	0x1C8004 , "ObjC" , "" , "" ,
	0x1C8004 , "ObjD" , "" , "" ,
	0x1C8004 , "ObjE" , "" , "" ,
	0x1C8004 , "ObjF" , "" , "" ,
	0x1C8004 , "Ob10" , "" , "" ,
	0x1C8004 , "Ob11" , "" , "" ,
	0x1C8004 , "Ob12" , "" , "" ,
	0x1C8004 , "Ob13" , "" , "" ,
	0x1C8004 , "Ob14" , "" , "" ,
	0x1C8004 , "Ob15" , "" , "" ,
	0x1C8004 , "Ob16" , "" , "" ,
	0x1C8004 , "Ob17" , "" , "" ,
	0x1C8044 , "--" , "" , "" ,
	0x1EDEBC , "Scroll" , "" , "" ,
	0x1EDEC6 , "PlaceObj" , "" , "" ,
	0x1EDED4 , "DrawBackNT" , "" , "" ,
	0x1EDED7 , "--" , "" , "" ,
	0x1EDEF9 , "GravityBG" , "" , "" ,
	0x1EDF1A , "ClearSpr" , "" , "" ,
	0x1EDF21 , "Spr" , "" , "" ,
	0x1EDF24 , "--" , "" , "" ,
	0x1EDF47 , "P-Wait" , "" , "" ,
	0xFFFFFF , "END"
} ;

AddrPrg8  = 0xF3 ;
AddrPrgA  = 0xF4 ;
AddrPrgCf = 0x1E0000 ;
DPrgVal8  = 0 ;
DPrgValA  = 0 ;
PrgvalMul = 1 ;



	dofile("_Sub_CycCnt.lua")

	while 1 do
		Output_List() ;
		FCEU.frameadvance() ;
	end
