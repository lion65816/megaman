#include "../common.h"

const int R1_VariableField::aciSpOffset[2] = {0x300,0x3A0} ;

void R1_VariableField::Finit()
{
	MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
	assert( pTask ) ;
	pTask->SetDrawState( 0 , 0 , 0 ) ;
	if( !GL::RS.IsValid() ){return;}
	pTask->SetDrawState( 1 , 0 , 0 ) ;

	GL::RS.ExportSpData( aucData ) ;
	for( int iStg=0 ; iStg<2 ; iStg++ )
	{
		unsigned char *pucBase = aucData+aciSpOffset[iStg] ;
		if( pucBase[0] == 0x00 )
		{
			for( int iVF=0 ; iVF<ciMaxVF ; iVF++ )
			{
				pucBase[iVF*ciVFSize+1+1] = 0xFF ;
			}
		}
	}

	iDragging = 0 ;
	iSelected = -1 ;

	{//メッセージ
		Task1206Rect tRect={0,0,8,16,2} ;
		new TaskObjectBoxText( this , true , tRect , GLMsg(630) , -1 , -1 , -1 ) ;
	}
	SortVF() ;
	return ;
}
void R1_VariableField::Fmain()
{

	{
		int iRV ;
		switch( iDragging )
		{
		case 0: iRV = SubDragging0() ; break ;
		case 1: iRV = SubDragging1() ; break ;
		case 2: iRV = SubDragging2() ; break ;
		}
		if( iRV )
		{
			GL::iStageUpdated = 1 ;
			GL::RS.ImportSpData( aucData ) ;
			GL::RequestRedraw() ;
		}
	}
	return ;
}
void R1_VariableField::GetVFPosition( unsigned char *pucVF , int *piX0 , int *piY0 , int *piX1 , int *piY1 )
{
	*piX0 = pucVF[2] ;
	*piY0 = pucVF[3] ;
	*piX1 = pucVF[4] ;
	*piY1 = pucVF[5] ;
	if( !*piX1 ){ *piX1=256; }
	if( !*piY1 ){ *piY1=256; }
	*piX0 += pucVF[1]*256 ;
	*piX1 += pucVF[1]*256 ;
	return ;
}
void R1_VariableField::FixVFPosition( int *piX0 , int *piY0 , int *piX1 , int *piY1 )
{
	if( *piX0==*piX1 )
	{
		*piX0 -= 16 ;	
		*piX1 += 16 ;	
	}
	if( *piY0==*piY1 )
	{
		*piY0 -= 16 ;
		*piY1 += 16 ;
	}
}
int R1_VariableField::SetVFPosition( unsigned char *pucVF , int iX0 , int iY0 , int iX1 , int iY1 )
{
	if( iX0<0 || iX1<0 || iY0<0 || iY1<0 || 
		iX0>=ciInvalidPage*0x100 || iX1>=ciInvalidPage*0x100 ||
		iY0>=GL::RS.ciDotPPageH || iY1>GL::RS.ciDotPPageH ||
		iX0>iX1 || iY0>iY1 )
	{
		return 1 ;
	}
	if( iX0/256 != iX1/256 )
	{
		if( iX1%256==0 && iX0/256 == iX1/256-1 )
		{
		}
		else
		{
			return 1 ;
		}
	}
	pucVF[1] = iX0/256 ;
	pucVF[2] = iX0%256 ;
	pucVF[3] = iY0%256 ;
	pucVF[4] = iX1%256 ;
	pucVF[5] = iY1%256 ;
	return 0;
}
int R1_VariableField::NewVF( int iX , int iY )
{
	int iStg = iX >= GL::RS.R12_GetLatterPageNumber()*GL::RS.ciDotPPageW ;
	int iOffset = aciSpOffset[ iStg ] ;
	for( int iVF=0 ; iVF<ciMaxVF ; iVF++ )
	{
		unsigned char *pucBase = aucData+iOffset+iVF*ciVFSize+1 ;
		int iX0,iX1,iY0,iY1 ;
		GetVFPosition( pucBase , &iX0 , &iY0 , &iX1 , &iY1 ) ;
		if( iX0>=ciInvalidPage*GL::RS.ciDotPPageW )
		{
			iX = iX/GL::RS.ciDotPChipW*GL::RS.ciDotPChipW ;
			iY = iY/GL::RS.ciDotPChipW*GL::RS.ciDotPChipW ;
			SetVFPosition( pucBase , iX , iY , iX , iY ) ;
			SetVFPosition( pucBase , iX , iY , iX+GL::RS.ciDotPChipW , iY+GL::RS.ciDotPChipW ) ;
			pucBase[0] = 0 ;
			return iStg*1000+iVF ;
		}
	}
	return -1 ;
}
int R1_VariableField::SortVF()
{
	unsigned char aucSelected[ciVFSize] ;
	if( iSelected>=0 )
	{
		memcpy( aucSelected ,  aucData+aciSpOffset[ iSelected>=1000 ]+(iSelected%1000)*ciVFSize+1 , ciVFSize ) ;
	}
	for( int iStg=0 ; iStg<2 ; iStg++ )
	{
		int iInvalidate = 0 ;
		for( int iVF=0 ; iVF<ciMaxVF ; iVF++ )
		{
			unsigned char *pucBase = aucData+aciSpOffset[iStg]+iVF*6+1 ;
			int iX0,iX1,iY0,iY1 ;
			GetVFPosition( pucBase , &iX0 , &iY0 , &iX1 , &iY1 ) ;
			if( iInvalidate || iX0>=ciInvalidPage*GL::RS.ciDotPPageW )
			{
				iInvalidate = 1 ;
				memset( pucBase , 0xFF , ciVFSize ) ;
				continue ;
			}
		}
	}
	for( int iStg=0 ; iStg<2 ; iStg++ )
	{
		int iInvalidMode = 0 ;
		for( int iVF=0 ; iVF<ciMaxVF ; iVF++ )
		{
			unsigned char *pucBase = aucData+aciSpOffset[iStg]+iVF*6+1 ;
			int iX0,iX1,iY0,iY1 ;
			GetVFPosition( pucBase , &iX0 , &iY0 , &iX1 , &iY1 ) ;
			for( int iVFC=iVF+1 ; iVFC<ciMaxVF ; iVFC++ )
			{
				unsigned char *pucBaseC = aucData+aciSpOffset[iStg]+iVFC*6+1 ;
				int iX0C,iX1C,iY0C,iY1C ;
				GetVFPosition( pucBaseC , &iX0C , &iY0C , &iX1C , &iY1C ) ;
				if( iX0/GL::RS.ciDotPPageW > iX0C/GL::RS.ciDotPPageW )
				{
					unsigned char aucWorking[ciVFSize] ;
					memcpy( aucWorking , pucBase    , ciVFSize ) ;
					memcpy( pucBase    , pucBaseC   , ciVFSize ) ;
					memcpy( pucBaseC   , aucWorking , ciVFSize ) ;
					GetVFPosition( pucBase , &iX0 , &iY0 , &iX1 , &iY1 ) ;
				}
			}
		}
	}
	if( iSelected>=0 )
	{
		int iStg = (iSelected>=1000) ;
		for( int iVF=0 ; iVF<ciMaxVF ; iVF++ )
		{
			unsigned char *pucBase = aucData+aciSpOffset[iStg]+iVF*6+1 ;
			if( !memcmp( pucBase , aucSelected , ciVFSize ) )
			{
				iSelected = iStg*1000 + iVF ;
				break ;
			}
		}
	}
	return -1 ;
}
void R1_VariableField::DeleteVF()
{
	if( iSelected<0 ){ return ; }
	int iStg = (iSelected>=1000) ;
	{
		unsigned char *pucBase = aucData+aciSpOffset[iStg]+iSelected%1000*6+1 ;
		memset( pucBase , 0xFF , ciVFSize ) ;
	}
	for( int iVF=iSelected%1000+1 ; iVF<ciMaxVF ; iVF++ )
	{
		unsigned char *pucBase = aucData+aciSpOffset[iStg]+iVF*6+1 ;
		unsigned char aucWorking[ciVFSize] ;
		memcpy( aucWorking       , pucBase            , ciVFSize ) ;
		memcpy( pucBase          , pucBase-ciVFSize   , ciVFSize ) ;
		memcpy( pucBase-ciVFSize , aucWorking         , ciVFSize ) ;
	}
	iSelected = -1 ;
}
int R1_VariableField::SubDragging0()
{
	int ix , iy ;
	this->GetGlobalPosition( &ix , &iy ,  2 ) ;
	int iMx , iMy ;
	iMx = -ix + GetMousePosX() ;
	iMy = -iy + GetMousePosY() ;
	if( iMx>=0 && iMy>=0 && iMx<GL::RS.ciDotPPageW*ciInvalidPage && iMy<GL::RS.ciDotPPageH &&
		MousePush( MB_L ) || MousePush( MB_R ) )
	{
		int iMode = 1 ;
		if( MousePush( MB_L ) ){ iMode=1 ; }
		if( MousePush( MB_R ) ){ iMode=2 ; }

		for( int iStg=0 ; iStg<2 ; iStg++ )
		{
			for( int iVF=0 ; iVF<ciMaxVF ; iVF++ )
			{
				unsigned char *pucBase = aucData+aciSpOffset[iStg]+iVF*6+1 ;
				int iX0,iX1,iY0,iY1 ;
				GetVFPosition( pucBase , &iX0 , &iY0 , &iX1 , &iY1 ) ;
				FixVFPosition( &iX0 , &iY0 , &iX1 , &iY1 ) ; ;
				if( iX0>=ciInvalidPage*0x100 ){ break; }
				if( iMx >= iX0 && iMx < iX1 && iMy >= iY0 && iMy < iY1 )
				{
					iDragging = iMode ;
					iSelected = iStg*1000 + iVF ;
					iDragOrgX = iMx ;
					iDragOrgY = iMy ;
					return 1 ;
				}
			}
		}
		//空振り
		if( KeyOn( KC_CTRL ) )
		{
			if( (iSelected = NewVF( iMx , iMy ) ) >= 0 )
			{
				iDragging = iMode ;
				iDragOrgX = iMx ;
				iDragOrgY = iMy ;
			}
		}
		else
		{
			iSelected = -1 ;
		}
		return 1 ;
	}
	if( iSelected>=0 )
	{
		if( KeyPush( KC_DEL ) )
		{
			DeleteVF() ;
			return 1 ;
		}
		int iNum = GetNumberKey() ;
		if( iNum>=1 && iNum<=5 )
		{
			unsigned char *pucBase = aucData+aciSpOffset[iSelected/1000]+iSelected%1000*6+1 ;
			pucBase[0] = iNum-1 ;
			return 1 ;
		}
	}
	return 0 ;
}
int R1_VariableField::SubDragging12Sub( mousebuttonidentifyindex MouseCode , int iProcNo )
{
	if( MouseOff( MouseCode ) )
	{
		SortVF() ;
		iDragging = 0 ;
		return 1 ;
	}
	int ix , iy ;
	int iRV = 0 ;
	this->GetGlobalPosition( &ix , &iy ,  2 ) ;
	int iMx , iMy ;
	iMx = -ix + GetMousePosX() ;
	iMy = -iy + GetMousePosY() ;
	int iDx , iDy ;
	iDx = iMx - iDragOrgX ;
	iDy = iMy - iDragOrgY ;
	iDx /= GL::RS.ciDotPChipW ;
	iDy /= GL::RS.ciDotPChipH ;
	if( iDx || iDy )
	{
		iDx *= GL::RS.ciDotPChipW ;
		iDy *= GL::RS.ciDotPChipH ;
		int iStg = iSelected / 1000 ;
		int iVF  = iSelected % 1000 ;
		unsigned char *pucBase = aucData+aciSpOffset[iStg]+iVF*6+1 ;
		int iX0,iX1,iY0,iY1 ;
		GetVFPosition( pucBase , &iX0 , &iY0 , &iX1 , &iY1 ) ;
		if( iDx )
		{
			if( iProcNo==1 ){ iX0 += iDx ; }
			iX1 += iDx ;
			if( !SetVFPosition( pucBase , iX0 , iY0 , iX1 , iY1 ) )
			{
				iDragOrgX += iDx ;
				iRV = 1 ;
			}
		}
		if( iDy )
		{
			if( iProcNo==1 ){ iY0 += iDy ; }
			iY1 += iDy ;
			if( !SetVFPosition( pucBase , iX0 , iY0 , iX1 , iY1 ) )
			{
				iDragOrgY += iDy ;
				iRV = 1 ;
			}
		}
	}
	return iRV ;
}
int R1_VariableField::SubDragging1()
{
	return SubDragging12Sub( MB_L , 1 ) ;
}
int R1_VariableField::SubDragging2()
{
	return SubDragging12Sub( MB_R , 2 ) ;
}

