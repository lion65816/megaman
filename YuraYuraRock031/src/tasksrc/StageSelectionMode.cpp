#include "../common.h"


static const int aciMsgOrg[6] = {20,44,68,92,116,140} ;

void StageSelectionMode::Finit()
{
	Task1206Rect tRect = {48,20,8,16,0} ;
	new TaskObjectBoxText( this , false , tRect ,  GLMsg(11) , -1 , -1 , -1 ) ;
	tRect.y += tRect.h + 10 ;
	assert( iEditMode>=1 && iEditMode<=6 ) ;

	int iY0 = tRect.y ;
	tRect.x = 10 ;
	tRect.w = 200 ;
	tRect.h = 32 ;
	for( int i=0 ; i<GL::RS.aciNOStage[iEditMode-1] ; i++ )
	{
		new TaskObjectButton( this , false , tRect ,  14 , GLMsg(aciMsgOrg[iEditMode-1]+i) , NULL , &iPushedButton , (void*)i ) ;
		
		tRect.y += tRect.h ;
		if( i%8 == 7 )
		{
			tRect.y = iY0 ;
			tRect.x += tRect.w ;
		}
	}
	tRect.x = 10 ;
	tRect.y = iY0+tRect.h*8+10 ;
	new TaskObjectButton( this , false , tRect ,  14 , GLMsg(360) , NULL , &iPushedButton , (void*)101 ) ;

	iPushedButton = -1 ;

	hEditButton = 0 ;
	GL::RequestRedraw() ;
	return ;
}
void StageSelectionMode::Fmain()
{
	if( iPushedButton>=0 )
	{
		if( iPushedButton==100 )
		{
			GL::DropRoutineSub( GLMsg(171) ) ;
			return ;
		}
		Task1206Rect tRect = { 10,10,8,16,2 } ;
		this->KillP( TP_BOX_TEXT , TP_BOX_TEXT ) ;
		if( hEditButton )
		{
			Kill( hEditButton ) ;
			hEditButton = 0 ;
		}

		int iOrg,iEnd ;
		iOrg = iEnd = iPushedButton ;
		if( iPushedButton == 101 )
		{
			iOrg = 0 ;
			iEnd = GL::RS.aciNOStage[iEditMode-1]-1 ;
		}
		int iRV = 0 ;
		for( int iRipStage=iOrg ; iRipStage<=iEnd && !iRV ; iRipStage++ )
		{
			{
				tstring strFilename ;
				if( iPushedButton != 101 )
				{
					strFilename = GLMsg(171) ;
				}
				else
				{
					TCHAR atcTmp1[256] ;
					TCHAR atcTmp2[256] ;
					_stprintf_s( atcTmp1 , _countof(atcTmp1) , _T("%s%d") ,GLMsg(361) , iEditMode ) ;
					CreateDirectory( atcTmp1 , NULL ) ;
					_stprintf_s( atcTmp2 , _countof(atcTmp2) , _T("%s/%d[%02X]_%s.%s") ,
						atcTmp1 , iRipStage , iRipStage , 
						GLMsg(aciMsgOrg[iEditMode-1]+iRipStage) , GLMsg(3) ) ;
					strFilename = atcTmp2 ;
				}
				iRV = RipStage( iRipStage , strFilename.c_str() ) ;
			}
			switch( iRV )
			{
			case -1:
			case -2:
				{
					if( GL::RS.IsValid() )
					{
						_TCHAR atcTmp[512] ;
						_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(174) , GLMsg(164+iEditMode-1) , iRipStage , GLMsg(aciMsgOrg[iEditMode-1]+iRipStage) ) ;
						new TaskObjectBoxText( this , false , tRect ,  atcTmp , -1 , -1 , -1 ) ;
					}
					else
					{
						iRV = 0 ;
					}
				}
			break ;
			default:
				;
			}
		}

		if( iPushedButton != 101 )
		{
			if( !iRV )
			{
				{//取り出し成功
					_TCHAR atcTmp[512] ;
					_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(170) , GLMsg(164+iEditMode-1) , iPushedButton , GLMsg(aciMsgOrg[iEditMode-1]+iPushedButton) , GLMsg(171) , GLMsg(3) ) ;
					new TaskObjectBoxText( this , false , tRect ,  atcTmp , -1 , -1 , -1 ) ;
				}
				{//そのまま編集
					Task1206Rect tRect2 = { 10,10,240,20,3 } ;
					Task0810 *pTmp ;
					pTmp = new TaskObjectButton( this , true , tRect2 , 14 , GLMsg(172) ,  NULL , &iPushedButton , (void*)100 ) ;
					if( pTmp ){ hEditButton = pTmp->GetHandle() ; }
				}
			}
		}
		else
		{
			if( !iRV )
			{//取り出し成功
				_TCHAR atcTmp[512] ;
				_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(362) , GLMsg(164+iEditMode-1) , GLMsg(361) , iEditMode , GLMsg(3) ) ;
				new TaskObjectBoxText( this , false , tRect ,  atcTmp , -1 , -1 , -1 ) ;
			}
			else
			{//取り出し失敗
				_TCHAR atcTmp[512] ;
				_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(363) , GLMsg(164+iEditMode-1)) ;
				new TaskObjectBoxText( this , false , tRect ,  atcTmp , -1 , -1 , -1 ) ;
			}
		}


		iPushedButton = -1 ;
	}
	if( KeyPush( KC_ESC ) )
	{
		Task0810 *pTmp = SolveHandle( GetParentHandle() ) ;
		new RomModeManager( pTmp ) ;
		Suicide() ;
		return ;
	}

	return ;
}
void StageSelectionMode::Fdest()
{
	return ;
}
void StageSelectionMode::Fdraw()
{
	return ;
}
int StageSelectionMode::RipStage( int iStage , LPCTSTR filename )
{
	if( GL::LoadROM(iEditMode) )
	{
		return -1 ;
	}
	GL::RS.SetRom( GL::pucRom , GL::iRomSize ) ;
	GL::RS.SetEditMode( iEditMode ) ;
	if( GL::RS.ImportFromRom( iStage ) ||
		GL::RS.Save( filename ) )
	{
		return -2 ;
	}
	return 0 ;
}
