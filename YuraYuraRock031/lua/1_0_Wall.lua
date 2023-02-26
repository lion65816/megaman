print("●カットマンステージの壁\n")
print("(利用方法)範囲選択後[0]:自動補正実行\n")
print("・緑の壁の内部を市松模様に配置しつつ上端を専用のタイルに置き換える\n")

require("lua/common")

local tTGDest = --壁
{
[0x22]=1,
[0x28]=1,
[0x29]=1,
}
local tTGFixed =
{
0x22,0x28,0x22,0x28,
}

local tTGDest2 = --壁を周期的に修正
{
[0x29]=1,
[0x28]=1,
}
local tTGFixed2 =
{
0x29,0x28,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayV(tTGDest,tTGFixed,true)
		CorrectCyclicTile(tTGDest2,tTGFixed2,1,1)
		updateundo()
	end --}

	return iRV
end --function
