print("●スカルマンステージの骨\n")
print("(利用方法)範囲選択後[0]:自動補正実行\n")
print("・骨の部分の僅かな空の色の有無を自動補正する。\n・周囲を見て壁と判断されなければ、空の色を含むものとする。\n")

require("lua/common")


local tTGDest = --対象
{
[0x02]=0x02,[0x03]=0x03,[0x04]=0x04,[0x05]=0x05,[0x06]=0x06,[0x07]=0x07,[0x08]=0x08,
[0x4E]=0x02,[0x51]=0x03,[0x52]=0x04,[0x53]=0x05,[0x54]=0x06,[0x55]=0x07,[0x56]=0x08,
}
local tCond =
{
[0x02]={0x4E,-1,0,1,0},
[0x03]={0x51,0,1,0,1}, --この２つは
[0x04]={0x52,0,1,0,1}, --下だけを見る
[0x05]={0x53,1,0,0,-1},
[0x06]={0x54,-1,0,0,-1},
[0x07]={0x55,1,0,0,1},
[0x08]={0x56,-1,0,0,1},
}
local tBG =
{
[0x0B]=1,[0x0C]=1,[0x5E]=1,[0x70]=1,[0x71]=1,[0x72]=1,[0x73]=1,[0x74]=1,[0x75]=1,[0x76]=1,[0x77]=1,[0x78]=1,[0x79]=1,[0x7A]=1,[0x7B]=1,[0x7C]=1,[0x7D]=1,[0x7E]=1,[0x7F]=1,[0x82]=1,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		for ix=x0,x1,1 do --{
		for iy=y0,y1,1 do --{
			if tTGDest[gettile(ix,iy)] then --{
				settile(ix,iy,tTGDest[gettile(ix,iy)])
				local tTmp = tCond[gettile(ix,iy)]
				local tx,ty,tx2,ty2
				tx,ty   = SetShiftPosition(ix,iy,tTmp[2],tTmp[3],bOut)
				tx2,ty2 = SetShiftPosition(ix,iy,tTmp[4],tTmp[5],bOut)
				if GetTerrainCollision(tx,ty)==1 or
				   GetTerrainCollision(tx2,ty2)==1 or 
				   tBG[gettile(tx,ty)] or
				   tBG[gettile(tx2,ty2)] then
					settile(ix,iy,tTmp[1])
				end
			end --}
		end --}
		end --}

		updateundo()
	end --}

	return iRV
end --function
