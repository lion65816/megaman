
DestTable =
{[0]=
	0x3EC000 , "NMI" , "" , "" ,
	0x3EC0A9 , "Audio+" , "" , "" ,
--	0x3EC0B4 , "Audio" , "" , "" ,
	0x3EC0B7 , "Random" , "" , "" ,
	0x3EC0BA , "--" , "" , "" ,
	0x3ECD5D , "F-Wait" , "" , "" ,
	0x3ECD4C , "PlaceObj" , "" , "" ,
	0x3FE43C , "O16" , "" , "" ,
	0x3FE43C , "O15" , "" , "" ,
	0x3FE43C , "O14" , "" , "" ,
	0x3FE43C , "O13" , "" , "" ,
	0x3FE43C , "O12" , "" , "" ,
	0x3FE43C , "O11" , "" , "" ,
	0x3FE43C , "O10" , "" , "" ,
	0x3FE43C , "OF" , "" , "" ,
	0x3FE43C , "OE" , "" , "" ,
	0x3FE43C , "OD" , "" , "" ,
	0x3FE43C , "OC" , "" , "" ,
	0x3FE43C , "OB" , "" , "" ,
	0x3FE43C , "OA" , "" , "" ,
	0x3FE43C , "O9" , "" , "" ,
	0x3FE43C , "O8" , "" , "" ,
	0x3FE43C , "O7" , "" , "" ,
	0x3FE43C , "O6" , "" , "" ,
	0x3FE43C , "O5" , "" , "" ,
	0x3FE43C , "O4" , "" , "" ,
	0x3FE43C , "O3" , "" , "" ,
	0x3FE43C , "O2" , "" , "" ,
	0x3FE43C , "O1" , "" , "" ,
	0x3FE43C , "O0" , "" , "" ,
	0x3FE482 , "--" , "" , "" ,
	0x3ECD53 , "Sprite" , "" , "" ,
	0x3ECD56 , "SetupPT" , "" , "" ,
	0x3ECD5A , "P-Wait" , "" , "" ,
	0xFFFFFF , "END"
} ;

AddrPrg8  = 0x4A ;
AddrPrgA  = 0x4B ;
AddrPrgCf = 0x3E0000 ;
DPrgVal8  = 0 ;
DPrgValA  = 0 ;
PrgvalMul = 1 ;



	dofile("_Sub_CycCnt.lua")

	while 1 do
		Output_List() ;
		FCEU.frameadvance() ;
	end
