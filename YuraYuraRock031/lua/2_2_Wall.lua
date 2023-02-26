print("●ウッドマンステージの土壁と洞窟内の背景\n")
print("(利用方法)範囲選択後[0]:自動補正実行\n")
print("・茶色の地面に対し、上端・下端・中程を自動配置。\n・こげ茶色の背景の天井際に影をつける。\n・ハシゴの下等にも影がついてしまう。\n")

require("lua/common")

local tTGDest = --土壁
{
[0x98]=1,
[0x99]=1,
[0x9A]=1,
[0xA0]=1,
}
local tTGFixed =
{
0xA0,0x9A,0xA0,0x98,
}

local tTGDest2 = --土壁を周期的に修正
{
[0x98]=1,
[0x99]=1,
}
local tTGFixed2 =
{
0x98,0x99
}

local tTGDest3 = --洞窟内の背景
{
[0xE1]=1,
[0xE2]=1,
}
local tTGFixed3 =
{
0xE2,0xE1,0xE2,0xE1,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayV(tTGDest,tTGFixed,true)
		CorrectCyclicTile(tTGDest2,tTGFixed2,1,0)
		Correct2WayV(tTGDest3,tTGFixed3,true)
		updateundo()
	end --}

	return iRV
end --function
