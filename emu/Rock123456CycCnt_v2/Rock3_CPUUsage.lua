
	cAddrFrameEnd = 0xFF65 ;

	dofile("_Sub_CPUUsage.lua") ;

	while 1 do
		Draw() ;
		FCEU.frameadvance() ;
	end
