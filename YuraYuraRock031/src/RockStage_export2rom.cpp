#include "RockStage_p.h"

#define MASK(Addr,Size) {if(pucRomMask){int iOffset=ROMp(Addr)-pucRom; memset( pucRomMask+iOffset , 1 , Size ) ;}}


int RockStage::ExportToRom( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , unsigned char *pucRomMask )
{
	if( !iIsValid )
	{
		return -4;
	}
	CorrectEditModeStageNORomDependedValue() ;

	{//●チップ書き込み
		int iRV ;
		iRV = ExportToRom_sub_Chip( pucRomMask ) ;
		if( iRV ){ return iRV; }
	}
	{//●オブジェクト書き込み
		int iRV ;
		iRV = ExportToRom_sub_Object( pucRomMask , piOutPage , piOutTile ) ; //変数名と用途が一致していない
		if( iRV ){ return iRV; }
	}
	{//●タイル書き込み
		int iRV ;
		iRV = ExportToRom_sub_Tile( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , pucRomMask ) ;
		if( iRV ){ return iRV; }
	}
	{//●特殊データ書き込み
		int iRV ;
		iRV = ExportToRom_sub_SpData( pucRomMask ) ;
		if( iRV ){ return iRV; }
	}

	return 0 ;
}

int RockStage::ExportToRom_sub_Chip( unsigned char *pucRomMask )
{
	if( iAddrChip>=0 )
	{
		memcpy_s(  ROMp(iAddrChip) , ROMRemp(iAddrChip) ,
					aucChip , sizeof(aucChip) ) ;
		MASK( iAddrChip , sizeof(aucChip) ) ;
	}
	if( iAddrChipHit>=0 )
	{
		memcpy_s(  ROMp(iAddrChipHit) , ROMRemp(iAddrChipHit) ,
					aucChipHit , sizeof(aucChipHit) ) ;
		MASK( iAddrChipHit , sizeof(aucChipHit) ) ;
	}
	if( iHaveVChip )
	{//変化チップ(ロックマン６向け)
		int iAddr = GetROM8p( 0x3EDF55 + iStageNO ) * 0x10000 + 0x9B00 ;
		for( int i=0 ; i<256 ; i++ )
		{
			if( aucVChipValid[i] )
			{
				SetROM8p( iAddr+0x000+i , aucVChip[0x000+i] ) ;
				SetROM8p( iAddr+0x100+i , aucVChip[0x100+i] ) ;
				SetROM8p( iAddr+0x200+i , aucVChip[0x200+i] ) ;
				SetROM8p( iAddr+0x300+i , aucVChip[0x300+i] ) ;
				SetROM8p( iAddr+0x400+i , aucVChipHit[i] ) ;
				MASK( iAddr+0x000+i , 1 ) ;
				MASK( iAddr+0x100+i , 1 ) ;
				MASK( iAddr+0x200+i , 1 ) ;
				MASK( iAddr+0x300+i , 1 ) ;
				MASK( iAddr+0x400+i , 1 ) ;
			}
		}
	}
	return 0 ;
}
int RockStage::ExportToRom_sub_Object( unsigned char *pucRomMask , int *piOutObjSize , int *piOutMaxSize )
{
	if( iExportObject )
	{
		{//オブジェクトデータ本体
			if( OU[0].GetCount()>aiMaxObject[0] )
			{

				if( iEditMode == 1 || iEditMode == 6 )
				{ //再割当てを実行
					if( RemapObject( pucRomMask , piOutObjSize , piOutMaxSize ) )
					{
						return -3 ;
					}
				}
				else
				{
					assert( 0 ) ;
					return -3 ;
				}
			}
			OU[0].ExportToROM( iEditMode , ROMp(aiAddrObjectPage[0]) , ROMp(aiAddrObjectX[0]) ,
								ROMp(aiAddrObjectY[0]) , ROMp(aiAddrObjectType[0]) , aiMaxObject[0] ) ;
			MASK( aiAddrObjectPage[0] , aiMaxObject[0] ) ;
			MASK( aiAddrObjectX[0] , aiMaxObject[0] ) ;
			MASK( aiAddrObjectY[0] , aiMaxObject[0] ) ;
			MASK( aiAddrObjectType[0] , aiMaxObject[0] ) ;
			if( iEditMode==1 ){ MASK( aiAddrObjectPage[0] , aiMaxObject[0]*4 ) ; }
			{//多重ステージのオブジェクト書き出し
				int iLoops=0 ; //通常は書き出ししない
				switch( iMultiplexStage )
				{
				case 313:iLoops=2;break;
				case 508: case 514:iLoops=1;break;
				}

				if( iLoops )
				{//多重ステージなら、終端のFFを挿入する
					OU[0].ExportToROMTerm( iEditMode , ROMp(aiAddrObjectPage[0]) , ROMp(aiAddrObjectX[0]) ,
								ROMp(aiAddrObjectY[0]) , ROMp(aiAddrObjectType[0]) , aiMultiplexOriginalPage[0] ) ;
				}
				for( int i=0 ; i<iLoops ; i++ )
				{
					OU[0].ExportToROM_m( iEditMode , ROMp(aiAddrObjectPage[0]+aiMultiplexStage_DeltaAddr[i]) , ROMp(aiAddrObjectX[0]+aiMultiplexStage_DeltaAddr[i]) ,
										ROMp(aiAddrObjectY[0]+aiMultiplexStage_DeltaAddr[i]) , ROMp(aiAddrObjectType[0]+aiMultiplexStage_DeltaAddr[i]) ,
										aiMultiplexOriginalPage[i] ) ;
					MASK( aiAddrObjectPage[0]+aiMultiplexStage_DeltaAddr[i] , aiMaxObject[0] ) ;
					MASK( aiAddrObjectX[0]   +aiMultiplexStage_DeltaAddr[i] , aiMaxObject[0] ) ;
					MASK( aiAddrObjectY[0]   +aiMultiplexStage_DeltaAddr[i] , aiMaxObject[0] ) ;
					MASK( aiAddrObjectType[0]+aiMultiplexStage_DeltaAddr[i] , aiMaxObject[0] ) ;
					if( i+1<iLoops )
					{
						OU[0].ExportToROMTerm( iEditMode , ROMp(aiAddrObjectPage[0]+aiMultiplexStage_DeltaAddr[i]) , ROMp(aiAddrObjectX[0]+aiMultiplexStage_DeltaAddr[i]) ,
										ROMp(aiAddrObjectY[0]+aiMultiplexStage_DeltaAddr[i]) , ROMp(aiAddrObjectType[0]+aiMultiplexStage_DeltaAddr[i]) ,
										aiMultiplexOriginalPage[i+1]-aiMultiplexOriginalPage[i] ) ;
					}
				}
			}

			if( aiMaxObject[1] )
			{//ロックマン1の後半とロックマン2のアイテム
				OU[1].ExportToROM( iEditMode , ROMp(aiAddrObjectPage[1]) , ROMp(aiAddrObjectX[1]) ,
									ROMp(aiAddrObjectY[1]) , ROMp(aiAddrObjectType[1]) , aiMaxObject[1] ) ;
				MASK( aiAddrObjectPage[0] , aiMaxObject[1] ) ;
				MASK( aiAddrObjectX[0] , aiMaxObject[1] ) ;
				MASK( aiAddrObjectY[0] , aiMaxObject[1] ) ;
				MASK( aiAddrObjectType[0] , aiMaxObject[1] ) ;
				if( iEditMode==1 ){ MASK( aiAddrObjectPage[1] , aiMaxObject[1]*4 ) ; }
			}
		}

		if( iAddrObjectSuffixList )
		{//ページ毎のオブジェクトオフセット
			for( int iP=0 ; iP<iProcessPageCount ; iP++ )
			{
				SetROM8p( iAddrObjectSuffixList+iP , OU[0].GetElemOffsetPerPage( iP ) ) ;
				MASK( iAddrObjectSuffixList+iP , 1 ) ;
				switch( iMultiplexStage )
				{
				case 508: case 514:
					SetROM8p( iAddrObjectSuffixList+aiMultiplexStage_DeltaAddr[0]+iP ,
								OU[0].GetElemOffsetPerPage_m( iP , aiMultiplexOriginalPage[0] ) ) ;
					MASK( iAddrObjectSuffixList+aiMultiplexStage_DeltaAddr[0]+iP , 1 ) ;
				break ;
				}
			}
		}
	}
	return 0 ;
}


