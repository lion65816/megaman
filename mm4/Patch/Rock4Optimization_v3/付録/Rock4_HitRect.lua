--���b�N�}���S��������g�\��Lua�X�N���v�g
--FCEUX2.2.1�ɂē���
--�\����
--   TT     TT:�^�C�v�̔ԍ�(�{�X�͕ʈ����̔ԍ�)
--   HH     HH:HP
--   DD     DD:�ڐG���̃_���[�W(���b�N�}��/����ɂ͔�\��)
--
--�i�⑫�j
--�v���O������A
--���b�N�}��/���b�N�}���̕���/�I�u�W�F�N�g
--�ɁA���ꂼ��ʂɃT�C�Y���^�����Ă���킯�ł͂Ȃ�
--���b�N�}���̃I�u�W�F�N�g
--���b�N�}���̕���̃I�u�W�F�N�g
--�̑��ΓI�ȑ傫�������^�����Ă��Ȃ��̂ŁA
--���ꂼ��̊Ԃłǂ��炩�����̒l�Ɍ��߂Ď��o������K�v������B
--�����ł̓��b�N�}���̃T�C�Y��12x20�A���b�N�}���̕���̊�{�T�C�Y��0x0�Ƃ����B

	local EmuYFix = 0 ; --�G�~�����[�^�ɂ��Y�����̕␳

local function BOX(x1,y1,x2,y2,c1,c2)
	gui.box( x1 , y1+EmuYFix , x2 , y2+EmuYFix , c1 , c2 ) ;
end --function BOX
local function TEXT(x,y,t)
	gui.text( x , y+EmuYFix , t ) ;
end --function TEXT
local function ShowNOObj()
	local iCnt = 0 ;
	local iCur = 0 ;
	local iTmp ;

	for iCnt=0,0x17,1 do
		iTmp = memory.readbyte(0x0300+iCnt) ;
		if( iTmp ~= 0 ) then
			iCur = iCur + 1 ;
		end --if
	end --for

	TEXT( 0,8,"O:"..iCur) ;
end --function ShoNOObj


	local CRockW = 0x6 ;
	local CRockH = 0xA ;
	local CWepW  = 0x0 ;
	local CWepH  = 0x0 ;






local function FuncMain()
	local iCnt ;
	local iScX , iScY ;

	iScX = memory.readbyte(0xF9)*256+memory.readbyte(0xFC) ;
	iScY = 0 ;

	TEXT( 8 , 16 , string.format(
		"%d",AND(memory.readbyte(0xB0),0x7F)
	 )) ;

	for iCnt=0 , 0x17 , 1 do
		local iX , iY ;
		iX = memory.readbyte(0x0348+iCnt)*256+memory.readbyte(0x0330+iCnt) ;
		iY = memory.readbyte(0x0378+iCnt) ;
		iX = iX - iScX ;
		iY = iY - iScY ;

		local iT ;
		iT  = memory.readbyte(0x0300+iCnt) ;

		if( iT ~= 0 ) then
			if( iCnt==0 ) then
				local iHitSizeX , iHitSizeY ;
				iHitSizeX = CRockW ;
				iHitSizeY = CRockH ;
				if( memory.readbyte(0x0558) == 0x10 )then
					iHitSizeY = iHitSizeY - 8 ;
				end --if
				BOX( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "#FF33FF" ) ;
			elseif( iCnt<=4 ) then
				local iHitSizeX , iHitSizeY ;
				local iTmp ;
				iTmp = memory.readbyte(0x0408+iCnt) * 2 ;
				iHitSizeX = CWepW + memory.readbyte(0xFACE+iTmp+1) ;
				iHitSizeY = CWepH + memory.readbyte(0xFACE+iTmp+0) ;
				BOX( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "#00FF00" ) ;
			elseif( iCnt<=0x7 ) then
				local iHitSizeX , iHitSizeY ;
				iHitSizeX = 2 ;
				iHitSizeY = 2 ;
				BOX( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" , "orange" ) ;
			else
				local iTmp , iHitSizeX , iHitSizeY ;
				local iHP , iDmg ;
				iTmp = AND( memory.readbyte(0x0408+iCnt) , 0x3F ) ;
				iHitSizeX = math.max(0, memory.readbyte(0xF9F4+iTmp) - CRockW ) ;
				iHitSizeY = math.max(0, memory.readbyte(0xF9B4+iTmp) - CRockH ) ;
				BOX( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" ,  "#FF33FF" ) ;
				iHitSizeX = math.max(0, memory.readbyte(0xFB1C+iTmp) - CWepW ) ;
				iHitSizeY = math.max(0, memory.readbyte(0xFADC+iTmp) - CWepH ) ;
				BOX( iX-iHitSizeX , iY-iHitSizeY , iX+iHitSizeX , iY+iHitSizeY , "clear" ,  "#00FF00" ) ;
				iDmg = rom.readbyte(0x2000*0x3A+0x0413+0x10+iT)
				iHP = memory.readbyte(0x0450+iCnt) ;
				TEXT( iX , iY , string.format(
					"%02X\n%d\n%d",iT,iHP,iDmg
				 )) ;
			end --if
		end --if
	end --for iCnt
end --function


while 1 do
	FuncMain() ;
	ShowNOObj() ;
	FCEU.frameadvance()
end --while mainloop

