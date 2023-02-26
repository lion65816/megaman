#include "../common.h"

void MapEditor::Finit()
{
	MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
	assert( pTask ) ;
	pTask->SetDrawState( 0 , 0 , 0 ) ;
	if( !GL::RS.IsValid() ){return;}
	x = y = 0 ;
	pTask->SetDrawState( 1 , 1 , 0 ) ;
	hLockTask = 0 ;
	iLockButton = -1 ;

	Task0810 *pUI ;
	pUI = new Task0810( this , TP_UILayer , true ) ;
	{
		Task1206Rect tRect={0,0,8,16,2} ;
		TaskObject *pTask ;
		pTask = new TaskObjectBoxText( pUI , true , tRect , GLMsg(271) , -1 , -1 , -1 ) ;
		hText = 0 ;
		if( !pTask ){ return; }
		hText = pTask->GetHandle();
		tRect.x += pTask->GetRect().w + 80 ;
		tRect.w = 80 ;
		pTask = new TaskObjectButton( pUI , true , tRect , tRect.h , GLMsg(282) , NULL , &iLockButton , (void*) 0 ) ;
//		if( !pTask ){ return; }
//		tRect.y += pTask->GetRect().h ;
//		pTask = new TaskObjectButton( pUI , true , tRect , tRect.h , GLMsg(281) , NULL , &iLockButton , (void*) 1 ) ;
	}
	this->SetProcessOrderPandC( false , true ) ;
	iCulcTimer = 1 ;
	int ix , iy ;
	this->GetGlobalPosition( &ix , &iy ,  2 ) ;
	GL::RS.ProcessChip( ix , iy , GL::WINWIDTH-128 , GL::WINHEIGHT-512 , 0 ) ;
	GL::RequestRedraw() ;
	return ;
}
void MapEditor::Fmain()
{
	if( !GL::RS.IsValid() ){return;}
	if( hLockTask )
	{
		if( !this->SolveHandle( hLockTask ) )
		{
			hLockTask = 0 ;
			MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
			assert( pTask ) ;
			pTask->SetDrawState( 1 , 1 , 0 ) ;

			this->Wake( this->SearchTask( TP_UILayer ) ) ;
			GL::RequestRedraw() ;
			iCulcTimer = 2 ;
		}
		return ;
	}
	int ix , iy ;
	this->GetGlobalPosition( &ix , &iy ,  2 ) ;
	if( GL::RS.ProcessChip( ix , iy , GL::WINWIDTH-128 , GL::WINHEIGHT-512 ) )
	{
		if( !iCulcTimer ){ iCulcTimer = 10 ; }
		TaskObjectBoxText *pTask = (TaskObjectBoxText *)SolveHandle( hText ) ;
		if( pTask )
		{
			tstring strTmp = GLMsg(271) ;
			pTask->SetString( strTmp ) ;
		}
		GL::iStageUpdated = 1 ;
		GL::RequestRedraw() ;
	}
	if( iCulcTimer )
	{
		if( !--iCulcTimer )
		{
			TaskObjectBoxText *pTask = (TaskObjectBoxText *)SolveHandle( hText ) ;
			if( pTask )
			{
				int iRV,iP,iT,iPm,iTm,iPP,iPT ;
				iRV = GL::RS.CulcPageTileAmount( &iP , &iT , &iPm , &iTm , &iPP , &iPT ) ;
				if( !iRV )
				{
					pTask->SetColor1( RGB(0,0,0) ) ;
				}else{
					pTask->SetColor1( RGB(200,0,0) ) ;
				}
				_TCHAR atcTmp[256] ;
				_TCHAR atcP[2][64] ;
				tstring strTmp ;

				atcP[0][0] = atcP[0][1] = _T('\0') ;
				if( GL::RS.IsTilePreservable() )
				{_stprintf_s( atcP[0] , _countof(atcP[0]) , GLMsg(280) , 0 ) ; }
				_stprintf_s( atcP[1] , _countof(atcP[1]) , GLMsg(280) , iPT ) ;
				_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(270) , iP , iPm , atcP[0] , iT , iTm , atcP[1] ) ;

				strTmp = atcTmp ;
				pTask->SetString( strTmp ) ;
				GL::RequestRedraw() ;
			}
		}
	}
	if( KeyPush( KC_F9 ) )
	{
		_TCHAR atcTmp[512] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(5) , GL::RS.GetFileName().c_str() ) ;
		GL::RS.SaveBitmapPage( &GL::mdo , atcTmp ) ;
		_TCHAR atcTmp2[512] ;
		_stprintf_s( atcTmp2 , _countof(atcTmp2) , GLMsg(298) , atcTmp ) ;
		GL::AlertS( atcTmp2 ) ;
	}
	if( iLockButton>=0 )
	{
		Task0810 *pTask ;
		switch( iLockButton )
		{
		case 0:
			pTask = new LockTileEditor( this ) ;
			break ;
		case 1:
			pTask = new LockPageEditor( this ) ;
			break ;
		default:
			assert( 0 ) ;
		}
		if( pTask )
		{
			hLockTask = pTask->GetHandle() ;
			MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
			assert( pTask ) ;
			pTask->SetDrawState( 0 , 0 , 0 ) ;
			this->Sleep( this->SearchTask( TP_UILayer ) ) ;
		}
		iLockButton = -1 ;
	}
	return ;
}
void MapEditor::Fdest()
{
	return ;
}
void MapEditor::Fdraw()
{
	return ;
}
