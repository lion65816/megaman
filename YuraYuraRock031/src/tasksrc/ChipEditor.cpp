#include "../common.h"

void ChipEditor::Finit()
{
	pVTE = NULL ;
	if( !GL::RS.IsValid() ){return;}
	MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
	assert( pTask ) ;
	pTask->SetDrawState( 0 , 0 , 0 ) ;

	ImportWorkingData() ;
	pVTE = new VersatileTileEditor<unsigned char>( aucWorking , 32 , 32 , 32 , 0 ) ;
	pVTE->SetTileSizeEX( 16 , 16 , 16 , 16 ) ; 
	pVTE->SetSFCTile( GL::SFC_CHR_BW ) ;
	pVTE->SetTilePalette( GL::WINWIDTH-256 , GL::WINHEIGHT-256 ) ;
	pVTE->SetClipFileName( _T("chipclip.rstgclip") ) ;
	GL::RS.DrawChip( &GL::mdo , GetChipEditorMode() , 0 ) ;
	GL::RequestRedraw() ;
	return ;
}
void ChipEditor::Fmain()
{
	if( !GL::RS.IsValid() ){return;}
	pVTE->SetPosition( 0 , 0 ) ;
	pVTE->SetTilePalette( GL::WINWIDTH-256 , GL::WINHEIGHT-256 ) ;
	if( pVTE->DoEdit() )
	{
		GL::iStageUpdated = 1 ;
		GL::RequestRedraw() ;
		ExportWorkingData() ;
		GL::RS.DrawChip( &GL::mdo , GetChipEditorMode() , 0 ) ;
	}
	int iOnMouse=-1 ;
	{
		int imx , imy ;
		imx = GaussDivision( GetMousePosX() , 32 ) ;
		imy = GaussDivision( GetMousePosY() , 32 ) ;
		
		if( RectIn( imx , imy , 0 , 0 , 16 , 16 ) )
		{
			iOnMouse = imx/8*0x80 + imx%8 + imy%0x80*8 ;
			assert( iOnMouse<256 ) ;
		}
	}
	if( iOnMouse>=0 )
	{
		{
			int iTmp = -1 ;
				 if( KeyOn( KC_1 ) ){ iTmp=0 ; }
			else if( KeyOn( KC_2 ) ){ iTmp=1 ; } 
			else if( KeyOn( KC_3 ) ){ iTmp=2 ; } 
			else if( KeyOn( KC_4 ) ){ iTmp=3 ; } 
			else if( KeyOn( KC_5 ) ){ iTmp=4 ; } 
			else if( KeyOn( KC_6 ) ){ iTmp=5 ; } 
			else if( KeyOn( KC_7 ) ){ iTmp=6 ; } 
			else if( KeyOn( KC_8 ) ){ iTmp=7 ; } 
			else if( KeyOn( KC_Q ) ){ iTmp=8 ; } 
			else if( KeyOn( KC_W ) ){ iTmp=9 ; } 
			else if( KeyOn( KC_E ) ){ iTmp=10 ; } 
			else if( KeyOn( KC_R ) ){ iTmp=11 ; } 
			else if( KeyOn( KC_T ) ){ iTmp=12 ; } 
			else if( KeyOn( KC_Y ) ){ iTmp=13 ; } 
			else if( KeyOn( KC_U ) ){ iTmp=14 ; } 
			else if( KeyOn( KC_I ) ){ iTmp=15 ; } 
			if( iTmp>=0 )
			{
				int iAttr = GetChipHitFromRS( iOnMouse ) ;
				iTmp = (iAttr & ~0xF0) | iTmp*16 ;
				if( iTmp != iAttr )
				{
					GL::iStageUpdated = 1 ;
					SetChipHitFromRS( iOnMouse , iTmp ) ;
					GL::RequestRedraw() ;
					GL::RS.DrawChip( &GL::mdo , GetChipEditorMode() , 0 ) ;
				}
			}
		}
		{
			int iTmp = -1 ;
				 if( KeyOn( KC_A ) ){ iTmp=0 ; }
			else if( KeyOn( KC_S ) ){ iTmp=1 ; } 
			else if( KeyOn( KC_D ) ){ iTmp=2 ; } 
			else if( KeyOn( KC_F ) ){ iTmp=3 ; } 
			if( iTmp>=0 )
			{
				int iAttr = GetChipHitFromRS( iOnMouse ) ;
				iTmp = (iAttr & ~0x03) | iTmp ;
				if( iTmp != iAttr )
				{
					GL::iStageUpdated = 1 ;
					SetChipHitFromRS( iOnMouse , iTmp ) ;
					GL::RequestRedraw() ;
					GL::RS.DrawChip( &GL::mdo , GetChipEditorMode() , 0 ) ;
				}
			}
		}
		{
			int iTmp = 0 ;
				 if( KeyPush( KC_Z ) ){ iTmp|=0x08 ; }
			else if( KeyPush( KC_X ) ){ iTmp|=0x04 ; } 
			if( iTmp )
			{
				GL::iStageUpdated = 1 ;
				int iAttr = GetChipHitFromRS( iOnMouse ) ;
				iTmp = iAttr ^ iTmp ;
				SetChipHitFromRS( iOnMouse , iTmp ) ;
				GL::RequestRedraw() ;
				GL::RS.DrawChip( &GL::mdo , GetChipEditorMode() , 0 ) ;
			}
		}
		VChipProc( iOnMouse ) ;
	}
	if( KeyPush( KC_F9 ) )
	{
		_TCHAR atcTmp[512] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(4) , GL::RS.GetFileName().c_str() ) ;
		GL::RS.SaveBitmapChip( &GL::mdo , atcTmp ) ;
		_TCHAR atcTmp2[512] ;
		_stprintf_s( atcTmp2 , _countof(atcTmp2) , GLMsg(297) , atcTmp ) ;
		GL::AlertS( atcTmp2 ) ;
	}
	return ;
}
void ChipEditor::Fdest()
{
	if( pVTE ){ delete pVTE ; pVTE=NULL ; }
	return ;
}
void ChipEditor::Fdraw()
{
	if( !GL::RS.IsValid() ){return;}
	GL::RS.UpdateSFC( &GL::mdo , 0 ) ;
	{
		MDO3Opt topt = *MDO3normal ;
		static BMPD aCol[4] = {myRGB(0,0,0),myRGB(31,31,31),myRGB(20,20,20),myRGB(10,10,10)} ;
		topt.flag |= MDO3F_USE_COLOR_TABLE ;
		topt.PBMPD = aCol ;
		GL::mdo.SBlt( &topt , GL::SFC_CHR_BW , 0 , 0 , 256 , 256 , GL::SFC_CHR , 0 , 0 , 128 , 128 ) ;
	
	}
	GL::mdo.SBlt( MDO3WINAPI , GL::SFC_BACK , 0 , 0 , 256 , 512 , GL::SFC_CHIP , 0 , 0 , 128 , 256 ) ;
	GL::mdo.SBlt( MDO3WINAPI , GL::SFC_BACK , 256 , 0 , 256 , 512 , GL::SFC_CHIP , 0 , 256 , 128 , 256 ) ;
	pVTE->DrawEditor( &GL::mdo , GL::SFC_BACK ) ;
//	GL::mdo.Blt( MDO3WINAPI , GL::SFC_BACK , 0 , 0 , 128 , 128 , GL::SFC_CHR_BW , 0 , 0 ) ;
	return ;
}

