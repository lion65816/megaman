local Cycle = 0 ;
local CycleT = 0 ;


local tPCLog = {} ;
local tCycLog = {} ;
local iPCLogSize = 1 ;
local iPCLogOffset = 0 ;
local iProbable = 0 ;
local iProbablePC = 0 ;
local iPrevIRQCycle = 0 ;
--local iNoDetectionFrames = 100 ;

local cMaxCycLog = 256 ; --何フレーム分の記録を行うか
local cMaxNullLoop = 64 ; --処理待ちループの最大命令数
local cMaxProbableFrames = 10 ; --正常実行できているらしいフレーム数の最大値
local cResetProbableFrames = 3 ; --正常に実行できていなそうなとき、次の命令数を試すフレーム数

local function ProcNMI()
--[[
	if( CycleT==0 )then
		iNoDetectionFrames = iNoDetectionFrames + 1 ;
		if( iNoDetectionFrames >= 5 )then
			iPCLogSize = iPCLogSize + 1 ;
			if( iPCLogSize >= cMaxNullLoop )then iPCLogSize = 1 ; end
		end --if
	else
		iNoDetectionFrames = 0 ;
	end --if
--]]
	if( CycleT > 0 )then
		CycleT = CycleT + iPrevIRQCycle ;
	end --if
	for iCnt=cMaxCycLog-1,1,-1 do
		tCycLog[iCnt] = tCycLog[iCnt-1] ;
	end --for
	tCycLog[0] = CycleT ;
	if( CycleT >= iPCLogSize*2*5 )then
		iProbable = math.min(iProbable+1,cMaxProbableFrames) ;
		iProbablePC = tPCLog[0] ;
	else
		iProbable = math.max(iProbable-1,0) ;
		if( iProbable == 0 )then
			iPCLogSize = iPCLogSize + 1 ;
			if( iPCLogSize >= cMaxNullLoop )then iPCLogSize = 1 ; end
			iProbable = cResetProbableFrames ;
			iProbablePC = -1 ;
		end --if
	end --if
	CycleT = 0 ;
	iPrevIRQCycle = 0 ;
end --function



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

local function MainFunction(add,size)
	local iOp = memory.readbyte( add ) ;
	local iCurCycle = CPUCycleTable[iOp] ;


	if( AdditionalCycleTable[iOp] ) then
		iCurCycle = iCurCycle + AdditionalCycleTable[iOp](add) ;
	end --if
	CycleT = CycleT + iCurCycle ;


	local iPC = memory.getregister("pc") ;
	if( tPCLog[iPCLogOffset%iPCLogSize]~=iPC )then
		if( CycleT >= iPCLogSize*2+7 and iProbable>=5 ) then
			--IRQ検出用
			for iCnt=0,iPCLogSize-1,1 do
				if( tPCLog[iCnt] == iProbablePC )then
					iPrevIRQCycle = iPrevIRQCycle + CycleT ;
					break ;
				end --if
			end --for
		end --if
		CycleT = 0 ;
	end --if
	tPCLog[iPCLogOffset%iPCLogSize]=iPC;
	iPCLogOffset = iPCLogOffset + 1 ;

end --function

local function SPRDMA()
	CycleT = CycleT + 512 ;
end --function
local function IRQ(addr,size)
	CycleT = CycleT + 7 ;
	MainFunction(addr,size) ;
end --function
local function NMI(addr,size)
	ProcNMI() ;
	CycleT = CycleT + 7 ;
	MainFunction(addr,size) ;
end --function
	memory.registerexec( 0x0000 , 0x10000 , MainFunction ) ;
	memory.registerwrite( 0x4014 , 0x0001 , SPRDMA ) ;
	local iTmpAddr = memory.readbyte( 0xFFFE ) + memory.readbyte( 0xFFFF )*256 ;
	memory.registerexec( iTmpAddr , 0x0001 , IRQ ) ;
	local iTmpAddr = memory.readbyte( 0xFFFA ) + memory.readbyte( 0xFFFB )*256 ;
	memory.registerexec( iTmpAddr , 0x0001 , NMI ) ;

	while 1 do

		for iCnt=0,cMaxCycLog-1,1 do
			if( tCycLog[iCnt] )then
				local Color = "green" ;
				if( tCycLog[iCnt+1]==0 )then Color = "red" ; end
				gui.box(255-iCnt,239-tCycLog[iCnt]/500,255-iCnt,239,Color);
			end --if
		end --for
		if( tCycLog[0] )then
			gui.text(226,233,string.format("%5d",tCycLog[0]));
		end --if
		if( iProbable ~= cMaxProbableFrames )then
			local iY ;
			iY = math.floor(iProbable/cMaxProbableFrames*240)
			gui.box( 0 , iY , 7 , iY+2 , "orange" ) ;
			gui.text( 7 , iY , iPCLogSize ) ;
		end --if
--[[
		for iCnt=0,iPCLogSize-1,1 do
			if( tPCLog[iCnt] )then
				gui.text(0,iCnt*7,string.format("%04X",tPCLog[iCnt]));
			end --if
		end --for
--]]
		FCEU.frameadvance() ;
	end
