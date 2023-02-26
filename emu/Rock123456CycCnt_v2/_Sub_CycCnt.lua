
local OutTable = {} ;
local DestPos = -4 ;

local NextAddrL ;
local iPrevREAddr = -1 ;

local pMainFunc = nil ;

local function SetupNext()
	DestPos = DestPos + 4 ;
	if( DestTable[DestPos] == 0xFFFFFF ) then
		OutTable[math.floor(DestPos/4)-1] = OutTable[-1] ;
		OutTable[-1] = nil ;
		DestPos = 0 ;
	end --if
	NextAddrL = DestTable[DestPos] ;
	if( iPrevREAddr~=-1 )then memory.registerexec( iPrevREAddr , 1 , nil ) ; end
	iPrevREAddr = AND(NextAddrL,0xFFFF) ;
	memory.registerexec( iPrevREAddr , 1 , pMainFunc ) ;
end --function
local function MainFunction(addr,size)
	local LongAddr ;
	if( addr < 0xA000 ) then
		LongAddr = OR( (memory.readbyte( AddrPrg8 )*PrgvalMul+DPrgVal8)*0x10000 , addr ) ;
	elseif( addr < 0xC000 ) then
		LongAddr = OR( (memory.readbyte( AddrPrgA )*PrgvalMul+DPrgValA)*0x10000 , addr ) ;
	elseif( addr < 0xE000 ) then
		LongAddr = OR( AddrPrgCf , addr ) ;
	else
		LongAddr = OR( AddrPrgCf+0x10000 , addr ) ;
	end --if
	if( LongAddr ~= NextAddrL ) then
		return ;
	end --if

	OutTable[math.floor(DestPos/4)-1] = debugger.getcyclescount() ;
	debugger.resetcyclescount() ;
	SetupNext() ;

end --function


	pMainFunc = MainFunction ;
	debugger.resetcyclescount() ;
	SetupNext() ;

function Output_List()
	local iCnt ;
	local ty = 0 ;
	local tx = 0 ;
	local iTotal = 0 ;
	for iCnt=0,99,1 do
		local tmp ;
		local label ;
		tmp = OutTable[iCnt] ;
		if( not tmp )then
			break ;
		end --if
		iTotal = iTotal + tmp ;
		label = DestTable[iCnt*4+1] ;
		if( label ~= "" )then
			gui.text( tx, ty , label .. ":" .. tmp .. "(" .. math.floor(tmp*3/341) ) ;
			if( iCnt==DestPos/4 ) then
				gui.box( tx, ty , tx+1 , ty+8 , "orange" ) ;
			end --if
			ty = ty + 8 ;
			if( ty >= 220 ) then
				ty = 0 ;
				tx = tx + 180 ;
			end --if
		end --if
	end --for
	ty = ty + 8 ;
	gui.text( tx, ty , "Total:" .. iTotal ) ;
	ty = ty + 8 ;
end --function

