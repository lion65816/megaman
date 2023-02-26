--[[
FCEUX / Snes9Xrerecordingで利用可能
簡易UI。
--]]

require "lib_input"


EUI = {} ;
EUIButton = {} ;
EUIShortcut = {} ;
EUIShortcutPad = {} ;
EUILabel = {} ;

--[[利用例

IEUI = EUI.new() ;
IEUI:add( EUIButton.new(20,180,40,20,"Hoge",nil) ) ;

	IEUI:Main() ;

--]]


EUI.new = function()
	local obj = {}
	obj.obj = {}
	obj.objs = 0

	obj.add = function(t,nobj)
		t.obj[t.objs+1] = nobj
		t.objs = t.objs + 1
	end --function
	obj.delete = function(t,dest)
		for k,v in pairs(t.obj) do
			if v == dest then
				--切り離すのみで、テーブルを詰めない
				t.obj[k] = nil
			end
		end
	end --funcion
	obj.init = function(t)
		t.obj = {}
		t.objs = 0
	end --function
	obj.Main = function(t)
		for i,obj in pairs(t.obj) do
			obj:Main()
		end
	end --function

	return obj
end --function new

EUIButton.new = 
function(x,y,w,h,caption,handler)
	local obj = {} ;
	obj.x = x ;
	obj.y = y ;
	obj.w = w ;
	obj.h = h ;
	obj.caption = caption ;
	obj.handler = handler ;
	obj.pressing = 0 ;

	obj.Main = function(t)
	local iMx = tInput.xmouse() - t.x ;
	local iMy = tInput.ymouse() - t.y ;
	if( iMx>=0 and iMy>=0 and iMx<t.w and iMy<t.h )then
		if( tInput.Press("leftclick") )then t.pressing=3; end
		if( t.pressing ~= 0 )then
			if( tInput.Hold("leftclick") )then t.pressing=3; end
			if( tInput.Release("leftclick"))then
				t.pressing = 0 ;
				if( t.handler )then t:handler() ; end
			end
		end --if
	else
		t.pressing=t.pressing%2*2 ;
	end --if

	if( t.pressing%2==0 )then
		gui.box(t.x  ,t.y  ,t.x+t.w-1  ,t.y+t.h-1  ,"#000000") ;
		gui.box(t.x  ,t.y  ,t.x+t.w-1-1,t.y+t.h-1-1,"#FFFFFF") ;
		gui.box(t.x+1,t.y+1,t.x+t.w-1-1,t.y+t.h-1-1,"#AAAAAA") ;
		gui.text(t.x+1 , t.y+(t.h-7)/2 , t.caption) ;
	else
		gui.box(t.x  ,t.y  ,t.x+t.w-1  ,t.y+t.h-1  ,"#FFFFFF") ;
		gui.box(t.x  ,t.y  ,t.x+t.w-1-1,t.y+t.h-1-1,"#000000") ;
		gui.box(t.x+1,t.y+1,t.x+t.w-1-1,t.y+t.h-1-1,"#AAAAAA") ;
		gui.text(t.x+1+1 , t.y+(t.h-7)/2+1 , t.caption) ;
	end --if
	end --function Main

	return obj ;
end --function new

EUIShortcut.new =
function(x,y,w,h,caption,handler,key)
	local obj = {} ;
	obj.x = x ;
	obj.y = y ;
	obj.w = w ;
	obj.h = h ;
	obj.caption = caption ;
	obj.handler = handler ;
	obj.key = key ;

	obj.Main = function(t)
		if( tInput.Press(t.key) )then
			if( t.handler )then t:handler() ; end
		end --if
		if( t.caption )then
			gui.box(t.x  ,t.y  ,t.x+t.w-1  ,t.y+t.h-1  ,"#000000") ;
			gui.text(t.x+1+1 , t.y+(t.h-7)/2+1 , t.caption) ;
		end --if
	end --function Main

	return obj
end --function EUIShortcut.new

EUIShortcutPad.new =
function(x,y,w,h,caption,handler,key)
	local obj = {} ;
	obj.x = x ;
	obj.y = y ;
	obj.w = w ;
	obj.h = h ;
	obj.caption = caption ;
	obj.handler = handler ;
	obj.key = key ;

	obj.Main = function(t)
		if( tPad.Press(t.key) )then
			if( t.handler )then t:handler() ; end
		end --if
		if( t.caption )then
			gui.box(t.x  ,t.y  ,t.x+t.w-1  ,t.y+t.h-1  ,"#000000") ;
			gui.text(t.x+1+1 , t.y+(t.h-7)/2+1 , t.caption) ;
		end --if
	end --function Main

	return obj
end --function EUIShortcutPad.new

EUILabel.new =
function(x,y,w,h,caption,color)
	local obj = {} ;
	obj.x = x ;
	obj.y = y ;
	obj.w = w ;
	obj.h = h ;
	obj.caption = caption ;
	obj.color = color ;

	obj.Main = function(t)
		gui.box(t.x  ,t.y  ,t.x+t.w-1  ,t.y+t.h-1  ,color) ;
		gui.text(t.x+1+1 , t.y+(t.h-7)/2+1 , t.caption) ;
	end --function Main

	return obj
end --function EUILabel.new

