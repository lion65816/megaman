print("●バブルマンステージの滝\n")
print("(利用方法)範囲選択後[0]:自動補正実行\n")
print("・滝の部分を市松模様に２種類のタイルを配置する。\n・滝以外の部分の下に影をつける。\n")

require("lua/common")

local tTGDest = --滝
{
[0xDC]=1,
[0xDD]=1,
[0xE7]=1,
}
local tTGFixed =
{
0xE7,0xDC,0xE7,0xDC,
}

local tTGDest2 = --周期的に修正
{
[0xDC]=1,
[0xDD]=1,
}
local tTGFixed2 =
{
0xDC,0xDD
}


function pEdit()
	local iRV=0
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayV(tTGDest,tTGFixed,true)
		CorrectCyclicTile(tTGDest2,tTGFixed2,1,1)
		updateundo()
	end --}

	return iRV
end --function
