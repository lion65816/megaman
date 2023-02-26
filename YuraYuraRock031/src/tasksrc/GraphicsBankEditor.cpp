#include "../common.h"

#define IncXOrReturn()		{if(!pTask){return;}tRect.x+=pTask->GetRect().w;}
#define IncYOrReturn()		{if(!pTask){return;}tRect.y+=pTask->GetRect().h;}

void GraphicsBankEditor::Finit()
{
	iButton = -1 ;
	MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
	assert( pTask ) ;
	pTask->SetDrawState( 0 , 0 , 0 ) ;
	GL::RS.ExportSpData( aucData ) ;

	{//VRAMデータのロード
		tstring strNameTable[256] ;
		GL::LoadNameTable( strNameTable , _countof(strNameTable) , GLMsg(515) ) ;
		for( int i=0 ; i<256 ; i++ )
		{
			for( int q=0 ; q<6 ; q++ )
			{
				aiObjVRAMPat[i*6+q] = 0 ;
				tstring strTmp = strNameTable[i].substr( q*4 , 4 ) ;
				int iTmp ;
				if( _stscanf_s( strTmp.c_str() , _T("%04X") , &iTmp ) == 1 )
				{
					aiObjVRAMPat[i*6+q] = iTmp ;
				}
			}
		}
		GL::LoadNameTable( strNameTable , _countof(strNameTable) , GLMsg(516) ) ;
		for( int i=0 ; i<14 ; i++ )
		{
			for( int q=0 ; q<6 ; q++ )
			{
				aiBossVRAMPat[i*6+q] = 0 ;
				tstring strTmp = strNameTable[i].substr( q*4 , 4 ) ;
				int iTmp ;
				if( _stscanf_s( strTmp.c_str() , _T("%04X") , &iTmp ) == 1 )
				{
					aiBossVRAMPat[i*6+q] = iTmp ;
				}
			}
		}
	}


	{//オブジェクト配置
		TaskObject *pTask ;
		Task1206Rect tRect = {20,20,8,16,0} ;

		pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(510) , -1 , -1 , -1 ) ;
		IncYOrReturn() ;
		pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(511) , -1 , -1 , -1 ) ;
		IncYOrReturn() ;
		pTask = new TaskObjectBinaryEditor( this , true , tRect , aucData+0x180 , 1 , 0x20 , 0x10 ) ;
		IncYOrReturn() ;
		IncYOrReturn() ;

		pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(512) , -1 , -1 , -1 ) ;
		IncYOrReturn() ;

		pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(513) , -1 , -1 , -1 ) ;
		IncXOrReturn() ;
		for( int i=0 ; i<14 ; i++ )
		{
			pTask = new TaskObjectBinaryEditor( this , true , tRect , aucData+0x200+i*0x12 , 1 , 0x12 , -1 ) ;
			int iX0 = tRect.x ;
			IncXOrReturn();
			{
				Task1206Rect tRect2 = tRect ;
				tRect2.x += 8 ;
//				tRect2.h = 20 ;
				tRect2.w = 100 ;
				pTask = new TaskObjectButton( this , false , tRect2 ,  14 , GLMsg(514) , NULL , &iButton , (void*)(i*0x12) ) ;
			}
			tRect.x = iX0 ;
			IncYOrReturn() ;
		}


		tRect.y += tRect.h ;
	}


	GL::RequestRedraw() ;
	return ;
}
void GraphicsBankEditor::Fmain()
{
	{
		TaskObjectBinaryEditor *pBE ;
		for( int i=0 ;; i++ )
		{
			pBE = (TaskObjectBinaryEditor*)SolveHandle( SearchTask( TP_BINARY_EDITOR , TP_BINARY_EDITOR , i ) ) ;
			if( !pBE ){break;}
			if( pBE->IsChanged() )
			{
				GL::RS.ImportSpData( aucData ) ;
				GL::iStageUpdated = 1 ;
				GL::RequestRedraw();
			}
		}
	}
	{
		if( iButton!=-1 )
		{
			int iRV ;
			iRV = GL::RS.AutoObjBankData_2( iButton , aiObjVRAMPat , aiBossVRAMPat ) ;
			if( iRV>=0 )
			{
				_TCHAR atcTmp[256] ;
				tstring strTmp ;
				_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(517) , iRV ) ;
				GL::Alert( atcTmp ) ;
			}
			GL::RS.ExportSpData( aucData ) ;
			GL::iStageUpdated = 1 ;
			GL::RequestRedraw();
		}
		iButton = -1 ;
	}

	return ;
}
void GraphicsBankEditor::Fdest()
{
	return ;
}
void GraphicsBankEditor::Fdraw()
{
	return ;
}
