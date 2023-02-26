--���b�N�}��4�����n�`����\��Lua�X�N���v�g
--FCEUX2.2.1�ɂē���
--
--(����)
--�n�`�Ƃ̐ڐG���肪�s��ꂽ�_��\�����܂��B
--�X�N���[�����Ă���ꍇ�Ȃǂ͏��X�����ꍇ������܂���
--�d�l�Ƃ������Ƃɂ��Ă����܂��B
--���b�N�}��3�`5�́A�c�����́u�_�v��̐��_�𔻒�ɗ��p���܂��B
--�c�_�̐���V�A���_�̐���H�A����_�̐���P�Ƃ��ĕ\�����܂��B

	local EmuYFix = 0 ; --�G�~�����[�^�ɂ��Y�����̕␳

local function BOX(x1,y1,x2,y2,c1,c2)
	gui.box( x1 , y1+EmuYFix , x2 , y2+EmuYFix , c1 , c2 ) ;
end --function BOX
local function TEXT(x,y,t)
	gui.text( x , y+EmuYFix , t ) ;
end --function TEXT

	local NumOfHBars = 0 ;
	local NumOfVBars = 0 ;
	local NumOfPoints  = 0 ;

local function FuncStartCount(add,size)
	local x ;
	x = memory.getregister( "x" ) ;
	if( x==0 ) then
		NumOfHBars = 0 ;
		NumOfVBars = 0 ;
		NumOfPoints  = 0 ;
	end --if
end --function

local function FuncHBar(add,size)
	NumOfHBars = NumOfHBars + 1 ;
	local ObjNo ;
	local HitNo ;
	local NumOfHits ;
	local ptr ;
	local tx , ty ;
	local ttx , tty ;
	local dx , dy ;
	local sx , sy ;
	local cnt ;
	ObjNo = memory.getregister( "x" ) ;
	HitNo = memory.getregister( "y" ) ;
	ptr = memory.readbyte(0xd6de+HitNo)*256 + 
	      memory.readbyte(0xd69e+HitNo) ;
	NumOfHits = memory.readbyte( ptr )+1 ; 
	dx = memory.readbytesigned( ptr+2 ) ;
	dy = memory.readbytesigned( ptr+1 ) ;
	sx = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	sy = 0 ;
	tx = memory.readbyte(0x0348+ObjNo)*256 + memory.readbyte(0x0330+ObjNo) ;
	ty = memory.readbyte(0x0390+ObjNo)*256 + memory.readbyte(0x0378+ObjNo) ;
	tx = tx + dx ;
	ty = ty + dy ;

	for cnt=0,NumOfHits-1,1 do
		ttx = tx - sx ;
		tty = ty - sy ;
		tty = tty + EmuYFix ;
		gui.box( ttx-1 , tty-1 , ttx+1 , tty+1 , "green" ) ;
		NumOfPoints = NumOfPoints + 1 ;
		tx  = tx + memory.readbytesigned( ptr+3+cnt ) ;
	end --for
end --function

local function FuncVBar(add,size)
	NumOfVBars = NumOfVBars + 1 ;
	local ObjNo ;
	local HitNo ;
	local NumOfHits ;
	local ptr ;
	local tx , ty ;
	local ttx , tty ;
	local dx , dy ;
	local sx , sy ;
	local cnt ;
	ObjNo = memory.getregister( "x" ) ;
	HitNo = memory.getregister( "y" ) ;
	ptr = memory.readbyte(0xd848+HitNo)*256 + 
	      memory.readbyte(0xd808+HitNo) ;
	NumOfHits = memory.readbyte( ptr )+1 ; 
	dx = memory.readbytesigned( ptr+1 ) ;
	dy = memory.readbytesigned( ptr+2 ) ;
	sx = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	sy = 0 ;
	tx = memory.readbyte(0x0348+ObjNo)*256 + memory.readbyte(0x0330+ObjNo) ;
	ty = memory.readbyte(0x0390+ObjNo)*256 + memory.readbyte(0x0378+ObjNo) ;
	tx = tx + dx ;
	ty = ty + dy ;

	for cnt=0,NumOfHits-1,1 do
		ttx = tx - sx ;
		tty = ty - sy ;
		tty = tty + EmuYFix ;
		gui.box( ttx-1 , tty-1 , ttx+1 , tty+1 , "green" ) ;
		NumOfPoints = NumOfPoints + 1 ;
		ty  = ty + memory.readbytesigned( ptr+3+cnt ) ;
	end --for
end --function

	memory.registerexec( 0xFEDD, 1 , FuncStartCount ) ;
	memory.registerexec( 0xD2FC, 1 , FuncHBar ) ;
	memory.registerexec( 0xD428, 1 , FuncVBar ) ;

while 1 do
	TEXT( 8 ,  8 , "H:" .. NumOfHBars ) ;
	TEXT( 8 , 16 , "V:" .. NumOfVBars ) ;
	TEXT( 8 , 24 , "P:" .. NumOfPoints ) ;
	FCEU.frameadvance()
end --while mainloop

