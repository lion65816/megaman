print("●ストーンマンステージの岩壁\n")
print("(利用方法)範囲選択後[0]:自動補正実行\n")
print("・オレンジ色の岩壁を自動補正する。\n・32x32の位置で4通りに決め、天井と右側の壁のみ調整\n")

require("lua/common")


local tTGDest = --対象
{
[0x02]=1,[0x03]=1,[0x0A]=1,[0x0B]=1,
}
local tTSurface =
{
0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,
0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		--別に表面の補正を使うことはないのだが、面倒なので流用
		CorrectSurface(tTGDest,tTSurface,true)
		CorrectCyclicTile({[0x02]=1},{0x02,0x03,0x0A,0x0B,},1,2,2,2)
		Correct2WayV_c({[0x02]=1},{nil,0x0A,nil,nil},true,1)
		Correct2WayV_c({[0x03]=1},{nil,0x0B,nil,nil},true,1)
		Correct2WayH_c({[0x03]=1},{nil,nil,0x02,nil},true,1)
		Correct2WayH_c({[0x0B]=1},{nil,nil,0x0A,nil},true,1)
--		CorrectCyclicTile({[]=1},{},1,2,2,2)
		updateundo()
	end --}

	return iRV
end --function