int RockStage::ExportToRom_sub_Tile( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , unsigned char *pucRomMask )
{
	switch( iEditMode )
	{
	case 1:
	case 2:
		return ExportToRom_sub_Tile12( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , pucRomMask ) ;
	break ;
	case 3:
	case 4:
	case 5:
	case 6:
		return ExportToRom_sub_Tile3456( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , pucRomMask ) ;
	break ;
	default:
		assert(0) ;
	}
	assert(0) ;
	return 0 ;
}

int RockStage::ExportToRom_sub_SpData( unsigned char *pucRomMask )
{
	RS_SpData tSp = {0} ;
	for( ; LoadSpData(&tSp)!=-1 ; )
	{
		for( int i=0 ; i<tSp.iSize ; i++ )
		{
			SetROM8p(tSp.iAddrBase+iStageNO*tSp.iAddrDeltaS+i*tSp.iAddrDeltaD , aucSpData[tSp.iDataOffset+i] ) ;
			MASK( tSp.iAddrBase+iStageNO*tSp.iAddrDeltaS+i*tSp.iAddrDeltaD , 1 ) ;
		}
	}
	return 0;
}






































int RockStage::CulcPageTileAmount_sub_1( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile )
{
	int iRV = DoTiling12( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , piOutPrePage , piOutPreTile ,
		NULL , NULL , NULL , NULL ) ;
	return iRV ;
#if 0
	const int ciSizePerTile = (ciChipPTileS+1) ;
	const int ciWholeTileSize = iProcessPageCount*ciTilePPageS*ciSizePerTile ;
	unsigned char *pucWholeTile = (unsigned char*)malloc(ciWholeTileSize) ; //全体のタイルデータを繋いだもの(5バイト*全体分)
	int iRV=0 ;
	try
	{
		if( !pucWholeTile ){ throw -1; }
		//全体タイルを作成
		Rock12_SetupWholeTile( pucWholeTile ) ;

		{//タイル数測定
			int iCurSize=0 ;
			for( int iP=0 ; iP<iProcessPageCount*ciTilePPageS ; iP++ )
			{
				//保護タイルとの比較
				{
					int iPT ;
					for( iPT=0 ; iPT<iMaxTile ; iPT++ )
					{
						if( aucPreTileFlag[ iPT ] & ciLF_LockedAnyway )
						{ //5バイトタイルを作成
							unsigned char aucTmpTile[5] ;
							Rock12_Setup5ByteTile( aucTmpTile , aucPreTile+iPT*4 , aucPreTileHit+iPT*4 , iP ) ;
							if( !memcmp( pucWholeTile+iP*5 , aucTmpTile , 5 ) )
							{ iPT=-1; break; }
						}
					}
					if( iPT<0 ){ continue; }
				}
				
				//そこまでに同じ5バイトがなければ数を追加する
				int iPC ;
				for( iPC=0 ; iPC<iP ; iPC++ )
				{
					if( !memcmp( pucWholeTile+iP*5 , pucWholeTile+iPC*5 , 5 ) )
					{
						break ;
					}
				}
				if( iPC==iP )
				{
					iCurSize ++ ;
				}
			}
			*piOutTile = iCurSize ;
		}
		{//ページ数測定
			int iCurSize=0 ;
			for( int iP=0 ; iP<iProcessPageCount ; iP++ )
			{//そこまでに同じ5*ciTilePPageSバイトがなければ数を追加する
				const int ciSize = 5*ciTilePPageS ;
				int iPC ;
				for( iPC=0 ; iPC<iP ; iPC++ )
				{
					if( !memcmp( pucWholeTile+iP*ciSize , pucWholeTile+iPC*ciSize , ciSize ) )
					{
						break ;
					}
				}
				if( iPC==iP )
				{
					iCurSize ++ ;
				}
			}
			*piOutPage = iCurSize ;
		}
	}
	catch( int iErr )
	{
		iRV = iErr ;
		*piOutPage = 0 ;
		*piOutTile = 0 ;
	}
	if( pucWholeTile ){ free(pucWholeTile); }
	return iRV ;
#endif
}