void R1_VariableField::Fdest()
{
	return ;
}
void R1_VariableField::Fdraw()
{
	int ix , iy ;
	this->GetGlobalPosition( &ix , &iy ,  2 ) ;
	for( int iStg=0 ; iStg<2 ; iStg++ )
	{
		unsigned char *pucBaseBase = aucData+aciSpOffset[iStg]+1 ;
		for( int iVF=0 ; iVF<ciMaxVF ; iVF++ )
		{
			unsigned char *pucBase = pucBaseBase+iVF*ciVFSize ;
			if( pucBase[1]>=ciInvalidPage ){ break; }
			int iX0,iX1,iY0,iY1 ;
			GetVFPosition( pucBase , &iX0 , &iY0 , &iX1 , &iY1 ) ;
			BMPD ColorTable[5] = { myRGB(31,31,31) , myRGB(31,31,0) , myRGB(20,0,0) , myRGB(0,31,0) , myRGB(31,20,20) };
			BMPD color ;
			if( pucBase[0] >= _countof(ColorTable) ){ color=myRGB(0,0,0); }
			else{ color=ColorTable[pucBase[0]]; }
			iX0 += ix ;
			iX1 += ix ;
			iY0 += iy ;
			iY1 += iy ;
			{
				MDO3Opt topt=*MDO3normal ;
				topt.alpha = 0xC0 ;
				topt.flag |= MDO3F_BLEND ;
				GL::mdo.Cls( &topt , GL::SFC_BACK , iX0 , iY0 , max(iX1-iX0,1) , max(iY1-iY0,1) , color ) ;
				topt.flag &= ~MDO3F_BLEND ;
				FixVFPosition( &iX0 , &iY0 , &iX1 , &iY1 ) ; ;

				topt.flag |= MDO3F_LIGHT_BLEND ;
				GL::mdo.Line( &topt , GL::SFC_BACK , iX0 , iY0 , iX1 , iY1 , color ) ;
				topt.flag &= ~MDO3F_LIGHT_BLEND ;
				topt.flag |= MDO3F_DARK_BLEND ;
				GL::mdo.Line( &topt , GL::SFC_BACK , iX0 , iY1 , iX1 , iY0 , color ) ;

				if( iSelected == iStg*1000 + iVF )
				{
					GL::mdo.Text( GL::SFC_BACK , _T("●") , (iX0+iX1)/2-10 , (iY0+iY1)/2-10 , 20 , 10 , RGB(0,255,0) ) ;
				}
				{
					TCHAR atcTmp[32] ;
					static const int ciColorTable[2] = { RGB(255,255,0) , RGB(255,0,255) } ;
					UINT color = ciColorTable[iStg] ;
					_stprintf_s( atcTmp , _countof(atcTmp) , _T("%d") , iVF ) ;
					GL::mdo.BoxMoji( GL::SFC_BACK , atcTmp , (iX0+iX1)/2-10 , (iY0+iY1)/2-10 , 20 , 10 , color , RGB(0,0,0) ) ;
				}
			}
		}
	}
	return ;
}
