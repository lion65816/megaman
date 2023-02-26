--[[
FCEUXで利用可能。
memory.registerexecのラッパー。
広範囲に渡るregisterexecは不可能になっているが、
そういった用途は想定されていない。
一つのアドレスに複数の関数を登録可能。
BBAAAA(BB:バンク/AAAA:アドレス)という形で表される
24bitのアドレスに登録可能。

Rexe.init()
	初期化。呼ばなくても利用開始可能。

Rexe.register(Addr,func,value,label)
	registerexecする。
	AddrはBBAAAA(BB:バンク/AAAA:アドレス)という24bitのアドレスを渡す。
	funcは呼び出される関数であり、引数としてvalueが渡される。
	labelとして、registerexec解除に使うラベルを設定する事ができる。

Rexe.unregister(label,Addr)
	ラベルlabelとしてアドレスAddrに登録された関数を登録解除する。
	Addrを省略した場合、全てのアドレスを対象とする。

--]]

Rexe = {}
Rexe.RE = {}

Rexe.init = function()
	Rexe.RE = {}
	memory.registerexec( 0x0000 , 0x10000 , nil )
end
Rexe.handler = function(Addr)
	for k,v in pairs(Rexe.RE[Addr]) do
		local skip = false
		if v.tPrg then
			for i=0,#(v.tPrg)-1,1 do
				if memory.readbyte(Addr+i) ~= v.tPrg[i+1] then
					skip = true
				end
			end
		end
		if not skip then
			v.func(v.value)
		end
	end
end
Rexe.register = function(Addr,func,value,label)
	local Addr16 = AND(Addr,0xFFFF)
	local bank = bit.rshift(Addr,16)
	if not Rexe.RE[Addr16] then
		Rexe.RE[Addr16] = {}
	end
	local NewTbl = {}
	if Addr16 >= 0x8000 then
		local Offset = AND(Addr,0x1FFF)
		local Banks = rom.readbyte(4)*2
		local MatchBank = {}
		local MaxSize = math.min(10,0x2000-Offset)
		local tPrg = {}
		for i=0,Banks-1,1 do table.insert(MatchBank,i) end
		for RS=1,MaxSize,1 do
			local DestHex = rom.readbyte(0x10+0x2000*bank+Offset+RS-1)
			table.insert(tPrg,DestHex)
			local MatchCount = 0
			for k,v in pairs(MatchBank) do
				if rom.readbyte(0x10+0x2000*v+Offset+RS-1) ~= DestHex then
					MatchBank[k] = nil
				else
					MatchCount = MatchCount + 1
				end
			end
			if MatchCount == 1 then
				break
			end
		end
		NewTbl.tPrg = tPrg
	else
		--特に何もしない(nil)
	end
	NewTbl.func = func
	NewTbl.value = value
	Rexe.RE[Addr16][label] = NewTbl
	memory.registerexec(Addr16,Rexe.handler)
end

Rexe.unregister_sub = function(k,v,label)
	for ki,vi in pairs(v) do
		if ki==label then
			v[ki] = nil
		end
	end
	if next(v) == nil then --テーブルが空
		memory.registerexec(k,nil)
		Rexe.RE[k] = nil
	end
end
Rexe.unregister = function(label,Addr)
	if Addr then
		local Addr16 = AND(Addr,0xFFFF)
		Rexe.unregister_sub(Addr16,Rexe.RE[Addr16],label)
	else
		for k,v in pairs(Rexe.RE) do
			Rexe.unregister_sub(k,v,label)
		end
	end
end