int RockStage::CulcPageTileAmount_sub_2( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile )
{
	return CulcPageTileAmount_sub_1( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , piOutPrePage , piOutPreTile ) ;
#if 0
	const int ciSizePerTile = (ciChipPTileS+1) ;
	const int ciWholeTileSize = iProcessPageCount*ciTilePPageS*ciSizePerTile ;
	unsigned char *pucWholeTile = (unsigned char*)malloc(ciWholeTileSize) ; //全体のタイルデータを繋いだもの(5バイト*全体分)
	int iCurSize=0 ;
	int iRV=0 ;
	try
	{
		if( !pucWholeTile ){ throw -1; }
		*piOutPage = iProcessPageCount ;
		//全体タイルを作成
		Rock12_SetupWholeTile( pucWholeTile ) ;

		for( int iP=0 ; iP<iProcessPageCount*ciTilePPageS ; iP++ )
		{
			//保護タイルとの比較
			{
				int iPT ;
				for( iPT=0 ; iPT<iMaxTile ; iPT++ )
				{
					if( aucPreTileFlag[ iPT ] & ciLF_LockedAnyway )
					{ //5バイトタイルを作成
						unsigned char aucTmpTile[5] ;
						Rock12_Setup5ByteTile( aucTmpTile , aucPreTile+iPT*4 , aucPreTileHit+iPT*4 , iP ) ;
						if( !memcmp( pucWholeTile+iP*5 , aucTmpTile , 5 ) )
						{ iPT=-1; break; }
					}
				}
				if( iPT<0 ){ continue; }
			}
			//そこまでに同じ5バイトがなければ数を追加する
			int iPC ;
			for( iPC=0 ; iPC<iP ; iPC++ )
			{
				if( !memcmp( pucWholeTile+iP*5 , pucWholeTile+iPC*5 , 5 ) )
				{
					break ;
				}
			}
			if( iPC==iP )
			{
				iCurSize ++ ;
			}
		}
		*piOutTile = iCurSize ;
	}
	catch( int iErr )
	{
		*piOutPage = 0 ;
		*piOutTile = 0 ;
		iRV = iErr ;
	}
	if( pucWholeTile ){ free(pucWholeTile); }
	return iRV ;
#endif
}
int RockStage::CulcPageTileAmount_sub_3( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile )
{
	int iRV = DoTiling3456( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , piOutPrePage , piOutPreTile ,
		NULL , NULL , NULL ) ;
	return iRV ;

}
int RockStage::CulcPageTileAmount_sub_4( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile )
{
	return CulcPageTileAmount_sub_3( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , piOutPrePage , piOutPreTile ) ;
}
int RockStage::CulcPageTileAmount_sub_5( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile )
{
	return CulcPageTileAmount_sub_3( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , piOutPrePage , piOutPreTile ) ;
}
int RockStage::CulcPageTileAmount_sub_6( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile )
{
	return CulcPageTileAmount_sub_3( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , piOutPrePage , piOutPreTile ) ;
}

