#include "RockStage_p.h"

//特殊データの設定
/*
RRRRRRRRRRRRRRRR 0
RRRRRRRRRRRRRRRR　ルーム進行
RRRRRRRRRRRRRRRR
[RofR]..[EOoR]..　復活点の　ルーム・敵オフセット
HHHHHHHH......BB 4判定　BGM
RRRRRRRRRR......　復活地点のページ
LRLRLRLR........  復活地点の左端・右端ページ数
[TDy ]..[BTil]..　着地Y　タイルの裏側
................ 8
................
................
................
................ C
................
................
................
*/

static const RS_SpDataList acSpDataLoc1[] = {
	{0x0ECD46,0x000004,1,   4,0x040,580,-1,-1,0,}, //判定選択(前)
	{-2,0x00,0x04,0x01,}, //以下0～5のみ
	{0x0ECD5E,0x000004,1,   4,0x044,581,-1,-1,0,}, //判定選択(後)
	//以上0～4のみ
	{0x008C70,0x020000,1,0x30,0x000,582,-1,16,0,},//ルーム進行

	{0x0EC2EB,0x000001,0xC, 3,0x050,584,-1,-1,101,},//復活地点ページ
	{0x0EC2D4,0x000001,0xC, 2,0x053,583,-1,-1,102,},//復活地点更新ページ

	{-2,0x00,0x04,0x02,}, //以下0～4のみ
	{0x0EC2F1,0x000001,0xC, 3,0x055,586,-1,-1,101,},//復活地点ページ(後)
	{0x0EC2DA,0x000001,0xC, 2,0x058,585,-1,-1,102,},//復活地点更新ページ(後)
	//以上0～4のみ
	{-2,0x05,0x05,0x02,}, //以下5のみ
	{0x0EC2F1,0x000001,0xC, 2,0x055,586,-1,-1,101,},//復活地点ページ(後)
	{0x0EC2DA,0x000001,0xC, 1,0x058,585,-1,-1,102,},//復活地点更新ページ(後)
	//以上5のみ

	{-2,0x00,0x04,0x04,}, //以下0～4のみ
	{0x0A93A0,0x000001,0xC, 3,0x030,593,-1,-1,101,}, //復活地点毎のルーム番号
	{0x0A93A0+6,0x0001,0xC, 3,0x033,594,-1,-1,102,}, //復活地点毎のルーム番号(後)
	{0x0A93C3,0x000001,0xC, 3,0x038,595,-1,-1,101,}, //復活地点毎の敵オフセット
	{0x0A93C3+6,0x0001,0xC, 3,0x03B,596,-1,-1,102,}, //復活地点毎の敵オフセット(後)
	//以上0～4のみ
	{-2,0x05,0x05,0x04,}, //以下5のみ
	{0x0A93A0,0x000001,0xC, 3,0x030,593,-1,-1,101,}, //復活地点毎のルーム番号
	{0x0A93A0+6,0x0001,0xC, 2,0x033,594,-1,-1,102,}, //復活地点毎のルーム番号(後)
	{0x0A93C3,0x000001,0xC, 3,0x038,595,-1,-1,101,}, //復活地点毎の敵オフセット
	{0x0A93C3+6,0x0001,0xC, 2,0x03B,596,-1,-1,102,}, //復活地点毎の敵オフセット(後)
	//以上5のみ
	{0x0A93FA,0x000001,0x18,2,0x060,597,-1,-1,101,}, //復活地点1のルーム左端・右端ページ
	{0x0A93FA+0xC,0x01,0x18,2,0x062,598,-1,-1,102,}, //復活地点2のルーム左端・右端ページ
	{0x0A93FA+0x6,0x01,0x18,2,0x064,599,-1,-1,101,}, //復活地点1のルーム左端・右端ページ
	{0x0A93FA+0x12,0x1,0x18,2,0x066,600,-1,-1,102,}, //復活地点2のルーム左端・右端ページ

	{0x000000,0x000000,0,0x00,0x000,  0,-1,-1,103,}, //ボタン

	{-2,0x00,0x04,0x02,}, //以下0～4のみ
	{0x0EC51A,0x000001,0xC, 3,0x070,601,-1,-1,101,}, //着地Y
	{0x0EC51A+6,0x0001,0xC, 3,0x073,602,-1,-1,102,}, //着地Y(後)
	//以上0～4のみ
	{-2,0x05,0x05,0x02,}, //以下5のみ
	{0x0EC51A,0x000001,0xC, 3,0x070,601,-1,-1,101,}, //着地Y
	{0x0EC51A+6,0x0001,0xC, 2,0x073,602,-1,-1,102,}, //着地Y(後)
	//以上5のみ

	{0x0A9394,0x000001,6,   2,0x04B,592,-1,-1,0,}, //ステージ毎のBGM

	{0x0ECE3D,0x000001,6,   2,0x078,603,-1,-1,101,}, //ブロックの裏側
	{-2,0x00,0x03,0x02,}, //以下0～3のみ
	{0x0ECE31,0x000001,6,   2,0x07A,604,-1,-1,101,}, //ブロックの裏側特殊
	{0x0ECE49,0x000001,6,   2,0x07C,605,-1,-1,102,}, //ブロックの特集ページ
	//以上0～3のみ
	{-2,0x04,0x05,0x02,}, //以下4,5のみ
	{0x0ECE31,0x000001,6,   2,0x07A,604,-1,-1,101,}, //ブロックの裏側特殊
	{0x0ECE49,0x000001,6,   1,0x07C,605,-1,-1,102,}, //ブロックの特集ページ
	//以上4,5のみ

	{0x008D00,0x020000,1,0x01,0x200,588,-1,-1,0,}, //グラフィック指定の数
	{0x008D01,0x020000,1,0x1F,0x201,589,-1,16,0,}, //グラフィック指定の本体
	{0x008D20,0x020000,1,0x01,0x220,590,-1,-1,0,}, //グラフィック指定の数(後)
	{0x008D21,0x020000,1,0x1F,0x221,591,-1,16,0,}, //グラフィック指定の本体(後)
	{0x008D40,0x020000,1,0x30,0x240,  0,-1,-1,0,}, //ページごとの敵画像番号
	{0x008D80,0x020000,1,0x79,0x280,  0,-1,-1,0,}, //敵画像定義

	{0x008CA0,0x020000,1,0x60,0x100,  0, 0, 0,0,}, //パレット
	{-2,0x00,0x03,0x01,}, //以下0～3のみ(他と違うので注意)
	{0x008E00,0x020000,1,0x140,0x300,  0, 0, 0,0,}, //変化地形データ
	{-2,0x04,0x05,0x01,}, //以下4,5のみ(他と違うので注意)
	{0x008E00,0x020000,1,0x0A0,0x300,  0, 0, 0,0,}, //変化地形データ
//	{0x,0x,1,0x,0xXXX,  0,-1,-1,0,}, //
	{-1}, //終了
} ;
static const RS_SpDataList acSpDataLoc2[] = 
{
	{0x01B400,0x020000,1,0x20,0x050,492,-1,16,0,}, //ルーム進行
	{0x01BB00,0x020000,1, 6*2,0x000,490,-1, 6,0,}, //復活地点設定(手動)
	{0x01BB0C,0x020000,1, 6*9,  6*2,491,-1, 6,201,}, //復活地点設定(自動可)
	{0x1ECC44,0x000002,1,   2,0x070,493,-1,-1,0,}, //判定選択(前)
	{0x1C906F,0x000001,1,   1,0x074,500,-1,-1,0,}, //ボス出現ページ(前)
	{0x1C9061,0x000001,1,   1,0x076,502,-1,-1,0,}, //シャッターを閉め始めるページ(前)
	{-2,0x00,0x05,0x03,}, //以下0～5のみ
	{0x1ECC54,0x000002,1,   2,0x072,494,-1,-1,0,}, //判定選択(後)
	{0x1C9077,0x000001,1,   1,0x075,501,-1,-1,0,}, //ボス出現ページ(後)
	{0x1C9069,0x000001,1,   1,0x077,503,-1,-1,0,}, //シャッターを閉め始めるページ(後)
	//以上0～5のみ
	//色設定
	{0x01BE00,0x020000,1,0x62,0x080,  0, 0, 0,0,}, //前のステージ
	{0x01BF00,0x020000,1,0x62,0x100,  0, 0, 0,0,}, //後ろのステージ
	//敵グラフィック設定
	{0x01B42C,0x020000,1,0x20,0x180,  0, 0, 0,0,}, //ルーム毎のオフセット
	{0x01B460,0x020000,1,0xFC,0x200,  0, 0, 0,0,}, //データ実体
	{-1,}, //終了
} ;
static const RS_SpDataList acSpDataLoc3[] =
{
	{0x00AA40,0x010000,1,0x20,0x000,550,-1,0x08,0,}, //ルーム進行
	{0x00AA60,0x010000,1,0x20,0x020,551,-1,0x10,303,}, //ルーム毎の敵パターン・色パターン
	{0x00AA80,0x010000,1,0x02,0x040,552,-1, -1 ,0,}, //VROM
	{0x00AAF8,0x010000,1,0x08,0x050,553,-1, -1 ,0,}, //中間ページ
	{0x00AAF0,0x010000,1,0x08,0x058,554,-1, -1 ,301,}, //中間ルーム
	{0x00ABC0,0x010000,1,0x08,0x060,555,-1, -1 ,302,}, //中間敵オフセット

	{0x00AA82,0x010000,1,0x64,0x100,  0,-1, -1 ,0,}, //BG色・アニメーション番号

	{-1,}, //終了
} ;
static const RS_SpDataList acSpDataLoc4[] =
{
	{0x20B530,0x010000,1,0x10,0x00,260,-1,0x08,0,}, //ルーム進行
	{0x20B550,0x010000,1,0x10,0x10,261,-1,0x08,0,}, //色セット番号
	{0x20B560,0x010000,1,0x10,0x20,262,-1,0x08,0,}, //敵(等)Chr
	{0x20B540,0x010000,1,0x10,0x30,263,-1,0x04,0,}, //分岐
	//0x40

	{-2,0x00,0x0F,0x05,}, //以下0～Fのみ
	{0x3EC88B,0x000002,1,0x02,0x100,264,-1, -1 ,0,}, //中間ページ
	{0x3EC8AB,0x000008,1,0x08,0x108,265,-1,0x04,0,}, //中間データ
	{0x3EC85B,0x000001,1,0x01,0x1E0,266, 3, -1 ,0,}, //BGM
	{0x3EC86B,0x000001,1,0x01,0x1E1,  0, 0,  0 ,0,}, //RockFlag
	{0x3EC87B,0x000001,1,0x01,0x1E2,  0, 0,  0 ,0,}, //隠すY
	//以上0～Fのみ

	{-1,}, //終了
} ;
static const RS_SpDataList acSpDataLoc5[] = 
{ 
	{0x00A950,0x010000,1,0x18,0x00,250,-1,0x08,0,}, //ルーム進行
	{0x00A968,0x010000,1,0x18,0x20,251,-1,0x08,0,}, //ルーム毎敵色など
	{0x00A9E0,0x010000,1,0x20,0x40,252,-1,0x04,0,}, //分岐
	{-2,0x0E,0x0E,0x01,}, //以下0E(ボスラッシュ)のみ
	{0x0EA908,0x000000,1,0x08,0x60,255,-1, -1 ,0,}, //ボスラッシュのページ数
	//以上0E(ボスラッシュ)のみ
	//0x70

	{-2,0x00,0x0F,0x02,}, //以下0～Fのみ
	{0x179166,0x000006,1,0x06,0x100,253,-1,0x03,0,}, //中間データ
	{0x1ED4D2,0x000001,1,0x01,0x1E0,254,-1, -1 ,0,}, //BGM
	//以上0～Fのみ

	{-1,}, //終了
} ;
static const RS_SpDataList acSpDataLoc6[] =
{
	{0x3EDB03,0x000001,1,0x01,0x1E0,470,-1, -1 ,0,}, //チップ判定セット
	{0x3EDFA5,0x000001,1,0x01,0x1E1,471,-1, -1 ,0,}, //BGM
	{-2,0x00,0x07,0x01,}, //以下00-07のみ
	{0x3FF518,0x000001,1,0x01,0x1E2,472,-1, -1 ,0,}, //真のボスのページ数
	//以上00-07のみ
	{-1,}, //終了
} ; 
static const RS_SpDataList *pacSpDataLoc[6] =
{ acSpDataLoc1 , acSpDataLoc2 , acSpDataLoc3 , acSpDataLoc4 , acSpDataLoc5 , acSpDataLoc6 } ;

