#include "RockStage_p.h"

int RockStage::ImportFromRom( int iStageNO )
{
	iIsValid = 0 ;
	if( iStageNO<0 || iStageNO>=aciNOStage[iEditMode-1] )
	{
		return -1 ;
	}
	if( iEditMode==3 && iStageNO==0x12 )
	{
		return -1 ;
	}
	iIsValid = 1 ;
	this->iStageNO = iStageNO ;
	aiMultiplexOriginalPage[0] = aiMultiplexOriginalPage[1] = -1; 
	CorrectEditModeStageNORomDependedValue() ;
	OU[0].Initialize(iMaxObjectAlloc,iEditMode) ;
	OU[1].Initialize(iMaxObjectAlloc,iEditMode) ;
	OU[2].Initialize(iMaxObjectAlloc,iEditMode) ;
	OU[0].SetPositionLimit( 0 , 0 , iProcessPageCount*256-1 , 255 ) ;
	OU[1].SetPositionLimit( 0 , 0 , iProcessPageCount*256-1 , 255 ) ;
	OU[2].SetPositionLimit( 0 , 0 , iProcessPageCount*256-1 , 255 ) ;


	{//特殊データを展開する
		memset( aucSpData , 0 , sizeof(aucSpData) ) ;
		RS_SpData tSp = {0} ;
		for( ; LoadSpData(&tSp)!=-1 ; )
		{
			if( tSp.iAddrDeltaD==1 )
			{
				memcpy( aucSpData+ tSp.iDataOffset , ROMp(tSp.iAddrBase+iStageNO*tSp.iAddrDeltaS) , tSp.iSize ) ;
			}
			else
			{
				for( int i=0 ; i<tSp.iSize ; i++ )
				{
					aucSpData[tSp.iDataOffset+i] = GetROM8p(tSp.iAddrBase+iStageNO*tSp.iAddrDeltaS+i*tSp.iAddrDeltaD) ;
				}
			}
		}
	}
	{//多重ステージの設定(設定可能のもの)
		switch( iEditMode )
		{
		case 3:
			{
				if( iStageNO==0xD )
				{
					OU[2].ImportFromROM( iEditMode , ROMp(aiAddrObjectPage[0]) , ROMp(aiAddrObjectX[0]) ,
							 ROMp(aiAddrObjectY[0]) , ROMp(aiAddrObjectType[0]) ,
							 aiMaxObject[0] , iProcessPageCount ) ;
					aiMultiplexOriginalPage[0] = OU[2].GetMaxPage()+1 ;
					OU[2].ImportFromROM_m( iEditMode , ROMp(aiAddrObjectPage[0]+aiMultiplexStage_DeltaAddr[0]) , ROMp(aiAddrObjectX[0]+aiMultiplexStage_DeltaAddr[0]) ,
										ROMp(aiAddrObjectY[0]+aiMultiplexStage_DeltaAddr[0]) , ROMp(aiAddrObjectType[0]+aiMultiplexStage_DeltaAddr[0]) ,
										iMaxObjectAlloc , iProcessPageCount , aiMultiplexOriginalPage[0] ) ;
					aiMultiplexOriginalPage[1] = OU[2].GetMaxPage()+1 ;
				}
			}
		break ;
		case 5:
			switch( iStageNO )
			{
			case 0x08: case 0x0E:
				{
					OU[2].ImportFromROM( iEditMode , ROMp(aiAddrObjectPage[0]) , ROMp(aiAddrObjectX[0]) ,
							 ROMp(aiAddrObjectY[0]) , ROMp(aiAddrObjectType[0]) ,
							 aiMaxObject[0] , iProcessPageCount ) ;
					aiMultiplexOriginalPage[0] = OU[2].GetMaxPage()+1 ;
				}
			break ;
			}
		break;
		}
	}
	{//チップを展開する
		switch( iChipMethod )
		{
		case 0: //3,4,5,6タイプ
			memset( aucChip , 0 , sizeof(aucChip) ) ;
			memcpy_s( aucChip , _countof(aucChip) , ROMp(iAddrChip) ,
				min(sizeof(aucChip),ROMRemp(iAddrChip)) ) ;
			memset( aucChipHit , 0 , sizeof(aucChipHit) ) ;
			memcpy_s( aucChipHit , _countof(aucChipHit) , ROMp(iAddrChipHit) , 
				min(sizeof(aucChipHit),ROMRemp(iAddrChipHit)) ) ;
		break ;
		case 1: //2タイプ
		case 2: //1タイプ
			{
				int iDefHitCount ;
				int iHitTypeCount ;
				if( iChipMethod==1 )
				{
					iDefHitCount = 5 ;
					iHitTypeCount = 8 ;
				}
				else
				{
					iDefHitCount = 7 ;
					iHitTypeCount = 7 ;
				}
				for( int q=0 ; q<4 ; q++ )
				{
					for( int i=0 ; i<64 ; i++ )
					{
						aucChip[ 0x000 + q*64 + i ] = i*4 + 0 ;
						aucChip[ 0x100 + q*64 + i ] = i*4 + 2 ;
						aucChip[ 0x200 + q*64 + i ] = i*4 + 1 ;
						aucChip[ 0x300 + q*64 + i ] = i*4 + 3 ;
						aucChipHit[ q*64 + i ] = 0x08|q ;
					}
				}
				{//当たり判定を読み込む(最初の一つが残る)
					int aiChipHitOfCurStage[4] ;
					for( int iTiP=0 ; iTiP<ciTilePPageS*iMaxPage ; iTiP++ )
					{
						Rock12_GetHitPattern( aiChipHitOfCurStage , iTiP ) ;
						int iTile = GetROM8p( iAddrPage+iTiP ) ;
						for( int iCiT=0 ; iCiT<ciChipPTileS ; iCiT++ )
						{
							int iChipRaw = GetROM8p( iAddrTile+iTile*ciChipPTileS+iCiT ) ;
							int iChipNo ;
							int iHitVal ;
							int iColNo ;
							iChipNo = (iChipRaw & 0x3F) ;
							iHitVal = aiChipHitOfCurStage[iChipRaw>>6] ;
							static const int ShiftTable[4] = {0,4,2,6} ;
							iColNo = ( (GetROM8p( iAddrTileColor+iTile ) >> ShiftTable[iCiT] ) &0x03 ) ;
							if( (aucChipHit[ iColNo*0x40+iChipNo ] & 0x08) )
							{
								aucChipHit[ iColNo*0x40+iChipNo ] &= 0x03 ;
								aucChipHit[ iColNo*0x40+iChipNo ] |= iHitVal*16 ;
							}
						}
					}
					//トゲなどのデフォルトを一応考慮しておく
					for( int i=0 ; i<4 ; i++ )
					{
						for( int q=0 ; q<iDefHitCount ; q++ )
						{
							int aiDefHit[16] = { 
								0x00,0x00,0x20,0x20,0x30,0x20,0x00
							} ;
							int iOff ;

							if( iOff=i*0x40+q , aucChipHit[iOff]&0x08 ){ aucChipHit[iOff] = aiDefHit[q]+(aucChipHit[iOff]&3) ; }
						}
					}
					//一つは存在する形にしておく
					for(int i=0 ; i<iHitTypeCount ; i++ )
					{
						int q ;
						for( q=0 ; q<256 ; q++ )
						{
							if( (aucChipHit[ q ] >> 4) == i ){ break; }
						}
						if( q<256 ){continue;}
						for( q=0 ; q<256 ; q++ )
						{
							if( aucChipHit[ q ] & 0x08 )
							{ 
								aucChipHit[ q ] &= 0x03 ;
								aucChipHit[ q ] |= i*16 ;
								break;
							}
						}
					}
					for( int i=0 ; i<256 ; i++ )
					{
						if( aucChipHit[ i ] & 0x08 )
						{ 
							aucChipHit[ i ] &= 0x03 ;
						}
					}
				}
			}
		break ;
		}
	}
	if( iHaveVChip )
	{//変化チップを展開する(ロックマン６向け)
		int iAddr = GetROM8p( 0x3EDF55 + iStageNO ) * 0x10000 + 0x9B00 ;
		memset( aucVChip , 0 , sizeof(aucVChip) ) ;
		memset( aucVChipHit , 0 , sizeof(aucVChipHit) ) ;
		memset( aucVChipValid , 0 , sizeof(aucVChipValid) ) ;
		memcpy_s( aucVChip , _countof(aucVChip) , ROMp(iAddr) , 
			min(sizeof(aucVChip),ROMRemp(iAddr)) ) ;
		memcpy_s( aucVChipHit , _countof(aucVChipHit) , ROMp(iAddr+0x400) , 
			min(sizeof(aucVChipHit),ROMRemp(iAddr+0x400)) ) ;
		{
			int iTblAddr = GetROM8p( 0x3EDB03 + iStageNO )*0x10 + 0x3EDB13 ;
			for( int i=0 ; i<0x100 ; i++ )
			{//有効フラグを確かめる/この処理は通常チップが破壊可能かどうかで区別する
				int iHit =  aucChipHit[i]/16 ;
				switch( GetROM8p( iTblAddr + iHit ) )
				{
				case 0x2:
				case 0xB:
				case 0xD:
				case 0x1B:
					aucVChipValid[i] = 1 ;
					break ;
				default:
					;
				}
			}
		}
	}
	{//保護のためタイルを控えておく
		switch( iPreTileMethod )
		{
		case 0: //3,4,5,6
			{
				memcpy( aucPreTile , ROMp(iAddrTile) , iMaxTile*ciChipPTileS ) ;
				memset( aucPreTileHit , 0 , _countof( aucPreTileHit ) ) ;
				memset( aucPreTileFlag , ciLF_Default , _countof(aucPreTileFlag) ) ;
				memcpy( aucPrePage , ROMp(iAddrPage) , iMaxPage*ciTilePPageS ) ;
				memset( aucPrePageFlag , ciLF_Default , _countof(aucPrePageFlag) ) ;
				if( iEditMode==3 && iStageNO<8 )
				{//ブルース戦の後のタイルを保護
					int iAddr =  GetROM8p( 0x098271+iStageNO ) ;
					if( iAddr != 0xFF )
					{
						iAddr += 0x098279 ;
						for( int i=0 ; i<16 ; i++ )
						{
							int iTileNo = GetROM8p( iAddr+i ) ;
							if( iTileNo == 0xFF ){ break; }
							aucPreTileFlag[ iTileNo ] |= ciLF_Locked ;
						}
					}
				}
			}
		break ;
		case 1: //1,2
			{
				for( int iT=0 ; iT<iMaxTile ; iT++ )
				{
					int iWholeColor = GetROM8p(iAddrTileColor+iT) ;

					int aiChipHitOfCurStage[4]  ;
					{//そのタイルが利用されている回数を調べ、どの判定を利用するかを決定する
						int iCount[2] = {0,0} ;
						int iRefPage = 0 ;
						for( int iStg=0 ; iStg<2 ; iStg++ )
						{
							int iStartPage = 0 ;
							int iEndPage = 0 ;
							if( iStg )
							{
								iStartPage = R12_GetLatterPageNumber();
								iEndPage   =  R12_GetEndPageNumber();
							}
							else
							{
								iEndPage = R12_GetLatterPageNumber()-1;
							}
							for( int i=iStartPage ; i<=min(iEndPage,iProcessPageCount-1) ; i++ )
							{
								int iPageNo = i ;
								if( iAddrPageAddrList )
								{//1の場合
									int iAddr ;
									iPageNo = GetROM8p( iAddrPageList + i ) ;
									iAddr   = GetROM16p( iAddrPageAddrList + iPageNo*2 ) + (iAddrPageAddrList&0xFF0000) ;
									iPageNo = (iAddr-iAddrPage)/0x40 ;
								}
								if( iPageNo<0 || iPageNo>=iMaxPage ){ continue; }
								for( int iTS=0 ; iTS<0x40 ; iTS++ )
								{
									if( iT == GetROM8p( iAddrPage + iPageNo*0x40 + iTS ) )
									{ iCount[iStg]++; }
								}
							}
						}
						if( iCount[0] < iCount[1] ){ iRefPage = iProcessPageCount-1; }
						Rock12_GetHitPattern( aiChipHitOfCurStage , iRefPage*ciTilePPageS ) ;
					}

					for( int i=0 ; i<4 ; i++ )
					{
						static const int ciTbl[] = {0,2,1,3} ;
						int iRaw ;
						int iCol ;
						int iTileNo ;
						int iHit ;
						iRaw = GetROM8p(iAddrTile+iT*4+ciTbl[i]) ;
						iTileNo = iRaw&0x3F ;
						iHit    = iRaw>>6 ;
						iCol    = iWholeColor&3 ;
						iWholeColor >>= 2 ;
						aucPreTile[ iT*4+i ] = ( iTileNo | iCol<<6 ) ;
						aucPreTileHit[ iT*4+i ] = aiChipHitOfCurStage[iHit] ;
					}
				}
				memset( aucPreTileFlag , ciLF_Default , _countof(aucPreTileFlag) ) ;
				{//ページ展開
					memcpy( aucPrePage , ROMp(iAddrPage) , iMaxPage*ciTilePPageS ) ;
					memset( aucPrePageFlag , ciLF_Default , _countof(aucPrePageFlag) ) ;
				}
				if( iEditMode==1 )
				{//タイルの裏側を保護
					for( int i=0 ; i<4 ; i++ )
					{ aucPreTileFlag[aucSpData[ SPOf1_BehindTile+i ]] |= ciLF_Locked ;}

				}
			}
		break ;
		default:
			assert( 0 ) ;
		}
	}
	{//マップをチップに展開する
		memset( aucChipMap , 0 , _countof(aucChipMap) ) ;
		switch( iTilingMethod )
		{
		case 0:
			{
				int iPageListLoopTimes = iMaxPageList ;
				if( iPageListLoopTimes == 0 ){ iPageListLoopTimes = iMaxPage ; } ;
				for( int iNoListLoop=0 ; iNoListLoop<2 ; iNoListLoop++ )
				{
					if( iNoListLoop && !iAddrPageList ){break;}
				for( int iPageList=0 ; iPageList<iPageListLoopTimes ; iPageList++ )
				{//ページの回数ループ
					int iPage ;
					int iRock35Exception = 0 ;
					if( iMultiplexStage>=0 )
					{
						switch( iMultiplexStage )
						{
						case 313:
							{
								for( int q=0 ; q<2 ; q++ )
								{
									if(iPageList>=aiMultiplexOriginalPage[q])
									{
										iRock35Exception=aiMultiplexStage_DeltaAddr[q]-aiMultiplexOriginalPage[q];
									}
								}
							}
						break ;
						case 508: if(iPageList>=aiMultiplexOriginalPage[0]){ iRock35Exception=0x030000-aiMultiplexOriginalPage[0]; } break;
						case 514: if(iPageList>=aiMultiplexOriginalPage[0]){ iRock35Exception=0x010000-aiMultiplexOriginalPage[0]; } break;
						}
					}
					//多重ステージのゲームシーンでないステージは変数を-1にし、ページリストを無効にする
//					if( iEditMode==3 && (iStageNO==0x0E || iStageNO==0x10 ) ){ iRock35Exception=-1; }
					if( iEditMode==5 && (iStageNO==0x0B || iStageNO==0x0F || iStageNO==0x11 ) ){ iRock35Exception=-1; }
					//ページリストが有効で、多重ステージがあればページリストから読み、そうでなければ連番で読む
					if( iExportPageList && iRock35Exception>=0 ){iPage = GetROM8p( iAddrPageList+iPageList+iRock35Exception ) ; }
					else {iPage = iPageList ; }
					//ページリスト無し版用設定
					if( iNoListLoop ){iPage = iPageList ; }
					if( iPage >= iMaxPage ){ iPage = 0 ; }
					for( int iTiP=0 ; iTiP<ciTilePPageS ; iTiP++ )
					{
						int iTile = GetROM8p( iAddrPage+iPage*ciTilePPageS+iTiP ) ;
						for( int iCiT=0 ; iCiT<ciChipPTileS ; iCiT++ )
						{
							int iChip = GetROM8p( iAddrTile+iTile*ciChipPTileS+iCiT ) ;
							int iTx , iTy , iOffest ;
							iTx = iPageList*ciChipPPageW + 
								  iTiP%ciTilePPageW*ciChipPTileW +
								  iCiT%ciChipPTileW ;
							iTy = iNoListLoop*ciChipPPageH +
								  iTiP/ciTilePPageW*ciChipPTileH +
								  iCiT/ciChipPTileW ;
							iOffest = iTx + iTy*ciMaxAllocatePage*ciChipPPageW ;
							assert( iOffest<_countof(aucChipMap) )  ;
							aucChipMap[ iOffest ] = iChip ;
						}
					}
				}
				}//iNoListLoop
			}
		break ;
		case 1: //6方式
			for( int iTiP=0 ; iTiP<ciTilePPageS*iMaxPage ; iTiP++ )
			{
				int iTile = GetROM8p( iAddrPage+iTiP ) ;
				for( int iCiT=0 ; iCiT<ciChipPTileS ; iCiT++ )
				{
					int iChip = GetROM8p( iAddrTile+iTile*ciChipPTileS+iCiT ) ;
					int iTx , iTy , iOffest ;
					iTx = iTiP%(ciTilePPageW*iMaxPage)*ciChipPTileW +
						  iCiT%ciChipPTileW ;
					iTy = iTiP/(ciTilePPageW*iMaxPage)*ciChipPTileH +
						  iCiT/ciChipPTileW ;
					iOffest = iTx + iTy*ciMaxAllocatePage*ciChipPPageW ;
					assert( iOffest<_countof(aucChipMap) )  ;
					aucChipMap[ iOffest ] = iChip ;
				}
			}
		break ;
		case 2: //2方式
		case 3: //1方式
			{
				int aiChipHitOfCurStage[4]  ;
				int aiEgHitChip[8] = {0} ;
				for( int i=0 ; i<8 ; i++ )
				{
					for( int q=0 ; q<256 ; q++ )
					{
						if( aucChipHit[q]/16 == i ){ aiEgHitChip[i]=q; break; }
					}
				}
				for( int iTiP=0 ; iTiP<ciTilePPageS*iProcessPageCount ; iTiP++ )
				{
					int iTile ;
					Rock12_GetHitPattern( aiChipHitOfCurStage , iTiP ) ;
					if( iTilingMethod==3 )
					{
						int iPage = GetROM8p( iAddrPageList+iTiP/ciTilePPageS ) ;
						if( iPage >= 0x20 ){ iPage=0; }
						int iTileAddr = GetROM16p( iAddrPageAddrList+iPage*2 ) ;
						if( iTileAddr<0x8000 || iTileAddr>=0xC000 ){ iTileAddr=0x83C0; }
						iTile = GetROM8p( (iAddrPage&0xFF0000) + iTileAddr +iTiP%ciTilePPageS ) ;
					}
					else
					{
						iTile = GetROM8p( iAddrPage+iTiP ) ;
					}
					for( int iCiT=0 ; iCiT<ciChipPTileS ; iCiT++ )
					{
						int iChipRaw = GetROM8p( iAddrTile+iTile*ciChipPTileS+iCiT ) ;
						int iTx , iTy , iOffset ;
						int iChipNo ;
						int iHitVal ;
						int iTrueHitVal ;
						int iColNo ;
						iChipNo = (iChipRaw & 0x3F) ;
						iTrueHitVal = aiChipHitOfCurStage[iChipRaw>>6] ;
						//色取り出し
						assert( iCiT < 4 ) ;
						static const int ShiftTable[4] = {0,4,2,6} ;
						iColNo = ( (GetROM8p( iAddrTileColor+iTile ) >> ShiftTable[iCiT] ) &0x03 ) ;
						iHitVal = aucChipHit[iChipNo+iColNo*0x40]>>4 ;


						iTx = iTiP/ciTilePPageH*ciChipPTileW +
							  iCiT/ciChipPTileH ;
						iTy = iTiP%ciTilePPageH*ciChipPTileH +
							  iCiT%ciChipPTileH ;
						iOffset = iTx + iTy*ciMaxAllocatePage*ciChipPPageW ;
						assert( iOffset<_countof(aucChipMap) )  ;

						aucChipMap[ iOffset ] = iChipNo + iColNo*0x40 ;
						aucChipMap[ iOffset+ciMaxAllocatePage*ciChipPPageS ] = iChipNo + iColNo*0x40 ;
						if( iHitVal != iTrueHitVal )
						{
							aucChipMap[ iOffset+ciMaxAllocatePage*ciChipPPageS ] = aiEgHitChip[iTrueHitVal] ;
						}
					}
				}
			}
		break ;
		}
	}
	if( iImportObject )
	{//オブジェクトデータを展開する
		OU[0].ImportFromROM( iEditMode , ROMp(aiAddrObjectPage[0]) , ROMp(aiAddrObjectX[0]) ,
							 ROMp(aiAddrObjectY[0]) , ROMp(aiAddrObjectType[0]) ,
							 aiMaxObject[0] , iProcessPageCount ) ;
/*		if( iEditMode==1 )
		{
			OU[0].ImportFromROM_m( iEditMode , ROMp(aiAddrObjectPage[1]) , ROMp(aiAddrObjectX[1]) ,
								ROMp(aiAddrObjectY[1]) , ROMp(aiAddrObjectType[1]) ,
								iMaxObjectAlloc , iProcessPageCount , 0 ) ;
			aiMaxObject[0] += aiMaxObject[1] ;
			aiMaxObject[1] = 0 ;
		}
*/
		if( aiMaxObject[1] )
		{
			OU[1].ImportFromROM( iEditMode , ROMp(aiAddrObjectPage[1]) , ROMp(aiAddrObjectX[1]) ,
								 ROMp(aiAddrObjectY[1]) , ROMp(aiAddrObjectType[1]) ,
								 aiMaxObject[1] , iProcessPageCount ) ;
		}
		switch( iMultiplexStage )
		{
		case 313:
			{
				for( int q=0 ; q<2 ; q++ )
				{
					OU[0].ImportFromROM_m( iEditMode , ROMp(aiAddrObjectPage[0]+aiMultiplexStage_DeltaAddr[q]) , ROMp(aiAddrObjectX[0]+aiMultiplexStage_DeltaAddr[q]) ,
										ROMp(aiAddrObjectY[0]+aiMultiplexStage_DeltaAddr[q]) , ROMp(aiAddrObjectType[0]+aiMultiplexStage_DeltaAddr[q]) ,
										iMaxObjectAlloc , iProcessPageCount , aiMultiplexOriginalPage[q] ) ;
				}
			}
		break;
		case 508: case 514:
			OU[0].ImportFromROM_m( iEditMode , ROMp(aiAddrObjectPage[0]+aiMultiplexStage_DeltaAddr[0]) , ROMp(aiAddrObjectX[0]+aiMultiplexStage_DeltaAddr[0]) ,
								ROMp(aiAddrObjectY[0]+aiMultiplexStage_DeltaAddr[0]) , ROMp(aiAddrObjectType[0]+aiMultiplexStage_DeltaAddr[0]) ,
								iMaxObjectAlloc , iProcessPageCount , aiMultiplexOriginalPage[0] ) ;
		break ;
		}
	}
	{//グラフィック指定を展開する
		SetupGraphicsPattern() ;
	}
	UpdateVTE() ;

	return 0 ;
}
