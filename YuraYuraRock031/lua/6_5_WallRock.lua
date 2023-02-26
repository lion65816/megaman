print("●トマホークマンステージの岩壁\n")
print("(利用方法)範囲選択後[0]:自動補正実行\n")
print("・オレンジ色の岩壁を自動補正する。\n・近傍が壁の判定だと連続していると判定される。\n")

require("lua/common")


local tTGDest = --対象
{
[0x61]=1,[0x62]=1,[0x63]=1,[0x64]=1,[0x65]=1,[0x66]=1,[0x69]=1,[0x6A]=1,[0x6B]=1,[0x6C]=1,[0x6F]=1,[0x70]=1,
}
local tTSurface =
{
0x69,0x6A,0x63,0x63,0x61,0x6B,0x6C,0x63,
0x6F,0x6F,0x63,0x63,0x6F,0x63,0x63,0x63,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		CorrectSurface_c(tTGDest,tTSurface,true,1)
		CorrectCyclicTile({[0x63]=1},{0x66,0x65,0x64,0x63,},1,2,2,2)
		CorrectCyclicTile({[0x61]=1},{0x62,0x61,},1,0,2,2)
		CorrectCyclicTile({[0x6F]=1},{0x6F,0x70,},1,0,2,2)
		CorrectCyclicTile({[0x6C]=1},{0x65,0x6C,},0,1,2,2)
		CorrectCyclicTile({[0x6B]=1},{0x66,0x6B,},0,1,2,2)
--		CorrectCyclicTile({[]=1},{},1,2,2,2)
		updateundo()
	end --}

	return iRV
end --function
