
DestTable =
{[0]=
	0x1EC000 , "NMI" , "" , "" ,
	0x1EC105 , "-" , "" , "" ,
	0x1EC139 , "Audio" , "" , "" ,
	0x1EC13C , "WaitLoopLoss" , "" , "" ,
	0x1FFEC3 , "ThreadStart" , "" , "" ,
	0x1FFF68 , "F-Wait" , "" , "" ,
	0x1ECA73 , "Pause" , "" , "" ,
	0x1ECAB5 , "Rockman" , "" , "" ,
	0x1ECAD7 , "Scrolling" , "" , "" ,
	0x1ECB0A , "ObjProc" , "" , "" ,
	0x1C8014 , "Obj1" , "" , "" ,
	0x1C8014 , "Obj2" , "" , "" ,
	0x1C8014 , "Obj3" , "" , "" ,
	0x1C8014 , "Obj4" , "" , "" ,
	0x1C8014 , "Obj5" , "" , "" ,
	0x1C8014 , "Obj6" , "" , "" ,
	0x1C8014 , "Obj7" , "" , "" ,
	0x1C8014 , "Obj8" , "" , "" ,
	0x1C8014 , "Obj9" , "" , "" ,
	0x1C8014 , "ObjA" , "" , "" ,
	0x1C8014 , "ObjB" , "" , "" ,
	0x1C8014 , "ObjC" , "" , "" ,
	0x1C8014 , "ObjD" , "" , "" ,
	0x1C8014 , "ObjE" , "" , "" ,
	0x1C8014 , "ObjF" , "" , "" ,
	0x1C8014 , "Ob10" , "" , "" ,
	0x1C8014 , "Ob11" , "" , "" ,
	0x1C8014 , "Ob12" , "" , "" ,
	0x1C8014 , "Ob13" , "" , "" ,
	0x1C8014 , "Ob14" , "" , "" ,
	0x1C8014 , "Ob15" , "" , "" ,
	0x1C8014 , "Ob16" , "" , "" ,
	0x1C8014 , "Ob17" , "" , "" ,
	0x1C8014 , "Ob18" , "" , "" ,
	0x1C8014 , "Ob19" , "" , "" ,
	0x1C8014 , "Ob1A" , "" , "" ,
	0x1C8014 , "Ob1B" , "" , "" ,
	0x1C8014 , "Ob1C" , "" , "" ,
	0x1C8014 , "Ob1D" , "" , "" ,
	0x1C8014 , "Ob1E" , "" , "" ,
	0x1C8014 , "Ob1F" , "" , "" ,
	0x1C8096 , "-" , "" , "" ,
	0x1ECB0D , "PlaceObj" , "" , "" ,
	0x1ECB1B , "B-Block" , "" , "" ,
	0x1ECB25 , "PlaceBRushC" , "" , "" ,
	0x1ECB28 , "PalAni" , "" , "" ,
	0x1ECB2B , "SnakeMBoss" , "" , "" ,
	0x1ECB2E , "BluesWall" , "" , "" ,
	0x1ECB31 , "W3Lift" , "" , "" ,
	0x1ECB34 , "Ndl2MBoss" , "" , "" ,
	0x1ECB37 , "DarkenPal" , "" , "" ,
	0x1ECB3A , "-" , "" , "" ,
	0x1FFF57 , "ClearSpr" , "" , "" ,
	0x1FFF5E , "Sprite" , "" , "" ,
	0x1FFF61 , "-" , "" , "" ,
	0x1FFF65 , "P-Wait" , "" , "" ,
	0xFFFFFF , "END"
} ;





AddrPrg8  = 0xF4 ;
AddrPrgA  = 0xF5 ;
AddrPrgCf = 0x1E0000 ;
DPrgVal8  = 0 ;
DPrgValA  = 0 ;
PrgvalMul = 1 ;



	dofile("_Sub_CycCnt.lua")

	while 1 do
		Output_List() ;
		FCEU.frameadvance() ;
	end
