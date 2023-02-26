#include "RockStage_p.h"

void RockStage::SetupGraphicsPattern()
{
	{
		for( int i=0 ; i<_countof(iViewPatGraph) ; i++ ){ iViewPatGraph[i]=-1; }
		for( int i=0 ; i<_countof(iViewPatColor) ; i++ ){ iViewPatColor[i]=0x0F; }
	}
	switch(iEditMode)
	{
	case 1:SetupGraphicsPattern1();break;
	case 2:SetupGraphicsPattern2();break;
	case 3:SetupGraphicsPattern3();break;
	case 4:SetupGraphicsPattern4();break;
	case 5:SetupGraphicsPattern5();break;
	case 6:SetupGraphicsPattern6();break;
	default:
		assert( 0 ) ;
	}
}
void RockStage::SetupGraphicsPattern1()
{
	for( int iPatNo=0 ; iPatNo<2 ; iPatNo++ )
	{
		int iAddr = 0x008D00+iStageNO*0x20000+iPatNo*0x20 ;
		int iPatRemains = GetROM8p( iAddr ) ;
		iAddr ++ ;
		int iPatSize=0 ;
		int iBank=0 ;
		int iRPos=0 ;
		for( int iCurWPos=-16 ; iCurWPos<16 ; iCurWPos++ )
		{
			if( iPatSize==0 )
			{
				iPatRemains-- ;
				if( iPatRemains<0 ){ break; }
				iRPos = (GetROM8p( iAddr+0 )/4*0x100)+0x8000 ;
				iBank = GetROM8p( iAddr+0 )%4 ;
				iPatSize = GetROM8p( iAddr+1 ) ;
				iAddr += 2 ;
			}
			if( iCurWPos>=0 )
			{
				iViewPatGraph[iPatNo*16+iCurWPos] = (iBank*2+((iRPos-0x8000)/0x2000))*0x10000+iRPos ;
			}
			iRPos += 0x100 ;
			iPatSize -- ;
		}
		for( int i=0 ; i<16 ; i++ )
		{
			iViewPatColor[iPatNo*16+i] = GetROM8p(0x008CA0+iStageNO*0x20000+iPatNo*0x30+i) ;
			iViewPatColor[iPatNo*16+4] = iViewPatColor[iPatNo*16+8] = 
				iViewPatColor[iPatNo*16+12] = iViewPatColor[iPatNo*16+0] ;
		}
	}
}
void RockStage::SetupGraphicsPattern2()
{
	for( int iPatNo=0 ; iPatNo<2 ; iPatNo++ )
	{
		int iAddr = 0x01BC00+iStageNO*0x20000+iPatNo*0x100 ;
		int iPatRemains = GetROM8p( iAddr ) ;
		iAddr ++ ;
		int iPatSize=0 ;
		int iBank=0 ;
		int iRPos=0 ;
		for( int iCurWPos=-16 ; iCurWPos<16 ; iCurWPos++ )
		{
			if( iPatSize==0 )
			{
				iPatRemains-- ;
				if( iPatRemains<0 ){ break; }
				iRPos = GetROM8p( iAddr+0 )*0x100 ;
				iBank = GetROM8p( iAddr+2 ) ;
				iPatSize = GetROM8p( iAddr+1 ) ;
				iAddr += 3 ;
			}
			if( iCurWPos>=0 )
			{
				iViewPatGraph[iPatNo*16+iCurWPos] = (iBank*2+((iRPos-0x8000)/0x2000))*0x10000+iRPos ;
			}
			iRPos += 0x100 ;
			iPatSize -- ;
		}
		for( int i=0 ; i<16 ; i++ )
		{
			iViewPatColor[iPatNo*16+i] = GetROM8p(0x01BE02+iStageNO*0x20000+iPatNo*0x100+i) ;
		}
		iViewPatColor[4] = iViewPatColor[8] = iViewPatColor[12] = iViewPatColor[0] ;
	}
	switch( iStageNO )
	{
	case 4: //映写室
		iViewPatGraph[2*16+0x0] = 0x109400 ;
		iViewPatGraph[2*16+0xC] = 0x118000 ;
		for( int i=0 ; i<16 ; i++ ){ iViewPatColor[2*16+i] = GetROM8p(0x169E30+i) ; }

	break ;
	case 5: //メニュー/エンディング
		iViewPatGraph[2*16+0x0] = 0x108000 ;
		for( int i=0 ; i<16 ; i++ ){ iViewPatColor[2*16+i] = GetROM8p(0x1B8E12+i) ; }
		iViewPatGraph[3*16+0x0] = 0x118400 ;
		iViewPatGraph[3*16+0xC] = 0x0FB200 ;
		iViewPatGraph[3*16+0xE] = 0x118200 ;
		for( int i=0 ; i<16 ; i++ ){ iViewPatColor[3*16+i] = GetROM8p(0x1B8E32+i) ; }
	break ;
	case 7: //OP
		iViewPatGraph[2*16+0x0] = 0x138000 ;
		for( int i=0 ; i<16 ; i++ ){ iViewPatColor[2*16+i] = GetROM8p(0x1B8A51+i) ; }

	break ;
	}

}
void RockStage::SetupGraphicsPattern3()
{
	switch( iStageNO )
	{
	case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:
	case 8:case 9:case 10:case 11:case 12:case 13:case 15:
	case 17:
		{
			for( int q=0 ; q<3 ; q++ )
			{
				iViewPatGraph[q*16+0] = GetROM8p(0x00AA80+iStageNO*0x10000+0)*0x400 ;
				iViewPatGraph[q*16+8] = GetROM8p(0x00AA80+iStageNO*0x10000+1)*0x400 ;
				{
					int iPalPat = GetROM8p(0x00AA60+iStageNO*0x10000+q*2+1) ;
					for( int i=0 ; i<0x10 ; i++ )
					{
						iViewPatColor[q*16+i] = GetROM8p(0x00AA82+iStageNO*0x10000+iPalPat*0x14+i) ;
					}
				}
			}

			if( iStageNO == 17 )
			{
				iViewPatGraph[1*16+0] = GetROM8p(0x12AE04+1)*0x400 ;
				iViewPatGraph[1*16+8] = GetROM8p(0x12AE08+1)*0x400 ;
				for( int i=0 ; i<0xC ; i++ )
				{
					iViewPatColor[1*16+i+4] = GetROM8p(0x12AE81+i) ;
				}				
			}
		}
	break;
	case 14:
		{
			static const int aciAddr[2] = {0x0B86C1,0x0B86B5} ;
			static const int aciAddrC[2] = {0x0B8695,0x0B8655} ;
			for( int i=0 ; i<2 ; i++ )
			{
				for( int q=0 ; q<2 ; q++ )
				{
					iViewPatGraph[i*16+q*8] = GetROM8p(aciAddr[i]+q)*0x400 ;
				}
				for( int q=0 ; q<0x10 ; q++ )
				{
					iViewPatColor[i*16+q] =  GetROM8p(aciAddrC[i]+q) ;
				}
			}
		}
	break;
	case 16:
		{
			for( int q=0 ; q<0x10 ; q++ )
			{
				iViewPatColor[0*16+q] = GetROM8p(0x0C865E+q) ;
			}
			iViewPatColor[0] = iViewPatColor[4] = iViewPatColor[8] = iViewPatColor[12] = GetROM8p(0x0C8206) ;
			iViewPatGraph[0*16+0*0] = GetROM8p(0x1EC490)*0x400 ;
//			iViewPatGraph[0*16+0*8] = GetROM8p(0x1EC494)*0x400 ;
			for( int q=0 ; q<0x10 ; q++ )
			{
				iViewPatColor[1*16+q] = GetROM8p(0x189CE2+q) ;
			}
			for( int q=0 ; q<2 ; q++ )
			{
				iViewPatGraph[1*16+q*8] = GetROM8p(0x189D12+q)*0x400 ;
			}
		}
	break;
	case 19:
		{
			static const int aciAddr[3]  = {0x189BC3,0x189BC3,0x0B86BB} ;
			static const int aciAddrC[3] = {0x189BCF,0x189BFF,0x0B8675} ;
			for( int i=0 ; i<3 ; i++ )
			{
				for( int q=0 ; q<2 ; q++ )
				{
					iViewPatGraph[i*16+q*8] = GetROM8p(aciAddr[i]+q)*0x400 ;
				}
				for( int q=0 ; q<0x10 ; q++ )
				{
					iViewPatColor[i*16+q] =  GetROM8p(aciAddrC[i]+q) ;
				}
			}
			iViewPatGraph[1*16+8] = GetROM8p(0x189192)*0x400 ;
	}
	break;
	}

}
void RockStage::SetupGraphicsPattern4()
{
	switch( iStageNO )
	{
	case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:
	case 8:case 9:case 10:case 11:case 12:case 13:case 14:case 15:
		{
			int iPatNO=0 ;
			for( int i=-1 ; i<2-(iStageNO>=8) ; i++ )
			{

				for( int q=0 ; q<2 ; q++ )
				{
					int iRenderNO=iStageNO ;
					if( q )
					{
						if( i<0 ){ break ; }
						iRenderNO = GetROM8p(0x3EC8AB+iStageNO*8+i*4+2) ;
						if( !iRenderNO ){ break ; }
					}
					int iAddr = GetROM8p(0x28B800+iRenderNO)+GetROM8p(0x28B870+iRenderNO)*256 + 0x280000 ;
					if( GetROM8p( iAddr ) != 0xFF ){ iAddr += 8; }
					else { iAddr += 1 ; }

					for(;;)
					{
						if( GetROM8p( iAddr ) == 0xFF ){ break; }

						int iBank = GetROM8p( iAddr+0 ) ;
						int iSize = GetROM8p( iAddr+1 ) ;
						int iRPos = GetROM8p( iAddr+2 ) ;
						int iWPos = GetROM8p( iAddr+3 ) ;
						for(;iSize>0;iSize--,iRPos++,iWPos++)
						{
							if( iWPos>=0x10 ){ break ; }
							if( iRPos>=0xA0 ){ iRPos-=0x20; iBank++; }
							iViewPatGraph[iPatNO*16+iWPos] = iBank*0x10000+iRPos*0x100 ;
						}
						iAddr += 4 ;
					}
				}
				int iColorPat=0 ;
				if( i>=0 )
				{
					iColorPat = GetROM8p(0x3EC8AB+iStageNO*8+i*4+3) ;
				}
				for( int i=0 ; i<0x10 ; i++ )
				{
					iViewPatColor[iPatNO*16+i] = GetROM8p(0x20B590+iStageNO*0x10000+iColorPat*0x14+i) ;
				}
				iPatNO++ ;
			}
		}
	break ;
	case 16:
		{
			iViewPatGraph[0*16+0] = 0x139000 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x39875E+i) ; }
			iViewPatGraph[1*16+0] = 0x139000 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x39871E+i) ; }
			iViewPatGraph[2*16+0] = 0x158000 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[2*16+i] = GetROM8p(0x3C9AE3+i) ; }
			iViewPatGraph[3*16+0] = 0x259800 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[3*16+i] = (i%4?0x20:0x0F) ; }
		}
	break;
	case 0x11:
		{
			iViewPatGraph[0*16+0] = 0x189000 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x3992CE+i) ; }
			iViewPatGraph[1*16+0] = 0x158000 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x3994F8+i) ; }
			iViewPatGraph[2*16+0] = 0x148000 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[2*16+i] = GetROM8p(0x39873E+i) ; }
		}
	break;
	case 0x12:
		{
			iViewPatGraph[0*16+0] = 0x149000 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x3987BE+i) ; }
			iViewPatGraph[1*16+0] = 0x199000 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x399380+i) ; }
			iViewPatGraph[2*16+0] = 0x199000 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[2*16+i] = GetROM8p(0x3987FE+i) ; }
		}
	break;
	case 0x13:
		{
			iViewPatGraph[0*16+0] = 0x249800 ;
			iViewPatGraph[0*16+8] = 0x2A9800 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x1B88F5+i) ; }
			iViewPatGraph[1*16+0] = 0x249800 ;
			iViewPatGraph[1*16+8] = 0x2B9800 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x1B94A2+i) ; }
			iViewPatGraph[2*16+0] = 0x249800 ;
			iViewPatGraph[2*16+8] = 0x2B9800 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[2*16+i] = GetROM8p(0x1B8935+i) ; }
			iViewPatGraph[3*16+0] = 0x249800 ;
			iViewPatGraph[3*16+8] = 0x2C9800 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[3*16+i] = GetROM8p(0x1B8955+i) ; }
			for( int i=0  ; i<3 ; i++ ){iViewPatColor[3*16+1 +i] = GetROM8p(0x20B933+i) ; }
			for( int i=0  ; i<3 ; i++ ){iViewPatColor[3*16+5 +i] = GetROM8p(0x20BA83+i) ; }
			for( int i=0  ; i<2 ; i++ ){iViewPatColor[3*16+14+i] = GetROM8p(0x20BB40+1+i) ; }
		}
	break;
	case 0x14:
		{
			iViewPatGraph[0*16+0] = 0x259800 ;
			iViewPatGraph[0*16+8] = 0x2E9800 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x1B8875+i) ; }
			iViewPatGraph[1*16+0] = 0x259800 ;
			iViewPatGraph[1*16+8] = 0x2F9800 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x1B8895+i) ; }
		}
	break;
	}
}
void RockStage::SetupGraphicsPattern5()
{
	switch( iStageNO )
	{
	case 0:case 1:case 2:case 3:case 4:case 5:case 6:case 7:
	case 8:case 9:case 10:case 12:case 13:case 14:
		{
			/*最初の地点*/
			iViewPatGraph[0*16+0] = GetROM8p(0xA980+iStageNO*0x10000+0)*0x400 ;
			iViewPatGraph[0*16+8] = GetROM8p(0xA980+iStageNO*0x10000+1)*0x400 ;
			for( int i=0 ; i<0x10 ; i++ )
			{
				iViewPatColor[0*16+i] = GetROM8p(0xA988+iStageNO*0x10000+i) ;
			}
			/*復活地点*/
			int iWPos=1 ;
			for( int i=0  ; i<2 ; i++ )
			{
				int iRevData = GetROM8p(0x179166+2+iStageNO*6+i*3) ;
				if( !iRevData ){ continue; }
				iRevData-- ;
				iRevData = iRevData*0x18 + 0x0B81BD ;
				iViewPatGraph[iWPos*16+0] = GetROM8p(iRevData+0)*0x400 ;
				iViewPatGraph[iWPos*16+8] = GetROM8p(iRevData+1)*0x400 ;
				for( int i=0 ; i<0x10 ; i++ )
				{
					iViewPatColor[iWPos*16+i] = GetROM8p(iRevData+4+i) ;
				}
				iWPos++;
			}
			switch( iStageNO )
			{
			case 8:
				iViewPatGraph[3*16+0] = GetROM8p(aiMultiplexStage_DeltaAddr[0]+0xA980+iStageNO*0x10000+0)*0x400 ;
				iViewPatGraph[3*16+8] = GetROM8p(aiMultiplexStage_DeltaAddr[0]+0xA980+iStageNO*0x10000+1)*0x400 ;
				for( int i=0 ; i<0x10 ; i++ ){iViewPatColor[3*16+i] = GetROM8p(aiMultiplexStage_DeltaAddr[0]+0xA988+iStageNO*0x10000+i) ;}
			break ;
			case 14:
				iViewPatGraph[1*16+0] = 0xB8*0x400 ;
				iViewPatGraph[1*16+8] = 0xBA*0x400 ;
				for( int i=0 ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x0EA99C+i) ; }
				iViewPatGraph[2*16+0] = 0xBC*0x400 ;
				iViewPatGraph[2*16+8] = 0xB0*0x400 ;
				for( int i=0 ; i<0x10 ; i++ ){ iViewPatColor[2*16+i] = GetROM8p(aiMultiplexStage_DeltaAddr[0]+0xA988+iStageNO*0x10000+i) ; }
				iViewPatGraph[3*16+0] = 0xEC*0x400 ;
				for( int i=0 ; i<0x10 ; i++ ){ iViewPatColor[3*16+i] = GetROM8p(aiMultiplexStage_DeltaAddr[0]+0xA988+iStageNO*0x10000+i+0x14) ; }
			break ;
			}
		}
	break;
	case 11:
		{
			iViewPatGraph[0*16+0] = 0xE0*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x0C8421+i) ; }
			iViewPatGraph[1*16+0] = 0xD4*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x0C840F+i) ; }
			iViewPatGraph[2*16+0] = 0xD4*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[2*16+i] = GetROM8p(0x0C83FD+i) ; }
			iViewPatGraph[3*16+0] = 0xAC*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[3*16+i] = GetROM8p(0x0C8433+i) ; }
		}
	break;
	case 15:
		{
			iViewPatGraph[0*16+0] = 0xC4*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x0C8457+i) ; }
			iViewPatGraph[1*16+0] = 0xD0*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x178BE9+i) ; }
			iViewPatGraph[2*16+0] = 0xC8*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[2*16+i] = GetROM8p(0x178B9D+i) ; }
			iViewPatGraph[3*16+0] = 0xC8*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[3*16+i] = GetROM8p(0x178C2F+i) ; }
		}
	break;
	case 16:
		{
			iViewPatGraph[0*16+0] = 0xCC*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x01852A+i) ; }
			iViewPatGraph[1*16+0] = 0xCC*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x178BC3+i) ; }
			iViewPatGraph[2*16+0] = 0xE4*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[2*16+i] = GetROM8p(0x0E84DC+i) ; }
		}
	break;
	case 17:
		{
			iViewPatGraph[0*16+0] = 0xD8*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x179821+i) ; }
			iViewPatGraph[1*16+0] = 0xDC*0x400 ;
			for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[1*16+i] = GetROM8p(0x179833+i) ; }
		}
	break;
	}
}
void RockStage::SetupGraphicsPattern6()
{
	for(;;)
	{
		int iRenderNo = GetROM8p( 0x3EDF85+iStageNO ) ;
		int iAddr     = 0x378000+iRenderNo*4 ;
		int aiTmp[4] ;

		aiTmp[0] = GetROM8p( iAddr+0 ) ;
		aiTmp[1] = GetROM8p( iAddr+1 ) ;
		aiTmp[2] = GetROM8p( iAddr+2 ) ;
		aiTmp[3] = GetROM8p( iAddr+3 ) ;

		int iSize , iDest , iSrc ;
		iSize = aiTmp[0] ;
	//;[1]……DestLo(000# **** **** 0000の*の位置)
	//;[2]……SrcLo(100# **** **** 0000の*の位置)
	//;[3]……DBBB BBBBS D..Destの# S..Srcの# B..SrcBank
		iDest = (aiTmp[3]&0x80)*2*16 + (aiTmp[1]*16) ;
		iSrc  = 0x8000 + (aiTmp[3]&1)*256*16 + (aiTmp[2]*16) ;
		iSrc  |= ((aiTmp[3]&0x7E)/2*65536) ;

		if( iDest&0xFF ){ break ; }
		if( iDest>=0x1000 ){ break ; }
		iViewPatGraph[0*16+iDest/0x100] = iSrc ;
		break ;
	}
	{
		int iColorNo = GetROM8p( 0x3EDF95+iStageNO ) ;
		int iAddr     = 0x379000+iColorNo ;
		int iWPos ;
		iAddr     = 0x370000 + GetROM8p(iAddr+0x100)*0x100 + GetROM8p(iAddr)  ;
		iWPos = GetROM8p( iAddr ) ;
		iAddr++ ;
		for( ; iWPos<0x10 ; iWPos++ )
		{
			int iData = GetROM8p( iAddr ) ;
			iAddr++ ;
			if( iData&0x40 )
			{
				iViewPatColor[0*16+iWPos] = 0x0F ;
				iWPos++ ;
				if( iWPos==0x10 ){ break; }
			}
			iViewPatColor[0*16+iWPos] = iData & 0x3F ;
			if( iData&0x80 ){ break; }
		}
	}
//	for( int i=0  ; i<0x10 ; i++ ){iViewPatColor[0*16+i] = GetROM8p(0x179821+i) ; }
}
void RockStage::UpdateGraphicsPattern()
{
	switch(iEditMode)
	{
	case 1:
		{
			for( int i=0 ; i<16 ; i++ )
			{
				iViewPatColor[0*16+i] = aucSpData[0x100+i] ;
			}
			for( int i=0 ; i<16 ; i++ )
			{
				iViewPatColor[1*16+i] = aucSpData[0x130+i] ;
			}
			iUpdateChip = 1 ;
		}
	break;
	case 2:
	   {
			for( int i=0 ; i<16 ; i++ )
			{
				iViewPatColor[0*16+i] = aucSpData[0x82+i] ;
			}
			for( int i=0 ; i<16 ; i++ )
			{
				iViewPatColor[1*16+i] = aucSpData[0x102+i] ;
			}
			iUpdateChip = 1 ;
	   }
	break;
	case 3:break;
	case 4:break;
	case 5:break;
	case 6:break;
	default:
		assert( 0 ) ;
	}

}
