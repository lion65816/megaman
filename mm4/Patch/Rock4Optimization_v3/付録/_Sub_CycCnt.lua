
local OutTable = {} ;
local DestPos = 0 ;

local NextAddrL = DestTable[0] ;
local NextAddr  = AND(NextAddrL,0xFFFF) ;
local Cycle = 0 ;
local CycleT = 0 ;

--By FCEUX src file
	local CPUCycleTable = {
[0]=
7,6,2,8, 3,3,5,5, 3,2,2,2, 4,4,6,6,
2,5,2,8, 4,4,6,6, 2,4,2,7, 4,4,7,7,
6,6,2,8, 3,3,5,5, 4,2,2,2, 4,4,6,6,
2,5,2,8, 4,4,6,6, 2,4,2,7, 4,4,7,7,

6,6,2,8, 3,3,5,5, 3,2,2,2, 3,4,6,6,
2,5,2,8, 4,4,6,6, 2,4,2,7, 4,4,7,7,
6,6,2,8, 3,3,5,5, 4,2,2,2, 5,4,6,6,
2,5,2,8, 4,4,6,6, 2,4,2,7, 4,4,7,7,

2,6,2,6, 3,3,3,3, 2,2,2,2, 4,4,4,4,
2,6,2,6, 4,4,4,4, 2,5,2,5, 5,5,5,5,
2,6,2,6, 3,3,3,3, 2,2,2,2, 4,4,4,4,
2,5,2,5, 4,4,4,4, 2,4,2,4, 4,4,4,4,

2,6,2,8, 3,3,5,5, 2,2,2,2, 4,4,6,6,
2,5,2,8, 4,4,6,6, 2,4,2,7, 4,4,7,7,
2,6,3,8, 3,3,5,5, 2,2,2,2, 4,4,6,6,
2,5,2,8, 4,4,6,6, 2,4,2,7, 4,4,7,7,
	} ;


local function ABXX(addr)
	local iOpr = memory.readbyte( addr+1 ) ;
	if( iOpr>=0x80 )then
		iOpr = -(XOR(iOpr,0xFF)+1) ;
	end --if
	if( XOR(AND(addr+2,0xFFFF),AND(addr+iOpr+2,0xFFFF)) >= 0x0100 )then
		return 2 ;
	end --if
	return 1 ;
end --function
local function ABPL(addr)
	if( AND(memory.getregister("p"),0x80) == 0 )then
		return ABXX(addr) ;
	end --if
	return 0 ;
end --function
local function ABMI(addr)
	if( AND(memory.getregister("p"),0x80) ~= 0 )then
		return ABXX(addr) ;
	end --if
	return 0 ;
end --function
local function ABVC(addr)
	if( AND(memory.getregister("p"),0x40) == 0 )then
		return ABXX(addr) ;
	end --if
	return 0 ;
end --function
local function ABVS(addr)
	if( AND(memory.getregister("p"),0x40) ~= 0 )then
		return ABXX(addr) ;
	end --if
	return 0 ;
end --function
local function ABCC(addr)
	if( AND(memory.getregister("p"),0x01) == 0 )then
		return ABXX(addr) ;
	end --if
	return 0 ;
end --function
local function ABCS(addr)
	if( AND(memory.getregister("p"),0x01) ~= 0 )then
		return ABXX(addr) ;
	end --if
	return 0 ;
end --function
local function ABNE(addr)
	if( AND(memory.getregister("p"),0x02) == 0 )then
		return ABXX(addr) ;
	end --if
	return 0 ;
end --function
local function ABEQ(addr)
	if( AND(memory.getregister("p"),0x02) ~= 0 )then
		return ABXX(addr) ;
	end --if
	return 0 ;
end --function
local function AABX(addr)
	local iTmp = memory.readbyte( addr+1 ) + memory.readbyte( addr+2 )*256 ;
	if( XOR(iTmp,AND(iTmp+memory.getregister("x"),0xFFFF)) >= 0x0100 )then
		return 1 ;
	end --if
	return 0 ;
end --function
local function AABY(addr)
	local iTmp = memory.readbyte( addr+1 ) + memory.readbyte( addr+2 )*256 ;
	if( XOR(iTmp,AND(iTmp+memory.getregister("y"),0xFFFF)) >= 0x0100 )then
		return 1 ;
	end --if
	return 0 ;
end --function

