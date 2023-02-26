local tLog = {} ;
local tLogC = {} ;
local cMaxLog = 256 ;

local iState = 0 ;

local function NMI(addr,size)
	for iCnt=cMaxLog-1,1,-1 do
		tLog[iCnt] = tLog[iCnt-1] ;
	end --for
	if ( iState == 1 ) then
		tLog[0] = debugger.getcyclescount() ;
		iState = 0 ;
	else
		tLog[0] = 0 ;
	end --if
end --function
	local iTmpAddr = memory.readbyte( 0xFFFA ) + memory.readbyte( 0xFFFB )*256 ;
	memory.registerexec( iTmpAddr , 0x0001 , NMI ) ;

local function ProcEnd(addr,size)
	iState = 1 ;
	debugger.resetcyclescount() ;
end --function

function Draw()
	for iCnt=0,cMaxLog-1,1 do
		if( tLog[iCnt] )then
			local Color = "green" ;
			if( tLog[iCnt+1]==0 )then Color = "red" ; end
			gui.box(255-iCnt,239-tLog[iCnt]/500,255-iCnt,239,Color);
		end --if
	end --for
	if( tLog[0] )then
		gui.text(226,233,string.format("%5d",tLog[0]));
	end --if
end --function

	memory.registerexec( cAddrFrameEnd , 0x0001 , ProcEnd ) ;
	debugger.resetcyclescount() ;