int RockStage::LoadSpData( RS_SpData *ptSp )
{
	int iRV=0 ;
	const RS_SpDataList *pcSpData = pacSpDataLoc[iEditMode-1] ;
	switch( pcSpData[ptSp->iLoadOffset].aiData[0] )
	{
	case -1: return -1 ;
	case -2: // [1]<=iStageNO<=[2]でなかったら[3]個データを飛ばす
		{
			if( iStageNO<pcSpData[ptSp->iLoadOffset].aiData[1] ||
				iStageNO>pcSpData[ptSp->iLoadOffset].aiData[2] )
			{
				ptSp->iLoadOffset += pcSpData[ptSp->iLoadOffset].aiData[3] ; 
			}
			ptSp->iLoadOffset ++;
			return LoadSpData( ptSp ) ;
		}
		break ; //要らない
	default:
		ptSp->iAddrBase   = pcSpData[ptSp->iLoadOffset].iAddrBase ;
		ptSp->iAddrDeltaS = pcSpData[ptSp->iLoadOffset].iAddrDeltaS ;
		ptSp->iAddrDeltaD = pcSpData[ptSp->iLoadOffset].iAddrDeltaD ;
		ptSp->iSize       = pcSpData[ptSp->iLoadOffset].iSize ;
		ptSp->iDataOffset = pcSpData[ptSp->iLoadOffset].iDataOffset ;
		ptSp->iEditMsg    = pcSpData[ptSp->iLoadOffset].iEditMsg ;
		ptSp->iEditSize   = pcSpData[ptSp->iLoadOffset].iEditSize ;
		ptSp->iEditLine   = pcSpData[ptSp->iLoadOffset].iEditLine ;
		iRV               = pcSpData[ptSp->iLoadOffset].iRV ;
		ptSp->iLoadOffset ++ ;
	}
	return iRV ;
}
int RockStage::R12_GetLatterPageNumber()
{
	switch( iEditMode )
	{
	case 1:
		return aucSpData[SPOf1_StageBorder] ;
	break ;
	case 2:
		return aucSpData[SPOf2_StageBorder] ;
	break ;
	default:
		assert( 0 ) ;
	}
	return 0 ;
}
int RockStage::R12_GetEndPageNumber()
{
	switch( iEditMode )
	{
	case 1:
		{
			if( iStageNO>=0x4 ){ return R12_GetLatterPageNumber(); }
			int aiRoomNoPerPage[ciMaxAllocatePage] ;
			AutoSpData_12_sub( aiRoomNoPerPage , R1_MaxRoom-1 , aucSpData+SPOf1_RoomConnection+1 ) ;
			for( int i=R12_GetLatterPageNumber() ; i<R1_MaxRoom ; i++ )
			{
				if( !aucSpData[SPOf1_RoomConnection+1+aiRoomNoPerPage[i]] ){ return i ; }
			}
			return R1_MaxRoom-1 ;
		}
	break ;
	case 2:
		{
			switch( iStageNO )
			{
			case 1:case 2:case 3:case 5:
				return aucSpData[0x075] ;
			}
			return iProcessPageCount-1 ;
		}
	break ;
	default:
		assert( 0 ) ;
	}
	return 0 ;
}
void RockStage::AutoSpData_12_sub( int *piRoomNoPerPage , int iMaxRoom , unsigned char *pucSP )
{
	for( int i=0 ; i<iProcessPageCount ; i++ ){ piRoomNoPerPage[i]=-1; }
	{
		int iWP=0 ;
		for( int i=0 ; i<iMaxRoom ; i++ )
		{
			for( int q=0 ; q<(pucSP[i]&0x1F)+1 ; q++ )
			{
				piRoomNoPerPage[ iWP++ ] = i ;
				if( iWP>=iProcessPageCount ){ break; }
			}
			if( iWP>=iProcessPageCount ){ break; }
		}
		for( int i=iWP ; i<iProcessPageCount ; i++ )
		{
			piRoomNoPerPage[ i ] = iMaxRoom-1 ;
		}
	}
}
void RockStage::AutoSpData_1_0()
{
//以下の値を利用して、他の値を計算する
//aucSpData[SPOf1_RoomConnection]
//aucSpData[SPOf1_RevPage0]
//aucSpData[SPOf1_RevPage1]
//計算する値：
//aucSpData[SPOf1_RevUDPage0]
//aucSpData[SPOf1_RevUDPage1]
//aucSpData[SPOf1_RevRoom]
//aucSpData[SPOf1_RevObjPID]
//aucSpData[SPOf1_RevPageLRPerRoom]
	//ページごとのルーム番号を確認
	int aiRoomNoPerPage[ciMaxAllocatePage] ;
	AutoSpData_12_sub( aiRoomNoPerPage , R1_MaxRoom-1 , aucSpData+SPOf1_RoomConnection+1 ) ;
	{//復活地点を更新するページ/復活地点と同じページにする
		aucSpData[SPOf1_RevUDPage0+0] = aucSpData[SPOf1_RevPage0+1] ;
		aucSpData[SPOf1_RevUDPage0+1] = aucSpData[SPOf1_RevPage0+2] ;
		aucSpData[SPOf1_RevUDPage1+0] = aucSpData[SPOf1_RevPage1+1] ;
		aucSpData[SPOf1_RevUDPage1+1] = aucSpData[SPOf1_RevPage1+2] ;
	}
	{//復活地点のルーム
		for( int i=0 ; i<3 ; i++ )
		{
			aucSpData[SPOf1_RevRoom+0+i] = aiRoomNoPerPage[ aucSpData[SPOf1_RevPage0+i] ] ;
			aucSpData[SPOf1_RevRoom+3+i] = aiRoomNoPerPage[ aucSpData[SPOf1_RevPage1+i] ] ;
		}
	}
	{//オブジェクトオフセット
		for( int i=0 ; i<3 ; i++ )
		{
			aucSpData[SPOf1_RevObjPID+0+i] = OU[0].GetElemOffsetPerPage( aucSpData[SPOf1_RevPage0+i]+1 )-1 ;
			aucSpData[SPOf1_RevObjPID+3+i] = OU[1].GetElemOffsetPerPage( aucSpData[SPOf1_RevPage1+i]+1 )-1 ;
		}
	}
	{//ルームの左右のページ番号
		for( int i=0 ; i<2 ; i++ )
		{
//			aucSpData[SPOf1_RevPageLRPerRoom+0+i*2] = aucSpData[SPOf1_RevPage0+1+i] ;
//			aucSpData[SPOf1_RevPageLRPerRoom+4+i*2] = aucSpData[SPOf1_RevPage1+1+i] ;

			for( int iFL=0 ; iFL<2 ; iFL++ )
			{
				static const int aciOffsetTable[2] = { SPOf1_RevPage0 , SPOf1_RevPage1 } ;
				int iSPOffset = aciOffsetTable[iFL] ;
				int iStartPage = aucSpData[iSPOffset+1+i] ;
				int q ;
				{//左
					for( q=iStartPage-1 ; q>=0 ; q-- )
					{
						if( aiRoomNoPerPage[iStartPage] != aiRoomNoPerPage[q] ){ break; }
					}
					q++ ;
					aucSpData[SPOf1_RevPageLRPerRoom+0+4*iFL+i*2] = q ;
				}
				{//右
					for( q=iStartPage+1 ; q<iProcessPageCount ; q++ )
					{
						if( aiRoomNoPerPage[iStartPage] != aiRoomNoPerPage[q] ){ break; }
					}
					q-- ;
					aucSpData[SPOf1_RevPageLRPerRoom+1+4*iFL+i*2] = q ;
				}
			}
		}
	}


}
void RockStage::AutoSpData_2_0()
{
	int aiRoomNoPerPage[ciMaxAllocatePage] ;
	AutoSpData_12_sub( aiRoomNoPerPage , R2_MaxRoom , aucSpData+SPOf2_RoomConnection ) ;

	for( int i=0 ; i<6 ; i++ )
	{
		int iPage = aucSpData[SPOf2_CP_Page+i] ;
		if( iPage>=iMaxPage ){ iPage=iMaxPage-1; }
		aucSpData[SPOf2_CP_Room+i] = aiRoomNoPerPage[iPage] ;
	}
}
void RockStage::AutoSpData_2_1()
{
//以下の3値を利用して、他の値を計算する
//aucSpData[SPOf2_RoomConnection+i]
//aucSpData[SPOf2_CP_Room+i]
//aucSpData[SPOf2_CP_Page+i]
	for( int i=0 ; i<6 ; i++ )
	{
		aucSpData[SPOf2_CP_ObjPID+i]  = OU[0].GetElemOffsetPerPage( aucSpData[SPOf2_CP_Page+i] ) ;
		aucSpData[SPOf2_CP_ItemPID+i] = OU[1].GetElemOffsetPerPage( aucSpData[SPOf2_CP_Page+i] ) ;
		int iNTL = 0x8500 + aucSpData[SPOf2_CP_Page+i]*0x40 - 0x20 ;
		int iNTR = 0x8500 + aucSpData[SPOf2_CP_Page+i]*0x40 + 0x60 ;
		aucSpData[SPOf2_CP_NTLhi  +i] = (iNTL>>8) ;
		aucSpData[SPOf2_CP_NTLlo  +i] = (iNTL&0xFF) ;
		aucSpData[SPOf2_CP_NTRhi  +i] = (iNTR>>8) ;
		aucSpData[SPOf2_CP_NTRlo  +i] = (iNTR&0xFF) ;
		aucSpData[SPOf2_CP_PageL  +i] = aucSpData[SPOf2_CP_Page+i] ;

		int iRoomNo = aucSpData[SPOf2_CP_Room+i] ;
		if( iRoomNo<0x20 )
		{
			aucSpData[SPOf2_CP_PageR  +i] = 
				aucSpData[SPOf2_CP_Page+i]+
				(aucSpData[SPOf2_RoomConnection+iRoomNo]&0xF);
		}
	}
}
int RockStage::AutoSpData_3_1()
{
	for( int i=0 ; i<R3_MaxRevPoint ; i++ )
	{
		int iPage = aucSpData[SPOf3_RevPage+i] ;
		if( iPage >= iProcessPageCount ){ break; }
		int iRemain = iPage ;
		int q ;
		for( q=0 ; q<R3_MaxRoom ; q++ )
		{
			if( !iRemain )
			{
				aucSpData[SPOf3_RevRoom+i] = q ;
				break ;
			}
			int iConVal = aucSpData[SPOf3_RoomConnection+q] ;
			iConVal &= 0xF ;
			iConVal ++ ;
			iRemain -= iConVal ;
		}
		if(	q==R3_MaxRoom ){return iPage ;}
	}
	return -1 ;
}
int RockStage::AutoSpData_3_2()
{
	for( int i=0 ; i<R3_MaxRevPoint ; i++ )
	{
		int iPage = aucSpData[SPOf3_RevPage+i] ;
		if( iPage >= iProcessPageCount ){ break; }
		int iTmp = OU[0].GetElemOffsetPerPage( iPage ) ;
		aucSpData[SPOf3_RevObjOffset+i] = iTmp ;
	}
	return 0 ;
}

