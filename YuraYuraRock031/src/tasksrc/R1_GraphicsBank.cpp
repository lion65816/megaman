#include "../common.h"

#define IncXOrReturn()		{if(!pTask){return;}tRect.x+=pTask->GetRect().w;}
#define IncYOrReturn()		{if(!pTask){return;}tRect.y+=pTask->GetRect().h;}

void R1_GraphicsBank::Finit()
{
	MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
	assert( pTask ) ;
	pTask->SetDrawState( 0 , 0 , 0 ) ;
	if( !GL::RS.IsValid() ){return;}

	iButton = -1 ;
	ucRoomLock = 1 ;
	GL::RS.ExportSpData( aucData ) ;
	memcpy( aucPrev , aucData , sizeof(aucPrev) ) ;

	{//VRAMデータのロード
		tstring strNameTable[256] ;
		GL::LoadNameTable( strNameTable , _countof(strNameTable) , GLMsg(635) ) ;
		for( int i=0 ; i<_countof(aiObjVRAMPat)/ciVRAMLines ; i++ )
		{
			for( int q=0 ; q<ciVRAMLines ; q++ )
			{
				aiObjVRAMPat[i*ciVRAMLines+q] = 0 ;
				tstring strTmp = strNameTable[i].substr( q*2 , 2 ) ;
				int iTmp ;
				if( _stscanf_s( strTmp.c_str() , _T("%02X") , &iTmp ) == 1 )
				{
					aiObjVRAMPat[i*ciVRAMLines+q] = iTmp ;
				}
			}
		}
		GL::LoadNameTable( strNameTable , _countof(strNameTable) , GLMsg(636) ) ;
		for( int i=0 ; i<ciLongStages ; i++ )
		{
			for( int q=0 ; q<ciVRAMLines ; q++ )
			{
				aiBossVRAMPat[i*ciVRAMLines+q] = 0 ;
				tstring strTmp = strNameTable[i].substr( q*2 , 2 ) ;
				int iTmp ;
				if( _stscanf_s( strTmp.c_str() , _T("%02X") , &iTmp ) == 1 )
				{
					aiBossVRAMPat[i*ciVRAMLines+q] = iTmp ;
				}
			}
		}
	}
	{//実データ
		TaskObject *pTask ;
		Task1206Rect tRect = {20,20,8,16,0} ;
		{
			Task1206Rect tRect2  ;
			pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(644) , -1 , -1 , -1 ) ;
			IncYOrReturn() ;
			pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(637) , -1 , -1 , -1 ) ;
			IncYOrReturn() ;
			tRect2 = tRect ;
			pTask = new TaskObjectBinaryEditor( this , true , tRect , aucData+ciSpOff_GrpOffset , 1 , ciSpSize_GrpOffset , 0x10 ) ;
			hBEOffset = pTask->GetHandle() ;
			IncXOrReturn() ;
			tRect.w = tRect.h ;
			tRect.x += 16 ;
			pTask = new TaskObjectCheckBox( this , true , tRect , GLMsg(639) , &ucRoomLock ) ;
			tRect = tRect2 ;
			{//ルームの表示
				tstring strTmp = _T("") ;
				int iRemain = 0 ;
				int iRoomNo = 0 ;
				for( int iP=0 ; iP<ciSpSize_GrpOffset ; iP++ )
				{
					if( iRemain )
					{
						strTmp += _T("   ") ;
					}
					else
					{
						strTmp += GLMsg(640) ;
						strTmp += _T(" ") ;
						iRoomNo ++ ;
						if( iRoomNo < ciSpSize_RoomConnection )
						{
							iRemain = (aucData[ciSpOff_RoomConnection+iRoomNo]&0x1F)+1 ;
						}
						else
						{
							iRemain = 0xFF ;
						}
					}
					aiRoomNo[ iP ] = iRoomNo ;
					iRemain--;

					if( iP%0x10 == 0x0F )
					{
						strTmp += _T("\n") ;
					}

				}
				tRect.x -= 8 ;
				pTask = new TaskObjectBoxText( this , false , tRect , strTmp.c_str() , RGB(0,0,255) , -1 , -1 ) ;
				tRect.x += 8 ;
			}
			IncYOrReturn() ;
			tRect.y += 8 ;
			{
				pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(642) , -1 , -1 , -1 ) ;
				IncXOrReturn() ;
				for( int i=0 ; i<ciSp_NOGrp ; i++ )
				{
					int iOffset = ciSpOff_GrpData + i*ciSp_SizePerGrp ;
					pTask = new TaskObjectBinaryEditor( this , true , tRect , aucData+iOffset , 1 , ciSp_SizePerGrp , -1 ) ;
					{
						Task1206Rect tRect2 = tRect ;
						IncXOrReturn() ;
						tRect.x += 8 ;
//						tRect.h = 20 ;
						tRect.w = 100 ;
						pTask = new TaskObjectButton( this , false , tRect ,  14 , GLMsg(643) , NULL , &iButton , (void*)(i*ciSp_SizePerGrp) ) ;
						tRect = tRect2 ;
					}
					IncYOrReturn() ;
				}
			}


		}
	}
	return ;
}
void R1_GraphicsBank::Fmain()
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
				{//ルームロック
					if( ucRoomLock && hBEOffset==pBE->GetHandle() )
					{
						int iDestRoom = -1 ;
						int iDestValue = -1 ;
						for( int i=0 ; i<ciPages ; i++ )
						{
							int iOffset = ciSpOff_GrpOffset+i ;
							if( aucPrev[iOffset] != aucData[iOffset] )
							{
								iDestRoom = aiRoomNo[i] ;
								iDestValue = aucData[iOffset] ;
								break ;
							}
						}
						for( int i=0 ; i<ciPages ; i++ )
						{
							int iOffset = ciSpOff_GrpOffset+i ;
							if( aiRoomNo[i] == iDestRoom )
							{
								aucData[iOffset] = iDestValue ;
								if( !(pBE->GetSelectedPosition()%2) )
								{
									pBE->SetSelectedPosition( i*2+2 ) ;
								}
							}
						}
					}
					memcpy( aucPrev , aucData , sizeof(aucPrev) ) ;
				}

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
			iRV = GL::RS.AutoObjBankData_1( iButton , aiObjVRAMPat , aiBossVRAMPat ) ;
			if( iRV>=0 )
			{
				_TCHAR atcTmp[256] ;
				tstring strTmp ;
				_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(645) , iRV ) ;
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
void R1_GraphicsBank::Fdest()
{
	return ;
}
void R1_GraphicsBank::Fdraw()
{
	if( !GL::RS.IsValid() ){return;}
	return ;
}