int RockStage::ExportToRom_sub_Tile12( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , unsigned char *pucRomMask )
{
	int iRV = 0 ;
	unsigned char *pucTile , *pucTileColor , *pucPage , *pucPageList ;
	iRV = DoTiling12( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , NULL , NULL , &pucPageList , &pucPage , &pucTile , &pucTileColor ) ;

	{//書き込み
		{ //タイル
			memcpy_s( ROMp( iAddrTile ) , ROMRemp( iAddrTile ) , pucTile , iMaxTile*ciChipPTileS ) ;
			MASK( iAddrTile , iMaxTile*ciChipPTileS ) ;
		}
		{ //タイル色
			memcpy_s( ROMp( iAddrTileColor ) , ROMRemp( iAddrTileColor ) , pucTileColor , iMaxTile ) ;
			MASK( iAddrTileColor , iMaxTile ) ;
		}
		{ //ページ
			memcpy_s( ROMp( iAddrPage ) , ROMRemp( iAddrPage ) , pucPage , iMaxPage*ciTilePPageS ) ;
			MASK( iAddrPage , iMaxPage*ciTilePPageS ) ;
		}
		if( iEditMode == 1 )
		{ //ロックマン1専用
			for( int i=0 ; i<iMaxPage ; i++ )
			{//アドレス指定は潰す
				SetROM16p( iAddrPageAddrList+i*2 , (iAddrPage&0xFFFF)+i*0x40 ) ;
				MASK( iAddrPageAddrList+i*2 , 2 ) ;
			}
			{//ページリスト
				memcpy_s( ROMp( iAddrPageList ) , ROMRemp( iAddrPageList ) , pucPageList , iProcessPageCount ) ;
				MASK( iAddrPageList , iProcessPageCount ) ;
			}
		}
	}
	if( pucTileColor ){ free( pucTileColor ); }
	if( pucTile      ){ free( pucTile      ); }
	if( pucPage      ){ free( pucPage      ); }
	if( pucPageList  ){ free( pucPageList  ); }
	return iRV ;

#if 0
	int iRV = 0 ;
	const int ciSizePerTile = (ciChipPTileS+1) ;
	const int ciWholeTileSize = iProcessPageCount*ciTilePPageS*ciSizePerTile ;
	const int ciMapSize = iProcessPageCount ;
	const int ciPage2Size = iMaxTile*ciTilePPageS ;
	const int ciPageSize = iProcessPageCount*ciTilePPageS ;
	const int ciTileCSize = ciSizePerTile*iMaxTile ;


	int *piPageList = (int*)malloc( ciMapSize*sizeof(int) ) ; //確定したページリストを格納
	int *piPage2    = (int*)malloc( ciPage2Size*sizeof(int) ) ; //出力時のページデータ
	int *piPage = (int*)malloc( ciPageSize*sizeof(int) ) ; //確定したページを構成するタイル
	int *piTileC = (int*)malloc( ciTileCSize*sizeof(int) ) ; //確定したタイルを構成する画像番号、判定、色(5バイト*256)
	unsigned char *pucWholeTile = (unsigned char*)malloc(ciWholeTileSize) ; //全体のタイルデータを繋いだもの(5バイト*全体分)

	try
	{
		if( !piPageList || !piPage2 || !piPage || !piTileC || !pucWholeTile ){ throw -1; }
		for( int i=0 ; i<ciMapSize ; i++ ){ piPageList[i]=-1; }
		for( int i=0 ; i<ciPage2Size ; i++ ){ piPage2[i]=-1; }
		for( int i=0 ; i<ciPageSize ; i++ ){ piPage[i]=-1; }
		for( int i=0 ; i<ciTileCSize ; i++ ){ piTileC[i]=-1; }

		//全体タイルを作成
		Rock12_SetupWholeTile( pucWholeTile ) ;

		{//原作と同一のタイルを予約する
			unsigned char aucOrgTile[256*5] ;
			{//原作タイルを展開
				for( int i=0 ; i<iMaxTile ; i++ )
				{
					memcpy( aucOrgTile+i*5 , ROMo/*←原作*/(iAddrTile+i*ciChipPTileS) , 4 ) ;
					aucOrgTile[ i*5+4 ] = GetROM8o/*←原作*/(iAddrTileColor+i) ;
				}
			}
			for( int iP=0 ; iP<iProcessPageCount*ciTilePPageS ; iP++ )
			{//全く同じ5バイトを走査
				for( int q=0 ; q<iMaxTile ; q++ )
				{
					if( !memcmp( aucOrgTile+q*5 , pucWholeTile+iP*5 , 5 ) )
					{//確定する
						piPage[ iP ] = q ;
						for( int k=0 ; k<5 ; k++ )
						{
							piTileC[ q*5+k ] = aucOrgTile[ q*5+k ] ;
						}
						break ;
					}
				}
			}
		}
		{//未確定のタイルを埋める
			if( Rock12_SetupTile(piPage,piTileC,pucWholeTile) ){ throw -1; }
		}
		{//マップを構成
			{//原作と同じページ
				int aiOrgPage[ciMaxAllocatePage*ciTilePPageS] ;
				{//原作タイルを展開
					for( int i=0 ; i<iMaxPage*ciTilePPageS ; i++ )
					{
						aiOrgPage[ i ] = GetROM8o/*←原作*/(iAddrPage+i) ;
					}
				}
				for( int iP=0 ; iP<iProcessPageCount ; iP++ )
				{
					for( int iOP=0 ; iOP<iMaxPage ; iOP++ )
					{
						int *piP  = piPage+iP*ciTilePPageS ;
						int *piOP = aiOrgPage+iOP*ciTilePPageS ;
						if( !memcmp( piP , piOP , ciTilePPageS*sizeof(int) ) )
						{//原作のページと完全に一致
							piPageList[iP] = iOP ;
							memcpy( piPage2+iOP*ciTilePPageS , piOP , ciTilePPageS*sizeof(int) ) ;
							break ;
						}
					}
				}
			}
			{//原作には存在しないページ
				for( int iP=0 ; iP<iProcessPageCount ; iP++ )
				{
					if( piPageList[iP] >= 0 ){ continue; }
					{//新たに追加されたページと一致する可能性があるので走査
						int iDP ;
						for( iDP=0 ; iDP<iMaxPage ; iDP++ )
						{
							if( piPage2[iDP*ciTilePPageS]<0 ){ continue; }
							int *piP  = piPage +iP*ciTilePPageS ;
							int *piDP = piPage2+iDP*ciTilePPageS ;
							if( !memcmp( piP , piDP , ciTilePPageS*sizeof(int) ) )
							{
								piPageList[iP] = iDP ;
								iDP = -1 ;
								break ;
							}
						}
						if( iDP<0 ){ continue; }
					}
					{//追加
						int iDP ;
						for( iDP=0 ; iDP<iMaxPage ; iDP++ )
						{
							if( piPage2[ iDP*ciTilePPageS ] < 0 ){ break; }
						}
						if( iDP==iMaxPage ){ throw -1; }
						//空きを発見したので書き込む
						piPageList[iP] = iDP ;
						memcpy( piPage2+iDP*ciTilePPageS , piPage+iP*ciTilePPageS , ciTilePPageS*sizeof(int) ) ;
					}
				}
			}
		}
		{//書き込み
			for( int iT=0 ; iT<iMaxTile ; iT++ )
			{
				for( int i=0 ; i<4 ; i++ )
				{
					SetROM8p( iAddrTile+iT*4+i , piTileC[iT*5+i] ) ;
				}
				SetROM8p( iAddrTileColor+iT , piTileC[iT*5+4] ) ;
				MASK( iAddrTile+iT*4 , 4 ) ;
				MASK( iAddrTileColor+iT , 1 ) ;
			}
			for( int iP=0 ; iP<iMaxPage*ciTilePPageS ; iP++ )
			{
				SetROM8p( iAddrPage+iP , piPage2[iP] ) ;
				MASK( iAddrPage+iP , 1 ) ;
			}
			for( int i=0 ; i<iMaxPage ; i++ )
			{//アドレス指定は潰す
				SetROM16p( iAddrPageAddrList+i*2 , (iAddrPage&0xFFFF)+i*0x40 ) ;
				MASK( iAddrPageAddrList+i*2 , 2 ) ;
			}
			for( int i=0 ; i<iProcessPageCount ; i++ )
			{//ページリスト
				SetROM8p( iAddrPageList+i , piPageList[i] ) ;
				MASK( iAddrPageList+i , 1 ) ;
			}
		}
	}
	catch( int iErr )
	{
		iRV = iErr ;
	}
	if( pucWholeTile ){ free(pucWholeTile); }
	if( piPageList ){ free(piPageList); }
	if( piPage2 ){ free(piPage2); }
	if( piPage ){ free(piPage); }
	if( piTileC ){ free(piTileC); }
	return iRV ;
#endif
}
#if 0
int RockStage::ExportToRom_sub_Tile2( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , unsigned char *pucRomMask )
{
	int iRV = 0 ;
//	const int ciTileSize = iProcessPageCount*ciChipPPageS ;
	const int ciSizePerTile = (ciChipPTileS+1) ;
	const int ciWholeTileSize = iProcessPageCount*ciTilePPageS*ciSizePerTile ;
	const int ciPageSize = iProcessPageCount*ciTilePPageS ;
	const int ciTileCSize = ciSizePerTile*iMaxTile ;

	int *piPage = (int*)malloc( ciPageSize*sizeof(int) ) ; //確定したページを構成するタイル
	int *piTileC = (int*)malloc( ciTileCSize*sizeof(int) ) ; //確定したタイルを構成する画像番号、判定、色(5バイト*256)
	unsigned char *pucWholeTile = (unsigned char*)malloc(ciWholeTileSize) ; //全体のタイルデータを繋いだもの(5バイト*全体分)

	try
	{
		if( !piPage || !piTileC || !pucWholeTile ){ throw -1; }
		for( int i=0 ; i<ciPageSize ; i++ ){ piPage[i]=-1; }
		for( int i=0 ; i<ciTileCSize ; i++ ){ piTileC[i]=-1; }

		//全体タイルを作成
		Rock12_SetupWholeTile( pucWholeTile ) ;

		{//原作と同一のタイルを予約する
			unsigned char aucOrgTile[256*5] ;
			{//原作タイルを展開
				for( int i=0 ; i<256 ; i++ )
				{
					memcpy( aucOrgTile+i*5 , ROMo/*←原作*/(iAddrTile+i*ciChipPTileS) , 4 ) ;
					aucOrgTile[ i*5+4 ] = GetROM8o/*←原作*/(iAddrTileColor+i) ;
				}
			}
			for( int iP=0 ; iP<iProcessPageCount*ciTilePPageS ; iP++ )
			{//全く同じ5バイトを走査
				for( int q=0 ; q<256 ; q++ )
				{
					if( !memcmp( aucOrgTile+q*5 , pucWholeTile+iP*5 , 5 ) )
					{//確定する
						piPage[ iP ] = q ;
						for( int k=0 ; k<5 ; k++ )
						{
							piTileC[ q*5+k ] = aucOrgTile[ q*5+k ] ;
						}
						break ;
					}
				}
			}
		}
		{//未確定のタイルを埋める
			if( Rock12_SetupTile(piPage,piTileC,pucWholeTile) ){ throw -1; }
		}
		{//書き込み
			for( int iT=0 ; iT<256 ; iT++ )
			{
				for( int i=0 ; i<4 ; i++ )
				{
					SetROM8p( iAddrTile+iT*4+i , piTileC[iT*5+i] ) ;
				}
				SetROM8p( iAddrTileColor+iT , piTileC[iT*5+4] ) ;
				MASK( iAddrTile+iT*4 , 4 ) ;
				MASK( iAddrTileColor+iT , 1 ) ;
			}
			for( int iP=0 ; iP<iProcessPageCount*ciTilePPageS ; iP++ )
			{
				SetROM8p( iAddrPage+iP , piPage[iP] ) ;
				MASK( iAddrPage+iP , 1 ) ;
			}
		}
	}
	catch( int iErr )
	{
		iRV = iErr ;
	}
	if( pucWholeTile ){ free(pucWholeTile); }
	if( piPage ){ free(piPage); }
	if( piTileC ){ free(piTileC); }
	return iRV ;
}
#endif 


