#ifndef VERSATILE_TILE_EDITOR_HEADER_INCLUDED
#define VERSATILE_TILE_EDITOR_HEADER_INCLUDED

#include <windows.h>
#include <assert.h>
#include "mydibobj3.h"
#include "nnsys.h"
#include "myeinput.h"
#include "keycode.h"
#include "TypedFunction.h"
#include "undo.h"
#include "mymemorymanage.h"

/*
VersatileTileEditor<unsigned char> *pVTE;
VersatileTileEditor<unsigned short> *pVTE;

●汎用タイルエディタ
　外部に確保されたメモリを取り付けて利用する。
　ウインドウという概念で、メモリの一部(=左上の端っこの方)のみを利用することが出来る。

・初期化
VersatileTileEditor( ChipType *pucData , int iDataWidth , int iDataHeight , int iUndoBuffer )
　タイルマップに利用する外部のメモリ、データの幅と高さ、
　アンドゥバッファー(負:利用無し)を指定することが可能。
SetTileSize / SetTileSizeEX / SetTileSizeEX2
　タイル自体のサイズ。デフォルト16x16
SetSFCTile 
　パレットのサーフェイス番号。
SetTileSFCSize
　パレットが縦横にどれだけタイルを保持するか。デフォルト16x16
SetClipFileName 
　ファイル名を決めておけばクリップデータが出力できる
SetWindow 
　ウインドウを設定する

・実行中主に使う関数
SetPosition
　マップの位置を決める
SetTilePalette
　パレットの位置を決める
DoEdit
　エディティングを実行
DrawEditor
　エディタ部を描画
DrawMap
　マップを描画

・その他
ClearMap 
SetSelectedTile 
GetData 
SetData 
SaveClipFile
LoadClipFile
GetUndoCounter 
ResetUndo 

*/
template <class ChipType>class VersatileTileEditor
{
public:
	VersatileTileEditor( ChipType *pucData , int iDataWidth , int iDataHeight , int iUndoBuffer , int iIsClearMap=1 )
	{
		pucClip = NULL ;
		iTilePaletteX = iTilePaletteY = 0 ;
		iSFCTile = -1 ;
		strClipFileName = _T("") ;
		this->pucData     = pucData ;
		this->iDataWidth  = iDataWidth ;
		this->iDataHeight = iDataHeight ;
		if( iIsClearMap ){ ClearMap() ; }
		SetPosition( 0 , 0 ) ;
		SetTileSize( 16 , 16 ) ;
		SetWindow( 0 , 0 , iDataWidth , iDataHeight ) ;
		SetTileSFCSize( 16 , 16 ) ;
		iDragging = 0 ;
		iSelectedX0 = iSelectedX1 = 0 ;
		iSelectedY0 = iSelectedY1 = 0 ;
		DeletepucClip() ;

		SetSelectedTile( 0 ) ;
		pUndo = NULL ;
		if( iUndoBuffer > 0 )
		{
			pUndo = new Undo( (unsigned char*)pucData , iDataWidth*iDataHeight*sizeof(ChipType) , iUndoBuffer ) ;
		}
//		AssignDefaultKey() ;
	}
	~VersatileTileEditor()
	{
		DeletepucClip() ;
		if( pUndo )
		{
			delete pUndo ;
			pUndo = NULL ;
		}
	}
	void ClearMap()
	{
		memset( pucData , 0xFF , iDataWidth*iDataHeight*sizeof(ChipType) ) ;
	}
	void SetSFCTile( int iSFCTile )
	{
		this->iSFCTile = iSFCTile ;
	}
	void SetPosition( int iOrgX , int iOrgY )
	{
		this->iOrgX = iOrgX ;
		this->iOrgY = iOrgY ;
	}
	void SetTileSize( int iTileW , int iTileH )
	{
		this->iTileWm = this->iTileWp = this->iTileWps = iTileW ;
		this->iTileHm = this->iTileHp = this->iTileHps = iTileH ;
	}
	void SetTileSizeEX( int iTileWm , int iTileHm , int iTileWp , int iTileHp )
	{
		this->iTileWm = iTileWm ;
		this->iTileHm = iTileHm ;
		this->iTileWp = this->iTileWps = iTileWp ;
		this->iTileHp = this->iTileHps = iTileHp ;
	}
	void SetTileSizeEX2( int iTileWm , int iTileHm , int iTileWp , int iTileHp , int iTileWps , int iTileHps )
	{
		this->iTileWm = iTileWm ;
		this->iTileHm = iTileHm ;
		this->iTileWp = iTileWp ;
		this->iTileHp = iTileHp ;
		this->iTileWps = iTileWps ;
		this->iTileHps = iTileHps ;
	}
	void SetWindow( int iWindowX , int iWindowY , int iWindowW , int iWindowH )
	{
		this->iWindowX = this->iWindowY = 0 ;
		this->iWindowW = this->iWindowH = 0 ;
		if( iWindowX < 0 ){ iWindowW+=iWindowX ; iWindowX = 0 ; }
		if( iWindowX >= iDataWidth ){ return ; }
		if( iWindowY < 0 ){ iWindowH+=iWindowY ; iWindowY = 0 ; }
		if( iWindowY >= iDataHeight ){ return ; }

		if( iWindowW < 0 ){ return ; }
		if( iWindowX+iWindowW > iDataWidth ){ iWindowW = iDataWidth - iWindowX ; }
		if( iWindowH < 0 ){ return ; }
		if( iWindowY+iWindowH > iDataHeight ){ iWindowH = iDataHeight - iWindowY ; }

		this->iWindowX = iWindowX ;
		this->iWindowY = iWindowY ;
		this->iWindowW = iWindowW ;
		this->iWindowH = iWindowH ;
	}
	void SetSelectedTile( int iSelectedTile )
	{
		this->iSelectedTile = iSelectedTile ;
	}
	void SetTilePalette( int iX , int iY )
	{
		this->iTilePaletteX = iX ;
		this->iTilePaletteY = iY ;
	}
	void SetClipFileName( tstring strClipFileName )
	{
		this->strClipFileName = strClipFileName ;
	}
	void SetTileSFCSize( int iW , int iH )
	{
		iTileSFCW = iW ;
		iTileSFCH = iH ;
	}

	int GetData( int iX , int iY )
	{
		if( !IsPositionInData( iX , iY ) )
			{ return -1 ; }
		return pucData[ GetOffset( iX,iY ) ] ;
	}
	void SetData( int iX , int iY , int iData , int iIgnoreWindow )
	{
		if( iIgnoreWindow )
		{
			if( !IsPositionInData( iX , iY ) )
				{ return ; }
		} else {
			if( !IsPositionInWindow( iX , iY ) )
				{ return ; }
		}
		pucData[ GetOffset( iX,iY ) ] = iData ;
	}
	virtual int DoEdit() ;
	virtual void DrawEditor( MyDIBObj3 *pMDO , int iSFC ) ;
	virtual void DrawMap( MyDIBObj3 *pMDO , int iSFC , int RuleW=-1 , int RuleH=-1 , int iOutSrc = 0 ) ;
	void SaveClipFile( LPCTSTR filename = NULL ) ;
	void LoadClipFile( LPCTSTR filename ) ;
	void GetUndoCounter( int *piCurrent , int *piTimes )
	{
		if( pUndo )
			{pUndo->GetCounter( piCurrent , piTimes ) ;	}
	}
	void ResetUndo()
	{
		if( pUndo ){ pUndo->Reset(); }
	}
	void PreserveUndo()
	{
		if( pUndo ){ pUndo->Preserve() ; }
	}
protected:
	ChipType *pucData ;
	int iDataWidth ;
	int iDataHeight ;
	int iWindowX , iWindowW ;
	int iWindowY , iWindowH ;
	int iOrgX , iOrgY ;
	int iTileWm , iTileHm ;
	int iTileWp , iTileHp ;
	int iTileWps , iTileHps ;
	int iSelectedTile ;
	int iDragging ;
	int iSelectedX0 , iSelectedY0 , iDragOrgX , iDragPreX ;
	int iSelectedX1 , iSelectedY1 , iDragOrgY , iDragPreY ;
	unsigned char *pucClip ;
	int iClipX , iClipY ;
	int iClipW , iClipH ;
	tstring strClipFileName ;
	int iTilePaletteX , iTilePaletteY ;
	int iSFCTile ;
	int iTileSFCW , iTileSFCH ;
	Undo *pUndo ;
//	KeyCode KeyTable[128] ;

	int DoEdit_Sub0() ;
	int DoEdit_Sub1() ;
	int DoEdit_Sub2() ;
	int DoEdit_Sub3() ;
	virtual int DoEdit_Sub0_KeyPressHook(){ return 0; }
	virtual int DoEdit_Sub0_SubSpuit( int mx , int my )
	{
		int iTmp = GetData( mx , my ) ;
		assert( iTmp >= 0 ) ;
		if( VAR_LET( iSelectedTile , iTmp ) ) { return 1 ; }
		return 0 ;
	}
	virtual int DoEdit_Sub2_GetSelectedTile(){ return iSelectedTile; }
	virtual int DrawEditor_SubSetBltParamForPalette( MDO3Opt *ptopt )
	{
		*ptopt = *MDO3WINAPI ;
		return 0 ;
	}
	virtual void DrawEditor_SubSetBltParamForClip( int iCN , int *piSrcX , int *piSrcY , MDO3Opt *ptopt )
	{
		*piSrcX = iCN%iTileSFCW*iTileWp ;
		*piSrcY = iCN/iTileSFCW*iTileHp ;
	}
	virtual void DrawMap_SubSetBltParam( int iCN , int *piSrcX , int *piSrcY , MDO3Opt *ptopt )
	{
		*piSrcX = iCN%iTileSFCW*iTileWp ;
		*piSrcY = iCN/iTileSFCW*iTileHp ;
	}
	int GetMousePosition( int *piX , int *piY ) ;
	void GetMousePositionN( int *piX , int *piY ) ;
	int IsPositionInData( int iX , int iY )
	{
		if( iX < 0 || iX >= iDataWidth ||
			iY < 0 || iY >= iDataHeight )
			{ return 0 ; }
		return 1 ;
	}
	int IsPositionInWindow( int iX , int iY )
	{
		if( iX < iWindowX || iX >= iWindowX+iWindowW ||
			iY < iWindowY || iY >= iWindowY+iWindowH )
			{ return 0 ;}
		return 1 ;
	}
	int GetOffset( int iX , int iY )
	{
		return iX+iY*iDataWidth ;
	}
	void DeletepucClip()
	{
		if( pucClip ){ delete pucClip ; }
		pucClip = NULL ;
	}
	ChipType *ptClipBody()
	{
		if( !pucClip ){return NULL;}
		return (ChipType*)(pucClip+4) ;
	}
	int GetDataF( int iX , int iY )
	{
		return pucData[ GetOffset( iX,iY ) ] ;
	}
	void AssignDefaultKey() ;
} ;


