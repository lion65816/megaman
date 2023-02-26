print("●リングマンステージの透き通った壁\n")
print("(利用方法)範囲選択後[0]:自動補正実行\n")
print("・透き通った壁を自動補正する。\n・壁タイル同士で連続していると判定される。\n・壁内部にある雲や機械は対応していない(壁配置後に置く形になる)\n・幾つか16x16タイル定義が不足しているので完全には補正できない。\n")

require("lua/common")


local tTGDest = --対象
{
[0x10]=1,[0x11]=1,[0x12]=1,[0x13]=1,[0x14]=1,[0x18]=1,[0x19]=1,[0x1A]=1,[0x1C]=1,[0x20]=1,[0x21]=1,[0x22]=1,[0x25]=1,[0x26]=1,[0x28]=1,[0x29]=1,[0x2D]=1,[0x2E]=1,[0x2F]=1,[0x30]=1,[0x68]=1,[0x76]=1,[0x77]=1,[0x7F]=1,[0x88]=1,[0x8D]=1,[0x8E]=1,[0x8F]=1,[0x95]=1,[0x96]=1,[0x97]=1,[0x98]=1,[0x99]=1,
}
local tTSurface =
{
0x14,0x98,0x2F,0x25,0x12,0x18,0x95,0x10,
0x8D,0x99,0x77,0x7F,0x8F,0x00,0x00,0x00,
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		CorrectSurface(tTGDest,tTSurface,true)
		CorrectCyclicTile({[0x10]=1},{0x10,0x19,},1,0,2,2)
		CorrectCyclicTile({[0x18]=1},{0x18,0x20,},1,0,2,2)
		CorrectCyclicTile({[0x95]=1},{0x95,0x11,},1,0,2,2)
		CorrectCyclicTile({[0x12]=1},{0x12,0x13,},1,0,2,2)
		CorrectCyclicTile({[0x8F]=1},{0x8F,0x8E,},1,0,2,2)
		CorrectCyclicTile({[0x14]=1},{0x14,0x28,},1,2,2,2)
		CorrectCyclicTile({[0x98]=1},{0x98,0x1C,},1,2,2,2)
		CorrectCyclicTile({[0x8D]=1},{0x8D,0x22,},1,2,2,2)
		CorrectCyclicTile({[0x99]=1},{0x99,0x97,},1,2,2,2)
		CorrectCyclicTile({[0x77]=1},{0x77,0x96,},1,2,2,2)
--		CorrectCyclicTile({[]=1},{},1,2,2,2)
		updateundo()
	end --}

	return iRV
end --function
