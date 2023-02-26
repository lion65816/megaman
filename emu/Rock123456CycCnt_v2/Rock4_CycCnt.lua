
DestTable =
{[0]=
	0x3EC000 , "NMI" , "" , "" ,
	0x3EC10B , "-" , "" , "" ,
	0x3EC13F , "Audio" , "" , "" ,
	0x3EC142 , "-" , "" , "" ,
	0x3EC7C9 , "F-Wait" , "" , "" ,
	0x3EC6F3 , "StartML" , "" , "" ,
	0x3EC707 , "Pause" , "" , "" ,
	0x3EC740 , "Rockman" , "" , "" ,
	0x3EC74D , "-" , "" , "" ,
	0x3A8018 , "Obj1" , "" , "" ,
	0x3A8018 , "Obj2" , "" , "" ,
	0x3A8018 , "Obj3" , "" , "" ,
	0x3A8018 , "Obj4" , "" , "" ,
	0x3A8018 , "Obj5" , "" , "" ,
	0x3A8018 , "Obj6" , "" , "" ,
	0x3A8018 , "Obj7" , "" , "" ,
	0x3A8018 , "Obj8" , "" , "" ,
	0x3A8018 , "Obj9" , "" , "" ,
	0x3A8018 , "ObjA" , "" , "" ,
	0x3A8018 , "ObjB" , "" , "" ,
	0x3A8018 , "ObjC" , "" , "" ,
	0x3A8018 , "ObjD" , "" , "" ,
	0x3A8018 , "ObjE" , "" , "" ,
	0x3A8018 , "ObjF" , "" , "" ,
	0x3A8018 , "Ob10" , "" , "" ,
	0x3A8018 , "Ob11" , "" , "" ,
	0x3A8018 , "Ob12" , "" , "" ,
	0x3A8018 , "Ob13" , "" , "" ,
	0x3A8018 , "Ob14" , "" , "" ,
	0x3A8018 , "Ob15" , "" , "" ,
	0x3A8018 , "Ob16" , "" , "" ,
	0x3A8018 , "Ob17" , "" , "" ,
	0x3A805A , "WDeath" , "" , "" ,
	0x3EC75A , "Scroll" , "" , "" ,
	0x3EC766 , "PlaceObj" , "" , "" ,
	0x3EC776 , "Draw16" , "" , "" ,
	0x3EC779 , "DrawBackNT" , "" , "" ,
	0x3EC77C , "Draw32" , "" , "" ,
	0x3EC77F , "BrightDark" , "" , "" ,
	0x3EC782 , "DrillFloor" , "" , "" ,
	0x3EC785 , "DustWall" , "" , "" ,
	0x3EC788 , "--" , "" , "" ,
	0x3EC792 , "CheckPoint" , "" , "" ,
	0x3EC7B4 , "ClearSpr" , "" , "" ,
	0x3EDB3A , "Spr" , "" , "" ,
	0x3EC7BE , "--" , "" , "" ,
	0x3EC7C6 , "P-Wait" , "" , "" ,
	0xFFFFFF , "END"
} ;

AddrPrg8  = 0xF3 ;
AddrPrgA  = 0xF4 ;
AddrPrgCf = 0x3E0000 ;
DPrgVal8  = 0 ;
DPrgValA  = 0 ;
PrgvalMul = 1 ;



	dofile("_Sub_CycCnt.lua")

	while 1 do
		Output_List() ;
		FCEU.frameadvance() ;
	end
