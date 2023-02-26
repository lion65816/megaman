#include "../common.h"

static const int aciTiles[] = { 192 , 256 , 256 , 256, 256, 256 } ;


void LockTileEditor::Finit()
{
	iTiles = aciTiles[GL::RS.GetEditMode()-1] ;
	iValidFill = -1 ;
	i12Mode = 0 ;
	if( GL::RS.GetEditMode()<=2 ){ i12Mode=1; }


	ImportWorkingData() ;
	pVTE = new VersatileTileEditor<unsigned char>( aucWorking , 32 , iTiles*4/32 , 32 , 0 ) ;
	pVTE->SetTileSize( 16 , 16 ) ; 
	pVTE->SetTileSFCSize( 8 , 32 ) ;
	pVTE->SetSFCTile( GL::SFC_CHIP ) ;
	pVTE->SetTilePalette( GL::WINWIDTH-128 , GL::WINHEIGHT-512 ) ;
	pVTE->SetClipFileName( _T("tileclip.rstgclip") ) ;

	{//メッセージ
		Task1206Rect tRect={0,0,8,16,2} ;
		TaskObject *pTask = new TaskObjectBoxText( this , true , tRect , GLMsg(700) , -1 , -1 , -1 ) ;
		if( !pTask ){ return ; }
		if( i12Mode )
		{
			tRect.y += pTask->GetRect().h ; 
			new TaskObjectBoxText( this , true , tRect , GLMsg(701) , -1 , -1 , -1 ) ;
		}
	}
	this->SetDrawOrderPandC( true , false ) ;
	GL::RequestRedraw() ;
	return ;
}
void LockTileEditor::Fmain()
{
	pVTE->SetPosition( 0 , 0 ) ;
	pVTE->SetTilePalette( GL::WINWIDTH-128 , GL::WINHEIGHT-512 ) ;
	if( pVTE->DoEdit() )
	{
		GL::iStageUpdated = 1 ;
		GL::RequestRedraw() ;
		ExportWorkingData() ;
	}

	int iOnMouse=-1 ;
	int iOnMouseTile=-1 ;
	{
		int imx , imy ;
		imx = GaussDivision( GetMousePosX() , 16 ) ;
		imy = GaussDivision( GetMousePosY() , 16 ) ;
		if( RectIn( imx , imy , 0 , 0 , 32 , iTiles*4/32 ) )
		{
			iOnMouse = imx+imy*32 ;
			assert( iOnMouse<32*32 ) ;
			iOnMouseTile = imx/2+imy/2*16 ;
			assert( iOnMouseTile<iTiles ) ;
			if( i12Mode )
			{//判定切り替え
				int iTmp = -1 ;
				if( KeyOn( KC_1 ) ){ iTmp = 0 ; }
				if( KeyOn( KC_2 ) ){ iTmp = 1 ; }
				if( KeyOn( KC_3 ) ){ iTmp = 2 ; }
				if( KeyOn( KC_4 ) ){ iTmp = 3 ; }
				if( KeyOn( KC_5 ) ){ iTmp = 4 ; }
				if( KeyOn( KC_6 ) ){ iTmp = 5 ; }
				if( KeyOn( KC_7 ) ){ iTmp = 6 ; }
				if( KeyOn( KC_8 ) ){ iTmp = 7 ; }
				if( iTmp>=0 && VAR_LET( aucHit[ iOnMouse ] , iTmp ) )
				{
					ExportWorkingData() ;
					GL::RequestRedraw() ;
				}

			}
		}
	}
	{
		int iTmp = 0 ;
		if( KeyPush( KC_SPACE ) )
		{
			iValidFill = (aucFlag[iOnMouseTile]&GL::RS.ciLF_Locked)^GL::RS.ciLF_Locked ;
		}
		if( KeyRelease( KC_SPACE ) )
		{
			iValidFill = -1 ;
		}
		if( iValidFill>=0 )
		{
			if( (aucFlag[iOnMouseTile]&GL::RS.ciLF_Locked) != iValidFill )
			{
				aucFlag[iOnMouseTile] &= ~GL::RS.ciLF_Locked ;
				aucFlag[iOnMouseTile] |= iValidFill ;
				ExportWorkingData() ;
//				GL::RS.SetVChipValid( iPosition , iTmp ) ;
				GL::iStageUpdated = 1 ;
				GL::RequestRedraw() ;
//				GL::RS.DrawChip( &GL::mdo , GetChipEditorMode() ) ;
			}
		}
	}
	{
		if( KeyOn( KC_CTRL ) && KeyPush( KC_A ) )
		{
			int iOrV = (aucFlag[0]&GL::RS.ciLF_Locked)^GL::RS.ciLF_Locked ;
			for( int i=0 ; i<256 ; i++ )
			{
				aucFlag[i] &= ~GL::RS.ciLF_Locked ;
				aucFlag[i] |= iOrV ;
			}
			ExportWorkingData() ;
			GL::iStageUpdated = 1 ;
			GL::RequestRedraw() ;
		
		}
	}

	if( KeyPush( KC_ESC ) )
	{
		this->Wake( this->GetParentHandle() ) ;
		Suicide() ;
	}
	if( KeyPush( KC_Z ) || KeyRelease( KC_Z ) )
	{
		GL::RequestRedraw() ;
	}
	return ;
}
void LockTileEditor::Fdest()
{
	if( pVTE ){ delete pVTE ; pVTE=NULL ; }
	GL::RS.DrawChip( &GL::mdo , 0 , 0 ) ;
	GL::RequestRedraw() ;
	return ;
}
void LockTileEditor::Fdraw()
{

	TASKHANDLE hTask = this->GetParentHandleN( 2 ) ;
	MainMode *pMM = (MainMode*)this->SolveHandle( hTask ) ;
	if( i12Mode && pMM->GetDrawMode()==2 )
	{
		GL::RS.DrawChip( &GL::mdo , 0 , 1 ) ;
	}
	
	pVTE->DrawMap( &GL::mdo , GL::SFC_BACK , 4 , 4 ) ;
	pVTE->DrawEditor( &GL::mdo , GL::SFC_BACK ) ;
	for( int i=0 ; i<iTiles ; i++ )
	{
		int iX , iY ;
		iX = i%16*32 ;
		iY = i/16*32 ;

		if( i12Mode && pMM->GetDrawMode()==2 )
		{ //1,2の判定
			for( int iI=0 ; iI<4 ; iI++ )
			{
				int iLx , iLy ;
				iLx = iX + iI%2*16 ;
				iLy = iY + iI/2*16 ;
				GL::mdo.Blt( MDO3normal , GL::SFC_BACK , iLx , iLy , 16 , 16 , GL::SFC_CHIPINFO , 
								aucHit[i%16*2+i/16*0x40+iI%2+iI/2*0x20]*16 , (GL::RS.GetEditMode()-1)*16) ;
			}
		}

		MDO3Opt topt = *MDO3normal ;
		topt.alpha = 0x80 ;
		topt.flag = MDO3F_BLEND ;
		if( KeyOff( KC_Z ) && !(aucFlag[i] & GL::RS.ciLF_LockedAnyway ) )
		{
			GL::mdo.Cls( &topt , GL::SFC_BACK , iX , iY , 32 , 32 , myRGB(0,0,0) ) ;
			GL::mdo.Line( &topt , GL::SFC_BACK , iX , iY , iX+31 , iY+31 , myRGB(31,0,0) ) ;
			GL::mdo.Line( &topt , GL::SFC_BACK , iX+31 , iY , iX , iY+31 , myRGB(31,0,0) ) ;
		}
	}
	return ;
}
void LockTileEditor::ImportWorkingData()
{
	for( int i=0 ; i<_countof(aucWorking) ; i++ )
	{
		assert( GetWorkingOffset(i) < _countof( aucWorking ) ) ;
		aucWorking[i] = GL::RS.GetPreTile( GetWorkingOffset(i) ) ;
		aucHit[i] = GL::RS.GetPreTileHit( GetWorkingOffset(i) ) ;
	}
	for( int i=0 ; i<256 ; i++ )
	{
		aucFlag[i] = GL::RS.GetPreTileFlag( i ) ;
	}
}
void LockTileEditor::ExportWorkingData()
{
	for( int i=0 ; i<_countof(aucWorking) ; i++ )
	{
		assert( GetWorkingOffset(i) < _countof( aucWorking ) ) ;
		GL::RS.SetPreTile( GetWorkingOffset(i) , aucWorking[i] ) ;
		GL::RS.SetPreTileHit( GetWorkingOffset(i) , aucHit[i] ) ;
	}
	for( int i=0 ; i<256 ; i++ )
	{
		GL::RS.SetPreTileFlag( i , aucFlag[i] ) ;
	}
}
int LockTileEditor::GetWorkingOffset( int iChipOffset )
{
	int iTileNo = iChipOffset/2%16 + iChipOffset/2/16/2*16 ;
	int iTileOf = iChipOffset%2 + iChipOffset/2/16%2*2 ;
	return iTileNo*4 + iTileOf ;
}
