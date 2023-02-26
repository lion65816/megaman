#include "../common.h"

#define IncXOrReturn()		{if(!pTask){return;}tRect.x+=pTask->GetRect().w;}
#define IncYOrReturn()		{if(!pTask){return;}tRect.y+=pTask->GetRect().h;}
#define DecYOrReturn()		{if(!pTask){return;}tRect.y-=pTask->GetRect().h;}

static const int ciX0 = 20 ;

void SpEditor::Finit()
{
	pstrEnemyPat = NULL ;
	if( !GL::RS.IsValid() ){return;}
	iButton = 0 ;
	MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
	assert( pTask ) ;
	pTask->SetDrawState( 0 , 0 , 0 ) ;
	GL::RS.ExportSpData( aucData ) ;

	{
		TaskObject *pTask ;
		Task1206Rect tRect = {ciX0,20,8,16,0} ;

		{//多重ステージの境界
			int iNOMP = GL::RS.ExportMultiplexPage( aucMultiplexPage ) ;
			if( iNOMP )
			{
				pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(556) , -1 , -1 , -1 ) ;
				IncXOrReturn() ;
				pTask = new TaskObjectBinaryEditor( this , true , tRect , aucMultiplexPage , 1 , iNOMP , -1 ) ;
				IncYOrReturn() ;
				IncYOrReturn() ;
				tRect.x = ciX0 ;
			}
		}


		RS_SpData tSp = {0} ;
		int iRV ;
		for( ; (iRV=GL::RS.LoadSpData(&tSp))!=-1 ; )
		{
			static const int ciYSpan = 8 ;
			if( tSp.iEditMsg )
			{
				int iEditSize = (tSp.iEditSize>=0?tSp.iEditSize:tSp.iSize) ;
				if( iRV==101 || iRV==102 )
				{//ロックマン1の復活地点の例外
					pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(tSp.iEditMsg) , -1 , -1 , -1 ) ;
					IncXOrReturn() ;
					pTask = new TaskObjectBinaryEditor( this , true , tRect , aucData+tSp.iDataOffset , 1 , iEditSize , tSp.iEditLine ) ;
					IncXOrReturn() ;

					if( iRV ==102 )
					{
						IncYOrReturn() ;
						tRect.x = ciX0 ;
					}
					else
					{
						tRect.y -= ciYSpan ;
					}
				}
				else if( iEditSize > 8 || tSp.iEditLine>=2 )
				{
					pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(tSp.iEditMsg) , -1 , -1 , -1 ) ;
					IncYOrReturn() ;
					switch( iRV )
					{
					case 201:
						{
							Task1206Rect tRect2 = tRect ;
							tRect2.h = 20 ;
							tRect2.w = 200 ;
							pTask = new TaskObjectButton( this , false , tRect2 ,  14 , GLMsg(495) , NULL , &iButton , (void*)201 ) ;
							tRect2.x += tRect2.w ;
							pTask = new TaskObjectButton( this , false , tRect2 ,  14 , GLMsg(496) , NULL , &iButton , (void*)202 ) ;
							IncYOrReturn() ;

						}
					break ;
					case 303:
						{
							Task1206Rect tRect2 = tRect ;
							tRect2.h = 20 ;
							tRect2.w = 300 ;
							pTask = new TaskObjectButton( this , false , tRect2 ,  14 , GLMsg(567) , NULL , &iButton , (void*)303 ) ;
							IncYOrReturn() ;
						}
					break;
					default:
						;
					}
					pTask = new TaskObjectBinaryEditor( this , true , tRect , aucData+tSp.iDataOffset , 1 , iEditSize , tSp.iEditLine ) ;
					IncYOrReturn() ;

				}
				else
				{
					pTask = new TaskObjectBinaryEditor( this , true , tRect , aucData+tSp.iDataOffset , 1 , iEditSize , tSp.iEditLine ) ;
					IncXOrReturn() ;
					tRect.x += 8 ;
					pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(tSp.iEditMsg) , -1 , -1 , -1 ) ;
					IncXOrReturn() ;
					tRect.x += 8 ;

					switch( iRV )
					{
					case 301:
					case 302:
						{
							Task1206Rect tRect2 = tRect ;
							tRect2.w = 120 ;
							pTask = new TaskObjectButton( this , false , tRect2 ,  14 , GLMsg(565+iRV-301) , NULL , &iButton , (void*)iRV ) ;
							tRect2.x += tRect2.w ;
						}
					break ;
					default:
						;
					}

					IncYOrReturn() ;
					tRect.x = ciX0 ;
				}
				tRect.y += ciYSpan ;
			}
			else
			{
				switch( iRV )
				{
				case 103:
					{
						Task1206Rect tRect2 = tRect ;
						tRect2.w = 140 ;
						pTask = new TaskObjectButton( this , false , tRect2 ,  14 , GLMsg(610) , NULL , &iButton , (void*)iRV ) ;
						IncYOrReturn() ;
						tRect.y += ciYSpan ;
					}
				break; 
				}
			}
		}
	}


	GL::RequestRedraw() ;
	return ;
}
void SpEditor::Fmain()
{
	if( !GL::RS.IsValid() ){return;}
	{
		TaskObjectBinaryEditor *pBE ;
		for( int i=0 ;; i++ )
		{
			pBE = (TaskObjectBinaryEditor*)SolveHandle( SearchTask( TP_BINARY_EDITOR , TP_BINARY_EDITOR , i ) ) ;
			if( !pBE ){break;}
			if( pBE->IsChanged() )
			{
				GL::RS.ImportSpData( aucData ) ;
				GL::RS.ImportMultiplexPage( aucMultiplexPage ) ;
				GL::iStageUpdated = 1 ;
			}
		}
	}
	{
		switch( iButton )
		{
		case 103:
			{
				GL::RS.AutoSpData_1_0() ;
				GL::RS.ExportSpData( aucData ) ;
			}
		break ;
		case 201:
			{//ルーム#の自動設定
				GL::RS.AutoSpData_2_0() ;
				GL::RS.ExportSpData( aucData ) ;
			}
		break ;
		case 202:
			{//いくつかの項目の自動設定
				GL::RS.AutoSpData_2_1() ;
				GL::RS.ExportSpData( aucData ) ;
			}
		break ;
		case 301:
			{
				int iRV = GL::RS.AutoSpData_3_1() ;
				GL::RS.ExportSpData( aucData ) ;
				if( iRV>=0 )
				{
					TCHAR atcTmp[256] ;
					_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(570) , iRV ) ;
					GL::Alert( atcTmp ) ;
				}
			}
		break ;
		case 302:
			{
				GL::RS.AutoSpData_3_2() ;
				GL::RS.ExportSpData( aucData ) ;
			}
		break ;
		case 303:
			{
				int iRV ;
				tstring strMessage=_T("") ;
				if( !pstrEnemyPat )
				{
					pstrEnemyPat = new tstring[256] ;
					GL::LoadNameTable( pstrEnemyPat , 256 , GLMsg(571) ) ;
				}
				iRV = GL::RS.AutoSpData_3_3( pstrEnemyPat , &strMessage ) ;
				if( iRV>=0 )
				{
					TCHAR atcTmp[256] ;
					_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(572) , iRV ) ;
					GL::Alert( atcTmp ) ;
				}
				else
				{
					GL::AlertS( strMessage.c_str() ) ;
				}
				GL::RS.ExportSpData( aucData ) ;
			}
		break ;
		default:
			;
		}
		if( iButton )
		{
			GL::iStageUpdated = 1 ;
			GL::RequestRedraw(); 
		}
		iButton = 0 ;
	}
	if( KeyPush( KC_F9 ) )
	{
		_TCHAR atcTmp[512] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(6) , GL::RS.GetFileName().c_str() ) ;
		GL::RS.SaveBitmapMap( &GL::mdo , atcTmp ) ;
		_TCHAR atcTmp2[512] ;
		_stprintf_s( atcTmp2 , _countof(atcTmp2) , GLMsg(299) , atcTmp ) ;
		GL::AlertS( atcTmp2 ) ;
	}

	return ;
}
void SpEditor::Fdest()
{
	if( pstrEnemyPat ){ delete []pstrEnemyPat ; }
	if( !GL::RS.IsValid() ){return;}
	return ;
}
void SpEditor::Fdraw()
{
	if( !GL::RS.IsValid() ){return;}
	return ;
}