int ChipEditor::GetWorkingOffset( int iChipOffset )
{
	int iChrPos = iChipOffset/0x100 ;
	int iChipNo = iChipOffset%0x100 ;
	int iX , iY ;
	iX = iChipNo/0x80*16 + iChipNo%0x80%8*2 + iChrPos%2 ;
	iY = iChipNo%0x80/8*2 + iChrPos/2 ;
	return iY*32+iX ;
}

void ChipEditor::ImportWorkingData()
{
	for( int i=0 ; i<GL::RS.ciMaxAllocateChip*GL::RS.ciGrapPChipS ; i++ )
	{
		assert( GetWorkingOffset(i) < _countof( aucWorking ) ) ;
		aucWorking[ GetWorkingOffset(i) ] = GetChipFromRS( i ) ;
	}
}
void ChipEditor::ExportWorkingData()
{
	for( int i=0 ; i<GL::RS.ciMaxAllocateChip*GL::RS.ciGrapPChipS ; i++ )
	{
		SetChipToRS( i , aucWorking[ GetWorkingOffset(i) ] ) ;
	}
}
int ChipEditor::GetChipFromRS( int Offset )
{
	return GL::RS.GetChip( Offset ) ;
}
void ChipEditor::SetChipToRS( int Offset , int iValue )
{
	GL::RS.SetChip( Offset , iValue ) ;
}
int ChipEditor::GetChipHitFromRS( int Offset )
{
	return GL::RS.GetChipHit( Offset ) ;
}
void ChipEditor::SetChipHitFromRS( int Offset , int iValue )
{
	GL::RS.SetChipHit( Offset , iValue ) ;
}
int ChipEditor::GetChipEditorMode()
{
	return 0 ;
}
void ChipEditor::VChipProc( int iPosition )
{
	return ;
}