int RockStage::ExportToRom_sub_Tile3456( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , unsigned char *pucRomMask )
{
	int iRV = 0 ;
	unsigned char *pucTile , *pucPage , *pucPageList ;
	iRV = DoTiling3456( piOutPage , piOutTile , piOutMaxPage , piOutMaxTile , NULL , NULL , &pucPageList , &pucPage , &pucTile ) ;
	if( !iRV )
	{
		if( iExportPageList )
		{ //ページリストを保持する構造
			if( (*piOutPage)<=(*piOutMaxPage) &&
				(*piOutTile)<=(*piOutMaxTile) )
			{
				memcpy_s( ROMp( iAddrTile ) , ROMRemp( iAddrTile ) , pucTile , iMaxTile*ciChipPTileS ) ;
				MASK( iAddrTile     , iMaxTile*ciChipPTileS ) ;
				memcpy_s( ROMp( iAddrPage ) , ROMRemp( iAddrPage ) , pucPage , iMaxPage*ciTilePPageS ) ;
				MASK( iAddrPage     , iMaxPage*ciTilePPageS ) ;
				if( iExportPageList )
				{
					memcpy_s( ROMp( iAddrPageList ) , ROMRemp( iAddrPageList ) ,pucPageList , iMaxPageList ) ;
					MASK( iAddrPageList , iMaxPageList ) ;
				}

				{//多重ステージのページリストの書き出し
					int iLoops = 0 ;//通常は処理しない
					switch( iMultiplexStage )
					{
					case 313:iLoops=2;break;
					case 508: case 514:iLoops=1;break;
					}

					for( int q=0 ; q<iLoops ; q++ )
					{
						for( int i=0 ; i<iMaxPageList ; i++ ){ SetROM8p( iAddrPageList+aiMultiplexStage_DeltaAddr[q]+i , 0) ; }
						int iWP = 0 ;
						for( int i=aiMultiplexOriginalPage[q] ; i<iMaxPageList ; i++ )
						{ 
							SetROM8p( iAddrPageList+aiMultiplexStage_DeltaAddr[q]+iWP , pucPageList[i] ) ; 
							iWP ++ ;
						}
						MASK( iAddrPageList+aiMultiplexStage_DeltaAddr[q] , iMaxPageList ) ;
					}
				}
			}
			else
			{
				iRV = -2 ;
			}
		}
		else
		{//ページリストを抱えない構造
			if( (*piOutPage)<=(*piOutMaxPage) &&
				(*piOutTile)<=(*piOutMaxTile) )
			{
				memcpy_s( ROMp( iAddrTile ) , ROMRemp( iAddrTile ) , pucTile , iMaxTile*ciChipPTileS ) ;
				MASK( iAddrTile     , iMaxTile*ciChipPTileS ) ;
				memcpy_s( ROMp( iAddrPage ) , ROMRemp( iAddrPage ) , pucPage , iMaxPage*ciTilePPageS ) ;
				MASK( iAddrPage     , iMaxPage*ciTilePPageS ) ;
			}
			else
			{
				iRV = -2 ;
			}
		}
	}
	if( pucTile     ){ free( pucTile     ); }
	if( pucPage     ){ free( pucPage     ); }
	if( pucPageList ){ free( pucPageList ); }
	return iRV ;
}