template<class ChipType> void VersatileTileEditor<ChipType>::AssignDefaultKey()
{
//	KeyTable[0] = 

}


template<class ChipType> int VersatileTileEditor<ChipType>::DoEdit()
{
	switch( iDragging )
	{
	case 0:return DoEdit_Sub0() ;
	case 1:return DoEdit_Sub1() ;
	case 2:return DoEdit_Sub2() ;
	case 3:return DoEdit_Sub3() ;
	}
	assert( 0 ) ;
	return -1 ;
}
template<class ChipType> void VersatileTileEditor<ChipType>::DrawEditor( MyDIBObj3 *pMDO , int iSFC )
{
	{//選択範囲の表示
		int x0 , x1 , y0 , y1 ;
		x0 = iSelectedX0     * iTileWm + iOrgX ;
		x1 = (iSelectedX1+1) * iTileWm + iOrgX -1 ;
		y0 = iSelectedY0     * iTileHm + iOrgY ;
		y1 = (iSelectedY1+1) * iTileHm + iOrgY -1 ;
		pMDO->Box( MDO3WINAPI , iSFC , x0   , y0   , x1   , y1   , myRGB(  0 , 31 ,  0 ) ) ;
		pMDO->Box( MDO3WINAPI , iSFC , x0-1 , y0-1 , x1+1 , y1+1 , myRGB(  0 ,  0 , 31 ) ) ;
		pMDO->Box( MDO3WINAPI , iSFC , x0+1 , y0+1 , x1-1 , y1-1 , myRGB( 31 , 31 ,  0 ) ) ;
	}

	if( iSFCTile>=0 )
	{
		//タイルパレットの表示
		{
			MDO3Opt topt ;
			if( !DrawEditor_SubSetBltParamForPalette( &topt ) )
			{
				pMDO->SBlt( &topt , iSFC , iTilePaletteX , iTilePaletteY ,
							iTileSFCW*iTileWps , iTileSFCH*iTileHps , 
							iSFCTile , 0 , 0 , iTileSFCW*iTileWp , iTileSFCH*iTileHp ) ;
			}
			else
			{
				for( int i=0 ; i<0x400 ; i++ )
				{
					int idx,idy,isx,isy ;
					idx = iTilePaletteX + i%iTileSFCW*iTileWps ;
					idy = iTilePaletteY + i/iTileSFCW*iTileHps ;
					isx = i%iTileSFCW*iTileWp ;
					isy = i/iTileSFCW*iTileHp ;
					pMDO->SBlt( &topt , iSFC , idx , idy , iTileWps , iTileHps , 
								iSFCTile , isx , isy , iTileWp , iTileHp ) ;
				}
			}
		}
		{//選択タイル表示
			int iX , iY ;
			int iW , iH ;
			if( iDragging != 3 )
			{
				iX = iTilePaletteX + iSelectedTile % iTileSFCW * iTileWps ;
				iY = iTilePaletteY + iSelectedTile / iTileSFCW * iTileHps ;
				iW = iTileWps ;
				iH = iTileHps ;
			}
			else
			{
				int iX0 , iY0 , iX1 , iY1 ;
				iX0 = iDragOrgX ; iX1 = iDragPreX ;
				iY0 = iDragOrgY ; iY1 = iDragPreY ;
				if( iX0>iX1 ){ MYSWAP(&iX0,&iX1); }
				if( iY0>iY1 ){ MYSWAP(&iY0,&iY1); }
				iX = iTilePaletteX + iX0 * iTileWps ;
				iY = iTilePaletteY + iY0 * iTileHps ;
				iW = (iX1-iX0+1)*iTileWps-1 ;
				iH = (iY1-iY0+1)*iTileHps-1 ;
			}
			pMDO->Box( MDO3WINAPI , iSFC , iX   , iY   , iX+iW-1   , iY+iH-1   , myRGB(  0 , 31 ,  0 ) ) ;
			pMDO->Box( MDO3WINAPI , iSFC , iX-1 , iY-1 , iX+iW-1+1 , iY+iH-1+1 , myRGB(  0 ,  0 , 31 ) ) ;
			pMDO->Box( MDO3WINAPI , iSFC , iX+1 , iY+1 , iX+iW-1-1 , iY+iH-1-1 , myRGB( 31 , 31 ,  0 ) ) ;
		}
		
		if( pucClip )
		{//クリップ中表示
			MDO3Opt topt = *MDO3normal ;
			topt.flag |= MDO3F_BLEND ;
			topt.alpha = 0x80 ;
			for( int iY=0 ; iY<iClipH ; iY++ )
			{
			for( int iX=0 ; iX<iClipW ; iX++ )
			{
				int iDX , iDY ;
				int iTile , iTX , iTY ;
				iDX = (iClipX + iX) * iTileWm + iOrgX ;
				iDY = (iClipY + iY) * iTileHm + iOrgY ;
				iTile = ptClipBody()[ iY*iClipW + iX ] ;

				DrawEditor_SubSetBltParamForClip( iTile , &iTX , &iTY , &topt ) ;
				if( iTileWm==iTileWp && iTileHm==iTileHp )
					pMDO->Blt( &topt , iSFC , iDX , iDY ,
						iTileWm , iTileHm , iSFCTile , iTX , iTY ) ;
				else
					pMDO->SBlt( &topt , iSFC , iDX , iDY , iTileWm , iTileHm ,
									iSFCTile , iTX , iTY , iTileWp , iTileWp ) ;

			} //iX
			} //iY
		}

	}

}
template<class ChipType> void VersatileTileEditor<ChipType>::DrawMap( MyDIBObj3 *pMDO , int iSFC , int RuleW , int RuleH , int iOutSrc )
{
	//クリッパーを取得して描画範囲を特定し、最適化
	{
		int iCX0 , iCX1 , iCY0 , iCY1 ;
		pMDO->GetClipper( iSFC , &iCX0 , &iCY0 , &iCX1 , &iCY1 ) ;
		iCX1 += iCX0 ;
		iCY1 += iCY0 ;
		iCX0 -= iOrgX ;
		iCX1 -= iOrgX ;
		iCY0 -= iOrgY ;
		iCY1 -= iOrgY ;
		iCX0 = GaussDivision( iCX0 , iTileWm ) ;
		iCX1 = GaussDivision( iCX1 , iTileWm )+1 ;
		iCY0 = GaussDivision( iCY0 , iTileHm ) ;
		iCY1 = GaussDivision( iCY1 , iTileHm )+1 ;
		iCX0 = min( max( iCX0 , iWindowX ) , iWindowX+iWindowW-1 ) ;
		iCX1 = min( max( iCX1 , iWindowX ) , iWindowX+iWindowW-1 ) ;
		iCY0 = min( max( iCY0 , iWindowY ) , iWindowY+iWindowH-1 ) ;
		iCY1 = min( max( iCY1 , iWindowY ) , iWindowY+iWindowH-1 ) ;


		MDO3Opt topt = *MDO3normal ;
		for( int iy=iCY0 ; iy<=iCY1 ; iy++ )
		{
			for( int ix=iCX0 ; ix<=iCX1 ; ix++ )
			{
				int ch ;
				ch = GetDataF( ix , iy ) ;
				if( ch>=iTileSFCW*iTileSFCH )
				{
					int iContinue = 0 ;
					switch( iOutSrc )
					{
					case 0: //そのタイルの描画を取りやめる
						iContinue ++ ;
					break ;
					case 1: //タイル数でループさせる
						RotateCorrect( &ch , iTileSFCW*iTileSFCH ) ;
					break ;
					case 2: //assert
						assert( 0 ) ;
					break ;
					case 3: //無視(DrawMap_SubSetBltParamで対処が必要)
					break; 
					}
					if( iContinue )
					{ continue ; }
				}
				int tx,ty ;
				tx = iOrgX + ix*iTileWm ;
				ty = iOrgY + iy*iTileHm ;
				int iSrcX , iSrcY ;
				DrawMap_SubSetBltParam( ch , &iSrcX , &iSrcY , &topt ) ;
				if( iTileWm==iTileWp && iTileHm==iTileHp )
					pMDO->Blt( &topt , iSFC , tx , ty , iTileWm , iTileHm , 
							iSFCTile , iSrcX , iSrcY ) ;
				else
					pMDO->SBlt( &topt , iSFC , tx , ty , iTileWm , iTileHm , 
							iSFCTile , iSrcX , iSrcY , iTileWp , iTileHp ) ;
			}
		}
	}
	//罫線
	if( RuleW>=1 )
	{
		for( int ix=1 ; ix<(iWindowW+RuleW-1)/RuleW ; ix++ )
		{
			int tx,th ;
			tx = iOrgX+ix*iTileWm*RuleW ;
			th = iWindowH*iTileHm ;
			pMDO->Cls( MDO3WINAPI , iSFC , tx , iOrgY , 1 , th , myRGB(0,31,0) ) ;
		}
	}
	if( RuleH>=1 )
	{
		for( int iy=1 ; iy<(iWindowH+RuleH-1)/RuleH ; iy++ )
		{
			int ty,tw ;
			ty = iOrgY+iy*iTileHm*RuleH ;
			tw = iWindowW*iTileWm ;
			pMDO->Cls( MDO3WINAPI , iSFC , iOrgX , ty , tw , 1 , myRGB(0,31,0) ) ;
		}
	}
}
template<class ChipType> void VersatileTileEditor<ChipType>::SaveClipFile( LPCTSTR filename )
{
	if( !pucClip ){return;}
	if( filename!=NULL )
	{
		WriteFileFromMemory( filename , pucClip , iClipW * iClipH * sizeof(ChipType) + 4 ) ;
	}
	else if( _T("") != strClipFileName )
	{
		WriteFileFromMemory( strClipFileName.c_str() , pucClip , iClipW * iClipH * sizeof(ChipType) + 4 ) ;
	}
}
template<class ChipType> void VersatileTileEditor<ChipType>::LoadClipFile( LPCTSTR filename )
{
	DeletepucClip() ;
	int iFileSize ;
	iFileSize = LoadMemoryFromFile( filename , &pucClip ) ;
	if( iFileSize >= 4 )
	{
		iClipX = iSelectedX0 ;
		iClipY = iSelectedY0 ;
		iClipW = pucClip[1]*256 + pucClip[0] ;
		iClipH = pucClip[3]*256 + pucClip[2] ;
		if( iFileSize != 4 + iClipW*iClipH*sizeof(ChipType) )
			{DeletepucClip() ;}
	}
	else
	{
		DeletepucClip() ;
	}
}