int RockStage::AutoSpData_3_3( tstring *pstrObjPat , tstring *pstrMessage )
{
	int iRV=-1 ;
//aucSpData[SPOf3_RoomConnection]
	//ページ毎のルーム番号の取得
	int iRoomPerPage[R3_MaxPageAlloc] ;
	for( int i=0 ; i<_countof(iRoomPerPage) ; i++ ){ iRoomPerPage[i]=-1; }
	{
		int iWPos=0 ;
		for( int iR=0 ; iR<R3_MaxRoom ; iR++ )
		{
			for( int i=0 ; i<((aucSpData[SPOf3_RoomConnection+iR]&0xF)+1) ; i++ )
			{
				if( iWPos<_countof(iRoomPerPage) ){ iRoomPerPage[ iWPos ] = iR ; }
				iWPos ++ ;
			}
		}
	}
	//ルーム毎に敵の存在をサーチ
	{
		for( int iR=0 ; iR<R3_MaxObjVROMBGColor ; iR++ )
		{
			unsigned char iChrBank[2][256] ;
			int iHaveCond[2] ;
			iHaveCond[0] = iHaveCond[1] = 0 ;
			for( int q=0 ; q<256 ; q++ ){ iChrBank[0][q]=iChrBank[1][q]=1; }

			//利用されているオブジェクトを検索
			for( int i=0 ; i<OU[0].GetCount() ; i++ )
			{
				int iTx = OU[0].GetX(i) ;
				int iOffset = iTx/256 ;
				if( iTx>=0 && iTx<iProcessPageCount*256 &&
					iOffset<_countof(iRoomPerPage) && iRoomPerPage[iOffset]==iR )
				{
					unsigned char iMask[2][256] ;
					for( int q=0 ; q<256 ; q++ ){ iMask[0][q]=iMask[1][q]=0; }
					tstring strTmp = pstrObjPat[OU[0].GetT(i)] ;
					for( int iTimesOut=0 ; iTimesOut<30 ; iTimesOut++ )
					{
						if( strTmp.length()<4 ){ break; }
						tstring strPart = strTmp.substr(0,4) ;
						strTmp = strTmp.substr( 4 ) ;
						int iHex ;
						if( _stscanf_s( strPart.c_str() , _T("%04X") , &iHex ) < 1 ){ continue; }
						iMask[0][iHex/256] = 1 ;
						iMask[1][iHex%256] = 1 ;
					}
					for( int q=0 ; q<2 ; q++ )
					{
						if( iMask[q][0] ){ continue; }
						iHaveCond[q] = 1 ;
						for( int k=0 ; k<256 ; k++ )
						{
							iChrBank[q][k] &= iMask[q][k] ;
						}
					}
				}
			}
			//満たすパターンを設定
			{
				static const int ciMaxEnemyPat = 0x3A ;
				int iFirstMatch=-1 ;
				int iFirstMatchMessageOut=0 ;
				if( iHaveCond[0]|iHaveCond[1] )
				{
					for( int i=0 ; i<ciMaxEnemyPat ; i++ )
					{
						int iOff = (i+aucSpData[SPOf3_RoomObjPatColor+iR*2+0])%ciMaxEnemyPat ;
						if(
							iChrBank[0][GetROM8p(0x01A200+iOff*2+0)] &&
							iChrBank[1][GetROM8p(0x01A200+iOff*2+1)]
						){
							if( iFirstMatch == -1 )
							{
								iFirstMatch = iOff ;
								aucSpData[SPOf3_RoomObjPatColor+iR*2+0] = iOff ;
							}
							else
							{
								_TCHAR atcTmp[64] ;
								if( !iFirstMatchMessageOut )
								{
									iFirstMatchMessageOut++ ;
									_stprintf_s( atcTmp , _countof(atcTmp) , _T("R%02X候補 ") , iR ) ;
									(*pstrMessage) += atcTmp ;
									_stprintf_s( atcTmp , _countof(atcTmp) , _T("%02X ") , iFirstMatch ) ;
									(*pstrMessage) += atcTmp ;
								}
								_stprintf_s( atcTmp , _countof(atcTmp) , _T("%02X ") , iOff ) ;
								(*pstrMessage) += atcTmp ;
							}
						}
					}
					if( iFirstMatch == -1 )
					{
						if( iRV<0 ){iRV = iR ;}
					}
					if( iFirstMatchMessageOut )
					{
						(*pstrMessage) += _T("\n") ;
					}
				}
			}
		}
	}
	return iRV ;
}







