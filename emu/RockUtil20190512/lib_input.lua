--[[
FCEUX / Snes9Xrerecordingで利用可能
毎フレームUpdateInput()を呼び出して下さい。
--]]

tInput = {} ;
tInput.tPre = input.get() ;
tInput.tCur = tInput.tPre ;
tInput.Update = function()
	tInput.tPre = tInput.tCur ;
	tInput.tCur = input.get() ;
end --function
tInput.Press = function(id)
	if( tInput.tCur[id] and not tInput.tPre[id] )then return true end
	return nil ;
end --function
tInput.Release = function(id)
	if( not tInput.tCur[id] and tInput.tPre[id] )then return true end
	return nil ;
end --function
tInput.Hold = function(id)
	if( tInput.tCur[id] )then return true end
	return nil ;
end --function
tInput.NumberD = function(id)
	if( tInput.Press("0") or tInput.Press("numpad0") )then return 0 ; end
	if( tInput.Press("1") or tInput.Press("numpad1") )then return 1 ; end
	if( tInput.Press("2") or tInput.Press("numpad2") )then return 2 ; end
	if( tInput.Press("3") or tInput.Press("numpad3") )then return 3 ; end
	if( tInput.Press("4") or tInput.Press("numpad4") )then return 4 ; end
	if( tInput.Press("5") or tInput.Press("numpad5") )then return 5 ; end
	if( tInput.Press("6") or tInput.Press("numpad6") )then return 6 ; end
	if( tInput.Press("7") or tInput.Press("numpad7") )then return 7 ; end
	if( tInput.Press("8") or tInput.Press("numpad8") )then return 8 ; end
	if( tInput.Press("9") or tInput.Press("numpad9") )then return 9 ; end
	return nil ;
end --if
tInput.NumberH = function(id)
	local tmp = tInput.NumberD() ;
	if( tmp )then return tmp ; end
	if( tInput.Press("A") )then return 10 ; end
	if( tInput.Press("B") )then return 11 ; end
	if( tInput.Press("C") )then return 12 ; end
	if( tInput.Press("D") )then return 13 ; end
	if( tInput.Press("E") )then return 14 ; end
	if( tInput.Press("F") )then return 15 ; end
	return nil ;
end --if
tInput.xmouse = function() return tInput.tCur.xmouse end
tInput.ymouse = function() return tInput.tCur.ymouse end

tPad = {} ;
tPad.tPre = joypad.get(1) ;
tPad.tCur = tPad.tPre ;
tPad.Update = function()
	tPad.tPre = tPad.tCur ;
	tPad.tCur = joypad.get(1) ;
end --function
tPad.Press = function(id)
	if( tPad.tCur[id] and not tPad.tPre[id] )then return true end
	return nil ;
end --function
tPad.Release = function(id)
	if( not tPad.tCur[id] and tPad.tPre[id] )then return true end
	return nil ;
end --function
tPad.Hold = function(id)
	if( tPad.tCur[id] )then return true end
	return nil ;
end --function


function UpdateInput()
	tInput.Update() ;
	tPad.Update() ;
end --function