template<class ChipType> int VersatileTileEditor<ChipType>::DoEdit_Sub0()
{ //範囲選択中以外
	//Undo処理
	if( KeyPush( KC_PAGEUP ) )
	{
		if( pUndo && pUndo->DoUndo() )
			{return 1 ;}
	}
	if( KeyPush( KC_PAGEDOWN ) )
	{
		if( pUndo && pUndo->DoRedo() )
			{return 1 ;}
	}
	//コピー処理
	if( KeyPush( KC_C ) || KeyPush( KC_INS ) )
	{
		DeletepucClip() ;
		iClipW = iSelectedX1-iSelectedX0+1 ;
		iClipH = iSelectedY1-iSelectedY0+1 ;
		pucClip = new unsigned char [ iClipW * iClipH * sizeof(ChipType) + 4 ] ;
		if( iClipW>0 && iClipH>0 && pucClip )
		{
			iClipX = iSelectedX0 ;
			iClipY = iSelectedY0 ;
			pucClip[0] = iClipW & 0xFF ;
			pucClip[1] = iClipW >> 8 ;
			pucClip[2] = iClipH & 0xFF ;
			pucClip[3] = iClipH >> 8 ;
			for( int iY=0 ; iY<iClipH ; iY++ )
			{
			for( int iX=0 ; iX<iClipW ; iX++ )
			{
				ptClipBody()[ iY*iClipW + iX ] = GetData( iX+iSelectedX0 , iY+iSelectedY0 ) ;
			} //iX
			} //iY
			if( KeyOn( KC_CTRL ) )
			{
				SaveClipFile() ;
			}
		}
		InvalidateKey() ;
		return 1 ;
	}
	//削除処理
	if( KeyPush( KC_DEL ) )
	{
		InvalidateKey() ;
		for( int iY=iSelectedY0 ; iY<=iSelectedY1 ; iY++ )
		{
		for( int iX=iSelectedX0 ; iX<=iSelectedX1 ; iX++ )
		{
			SetData( iX , iY , iSelectedTile , 0 ) ;
		} //iX
		} //iY
		if( pUndo ){ pUndo->Preserve() ; }
		return 1 ;
	}

	//追加キー入力処理
	if( DoEdit_Sub0_KeyPressHook() ){ return 1 ; }

	//タイルパレットの処理
	if( iSFCTile>=0 && iTileWps && iTileHps )
	{
		int iX , iY , iTX , iTY ;
		iX = GetMousePosX() - iTilePaletteX ;
		iY = GetMousePosY() - iTilePaletteY ;
		iTX = iX / iTileWps ;
		iTY = iY / iTileHps ;
		if( iX>=0 && iY>=0 && iTX<iTileSFCW && iTY<iTileSFCH )
		{
			if( MouseOn( MB_L ) || MouseOn( MB_L ) )
			{
				InvalidateMouse() ;
				int iTile ;
				iTile = iTX + iTY*iTileSFCW ;
				if( VAR_LET( iSelectedTile , iTile ) ) { return 1 ; }
				return 0 ;
			}
			else if( MouseOn( MB_C ) )
			{
				InvalidateMouse() ;
				iDragging = 3 ;
				iDragOrgX = iDragPreX = iTX ;
				iDragOrgY = iDragPreY = iTY ;
				return 1 ;
			}
		}
	}
	{
		int iTmp = 0 ;
		KeyScroll( &iTmp , KC_AR , KC_AL , 1  , 1 , 0 ) ;
		KeyScroll( &iTmp , KC_AD , KC_AU , iTileSFCW , 1 , 0 ) ;
		if( iTmp )
		{
			iSelectedTile += iTmp ;
			RotateCorrect( &iSelectedTile , iTileSFCW*iTileSFCH ) ;
			return 1;
		}
	}

	int mx , my ;
	if( !GetMousePosition( &mx , &my ) )
	{
		return 0 ;
	}

	//クリップ中の処理
	if( pucClip )
	{
		if( MouseOn( MB_R ) || MouseOn( MB_C ) )
		{ //マウスを押すとクリップ処理終了
			DeletepucClip() ;
			InvalidateMouse() ;
			return 1 ;
		}

		int iRV = 0 ;
		if( VAR_LET( iClipX , mx ) ) { iRV = 1 ; }
		if( VAR_LET( iClipY , my ) ) { iRV = 1 ; }
		if( MouseOn( MB_L ) )
		{
			for( int iY=0 ; iY<iClipH ; iY++ )
			{
			for( int iX=0 ; iX<iClipW ; iX++ )
			{
				int iDX , iDY ;
				int iDT , iTile ;
				iDX = (iClipX + iX) ;
				iDY = (iClipY + iY) ;
				if( !IsPositionInData( iDX , iDY ) )
					{ continue ;}
				iDT = GetData( iDX , iDY ) ;
				iTile = ptClipBody()[ iY*iClipW + iX ] ;
				int iDoProc = 1 ;
				if( KeyOn( KC_SHIFT ) )
				{
					if( iDT!=iSelectedTile ){ iDoProc = 0 ; }
				}
				else if( KeyOn( KC_CTRL ) )
				{
					if( iTile==0 ){ iDoProc = 0 ; }
				}
				if( iDT != iTile && iDoProc )
				{
					iRV = 1 ;
					SetData( iDX , iDY , iTile , 0 ) ;
				}
			} //iX
			} //iY

			InvalidateMouse() ;
		}
		if( MouseRelease( MB_L ) )
		{
			if( pUndo ){ pUndo->Preserve() ; }
		}
		return iRV ;
	}

	if( MousePush( MB_C ) )
	{ //範囲選択開始処理
		InvalidateMouse() ;
		iSelectedX0 = iSelectedX1 = iDragOrgX = mx ;
		iSelectedY0 = iSelectedY1 = iDragOrgY = my ;
		iDragging = 1 ;
		return 1 ;
	}
	if( MousePush( MB_L ) )
	{ //配置処理
		InvalidateMouse() ;
		iDragging = 2 ;
		return 1 ;
	}
	if( MouseOn( MB_R ) )
	{ //スポイト処理
		InvalidateMouse() ;
		return DoEdit_Sub0_SubSpuit( mx , my ) ;
	}
	return 0 ;
}
template<class ChipType> int VersatileTileEditor<ChipType>::DoEdit_Sub1()
{ //中央ボタンドラッグ中
	if( !MouseOn( MB_C ) )
	{
		iDragging = 0 ;
		return 0 ;
	}
	InvalidateMouse() ;
	int mx , my ;
	int iX0 , iX1 , iY0 , iY1 ;
	GetMousePositionN( &mx , &my ) ;
	iX0 = iDragOrgX ;
	iX1 = mx ;
	iY0 = iDragOrgY ;
	iY1 = my ;

	if( iX0 > iX1 )
		{ MYSWAP( &iX0 , &iX1 ) ; }
	if( iY0 > iY1 )
		{ MYSWAP( &iY0 , &iY1 ) ; }

	int iRV = 0 ;
	if( VAR_LET( iSelectedX0 , iX0 ) ) { iRV = 1 ; }
	if( VAR_LET( iSelectedX1 , iX1 ) ) { iRV = 1 ; }
	if( VAR_LET( iSelectedY0 , iY0 ) ) { iRV = 1 ; }
	if( VAR_LET( iSelectedY1 , iY1 ) ) { iRV = 1 ; }
	return iRV ;
}
template<class ChipType> int VersatileTileEditor<ChipType>::DoEdit_Sub2()
{ //左ボタンドラッグ中
	if( !MouseOn( MB_L ) )
	{
		iDragging = 0 ;
		if( pUndo ){ pUndo->Preserve() ; }
		return 0 ;
	}
	InvalidateMouse() ;
	int mx , my ;

	if( !GetMousePosition( &mx , &my ) )
	{ //窓の外に居たら処理しない
		return 0 ;
	}
	int iBaseTile = GetData( mx , my ) ;
	int iSelectedTileEX = DoEdit_Sub2_GetSelectedTile() ;
	if( iBaseTile == iSelectedTileEX )
	{ //その場所に既に同じタイルが置かれていたら処理しない
		return 0 ;
	}

	int iMode = 0 ;
	if( KeyOn( KC_CTRL  ) ){iMode += 2 ;}
	if( KeyOn( KC_SHIFT ) ){iMode += 1 ;}
	
	switch( iMode )
	{
	case 0 : //塗りつぶし無し
		SetData( mx , my , iSelectedTileEX , 0 ) ;
	break ;
	case 1 : //横塗りつぶし
	case 2 : //縦塗りつぶし
		{
			SetData( mx , my , iSelectedTileEX , 0 ) ;
			int iSubMode = iMode - 1 ;
			for( ; iSubMode<4 ; iSubMode+=2 )
			{
				static const int ciTableDx[4] = { -1 ,  0 , 1 , 0 } ;
				static const int ciTableDy[4] = {  0 , -1 , 0 , 1 } ;
				int iX , iY ;
				iX = mx ;
				iY = my ;
				for( int iTimesOut=0 ; iTimesOut<1000000 ; iTimesOut++ )
				{
					iX += ciTableDx[ iSubMode ] ;
					iY += ciTableDy[ iSubMode ] ;
					if( !IsPositionInWindow( iX , iY ) ){ break ; }
					if( GetData( iX , iY ) != iBaseTile ){ break ; }
					SetData( iX , iY , iSelectedTileEX , 0 ) ;
				}

			}
		}
	break ;
	case 3 : //いわゆる塗りつぶし
		{
			unsigned char *pucFlag = new unsigned char [ iDataWidth * iDataHeight ] ;
			if( !pucFlag ){ break ; }
			memset( pucFlag , 0 , iDataWidth * iDataHeight ) ;
			SetData( mx , my , iSelectedTileEX , 0 ) ;
			pucFlag[ GetOffset( mx , my ) ] = 1 ;
			for( int iTimesOut=0 ; iTimesOut<1000000 ; iTimesOut++ )
			{
				int iUpdated = 0 ;
				for( int iY=iWindowY ; iY<iWindowY+iWindowH ; iY++ )
				{
				for( int iX=iWindowX ; iX<iWindowX+iWindowW ; iX++ )
				{
					if( pucFlag[ GetOffset( iX , iY ) ] )
					{
#define FILL_PROC(x,y)														\
						if( IsPositionInWindow( (x) , (y) ) &&				\
							GetData( (x) , (y) ) == iBaseTile )				\
						{													\
							pucFlag[ GetOffset( (x) , (y) ) ] = 1 ;			\
							SetData( (x) , (y) , iSelectedTileEX , 0 ) ;		\
							iUpdated = 1 ;									\
						}

						pucFlag[ GetOffset( iX , iY ) ] = 0 ;
						FILL_PROC( iX+1 , iY   ) ;
						FILL_PROC( iX-1 , iY   ) ;
						FILL_PROC( iX   , iY+1 ) ;
						FILL_PROC( iX   , iY-1 ) ;
#undef FILL_PROC
					}
				} //iX
				} //iY
				if( !iUpdated ){ break ; }
			}

			delete pucFlag ;
		}
	break ;
	default:
		assert( 0 ) ;
	}

	return 1 ;
}
template<class ChipType> int VersatileTileEditor<ChipType>::DoEdit_Sub3()
{ //タイルパレットで中央ドラッグ中
	if( !MouseOn( MB_C ) )
	{
		iDragging = 0 ;
		int iX0 , iY0 , iX1 , iY1 ;
		iX0 = iDragOrgX ; iX1 = iDragPreX ;
		iY0 = iDragOrgY ; iY1 = iDragPreY ;
		if( iX0>iX1 ){ MYSWAP(&iX0,&iX1); }
		if( iY0>iY1 ){ MYSWAP(&iY0,&iY1); }

		DeletepucClip() ;
		iClipW = iX1-iX0+1 ;
		iClipH = iY1-iY0+1 ;
		pucClip = new unsigned char [ iClipW * iClipH * sizeof(ChipType) + 4 ] ;
		if( iClipW>0 && iClipH>0 && pucClip )
		{
			iClipX = 0 ;
			iClipY = 0 ;
			pucClip[0] = iClipW & 0xFF ;
			pucClip[1] = iClipW >> 8 ;
			pucClip[2] = iClipH & 0xFF ;
			pucClip[3] = iClipH >> 8 ;
			for( int iY=0 ; iY<iClipH ; iY++ )
			{
			for( int iX=0 ; iX<iClipW ; iX++ )
			{
				ptClipBody()[ iY*iClipW + iX ] = ( iX+iX0 ) + ( iY+iY0 )*iTileSFCW ;
			} //iX
			} //iY
		}
		return 1 ;
	}
	int iX , iY , iTX , iTY ;
	iX = GetMousePosX() - iTilePaletteX ;
	iY = GetMousePosY() - iTilePaletteY ;
	iTX = iX / iTileWps ;
	iTY = iY / iTileHps ;
	if( iX>=0 && iY>=0 && iTX<iTileSFCW && iTY<iTileSFCH && (iDragPreX != iTX || iDragPreY != iTY) )
	{
		iDragPreX = iTX ;
		iDragPreY = iTY ;
		return 1 ;
	}
	return 0 ;
}

