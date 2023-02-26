#include "RockStage_p.h"

void RockStage::SetupTileImage( int *piOut , int iT )
{
	unsigned char *pTmp ;
	pTmp = aucChipMap + GetChipOffsetPerTilingMethod(iT) ;
	piOut[0] = pTmp[0] ;
	piOut[1] = pTmp[1] ;
	piOut[2] = pTmp[ciMaxAllocatePage*ciChipPPageW] ;
	piOut[3] = pTmp[ciMaxAllocatePage*ciChipPPageW+1] ;
}
void RockStage::SetupTileImage( unsigned char *pucOut , int iT )
{
	unsigned char *pTmp ;
	pTmp = aucChipMap + GetChipOffsetPerTilingMethod(iT) ;
	pucOut[0] = pTmp[0] ;
	pucOut[1] = pTmp[1] ;
	pucOut[2] = pTmp[ciMaxAllocatePage*ciChipPPageW] ;
	pucOut[3] = pTmp[ciMaxAllocatePage*ciChipPPageW+1] ;
}
void RockStage::DoTiling12_sub_Setup5ByteTileByPreTile( unsigned char *pucOut , int iT , int (*pa2iChipHitOfCurStage)[4] )
{
	int iWholeColor = 0 ;
	for( int iC=0 ; iC<ciChipPTileS ; iC++ )
	{
		static const int iOrder[] = {0,2,1,3} ;
		int iTileNo , iColor , iHit , iHitTrue ;
		iTileNo = aucPreTile[iT*ciChipPTileS+iOrder[iC]] & 0x3F ;
		iColor  = aucPreTile[iT*ciChipPTileS+       iC ] & 0xC0 ;
		iHitTrue = 0 ;
		iHit    = aucPreTileHit[iT*ciChipPTileS+iOrder[iC]] ;
		for( int iHitNo=0 ; iHitNo<4 ; iHitNo++ )
		{
			for( int iStg=0 ; iStg<2 ; iStg++ )
			{
				if( iHit == pa2iChipHitOfCurStage[iStg][iHitNo] )
				{
					iHitTrue = iHitNo<<6 ;
					iHitNo = -1 ;
					break ;
				}
			}
			if( iHitNo<0 ){ break; }
		}
		pucOut[iC] = iHitTrue | iTileNo ;
		iWholeColor >>= 2 ;
		iWholeColor |= iColor ;
	}
	pucOut[4] = iWholeColor ;
}
int RockStage::DoTiling12( 
	int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piPrePage , int *piPreTile ,
	unsigned char **ppucOutPageList , unsigned char **ppucOutPage , unsigned char **ppucOutTile , unsigned char **ppucOutTileColor )
{
	int iRV = 0 ;

	const int ciSizeTileColor = (ciChipPTileS+1) ; //タイル４バイト＋色情報
	const int ciTiles = iMaxTile*2 ;
	const int ciPages = iMaxPage*2 ;
	const int ciTileSize = ciTiles*ciSizeTileColor ;
	const int ciPageSize = ciPages*ciTilePPageS ;
	const int ciPageListSize = iProcessPageCount ;
	const int ciExpTileSize = iProcessPageCount*ciTilePPageS ;
	const int ciWholeTileSize = iProcessPageCount*ciTilePPageS*ciSizeTileColor ; //マップ全体丸ごとタイル

	int *piExpTile  = (int*)malloc(ciExpTileSize  *sizeof(int)) ;
	int *piTile     = (int*)malloc(ciTileSize     *sizeof(int)) ;
	int *piPage     = (int*)malloc(ciPageSize     *sizeof(int)) ;
	int *piPageList = (int*)malloc(ciPageListSize *sizeof(int)) ;
	unsigned char *pucWholeTile = (unsigned char*)malloc(ciWholeTileSize) ; //全体のタイルデータを繋いだもの(5バイト*全体分)

	try
	{
		if( !piExpTile || !piTile || !piPage || !piPageList || !pucWholeTile ){ throw -1; }
		//初期化/全体タイルを作成
		for( int i=0 ; i<ciExpTileSize  ; i++ ){ piExpTile[i]=-1; }
		for( int i=0 ; i<ciTileSize     ; i++ ){ piTile[i]=-1; }
		for( int i=0 ; i<ciPageSize     ; i++ ){ piPage[i]=-1; }
		for( int i=0 ; i<ciPageListSize ; i++ ){ piPageList[i]=-1; }
		Rock12_SetupWholeTile( pucWholeTile ) ;
		//判定を読み込み
		int aiChipHitOfCurStage[2][4] ;
		Rock12_GetHitPattern( aiChipHitOfCurStage[0] , 0 ) ;
		Rock12_GetHitPattern( aiChipHitOfCurStage[1] , iProcessPageCount*ciTilePPageS-1 ) ;

		{//保護タイルを確定
			for( int iT=0 ; iT<iMaxTile ; iT++ )
			{
				if( aucPreTileFlag[iT] & ciLF_LockedAnyway )
				{
					unsigned char aucTmpTile[ciSizeTileColor] ;
					DoTiling12_sub_Setup5ByteTileByPreTile( aucTmpTile , iT , aiChipHitOfCurStage ) ;
					for( int i=0 ; i<ciSizeTileColor ; i++ ){ piTile[iT*ciSizeTileColor+i] = aucTmpTile[i] ; }
				}
			}
		}
		{//保護タイル(非保護部)と同一のタイルを予約する
			unsigned char aucOrgTile[ciMaxAllocateTile*ciSizeTileColor] ;
			{//保護タイルを展開
				for( int i=0 ; i<iMaxTile ; i++ )
				{
					DoTiling12_sub_Setup5ByteTileByPreTile( aucOrgTile+i*5 , i , aiChipHitOfCurStage ) ;
				}
			}
			for( int iT=0 ; iT<iProcessPageCount*ciTilePPageS ; iT++ )
			{
				int iTileImage[ciSizeTileColor] ;
				for( int i=0 ; i<ciSizeTileColor ; i++ ){ iTileImage[i] = pucWholeTile[iT*ciSizeTileColor+i] ; }
				{ //現在確定分との比較
					for( int q=0 ; q<ciTiles ; q++ )
					{
						if( piTile[q*5]>=0 && !memcmp( piTile+q*5 , iTileImage , ciSizeTileColor*sizeof(int) ) )
						{//確定する
							piExpTile[ iT ] = q ;
							break ;
						}
					}
					if( piExpTile[ iT ] >= 0 ){ continue; }
				}
				{//保護タイルと全く同じ5バイトを走査
					for( int q=0 ; q<iMaxTile ; q++ )
					{
						if( !memcmp( aucOrgTile+q*ciSizeTileColor , pucWholeTile+iT*ciSizeTileColor , ciSizeTileColor ) )
						{//確定する
							piExpTile[ iT ] = q ;
							for( int i=0 ; i<ciSizeTileColor ; i++ ){ piTile[q*ciSizeTileColor+i] = aucOrgTile[ q*5+i ] ; }
							break ;
						}
					}
					if( piExpTile[ iT ] >= 0 ){ continue; }
				}
			}
			{//未確定のタイルを埋める
				if( Rock12_SetupTile(piExpTile,piTile,pucWholeTile,ciTiles) ){ throw -1; }
			}
			if( iMaxPageList )
			{//マップを構成(1)
				{//原作と同じページ
					int aiOrgPage[ciMaxAllocatePage*ciTilePPageS] ; //※定数式のためciMaxAllocatePage
					{//原作タイルを展開
						for( int i=0 ; i<iMaxPage*ciTilePPageS ; i++ )
						{
							aiOrgPage[ i ] = aucPrePage[i] ;
						}
					}
					for( int iP=0 ; iP<iProcessPageCount ; iP++ )
					{
						for( int iOP=0 ; iOP<iMaxPage ; iOP++ )
						{
							int *piP  = piExpTile+iP*ciTilePPageS ;
							int *piOP = aiOrgPage+iOP*ciTilePPageS ;
							if( !memcmp( piP , piOP , ciTilePPageS*sizeof(int) ) )
							{//原作のページと完全に一致
								piPageList[iP] = iOP ;
								memcpy( piPage+iOP*ciTilePPageS , piOP , ciTilePPageS*sizeof(int) ) ;
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
							for( iDP=0 ; iDP<ciPages ; iDP++ )
							{
								if( piPage[iDP*ciTilePPageS]<0 ){ continue; }
								int *piP  = piExpTile +iP*ciTilePPageS ;
								int *piDP = piPage    +iDP*ciTilePPageS ;
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
							for( int iDP=0 ; iDP<ciPages ; iDP++ )
							{
								if( piPage[ iDP*ciTilePPageS ] < 0 )
								{//空きを発見したので書き込む
									piPageList[iP] = iDP ;
									memcpy( piPage+iDP*ciTilePPageS , piExpTile+iP*ciTilePPageS , 
										ciTilePPageS*sizeof(int) ) ;
									break;
								}
							}
							if( piPageList[iP]>=0 ){ continue; }
						}
						throw -1;
					}
				}
			}
			else
			{//マップを構成(2)
				memcpy( piPage , piExpTile , 
						iProcessPageCount*ciTilePPageS*sizeof(int) ) ;

			}
		}


	}
	catch( int iErr )
	{
		iRV = iErr ;
	}

	int iMaxTileOffset , iCountTile ;
	int iMaxPageOffset , iCountPage ;
	int iPrePage , iPreTile ;
	{//タイル数カウント
		iMaxTileOffset=0 ;
		iCountTile=0 ;
		for( int iTi=0 ; iTi<ciTiles ; iTi++ )
		{
			if( piTile[iTi*ciSizeTileColor] >= 0 )
			{ 
				iCountTile++ ;
				iMaxTileOffset = iTi;
			}
		}
	}
	{//ページ数カウント
		iMaxPageOffset=0 ;
		iCountPage=0 ;
		for( int iPa=0 ; iPa<ciPages ; iPa++ )
		{
			if( piPage[iPa*ciTilePPageS] >= 0 )
			{ 
				iCountPage++ ;
				iMaxPageOffset = iPa;
			}
		}
	}
	{//保護ページ数カウント
		iPrePage=0 ;
		for( int iPa=0 ; iPa<iMaxPage ; iPa++ )
		{
			if( aucPrePageFlag[iPa] & ciLF_LockedAnyway )
			{ iPrePage++; }
		}
	}
	{//保護タイル数カウント
		iPreTile=0 ;
		for( int iTi=0 ; iTi<iMaxTile ; iTi++ )
		{
			if( aucPreTileFlag[iTi] & ciLF_LockedAnyway )
			{ iPreTile++; }
		}
	}
	if( !iMaxPageList )
	{
		iCountPage = iMaxPage ;
		iPrePage = 0 ;
	}

	if( piOutMaxPage ){ *piOutMaxPage = iMaxPage; }
	if( piOutMaxTile ){ *piOutMaxTile = iMaxTile; }
	if( piOutTile ){ *piOutTile = iCountTile; }
	if( piOutPage ){ *piOutPage = iCountPage; }
	if( piPrePage ){ *piPrePage = iPrePage; }
	if( piPreTile ){ *piPreTile = iPreTile; }

	if( pucWholeTile ){ free(pucWholeTile); }
	if( piExpTile ){ free(piExpTile); }
	if( piPageList )
	{
		if( ppucOutPageList )
		{
			*ppucOutPageList = (unsigned char*)malloc( ciPageListSize ) ;
			if( *ppucOutPageList )
			{
				for( int i=0 ; i<ciPageListSize ; i++ )
				{
					(*ppucOutPageList)[i] = piPageList[i] ;
				}
			}
		}
		free(piPageList);
	}
	if( piPage )
	{
		if( ppucOutPage )
		{
			*ppucOutPage = (unsigned char*)malloc( ciPageSize ) ;
			if( *ppucOutPage )
			{
				for( int i=0 ; i<ciPageSize ; i++ )
				{
					(*ppucOutPage)[i] = piPage[i] ;
				}
			}
		}
		free(piPage);
	}
	if( piTile )
	{
		if( ppucOutTile )
		{
			*ppucOutTile = (unsigned char*)malloc( ciTiles*ciChipPTileS ) ;
			if( *ppucOutTile )
			{
				for( int i=0 ; i<ciTiles ; i++ )
				{
					for( int q=0 ; q<ciChipPTileS ; q++ )
					{
						(*ppucOutTile)[i*ciChipPTileS+q] = piTile[i*ciSizeTileColor+q] ;
					}
				}
			}
		}
		if( ppucOutTileColor )
		{
			*ppucOutTileColor = (unsigned char*)malloc( ciTiles ) ;
			if( *ppucOutTileColor )
			{
				for( int i=0 ; i<ciTiles ; i++ )
				{
					(*ppucOutTileColor)[i] = piTile[i*ciSizeTileColor+4] ;
				}
			}
		}
		free(piTile);
	}
	return iRV ;
}

int RockStage::DoTiling3456( 
	int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piPrePage , int *piPreTile ,
	unsigned char **ppucOutPageList , unsigned char **ppucOutPage , unsigned char **ppucOutTile )
{
	int iRV = 0 ;
	const int ciTiles = iMaxTile*2 ;
	const int ciPages = iMaxPage*2 ;
	const int ciTileSize = ciTiles*ciChipPTileS ;
	const int ciPageSize = ciPages*ciTilePPageS ;
	const int ciPageListSize = iProcessPageCount ;

//	const int ciExpChipSize = iProcessPageCount*ciChipPPageS ;
	const int ciExpTileSize = iProcessPageCount*ciTilePPageS ;

	int *piExpTile  = (int*)malloc(ciExpTileSize  *sizeof(int)) ;
	int *piTile     = (int*)malloc(ciTileSize     *sizeof(int)) ;
	int *piPage     = (int*)malloc(ciPageSize     *sizeof(int)) ;
	int *piPageList = (int*)malloc(ciPageListSize *sizeof(int)) ;

	if( ppucOutPageList ){ *ppucOutPageList = NULL ; }
	if( ppucOutPage     ){ *ppucOutPage     = NULL ; }
	if( ppucOutTile     ){ *ppucOutTile     = NULL ; }

	try
	{
		if( !piExpTile || !piTile || !piPage || !piPageList ){ throw 1 ; }
		for( int i=0 ; i<ciExpTileSize  ; i++ ){ piExpTile [i]=-1; }
		for( int i=0 ; i<ciTileSize     ; i++ ){ piTile    [i]=-1; }
		for( int i=0 ; i<ciPageSize     ; i++ ){ piPage    [i]=-1; }
		for( int i=0 ; i<ciPageListSize ; i++ ){ piPageList[i]=-1; }
		{//保護タイルを確定
			for( int iT=0 ; iT<iMaxTile ; iT++ )
			{
				if( aucPreTileFlag[iT] & ciLF_LockedAnyway )
				{
					for( int iC=0 ; iC<ciChipPTileS ; iC++ ){ piTile[iT*4+iC] = aucPreTile[iT*4+iC] ; }
				}
			}
		}
		{//原作と同一のタイルデータを取得
			for( int iTi=0 ; iTi<iProcessPageCount*ciTilePPageS ; iTi++ )
			{
				{//現在確定分との一致を検索
					int aiTileImage[4] ;
					SetupTileImage( aiTileImage , iTi ) ;
					for( int iTC=0 ; iTC<ciTiles ; iTC++ )
					{
						if( !memcmp( aiTileImage , piTile+iTC*4 , 4*sizeof(int) ) )
						{
							piExpTile[ iTi ] = iTC ;
							break ;
						}
					}
					if( piExpTile[ iTi ] >= 0 ){ continue; }
				}
				{//保護用のタイルデータとの一致
					unsigned char aucTileImage[4] ;
					SetupTileImage( aucTileImage , iTi ) ;
					for( int iTC=0 ; iTC<iMaxTile ; iTC++ )
					{
						if( !memcmp( aucTileImage , aucPreTile+iTC*4 , 4 ) )
						{
							piExpTile[ iTi ] = iTC ;
							for( int iC=0 ; iC<ciChipPTileS ; iC++ ){ piTile[iTC*4+iC] = aucTileImage[iC] ; }
							break ;
						}
					}
				}
			}
		}
		{//原作には無いタイル情報を作成
			for( int iTi=0 ; iTi<iProcessPageCount*ciTilePPageS ; iTi++ )
			{
				if( piExpTile[iTi] >=0 ){ continue; }
				int aiTileImage[4] ;
				SetupTileImage( aiTileImage , iTi ) ;
				{//同一なタイルを探す
					for( int iTC=0 ; iTC<ciTiles ; iTC++ )
					{
						if( piTile[ iTC*ciChipPTileS ] < 0 ){ continue; }
						if( !memcmp( piTile+iTC*ciChipPTileS , aiTileImage , ciChipPTileS*sizeof(int) ) )
						{
							piExpTile[iTi] = iTC ;
							break ;
						}
					}
					if( piExpTile[iTi] >= 0 )
					{ //見つかったとき
						continue ;
					}
				}
				{//新規登録
					for( int iNewT=0 ; iNewT<ciTiles ; iNewT++ )
					{
						if( piTile[iNewT*ciChipPTileS]>=0 ){ continue ; }
						piExpTile[iTi] = iNewT ;
						memcpy( piTile+iNewT*ciChipPTileS , aiTileImage , ciChipPTileS*sizeof(int) ) ;
						break ;
					}
					if( piExpTile[iTi] >= 0 )
					{ //見つかったとき
						continue ;
					}
				}
				//登録不可能
				throw -2 ;
			}
		}
		if( iExportPageList )
		{//ページリストを抱える構造の場合は、同一ページをまとめる/無い時は類似ページを利用する
			{//原作と同じページデータを作成
				for( int iPa=0 ; iPa<iProcessPageCount ; iPa++ )
				{
					unsigned char aucPageImage[ciTilePPageS] ;
					for( int i=0 ; i<ciTilePPageS ; i++ ){ aucPageImage[i] = piExpTile[iPa*ciTilePPageS+i] ; }
					for( int iDefPa=0 ; iDefPa<iMaxPage ; iDefPa++ )
					{
						if( !memcmp( aucPrePage+iDefPa*ciTilePPageS , aucPageImage , ciTilePPageS ) )
						{
							piPageList[iPa] = iDefPa ;
							memcpy( piPage+iDefPa*ciTilePPageS , piExpTile+iPa*ciTilePPageS , ciTilePPageS*sizeof(int) ) ;
							break ;
						}
					}
				}
			}
			{//原作に類似したページデータを更新して追加
				for( int iPa=0 ; iPa<iProcessPageCount ; iPa++ )
				{
					if( piPageList[iPa] >=0 ){ continue; } //既にページが確定していたら次へ
					unsigned char aucPageImage[ciTilePPageS] ;
					for( int i=0 ; i<ciTilePPageS ; i++ ){ aucPageImage[i] = (unsigned char)piExpTile[iPa*ciTilePPageS+i] ; }
					{//同一なタイルを探す
						for( int iSeekP=0 ; iSeekP<iProcessPageCount ; iSeekP++ )
						{
							if( piPageList[iSeekP]>=0 && iPa!=iSeekP &&
								!memcmp(  piExpTile+ciTilePPageS*iPa , piExpTile+ciTilePPageS*iSeekP , ciTilePPageS*sizeof(int) ) )
							{
								piPageList[iPa] = iSeekP ;
								break ;
							}
						}
						if( piPageList[iPa]>=0 )
						{ //見つかったとき
							continue ;
						}
					}
					{//未確定ページの中で最も重複の多いページに上書きする
						int iBestPage , iBestDelta ;
						iBestPage = -1 ;
						iBestDelta = ciTilePPageS ;
						for( int iDefPa=0 ; iDefPa<iMaxPage ; iDefPa++ )
						{
							if( piPage[iDefPa*ciTilePPageS]>=0 ){ continue ; }
							int iDelta=0 ;
							for( int i=0 ; i<ciTilePPageS ; i++ )
							{
								if( aucPrePage[iDefPa*ciTilePPageS+i] != aucPageImage[i] )
								{ iDelta++; }
							}
							if( iBestDelta>iDelta )
							{
								iBestDelta = iDelta ;
								iBestPage = iDefPa ;
							}
						}
						if( iBestDelta < ciTilePPageS/4 )
						{ //一番差分が小さかったものが、75%以上一致していればそれを採用する
							assert( piPage[iBestPage*ciTilePPageS]<0 ) ;
							piPageList[iPa] = iBestPage ;
							memcpy( piPage+iBestPage*ciTilePPageS , piExpTile+iPa*ciTilePPageS , ciTilePPageS*sizeof(int) ) ;
						}
					}
				}
			}
			{//原作には無いページデータを追加
				for( int iPa=0 ; iPa<iProcessPageCount ; iPa++ )
				{
					if( piPageList[iPa] >=0 ){ continue; }
					{//同一なタイルを探す
						for( int iSeekP=0 ; iSeekP<iProcessPageCount ; iSeekP++ )
						{
							if( piPageList[iSeekP]>=0 && iPa!=iSeekP &&
								!memcmp(  piExpTile+ciTilePPageS*iPa , piExpTile+ciTilePPageS*iSeekP , ciTilePPageS*sizeof(int) ) )
							{
								piPageList[iPa] = piPageList[iSeekP] ;
								break ;
							}
						}
						if( piPageList[iPa]>=0 )
						{ //見つかったとき
							continue ;
						}
					}
					{//新規登録
						for( int iNewP=0 ; iNewP<ciPages ; iNewP++ )
						{
							if( piPage[iNewP*ciTilePPageS]>=0 ){ continue ; }
							piPageList[iPa] = iNewP ;
							memcpy( piPage+iNewP*ciTilePPageS , piExpTile+iPa*ciTilePPageS , ciTilePPageS*sizeof(int) ) ;
							break ;
						}
						if( piPageList[iPa]>=0 ){ continue ; }
						throw -3 ;
					}
				}
			}
		}
		else
		{//ページリストのない構造の場合
				memcpy( piPage , piExpTile , 
						iProcessPageCount*ciTilePPageS*sizeof(int) ) ;
		}

	}
	catch( int i )
	{
		iRV = i ;
	}


	int iMaxTileOffset , iCountTile ;
	int iMaxPageOffset , iCountPage ;
	int iPrePage , iPreTile ;
	{//タイル数カウント
		iMaxTileOffset=0 ;
		iCountTile=0 ;
		for( int iTi=0 ; iTi<ciTiles ; iTi++ )
		{
			if( piTile[iTi*4] >= 0 )
			{ 
				iCountTile++ ;
				iMaxTileOffset = iTi;
			}
		}
	}
	{//ページ数カウント
		iMaxPageOffset=0 ;
		iCountPage=0 ;
		for( int iPa=0 ; iPa<ciPages ; iPa++ )
		{
			if( piPage[iPa*ciTilePPageS] >= 0 )
			{ 
				iCountPage++ ;
				iMaxPageOffset = iPa;
			}
		}
	}
	{//保護ページ数カウント
		iPrePage=0 ;
		for( int iPa=0 ; iPa<iMaxPage ; iPa++ )
		{
			if( aucPrePageFlag[iPa] & ciLF_LockedAnyway )
			{ iPrePage++; }
		}
	}
	{//保護タイル数カウント
		iPreTile=0 ;
		for( int iTi=0 ; iTi<iMaxTile ; iTi++ )
		{
			if( aucPreTileFlag[iTi] & ciLF_LockedAnyway )
			{ iPreTile++; }
		}
	}
	if( !iMaxPageList )
	{
		iCountPage = iMaxPage ;
		iPrePage = 0 ;
	}

	if( piOutMaxPage ){ *piOutMaxPage = iMaxPage; }
	if( piOutMaxTile ){ *piOutMaxTile = iMaxTile; }
	if( piOutTile ){ *piOutTile = iCountTile; }
	if( piOutPage ){ *piOutPage = iCountPage; }
	if( piPrePage ){ *piPrePage = iPrePage; }
	if( piPreTile ){ *piPreTile = iPreTile; }

	if( piExpTile  ){ free(piExpTile ) ; piExpTile =NULL ; }
	if( piTile     )
	{ 
		if( ppucOutTile )
		{
			*ppucOutTile = (unsigned char*)malloc( ciTileSize ) ;
			if( *ppucOutTile )
			{
				for( int i=0 ; i<ciTileSize ; i++ ){ (*ppucOutTile)[i] = piTile[i] ; }
			}
		}
		free( piTile ) ; 
		piTile = NULL ;
	}
	if( piPage )
	{ 
		if( ppucOutPage )
		{
			*ppucOutPage = (unsigned char*)malloc( ciPageSize ) ;
			if( *ppucOutPage )
			{
				for( int i=0 ; i<ciPageSize ; i++ ){ (*ppucOutPage)[i] = piPage[i] ; }
			}
		}
		free( piPage ) ; 
		piPage = NULL ; 
	}
	if( piPageList )
	{ 
		if( ppucOutPageList )
		{
			*ppucOutPageList = (unsigned char*)malloc( iProcessPageCount ) ;
			if( *ppucOutPageList )
			{
				for( int i=0 ; i<iProcessPageCount ; i++ ){ (*ppucOutPageList)[i] = piPageList[i] ; }
			}
		}
		free( piPageList ) ; 
		piPageList = NULL ; 
	}

	return iRV ;
#if 0


	if( piOutPage ){ *piOutPage=iLastPage; }
	if( piOutTile ){ *piOutTile=iLastTile; }
	if( piOutMaxPage ){ *piOutMaxPage=iMaxPage; }
	if( piOutMaxTile ){ *piOutMaxTile=iMaxTile; }
	if( iMaxPageList )
	{ //ページリストを保持する構造
		if( iLastPage<=iMaxPage &&
			iLastTile<=iMaxTile )
		{
			for( int i=0 ; i<iMaxTile*ciChipPTileS ; i++ )
				{ SetROM8p( iAddrTile+i , piTile[i] ) ; }
			MASK( iAddrTile     , iMaxTile*ciChipPTileS ) ;
			for( int i=0 ; i<iMaxPage*ciTilePPageS ; i++ )
				{ SetROM8p( iAddrPage+i , piPage[i] ) ; }
			MASK( iAddrPage     , iMaxPage*ciTilePPageS ) ;
			if( iExportPageList )
			{
				for( int i=0 ; i<iMaxPageList ; i++ )
					{ SetROM8p( iAddrPageList+i , piPageList[i] ) ; }
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
						SetROM8p( iAddrPageList+aiMultiplexStage_DeltaAddr[q]+iWP , piPageList[i] ) ; 
						iWP ++ ;
					}
					MASK( iAddrPageList+aiMultiplexStage_DeltaAddr[q] , iMaxPageList ) ;
				}
			}
		}
		else
		{

			return -2 ;
		}
	}
	else
	{//ページリストを抱えない構造
		if( iLastPage<=iMaxPage &&
			iLastTile<=iMaxTile )
		{
			for( int i=0 ; i<iMaxTile*ciChipPTileS ; i++ )
				{ SetROM8p( iAddrTile+i , piTile[i] ) ; }
			MASK( iAddrTile     , iMaxTile*ciChipPTileS ) ;
			for( int i=0 ; i<iMaxPage*ciTilePPageS ; i++ )
				{ SetROM8p( iAddrPage+i , piTileMap[i] ) ; }
			MASK( iAddrPage     , iMaxPage*ciTilePPageS ) ;
		}
		else
		{
			return -2 ;
		}
	}
	if( piTileMap ){ free(piTileMap); }
	if( piTile ){ free(piTile); }
	if( piPage ){ free(piPage); }
	if( piPageList ){ free(piPageList); }
	return 0 ;
#endif
}

