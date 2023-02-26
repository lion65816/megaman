
	cAddrFrameEnd = 0xC08C ;

	dofile("_Sub_CPUUsage.lua") ;

	while 1 do
		Draw() ;
		FCEU.frameadvance() ;
	end
