#include "../common.h"

void ObjectEditor::Finit()
{
	MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
	assert( pTask ) ;
	pTask->SetDrawState( 0 , 0 , 0 ) ;

	if( !GL::RS.IsValid() ){return;}

	pTask->SetDrawState( 1 , 0 , 1+iOUNO ) ;

	if( !GL::RS.IsEditObject() ){return;}


	{
		Task1206Rect tRect = {0,0,256,14,3} ;
		iListValue = 0 ;
		GL::LoadNameTable( strNameTable , _countof(strNameTable) , GLMsg(235+GL::RS.GetEditMode()-1) ) ;
		new TaskObjectRotateList( this , true , tRect , 24 , &iListValue , strNameTable , 256 , 4 ) ;
	}

	memset( aucParam , 0 , sizeof( aucParam) ) ;
	{
		Task1206Rect tRect = {0,0,0,20,2} ;
		new TaskObjectBinaryEditor( this , true , tRect , aucParam , 1 , _countof(aucParam) , -1 )  ;
	}

	{
		tstring strTmp[256] ;
		int aiDy[256] ;
		GL::LoadNameTable( strTmp , _countof(strTmp) , GLMsg(241+GL::RS.GetEditMode()-1) ) ;
		for( int i=0 ; i<256 ; i++ )
		{
			aiDy[i] = 0 ;
			_stscanf_s( strTmp[i].c_str() , _T("%d") , aiDy+i ) ;
		}
		GL::RS.SetObjDeltaYList( &aiDy , iOUNO ) ;
	}

	{//メッセージ用タスク用意
		Task1206Rect tRect={0,20,8,16,2} ;
		TaskObjectBoxText *pTask ;
		pTask = new TaskObjectBoxText( this , true , tRect ,_T("") , -1 , -1 , -1 ) ;
		hText = 0 ;
		if( pTask ){ hText = pTask->GetHandle(); }
	}
	UpdateText() ;

	GL::RS.SetObjParamPointer( aucParam , &iListValue , iOUNO ) ; 
	SetProcessOrderPandC( false , true ) ;
	GL::RequestRedraw() ;
	return ;
}
void ObjectEditor::Fmain()
{
	if( !GL::RS.IsValid() || !GL::RS.IsEditObject() ){return;}
	{//ローテートリストからオブジェクトデータの書き出し
		TaskObjectRotateList *pTask ;
		pTask = (TaskObjectRotateList*)SolveHandle( SearchTask( TP_ROTATE_LIST ) ) ;
		if( pTask && pTask->IsChanged() )
		{
			aucParam[3] = iListValue ;
			if( GL::RS.SetObjParam( 3 , iListValue , iOUNO ) )
			{ GL::iStageUpdated = 1 ;GL::RequestRedraw() ; }
		}
	}
	{//バイナリエディタからのオブジェクトデータの書き出し
		TaskObjectBinaryEditor *pTask ;
		pTask = (TaskObjectBinaryEditor*)SolveHandle( SearchTask( TP_BINARY_EDITOR ) ) ;
		if( pTask && pTask->IsChanged() )
		{
			iListValue = aucParam[3] ;
			int iOffset = pTask->GetLastChanged() ;
			if( GL::RS.SetObjParam( iOffset , aucParam[iOffset] , iOUNO ) )
			{ GL::iStageUpdated = 1 ;GL::RequestRedraw() ; }
		}
	}
	{//ロックマン1と6用のオブジェクト再配置
		if( IsRemapableObj() && KeyPush( KC_ENTER ) && KeyOn( KC_CTRL ) )
		{
			int iCurSize , iMaxSize ;
			int iMsgNo = 274 ;
			int iRV ;
			InvalidateKeyCode( KC_ENTER ) ;
			iRV = GL::RS.RemapObject( NULL , &iCurSize , &iMaxSize ) ;
			if( iRV ){ iMsgNo = 275 ; }
			GL::iStageUpdated = 1 ;
			GL::RequestRedraw() ;
			UpdateText() ;

			_TCHAR atcTmp[256] ;
			_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(iMsgNo) , iCurSize , iMaxSize ) ;
			if( iRV ){ GL::Alert( atcTmp ) ; }
			else { GL::AlertS( atcTmp ) ; }
			
		}
	}
	{//オブジェクト処理
		int ix , iy ;
		this->GetGlobalPosition( &ix , &iy ,  2 ) ;
		if( GL::RS.ProcessObj( ix , iy , iOUNO ) )
		{
			GL::iStageUpdated = 1 ;
			GL::RequestRedraw() ;
			UpdateText() ;
		}
	}
	{//リストの有効・無効を設定
		int iObjSelected = 1 ;
		if( GL::RS.GetObjSelection(iOUNO) == -1 ){ iObjSelected = 0 ; }
		{//ローテートリストからオブジェクトデータの書き出し
			TaskObjectRotateList *pTask ;
			pTask = (TaskObjectRotateList*)SolveHandle( SearchTask( TP_ROTATE_LIST ) ) ;
			if( pTask ){ if( iObjSelected ){pTask->Validate();}else{pTask->Invalidate();} }
		}
		{//バイナリエディタからのオブジェクトデータの書き出し
			TaskObjectBinaryEditor *pTask ;
			pTask = (TaskObjectBinaryEditor*)SolveHandle( SearchTask( TP_BINARY_EDITOR ) ) ;
			if( pTask ){ if( iObjSelected ){pTask->Validate();}else{pTask->Invalidate();} }
		}
	}
	return ;
}
void ObjectEditor::Fdest()
{
	if( !GL::RS.IsValid() ){return;}
	GL::RS.ReleaseObjParamPointer(  aucParam , &iListValue , iOUNO ) ; 
	return ;
}
void ObjectEditor::Fdraw()
{
	if( GL::RS.IsValid() && !GL::RS.IsEditObject() )
	{
		GL::mdo.BoxMoji( GL::SFC_BACK , GLMsg(277) , 0 , (GL::WINHEIGHT-24)/2 , 24 , 12 ) ;
	}
	return ;
}
void ObjectEditor::UpdateText()
{
	TaskObjectBoxText *pTask = (TaskObjectBoxText *)SolveHandle( hText ) ;
	if( pTask )
	{
		int iRV,iObj,iObjMax ;
		iRV = GL::RS.GetObjCount( &iObj , &iObjMax , iOUNO ) ;
		if( !iRV )
		{
			pTask->SetColor1( RGB(0,0,0) ) ;
		}else{
			pTask->SetColor1( RGB(200,0,0) ) ;
		}
		_TCHAR atcTmp[256] ;
		tstring strTmp ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(272) , iObj , iObjMax ) ;
		strTmp = atcTmp ;
		if( IsRemapableObj() )
		{
			strTmp = strTmp + _T(" ") ;
			strTmp = strTmp + GLMsg(273) ;
		}
		pTask->SetString( strTmp ) ;
		GL::RequestRedraw() ;
	}
}
int ObjectEditor::IsRemapableObj()
{
	int iMode = GL::RS.GetEditMode() ;
	if( ( iMode==1 || iMode==6 ) &&
		GL::iDirectEditMode )
	{
		return 1 ;
	}
	return 0 ;
}