#include "../common.h"

static const int aciMode1[] = {1,2,9,10,6,3,11} ;
static const int aciMode2[] = {1,2,5,3,6,7} ;
static const int aciMode3[] = {0,1,2,3} ;
static const int aciMode4[] = {0,1,2,3} ;
static const int aciMode5[] = {0,1,2,3} ;
static const int aciMode6[] = {0,1,2,3,4} ;
static const int aciMaxMode[7] = { 0,_countof(aciMode1),_countof(aciMode2),_countof(aciMode3),_countof(aciMode4),_countof(aciMode5),_countof(aciMode6) } ;

static const int *pciMode[] = {NULL,aciMode1,aciMode2,aciMode3,aciMode4,aciMode5,aciMode6} ;


void MainMode::Finit()
{
	x = y = iDrawMode = iDrawModeV = iUChip = iEditModeOrder = 0 ;
	iDrawPageNo = 1 ;
	GL::RS.SetDrawMode( iDrawMode , iUChip , iDrawPageNo ) ;

	iEditMode = pciMode[GL::RS.GetEditMode()][iEditModeOrder] ;
	GL::iStageUpdated = 0 ;
	iMaxMode = aciMaxMode[GL::RS.GetEditMode()] ;
	SetDrawState( 1 , 1 , 1 ) ;
	SwitchEditMode() ;

	SetProcessOrderPandC( false , true ) ;
	SetDrawOrderPandC( true , false ) ;
	GL::RS.ReserveUpdateChrChip() ;
	GL::RequestRedraw() ;
	return ;
}
void MainMode::Fmain()
{
	if( KeyPush( KC_TAB ) )
	{
		if( KeyOn( KC_CTRL ) )
		{ 
			iUChip ^= 1 ;
		}
		else if( KeyOn( KC_SHIFT) ) 
		{
			iDrawPageNo ^= 1 ;
		}
		else
		{
			RotateCorrect( &(++iDrawMode) , 3 ) ;
		}
		GL::RS.SetDrawMode( iDrawMode , iUChip , iDrawPageNo ) ;
		GL::RequestRedraw() ;
	}
	if( iDrawMap )
	{
		if( KeyScroll( &x , KC_S , KC_A , -64 , 8 , 0 ) |
			KeyScroll( &y , KC_Z , KC_W , -64 , 8 , 0 ) )
		{
			GL::RequestRedraw() ;
		}
	}
	{
		int iTmp=0 ;
		if( KeyScroll( &iTmp , KC_F4 , KC_F3 , 1 , 1 , 0 ) )
		if( iTmp )
		{
			GL::RS.SetViewPatNOD( iTmp ) ;
			GL::RequestRedraw() ;
		}
	}
	{
		if( KeyScroll( &iEditModeOrder , KC_F2 , KC_F1 , 1 , 1 , 0 ) )
		{
			RotateCorrect( &iEditModeOrder , iMaxMode ) ;
			iEditMode = pciMode[GL::RS.GetEditMode()][iEditModeOrder] ;
			SwitchEditMode() ;
			GL::RequestRedraw() ;
		}
	}
	if( GL::iDirectEditMode )
	{
		int iTmp = GL::iDirectEditStage ;
		if( KeyScroll( &iTmp , KC_F6 , KC_F5 , 1 , 1 , 0 ) )
		{
			if( GL::iStageUpdated && !KeyOn( KC_CTRL ) )
			{
				GL::AlertS( GLMsg(440) ) ;
			}
			else
			{
				RotateCorrect( &iTmp , GL::RS.aciNOStage[GL::iDirectEditMode-1] ) ;
				GL::iDirectEditStage = iTmp ;
				GL::RS.ImportFromRom( GL::iDirectEditStage ) ;
				GL::iStageUpdated = 0 ;
				GL::SetDirectEditFileName() ;
				GL::RS.ReserveUpdateChrChip() ;
				GL::RequestRedraw() ;
				SwitchEditMode() ;
			}
		}
	}
	if( KeyPush( KC_F11 ) && GL::RS.IsValid() )
	{
		if( !GL::RS.Save( NULL ) )
		{
			_TCHAR atcTmp[256] ;
			_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(200) , GL::RS.GetFileName().c_str() ) ;
			GL::AlertS( atcTmp ) ;
		}else{
			_TCHAR atcTmp[256] ;
			_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(201) , GL::RS.GetFileName().c_str() ) ;
			GL::Alert( atcTmp ) ;
		}
		if( KeyOn( KC_CTRL ) )
		{
			tstring strTmp = GL::RS.GetFileName() ;
			int iLastYen = strTmp.rfind(_T("\\")) ;
			if( iLastYen < 0 )
			{
				GL::Alert( GLMsg(202) ) ;
			}
			else
			{
				tstring strTmp2 = strTmp.substr( 0 , iLastYen ) ;
				GL::DropRoutineSub( strTmp2.c_str() ) ;
			}
		}
		if( GL::iDirectEditMode )
		{
			TCHAR atcTmp[256] ;
//			_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(421) , GL::strDirectEditROMFileName.c_str() ) ;
//			GL::AlertS( atcTmp ) ;
			int iP,iT,iPm,iTm ;
			if( int iRV = GL::RS.ExportToRom(&iP,&iT,&iPm,&iTm,NULL) )
			{
				_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(422) , GL::strDirectEditROMFileName.c_str() ) ;
				GL::Alert( atcTmp ) ; //直接書き込みに失敗しました
				switch( iRV )
				{
				case -2:
					_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(423) , iP , iPm , iT , iTm ) ;
					GL::Alert( atcTmp ) ; //ページ数もしくはタイル数が多すぎますPage:%d(最大%d)/Tile:%d(最大%d)
				break ;
				case -3:
					_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(424) , iP/4 , iT/4 ) ; //変数の名前と用途が異なります
					GL::Alert( atcTmp ) ; //オブジェクト数が多すぎます(%d,最大%d)
				break ;
				default:
					GL::Alert( GLMsg(427) ) ; //未知のエラーが発生
				}
			}
			else
			{
				int iRV2 = WriteFileFromMemory( GL::strDirectEditROMFileName.c_str() , GL::pucRom , GL::iRomSize ) ;
				if( !iRV2 )
				{
					_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(425) , GL::strDirectEditROMFileName.c_str() ) ;
					GL::AlertS( atcTmp ) ; //%sに直接書き込みが行われました
					GL::iStageUpdated = 0 ;
				}
				else
				{
					_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(426) , GL::strDirectEditROMFileName.c_str() ) ;
					GL::AlertS( atcTmp ) ; //%sへの書き込みに失敗しました
				}
			}
		}
	}
	return ;
}
void MainMode::Fdest()
{
	return ;
}
void MainMode::Fdraw()
{
	int iDraw = 0 ;
	if( iDrawMap ){ iDraw = iDrawMode+1 ; }
	GL::RS.Draw( &GL::mdo , GL::SFC_BACK , x , y , iDrawEditor , iDraw , iDrawObject , iDrawModeV ) ;

	if( !GL::iDirectEditMode )
	{
		_TCHAR atcTmp[512] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(300) , 
			iEditMode+1 , iMaxMode ,
			GLMsg(301+iEditMode) , GL::RS.GetViewPatNO()+1 , GL::RS.ciMaxViewPat ) ;
		SetWindowText( GL::hWnd , atcTmp ) ;
	}
	else
	{
		_TCHAR atcTmp[512] ;
		static const int aciMsgNO[] = {301,302,303,304,305,308,309,310,311,312,313,314} ;
		tstring strModified = _T("") ;
		if( GL::iStageUpdated ){ strModified = GL::Msg[307] ; }
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(306) , 
			iEditModeOrder+1 , iMaxMode ,
			GLMsg(aciMsgNO[iEditMode]) , GL::RS.GetViewPatNO()+1 , GL::RS.ciMaxViewPat ,
			GL::iDirectEditStage , strModified.c_str() ) ;
		SetWindowText( GL::hWnd , atcTmp ) ;
	}
	if( !GL::RS.IsValid() )
	{
		GL::mdo.BoxMoji( GL::SFC_BACK , GLMsg(319) , 0 , (GL::WINHEIGHT-24)/2 , 24 , 12 ) ;

	}
	return ;
}
void MainMode::SwitchEditMode()
{
	KillP( TP_HIGHEST , TP_LOWEST ) ;
	GL::RS.DrawChip( &GL::mdo , 0 , 0 ) ;
	GL::RS.UnloadLua() ;
	iDrawModeV = 0 ;
	switch( iEditMode )
	{
	case 0:
		new ChipEditor( this , TP_ChipEditor ) ;
	break ;
	case 1:
		new MapEditor( this ) ;
	break ;
	case 2:
		new ObjectEditor( this ) ;
	break ;
	case 3:
		new SpEditor( this ) ;
	break ;
	case 4:
		iDrawModeV = 1 ;
		new VChipEditor( this ) ;
	break ;
	case 5: //2用のアイテム編集
		new ObjectEditor( this , true , 1 ) ;
	break ;
	case 6: //色エディタ
		new ColorEditor( this ) ;
	break ;
	case 7: //スプライトバンク設定
		new GraphicsBankEditor( this ) ;
	break ;
	case 8: //32タイルエディタ
//		new Tile32Editor( this ) ;
	break ;
	case 9: //1用のオブジェクト編集（後半）
		new ObjectEditor( this , true , 1 ) ;
	break ;
	case 10: //1用のオブジェクト編集（後半）
		new R1_VariableField( this ) ;
	break ;
	case 11: //1用敵グラ指定
		new R1_GraphicsBank( this ) ;
	break ;
	default:
		assert( 0 ) ;
	}
}