int RockStage::GetChipOffsetPerTilingMethod( int iTileNo )
{
	switch( iTilingMethod )
	{
	case 0:
		return iTileNo%ciTilePPageW*ciChipPTileW +
			iTileNo%ciTilePPageS/ciTilePPageW*ciChipPTileH*ciChipPPageW*ciMaxAllocatePage +
			iTileNo/ciTilePPageS*ciChipPPageW ;
	break ;
	case 1:
		{
			int iX,iY ;
			iX = iTileNo%(ciTilePPageW*iProcessPageCount) ;
			iY = iTileNo/(ciTilePPageW*iProcessPageCount) ;
			return iX * ciChipPTileW +
				iY * ciChipPTileH * (ciChipPPageW*ciMaxAllocatePage) ;
		}
	break ;
	default:
		assert(0) ;
	}
	return 0 ;
}
void RockStage::Rock12_Setup5ByteTile( unsigned char *pucOut , unsigned char *pucColNO , unsigned char *pucHit , int iPage )
{
	static const int aiShift[4] = {0,4,2,6} ;
	static const int aiOrder[4] = {0,2,1,3} ;
	int iColor = 0 ;
	int aiChipHitOfCurStage[4]  ;

	Rock12_GetHitPattern( aiChipHitOfCurStage , iPage ) ;
	for( int i=0 ; i<4 ; i++ )
	{
		int iColNO = pucColNO[aiOrder[i]] ;
		int iHitT = pucHit[aiOrder[i]] ;
		int iHit=0 ;
		for( int iH=0 ; iH<4 ; iH++ ){ if( aiChipHitOfCurStage[iH] == iHitT ){ iHit=iH; break; } }

		pucOut[i] = (iColNO&0x3F) | ( iHit<<6 ) ;
		iColor >>= 2 ;
		iColor |= (pucColNO[i]&0xC0) ;
	}
	pucOut[4] = iColor ;
}
void RockStage::Rock12_GetHitPattern( int *piOut , int iTileOffset )
{
	switch( iEditMode )
	{
	case 1:
		 return Rock1_GetHitPattern( piOut , iTileOffset ) ;
	break ;
	case 2:
		 return Rock2_GetHitPattern( piOut , iTileOffset ) ;
	break ;
	default:
		_assume( 0 ) ;
	}
	assert( 0 ) ;
}
void RockStage::Rock1_GetHitPattern( int *piOut , int iTileOffset )
{
	int iOffset = 0 ;
	if( iTileOffset>=ciTilePPageS*aucSpData[SPOf1_StageBorder] )
	{ 
		iOffset=4;
	}
	piOut[0] = aucSpData[SPOf1_HitPattern+iOffset+0] ;
	piOut[1] = aucSpData[SPOf1_HitPattern+iOffset+1] ;
	piOut[2] = aucSpData[SPOf1_HitPattern+iOffset+2] ;
	piOut[3] = aucSpData[SPOf1_HitPattern+iOffset+3] ;
}
void RockStage::Rock2_GetHitPattern( int *piOut , int iTileOffset )
{
	piOut[0] = 0 ;
	piOut[1] = 1 ;
	int iOffset = 0 ;
	if( iStageNO<6 && iTileOffset>=ciTilePPageS*aucSpData[SPOf2_StageBorder] )
	{ 
		iOffset=2;
	}
	piOut[2] = aucSpData[SPOf2_HitPattern+iOffset+0] ;
	piOut[3] = aucSpData[SPOf2_HitPattern+iOffset+1] ;
}
int RockStage::Rock12_SetupTile( int *piExpTile , int *piTile , unsigned char *pucWholeTile , int iTiles )
{
	for( int iP=0 ; iP<iProcessPageCount*ciTilePPageS ; iP++ )
	{
		if( piExpTile[ iP ] >= 0 ){ continue; } //確定済み
		int iT ;
		for( iT=0 ; iT<iTiles ; iT++ )
		{//同一のタイルが既にあるかを確認
			int k ;
			for( k=0 ; k<5 ; k++ )
			{
				if( piTile[ iT*5+k ] != pucWholeTile[ iP*5+k ] ){ break; }
			}
			if( k==5 )
			{
				piExpTile[ iP ] = iT ;
				break ;
			}
		}
		if( iT!=iTiles ){ continue ; }
		//新規に追加する
		for( iT=0 ; iT<iTiles ; iT++ )
		{//空きを探す
			if( piTile[ iT*5 ] < 0 )
			{
				piExpTile[ iP ] = iT ;
				for( int k=0 ; k<5 ; k++ )
				{
					piTile[ iT*5+k ] = pucWholeTile[ iP*5+k ] ;
				}
				break ;
			}
		}
		if( iT==iTiles ){ return -1; }
	}
	return 0 ;
}
void RockStage::Rock12_SetupWholeTile( unsigned char *aucWholeTile )
{
	const int ciSizePerTile = (ciChipPTileS+1) ;
	const int ciWholeTileSize = iProcessPageCount*ciTilePPageS*ciSizePerTile ;
	const int ciPageSize = iProcessPageCount*ciTilePPageS ;
	const int ciTileCSize = ciSizePerTile*iMaxTile ;
	for( int iT=0 ; iT<iProcessPageCount*ciTilePPageS ; iT++ )
	{
		int aiChipHitOfCurStage[4] ;
		int aiChipHitInvTable[8] ;
		Rock12_GetHitPattern( aiChipHitOfCurStage , iT ) ;
		for( int i=0 ; i<8 ; i++ ){ aiChipHitInvTable[i] = 0 ; }
		for( int i=3 ; i>=0 ; i-- ){ aiChipHitInvTable[aiChipHitOfCurStage[i]&7] = i*0x40 ; } ;

		aucWholeTile[iT*ciSizePerTile+4] = 0 ;
		static const int ciShiftTimes[4] = { 0,4,2,6 } ;
		for( int iCiT=0 ; iCiT<ciChipPTileS ; iCiT++ )
		{
			int iTx , iTy ;
			int iOffset ;
			iTx = iT/ciTilePPageH*ciChipPTileW +
				  iCiT/ciChipPTileH ;
			iTy = iT%ciTilePPageH*ciChipPTileH +
				  iCiT%ciChipPTileH ;
			iOffset = iTx + iTy*ciMaxAllocatePage*ciChipPPageW ;
			assert( iOffset<_countof(aucChipMap) )  ;

			int iRawData ;
			int iChipNo ;
			int iColNo ;
			int iHitVal ;
			iRawData = aucChipMap[ iOffset ] ;
			iChipNo = ( iRawData&0x3F) ;
			iColNo  = (iRawData>>6) ;
			iHitVal = aucChipHit[aucChipMap[ iOffset+ciMaxAllocatePage*ciChipPPageS ]]>>4 ;
			iHitVal &= 7 ;
			aucWholeTile[iT*ciSizePerTile+4] |= (iColNo<<(ciShiftTimes[iCiT])) ;
			aucWholeTile[iT*ciSizePerTile+iCiT] = (iChipNo | (aiChipHitInvTable[iHitVal]) ) ;
		}
	}
}
void RockStage::Rock12_SetupListOfRoomPerPage( int *piOut )
{
	switch( iEditMode )
	{
	case 1:
		 return Rock1_SetupListOfRoomPerPage( piOut ) ;
	break ;
	case 2:
		 return Rock1_SetupListOfRoomPerPage( piOut ) ;
	break ;
	default:
		_assume( 0 ) ;
	}
	assert( 0 ) ;
}
void RockStage::Rock1_SetupListOfRoomPerPage( int *piOut )
{
	//初期化
	for( int i=0 ; i<iProcessPageCount ; i++ ){ piOut[i]=-1; }
	//１ページずつ記録
	int iRemain = 0 ;
	int iRoomNo = 0 ;
	for( int iP=0 ; iP<iProcessPageCount ; iP++ )
	{
		if( !iRemain )
		{
			iRoomNo ++ ;
			if( iRoomNo < SPOf1_SizeOfRoomConnection )
			{
				iRemain = (aucSpData[SPOf1_RoomConnection+iRoomNo]&0x1F)+1 ;
			}
			else
			{
				iRemain = 0xFF ;
			}
		}
		piOut[ iP ] = iRoomNo ;
		iRemain--;
	}
}
void RockStage::Rock2_SetupListOfRoomPerPage( int *piOut )
{
	//ページ毎のルーム番号を計算
	//初期化
	for( int i=0 ; i<iProcessPageCount ; i++ ){ piOut[i]=-1; }
	//突入地点のルーム番号・ページ番号の対応と、ルーム接続より、ルームの先頭に番号をつける
	{
		int iWPos = 0 ;
		for( int i=0 ; i<R2_MaxRoom ; i++ )
		{
			//
			if(               i==aucSpData[SPOf2_CP_Room+0] ){ iWPos=aucSpData[SPOf2_CP_Page+0]; }
			if( iStageNO<6 && i==aucSpData[SPOf2_CP_Room+3] ){ iWPos=aucSpData[SPOf2_CP_Page+3]; }
			if( iWPos<iProcessPageCount )
			{
				piOut[iWPos] = i ;
			}
			iWPos += ((aucSpData[SPOf2_RoomConnection+i]&0xF)+1) ;
		}
	}
	//隙間を埋める
	{
		int iPrevValue = 0 ;
		for( int i=0 ; i<iProcessPageCount ; i++ )
		{
			if(	piOut[i]==-1 )
			{
				piOut[i] = iPrevValue ;
			}
			else
			{
				iPrevValue = piOut[i] ;
			}
		}
	}
	return ;
}
