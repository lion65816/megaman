--[[
����Lua����Ăяo�����ėp�I�Ȋ֐��B

--]]

--[[
�ȉ��̊���̊֐��́A����ɉ��̊֐�����Ăяo�����Ƃ�z�肳��Ă���B
--]]
function GetTerrainCollision(ix,iy) --{
	local iTmp = getterrain(ix,iy)
	if not iTmp then return nil end
	return math.floor(iTmp/16)
end --}
function SetShiftPosition(ix,iy,dx,dy,bOut) --{
	if bOut==false then return ix,iy end
	local tx,ty

	tx = ix+dx
	if tx<0 then tx=0 end

	ty = iy+dy
	if math.floor(ty/16) ~= math.floor(iy/16) then
		if dy<0 then
			ty=math.floor(iy/16)*16+0
		else
			ty=math.floor(iy/16)*16+15
		end
	end
	return tx,ty
end --}

local function ContCond_DestTbl(val,ix,iy) --{
	return val[gettile(ix,iy)] ~= nil
end --}
local function ContCond_DestCollsion(val,ix,iy) --{
	return GetTerrainCollision(ix,iy)==val
end --}


--[[
�����Eor�㉺�̂Q�����Ƃ̌q������l�������␳
Correct2WayH(tDest,tPat,bOut)
Correct2WayH_c(tDest,tPat,bOut,iTerrain)
Correct2WayV(tDest,tPat,bOut)
Correct2WayV_c(tDest,tPat,bOut,iTerrain)

tDest:�␳�ΏۂƂ���^�C���ԍ�
tPat:�␳��̃^�C���ԍ�
bOut:bool:�ׂ���ʊO�ł��鎞�ɁA��ʓ��̋ߖT�ʒu�ɕ␳���邩
iTerrain:�A�����Ă��鈵���Ƃ��铖���蔻��ԍ�

H�����E�̒[��␳�AV���㉺�̒[��␳�B���Ȃǂ̉��ɐL�т����̂�V�B
tPat�e�[�u���͉��ʂ��獶�Eor�㉺�̏��ԂɃr�b�g�ɂȂ��Ă��܂��B
[�E��][����]
������Lua�̎d�l�I�ɁA�Y���͂����+1����܂��B
--]]


local function Correct2WayH_sub(tDest,tPat,bOut,fCont,ContVal) --{
	local x0,y0,x1,y1 = getselectedrect()
	for ix=x0,x1,1 do --{
	for iy=y0,y1,1 do --{
		if tDest[gettile(ix,iy)] then --{
			local iN=0
			local tx,ty
			tx,ty = SetShiftPosition(ix,iy,-1,0,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,1) end
			tx,ty = SetShiftPosition(ix,iy,1,0,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,2) end
			iN = tPat[iN+1]
			if iN then settile(ix,iy,iN) end
		end --}
	end --}
	end --}
end --}
local function Correct2WayV_sub(tDest,tPat,bOut,fCont,ContVal) --{
	local x0,y0,x1,y1 = getselectedrect()
	for ix=x0,x1,1 do --{
	for iy=y0,y1,1 do --{
		if tDest[gettile(ix,iy)] then --{
			local iN=0
			local tx,ty
			tx,ty = SetShiftPosition(ix,iy,0,-1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,1) end
			tx,ty = SetShiftPosition(ix,iy,0,1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,2) end
			iN = tPat[iN+1]
			if iN then settile(ix,iy,iN) end
		end --}
	end --}
	end --}
end --}


function Correct2WayH(tDest,tPat,bOut) --{
	Correct2WayH_sub(tDest,tPat,bOut,ContCond_DestTbl,tDest)
end --}

function Correct2WayH_c(tDest,tPat,bOut,iTerrain) --{
	Correct2WayH_sub(tDest,tPat,bOut,ContCond_DestCollsion,iTerrain)
end --}
function Correct2WayV(tDest,tPat,bOut) --{
	Correct2WayV_sub(tDest,tPat,bOut,ContCond_DestTbl,tDest)
end --}

function Correct2WayV_c(tDest,tPat,bOut,iTerrain) --{
	Correct2WayV_sub(tDest,tPat,bOut,ContCond_DestCollsion,iTerrain)
end --}

--[[
�����E�㉺�̂S�����Ƃ̌q������l�������␳
Correct4Way(tDest,tPat,bOut)
Correct4Way_c(tDest,tPat,bOut,iTerrain)

tDest:�␳�ΏۂƂ���^�C���ԍ�
tPat:�␳��̃^�C���ԍ�
bOut:bool:�ׂ���ʊO�ł��鎞�ɁA��ʓ��̋ߖT�ʒu�ɕ␳���邩
iTerrain:�A�����Ă��鈵���Ƃ��铖���蔻��ԍ�

tPat�e�[�u���͉��ʂ��獶�E�㉺�̏��ԂɃr�b�g�ɂȂ��Ă��܂��B
[����E��]
������Lua�̎d�l�I�ɁA�Y���͂����+1����܂��B
--]]

local function Correct4Way_sub(tDest,tPat,bOut,fCont,ContVal) --{
	local x0,y0,x1,y1 = getselectedrect()
	for ix=x0,x1,1 do --{
	for iy=y0,y1,1 do --{
		if tDest[gettile(ix,iy)] then --{
			local iN=0
			local tx,ty
			tx,ty = SetShiftPosition(ix,iy,-1,0,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,1) end
			tx,ty = SetShiftPosition(ix,iy,1,0,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,2) end
			tx,ty = SetShiftPosition(ix,iy,0,-1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,4) end
			tx,ty = SetShiftPosition(ix,iy,0,1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,8) end
			iN = tPat[iN+1]
			if iN then settile(ix,iy,iN) end
		end --}
	end --}
	end --}
end --}


function Correct4Way(tDest,tPat,bOut) --{
	Correct4Way_sub(tDest,tPat,bOut,ContCond_DestTbl,tDest)
end --}

function Correct4Way_c(tDest,tPat,bOut,iTerrain) --{
	Correct4Way_sub(tDest,tPat,bOut,ContCond_DestCollsion,iTerrain)
end --}


--[[
�����E�㉺�Ǝ΂߂̂W�����Ƃ̌q������l�������␳
Correct8Way(tDest,tPat,bOut)
Correct8Way_c(tDest,tPat,bOut,iTerrain)

tDest:�␳�ΏۂƂ���^�C���ԍ�
tPat:�␳��̃^�C���ԍ�
bOut:bool:�ׂ���ʊO�ł��鎞�ɁA��ʓ��̋ߖT�ʒu�ɕ␳���邩
iTerrain:�A�����Ă��鈵���Ƃ��铖���蔻��ԍ�

tPat�e�[�u���͉��ʂ���
���E�㉺(10�E��)(20�E��)(40����)(80����)�̏��ԂɃr�b�g�ɂȂ��Ă��܂��B
������Lua�̎d�l�I�ɁA�Y���͂����+1����܂��B
4way�̏��ԂɁA���v���Ɏ΂߂̕�����ǉ������`�ł��B
�S�Ẵe�[�u������邱�Ƃ͌����I�ł͂Ȃ��̂�
�K�v�Ȃ��̂����w�肵�Ďc���nil�Ƃ����e�[�u����n�����ƂɂȂ�܂��B
--]]

local function Correct8Way_sub(tDest,tPat,bOut,fCont,ContVal) --{
	local x0,y0,x1,y1 = getselectedrect()
	for ix=x0,x1,1 do --{
	for iy=y0,y1,1 do --{
		if tDest[gettile(ix,iy)] then --{
			local iN=0
			local tx,ty
			tx,ty = SetShiftPosition(ix,iy,-1,0,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,1) end
			tx,ty = SetShiftPosition(ix,iy,1,0,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,2) end
			tx,ty = SetShiftPosition(ix,iy,0,-1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,4) end
			tx,ty = SetShiftPosition(ix,iy,0,1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,8) end
			tx,ty = SetShiftPosition(ix,iy,1,-1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,0x10) end
			tx,ty = SetShiftPosition(ix,iy,1,1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,0x20) end
			tx,ty = SetShiftPosition(ix,iy,-1,1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,0x40) end
			tx,ty = SetShiftPosition(ix,iy,-1,-1,bOut)
			if fCont(ContVal,tx,ty)==true then iN=OR(iN,0x80) end
			iN = tPat[iN+1]
			if iN then settile(ix,iy,iN) end
		end --}
	end --}
	end --}
end --}
function Correct8Way(tDest,tPat,bOut) --{
	Correct8Way_sub(tDest,tPat,bOut,ContCond_DestTbl,tDest)
end --}
function Correct8Way_c(tDest,tPat,bOut,iTerrain) --{
	Correct8Way_sub(tDest,tPat,bOut,ContCond_DestCollsion,iTerrain)
end --}

--[[
�������I�ɕ��񂾃^�C���ɕ␳
CorrectCyclicTile(tDest,tPat,xf,yf)

tDest:�␳�ΏۂƂ���^�C���ԍ�
tPat:�␳��̃^�C���ԍ�/[1]����n�܂�z��ŁA���̔z��T�C�Y�Ŏ����I�ɕ��ׂ�
xf:x���W�Ɋ|����l
yf:y���W�Ɋ|����l
xr:x���W�ɏ�]���Z����l
yr:y���W�ɏ�]���Z����l
--]]

function CorrectCyclicTile(tDest,tPat,xf,yf,xr,yr) --{
	if not xr then xr=65536 end
	if not yr then yr=65536 end
	local x0,y0,x1,y1 = getselectedrect()
	for ix=x0,x1,1 do --{
	for iy=y0,y1,1 do --{
		if tDest[gettile(ix,iy)] then --{
			local i=(ix%xr)*xf+(iy%yr)*yf
			local iT=tPat[1+i%#tPat]
			settile(ix,iy,iT)
		end --}
	end --}
	end --}
end --}


--[[
���ʒu�������Ƃ��A����̃^�C�����A�ʂ̓���̃^�C���ɒu��������
SwitchTileByPosition(tDestPat,fCond)

tDestPat:�␳�ΏۂƂ���^�C���ԍ��ƕ␳��̃^�C���ԍ�
fCond:(ix,iy)�i���W�j�������Ƃ��Abool��Ԃ��֐�

���W�������Ƃ���bool��Ԃ��֐���true��Ԃ�������
tDestPat�̒l�ɉ����Ēu�����������s����B
--]]

function SwitchTileByPosition(tDestPat,fCond) --{
	local x0,y0,x1,y1 = getselectedrect()
	for ix=x0,x1,1 do --{
	for iy=y0,y1,1 do --{
		if tDestPat[gettile(ix,iy)] and fCond(ix,iy)==true then --{
			settile(ix,iy,tDestPat[gettile(ix,iy)])
		end --}
	end --}
	end --}
end --}


--[[
���\�ʂ𕢂��悤�Ȕz�u
CorrectSurface(tDest,tPat,bOut)
CorrectSurface_c(tDest,tPat,bOut,iTerrain)

tDest:�␳�ΏۂƂ���^�C���ԍ�
tPat:�␳�p�^�[��
bOut:bool:�ׂ���ʊO�ł��鎞�ɁA��ʓ��̋ߖT�ʒu�ɕ␳���邩
iTerrain:�A�����Ă��鈵���Ƃ��铖���蔻��ԍ�

�␳�p�^�[����[1]����[20]�܂ŁA�ȉ����Ԃɐݒ肷��B
[����][�E��][�����][�E���][��[][���[  ][�E�[  ][����  ]
[����][�E��][������][�E����][���[][�㉺��][���E��][���͖�]
[���][����][����  ][�E��  ]

[����]�́A�ǂ̍���ɑ�������^�C���ԍ��B
[�����]�́A�ǂ̊p�̕����̓����ŁA���͂W�����̂������ゾ�����󂢂��^�C���ԍ��B
[���[]�́A�ǂ̍��̑��ʂɑ�������^�C���ԍ��B
[�㉺��]�́A�㉺���󂢂����ɒ��������̃^�C���ԍ��B
[����]�́A�W�����S�Ăɕǂ̂��镔���B
[���͖�]�́A�W�����S�Ăɕǂ̂Ȃ��P�Ƃő��݂��Ă��镔���B
[���]�́A�S�����̂����A�������q�����Ă��Ȃ��A��ɓ˂��o�������ł���B
nil���w�肷�邱��(���邢�͉����w�肵�Ȃ�����)���\�ŁA
���̏ꍇ�͓��Y�^�C���͏����ς��Ȃ��B
�܂��A�l�Ƃ���00���w�肷���nil���w�肵���̂Ɠ��������ɂȂ�B

���̃p�^�[���́Atool_MakeTileTable.lua�𗘗p����Ɨe�Ղɍ쐬�ł���B
�܂�A8x3�ɏ�̐}�̒ʂ�Ƀ^�C����z�u������A
���͈̔͂�I�����Atool_MakeTileTable.lua�����s����Ηǂ��B

--]]

local function CorrectSurface_sub(tDest,tPat,bOut,fCont,ContVal) --{
	for i=1,20,1 do --{
		if tPat[i]==0 then tPat[i]=nil end
	end --}
	if not tPat[17] then tPat[17]=tPat[15] end
	if not tPat[18] then tPat[18]=tPat[15] end
	if not tPat[19] then tPat[19]=tPat[14] end
	if not tPat[20] then tPat[20]=tPat[14] end

	local tTbl1 =
{
tPat[16],tPat[20],tPat[19],tPat[14],
tPat[18],tPat[10],tPat[ 9],tPat[13],
tPat[17],tPat[2],tPat[1],tPat[5],
tPat[15],tPat[7],tPat[6],tPat[8],
}
	local tTbl2 =
{
[0xFF-0x10+1]=tPat[ 4],
[0xFF-0x20+1]=tPat[12],
[0xFF-0x40+1]=tPat[11],
[0xFF-0x80+1]=tPat[ 3],
}
	Correct4Way_sub(tDest,tTbl1,bOut,fCont,ContVal)
	Correct8Way_sub(tDest,tTbl2,bOut,fCont,ContVal)
end --}
function CorrectSurface(tDest,tPat,bOut) --{
	CorrectSurface_sub(tDest,tPat,bOut,ContCond_DestTbl,tDest)
end --}
function CorrectSurface_c(tDest,tPat,bOut,iTerrain) --{
	CorrectSurface_sub(tDest,tPat,bOut,ContCond_DestCollsion,iTerrain)
end --}
