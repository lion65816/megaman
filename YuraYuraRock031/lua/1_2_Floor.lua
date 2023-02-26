print("●ボンバーマンステージの白い横に伸びた床\n")
print("(利用方法)範囲選択後[0]:自動補正実行\n")
print("・床の左右端を補正。\n近傍が壁の判定だと連続していると判定される。\n")

require("lua/common")

local tTGDest = --壁
{
[0x21]=1,[0x60]=1,[0x62]=1,
}
local tPat =
{
0x21,0x62,0x60,0x21
}

function pEdit()
	local iRV=0
	local x0,y0,x1,y1 = getselectedrect()
	
	if iskeypressed(string.byte("0")) then --{
		iRV = 1
		Correct2WayH_c(tTGDest,tPat,true,1)
		updateundo()
	end --}

	return iRV
end --function
