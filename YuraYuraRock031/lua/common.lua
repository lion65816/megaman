--[[
他のLuaから呼び出される汎用的な関数。

--]]

--[[
以下の幾つかの関数は、さらに下の関数から呼び出すことを想定されている。
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
●左右or上下の２方向との繋がりを考慮した補正
Correct2WayH(tDest,tPat,bOut)
Correct2WayH_c(tDest,tPat,bOut,iTerrain)
Correct2WayV(tDest,tPat,bOut)
Correct2WayV_c(tDest,tPat,bOut,iTerrain)

tDest:補正対象とするタイル番号
tPat:補正後のタイル番号
bOut:bool:隣が画面外である時に、画面内の近傍位置に補正するか
iTerrain:連結している扱いとする当たり判定番号

Hが左右の端を補正、Vが上下の端を補正。床などの横に伸びたものはV。
tPatテーブルは下位から左右or上下の順番にビットになっています。
[右左][下上]
ただしLuaの仕様的に、添字はさらに+1されます。
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
●左右上下の４方向との繋がりを考慮した補正
Correct4Way(tDest,tPat,bOut)
Correct4Way_c(tDest,tPat,bOut,iTerrain)

tDest:補正対象とするタイル番号
tPat:補正後のタイル番号
bOut:bool:隣が画面外である時に、画面内の近傍位置に補正するか
iTerrain:連結している扱いとする当たり判定番号

tPatテーブルは下位から左右上下の順番にビットになっています。
[下上右左]
ただしLuaの仕様的に、添字はさらに+1されます。
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
●左右上下と斜めの８方向との繋がりを考慮した補正
Correct8Way(tDest,tPat,bOut)
Correct8Way_c(tDest,tPat,bOut,iTerrain)

tDest:補正対象とするタイル番号
tPat:補正後のタイル番号
bOut:bool:隣が画面外である時に、画面内の近傍位置に補正するか
iTerrain:連結している扱いとする当たり判定番号

tPatテーブルは下位から
左右上下(10右上)(20右下)(40左下)(80左上)の順番にビットになっています。
ただしLuaの仕様的に、添字はさらに+1されます。
4wayの順番に、時計回りに斜めの方向を追加した形です。
全てのテーブルを作ることは現実的ではないので
必要なものだけ指定して残りはnilというテーブルを渡すことになります。
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
●周期的に並んだタイルに補正
CorrectCyclicTile(tDest,tPat,xf,yf)

tDest:補正対象とするタイル番号
tPat:補正後のタイル番号/[1]から始まる配列で、その配列サイズで周期的に並べる
xf:x座標に掛ける値
yf:y座標に掛ける値
xr:x座標に剰余演算する値
yr:y座標に剰余演算する値
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
●位置を条件とし、特定のタイルを、別の特定のタイルに置き換える
SwitchTileByPosition(tDestPat,fCond)

tDestPat:補正対象とするタイル番号と補正後のタイル番号
fCond:(ix,iy)（座標）を引数とし、boolを返す関数

座標を条件としてboolを返す関数がtrueを返した時に
tDestPatの値に応じて置き換えを実行する。
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
●表面を覆うような配置
CorrectSurface(tDest,tPat,bOut)
CorrectSurface_c(tDest,tPat,bOut,iTerrain)

tDest:補正対象とするタイル番号
tPat:補正パターン
bOut:bool:隣が画面外である時に、画面内の近傍位置に補正するか
iTerrain:連結している扱いとする当たり判定番号

補正パターンは[1]から[20]まで、以下順番に設定する。
[左上][右上][左上空][右上空][上端][左端  ][右端  ][内部  ]
[左下][右下][左下空][右下空][下端][上下空][左右空][周囲無]
[上凸][下凸][左凸  ][右凸  ]

[左上]は、壁の左上に相当するタイル番号。
[左上空]は、壁の角の部分の内側で、周囲８方向のうち左上だけが空いたタイル番号。
[左端]は、壁の左の側面に相当するタイル番号。
[上下空き]は、上下が空いた横に長い部分のタイル番号。
[内部]は、８方向全てに壁のある部分。
[周囲無]は、８方向全てに壁のない単独で存在している部分。
[上凸]は、４方向のうち、下しか繋がっていない、上に突き出た部分である。
nilを指定すること(あるいは何も指定しないこと)も可能で、
この場合は当該タイルは書き変わらない。
また、値として00を指定するとnilを指定したのと同じ扱いになる。

このパターンは、tool_MakeTileTable.luaを利用すると容易に作成できる。
つまり、8x3に上の図の通りにタイルを配置した後、
その範囲を選択し、tool_MakeTileTable.luaを実行すれば良い。

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