template<class ChipType> int VersatileTileEditor<ChipType>::GetMousePosition( int *piX , int *piY )
{ //マウスの位置のタイル単位の座標を取得
	int iX , iY ;
	iX = GetMousePosX() - iOrgX ;
	iY = GetMousePosY() - iOrgY ;
	iX = GaussDivision( iX , iTileWm ) ;
	iY = GaussDivision( iY , iTileHm ) ;
	if( !IsPositionInWindow( iX , iY ) )
	{
		*piX = -1 ;
		*piY = -1 ;
		return 0 ;
	}
	*piX = iX ;
	*piY = iY ;
	return 1 ;
}
template<class ChipType> void VersatileTileEditor<ChipType>::GetMousePositionN( int *piX , int *piY )
{ //マウスの位置のタイル単位の座標を取得/はみ出したときは近傍
	int iX , iY ;
	iX = GetMousePosX() - iOrgX ;
	iY = GetMousePosY() - iOrgY ;
	iX = GaussDivision( iX , iTileWm ) ;
	iY = GaussDivision( iY , iTileHm ) ;
	if( iX < iWindowX ) iX = iWindowX ;
	if( iY < iWindowY ) iY = iWindowY ;
	if( iX >= iWindowX+iWindowW ) iX = iWindowX+iWindowW-1 ;
	if( iY >= iWindowY+iWindowH ) iY = iWindowY+iWindowH-1 ;
	*piX = iX ;
	*piY = iY ;
	return ;
}


#endif /*VERSATILE_TILE_EDITOR_HEADER_INCLUDED*/