local function AIDY(addr)
	local iTmp = memory.readbyte( addr+1 ) ;
	iTmp = memory.readbyte( iTmp ) + memory.readbyte( iTmp+1 )*256 ;
	if( XOR(iTmp,AND(iTmp+memory.getregister("y"),0xFFFF)) >= 0x0100 )then
		return 1 ;
	end --if
	return 0 ;
end --function

--[[
		print(
		string.format(
		"%04X",addr
		 ) );
--]]
	local AdditionalCycleTable = {
[0]=
nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil ,
ABPL,AIDY,nil ,nil , nil ,nil ,nil ,nil , nil ,AABY,nil ,nil , nil ,AABX,nil ,nil ,
nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil ,
ABMI,AIDY,nil ,nil , nil ,nil ,nil ,nil , nil ,AABY,nil ,nil , nil ,AABX,nil ,nil ,

nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil ,
ABVC,AIDY,nil ,nil , nil ,nil ,nil ,nil , nil ,AABY,nil ,nil , nil ,AABX,nil ,nil ,
nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil ,
ABVS,AIDY,nil ,nil , nil ,nil ,nil ,nil , nil ,AABY,nil ,nil , nil ,AABX,nil ,nil ,

nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil ,
ABCC,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil ,
nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil ,
ABCS,AIDY,nil ,nil , nil ,nil ,nil ,nil , nil ,AABY,nil ,nil , AABX,AABX,AABY,nil ,

nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil ,
ABNE,AIDY,nil ,nil , nil ,nil ,nil ,nil , nil ,AABY,nil ,nil , nil ,AABX,nil ,nil ,
nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil , nil ,nil ,nil ,nil ,
ABEQ,AIDY,nil ,nil , nil ,nil ,nil ,nil , nil ,AABY,nil ,nil , nil ,AABX,nil ,nil ,
	} ;

local function MainFunction(addr,size)
	local iOp = memory.readbyte( addr ) ;
	local iCurCycle = CPUCycleTable[iOp] ;
	if( AdditionalCycleTable[iOp] ) then
		iCurCycle = iCurCycle + AdditionalCycleTable[iOp](addr) ;
	end --if
	Cycle = Cycle + iCurCycle ;
	CycleT = CycleT + iCurCycle ;
	if( addr ~= NextAddr ) then
		return ;
	end --if

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

	OutTable[math.floor(DestPos/4)-1] = Cycle - iCurCycle ;
	Cycle = iCurCycle ;

	DestPos = DestPos + 4 ;
	if( DestTable[DestPos] == 0xFFFFFF ) then
		OutTable[math.floor(DestPos/4)-1] = OutTable[-1] ;
		OutTable[-1] = nil ;
		DestPos = 0 ;
	end --if
	NextAddrL = DestTable[DestPos] ;
	NextAddr  = AND(NextAddrL,0xFFFF) ;

end --function

local function SPRDMA()
	Cycle = Cycle + 512 ;
	CycleT = CycleT + 512 ;
end --function
local function Interrupt(addr,size)
	Cycle = Cycle + 7 ;
	CycleT = CycleT + 7 ;
	MainFunction(addr,size) ;
end --function
	memory.registerexec( 0x0000 , 0x10000 , MainFunction ) ;
	memory.registerwrite( 0x4014 , 0x0001 , SPRDMA ) ;
	local iTmpAddr = memory.readbyte( 0xFFFE ) + memory.readbyte( 0xFFFF )*256 ;
	memory.registerexec( iTmpAddr , 0x0001 , Interrupt ) ;
	local iTmpAddr = memory.readbyte( 0xFFFA ) + memory.readbyte( 0xFFFB )*256 ;
	memory.registerexec( iTmpAddr , 0x0001 , Interrupt ) ;

--表示用関数１　リスト表示
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
	gui.text( tx, ty , "Total2:" .. CycleT ) ;
	CycleT = 0;
end --function

--表示用関数２　「だいたい」スキャン（ライン）位置表示
--あまり有益なことはないが、気になる方は、
--Output_Listではなくこちらを呼んでみるようにしても良いかも。
function Output_Line()
	local TotalCycle = 0 ;
	local iCnt ;
	for iCnt=0,99,1 do
		local iTmp = OutTable[iCnt] ;
		if( not iTmp )then
			break ;
		end --if
		TotalCycle = TotalCycle+iTmp ;
		label = DestTable[iCnt*4+1] ;
		if( label ~= "" )then
			gui.text( iCnt%8*25, math.floor(TotalCycle*3/341-21), label ) ;
		end --if
	end --for
	CycleT = 0;
end --function

