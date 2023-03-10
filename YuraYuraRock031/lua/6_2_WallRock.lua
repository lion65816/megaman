print("●プラントマンステージの岩壁\n")
print("(利用方法)範囲選択後[0]:自動補正実行\n")
print("・オレンジ色の岩壁を自動補正する。\n・岩壁タイルと連続していると判定される。\n原作より細かく境界を付けてしまう。\n・「横２マス分」単位で置かないと、不自然な事になる。\n")

require("lua/common")


local tTGDest = --対象
{
[0x10]=1,[0x11]=1,[0x12]=1,[0x13]=1,[0x14]=1,[0x15]=1,[0x16]=1,[0x17]=1,[0x18]=1,[0x19]=1,[0x1A]=1,[0x1B]=1,[0x1C]=1,[0x1D]=1,[0x1E]=1,[0x1F]=1,
}
local tTSurface =
{
0x16,0x17,0x10,0x10,0x14,0x12,0x13,0x10,
0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		CorrectSurface(tTGDest,tTSurface,true)
		CorrectCyclicTile({[0x10]=1},{0x10,0x11,0x18,0x19,},1,2,2,2)
		CorrectCyclicTile({[0x12]=1},{0x12,0x1A,},0,1,2,2)
		CorrectCyclicTile({[0x13]=1},{0x13,0x1B,},0,1,2,2)
		CorrectCyclicTile({[0x14]=1},{0x14,0x15,0x1C,0x1D,},1,2,2,2)
		CorrectCyclicTile({[0x16]=1},{0x16,0x1E,},0,1,2,2)
		CorrectCyclicTile({[0x17]=1},{0x17,0x1F,},0,1,2,2)
--		CorrectCyclicTile({[]=1},{},1,2,2,2)
		updateundo()
	end --}

	return iRV
end --function
