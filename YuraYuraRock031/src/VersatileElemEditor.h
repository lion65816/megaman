#ifndef VERSATILE_ELEMENT_EDITOR_HEADER_INCLUDED
#define VERSATILE_ELEMENT_EDITOR_HEADER_INCLUDED

#include <windows.h>
#include <assert.h>
#include "mydibobj3.h"
#include "nnsys.h"
#include "typedfunction.h"
#include "myeinput.h"
#include "keycode.h"

template <class ElemType>class ElemUnit_c
{
public:
	ElemUnit_c( int iMaxElem )
	{
		ConstructorSub( iMaxElem ) ;
	}
	ElemUnit_c()
	{
		ConstructorSub( 0 ) ;
	}
	~ElemUnit_c()
	{
		if( pElem ){ delete []pElem ; pElem=NULL; }
	}
	void Initialize( int iMaxElem )
	{
		this->iMaxElem = max(iMaxElem,0) ;
		if( pElem )delete []pElem ;
		if( iMaxElem>0 )
		{
			pElem = new ElemType[iMaxElem] ;
			Clear() ;
		}
		iRectSelection = 0 ;
	}
	void SetPositionLimit( int iXmin , int iYmin , int iXmax , int iYmax )
	{
		this->iXmin = iXmin ;
		this->iXmax = iXmax ;
		this->iYmin = iYmin ;
		this->iYmax = iYmax ;
	}
	void Clear()
	{
		for( int i=0 ; i<iMaxElem ; i++ ){ pElem[i].Clear() ; }
		iNOElem = 0 ;
		iDragging = -1 ;
	}
	int Add()
	{
		if( iNOElem >= iMaxElem )
		{ return -1 ; }
		pElem[iNOElem].Clear() ;
		pElem[iNOElem].Add() ;
		iDragging = -1 ;
		return iNOElem++ ;
	}
	int Delete( int iSuffix )
	{
		if( !IsCorrectSuffix( iSuffix ) )
		{ return 0 ; }
		for( int i=iSuffix ; i<=iNOElem-2 ; i++ )
		{ pElem[i].Duplicate( &pElem[i+1] ) ; }
		pElem[ iNOElem-1 ].Clear() ;
		iNOElem-- ;
		iDragging = -1 ;
		return 1 ;
	}
	int DeleteS()
	{
		for( int i=0 ; i<iNOElem ; i++ )
		{
			if( IsSelected(i) )
			{
				Delete(i);
				i--;
			}
		}
		return 1 ;
	}
	int DeleteAll()
	{
		while( iNoElem ){ Delete(0); }
		return 1 ;
	}
	int PositionLimit( int iSuffix )
	{
		if( !IsCorrectSuffix( iSuffix ) ){ return 0 ; }
		pElem[ iSuffix ].PositionLimit( iXmin , iYmin , iXmax , iYmax ) ;
		return 1 ;
	}
	int PositionLimitS()
	{
		for( int i=0 ; i<iNOElem ; i++ )
			if( IsSelected(i) )
				PositionLimit(i) ;
		return 1 ;
	}
	int Duplicate( int iDest , int iSrc )
	{
		if( !IsCorrectSuffix( iDest ) || !IsCorrectSuffix( iSrc )){ return 0 ; }
		pElem[ iDest ].Duplicate( pElem+iSrc ) ;
		return 1 ;
	}
	int Swap( int iDest1 , int iDest2 )
	{
		if( !IsCorrectSuffix( iDest1 ) || !IsCorrectSuffix( iDest2 )){ return 0 ; }
		pElem[ iDest1 ].Swap( pElem+iDest2 ) ;
		return 1 ;
	}
	int SwapLong( int iDest , int iTill )
	{
		if( !IsCorrectSuffix( iDest ) || !IsCorrectSuffix( iTill )){ return 0 ; }
		for(; iDest!=iTill ;)
		{
			int iTmp = iDest ;
			if( iTill < iDest ){iTmp -- ;}
			else {iTmp++;}
			Swap( iTmp , iDest ) ;
			iDest = iTmp ;
		}
		return 1 ;
	}
	//選択操作
	void DeselectAll(){ for( int i=0 ; i<iNOElem ; i++ ){pElem[i].Deselect() ; } }
	void SelectAll(){ for( int i=0 ; i<iNOElem ; i++ ){pElem[i].Select() ; } }
	void SwitchSelectionAll(){ for( int i=0 ; i<iNOElem ; i++ ){pElem[i].SwitchSelection() ; } }
	void Deselect( int iDest ){ if( IsCorrectSuffix( iDest )){ pElem[iDest].Deselect() ; } }
	void Select( int iDest ){ if( IsCorrectSuffix( iDest )){ pElem[iDest].Select() ; } }
	void SwitchSelection( int iDest ){ if( IsCorrectSuffix( iDest )){ pElem[iDest].SwitchSelection() ; } }
	int  IsSelected( int iDest )
	{
		if( IsCorrectSuffix( iDest )){ return pElem[iDest].IsSelected() ; }
		return 0 ;
	}
	int GetSelectSuffix( int iSeekFlag ) //iSeekFlag: ２つ以上見つかった時の処理 0/-2を返却 1/最初の１つを返却 2/最後の１つを選択
	{
		int iTmp=-1 ;
		for( int i=0 ; i<iNOElem ; i++ )
		{
			if( IsSelected( i ) )
			{
				if( iSeekFlag==1 ){ return i ; }
				if( iSeekFlag==0 && iTmp>=0 ){ return -2; }
				iTmp = i ;
			}
		}
		return iTmp ;
	}
	//移動
	int SetXS( int iX )
	{
		int iRV = 0 ;
		for( int i=0 ; i<iNOElem ; i++ )
		{
			if( IsSelected(i) && pElem[i].GetX()!=iX )
			{
				pElem[i].SetX( iX ) ;
				iRV = 1 ;
			}
		}
		return iRV ;
	}
	int SetYS( int iY )
	{
		int iRV = 0 ;
		for( int i=0 ; i<iNOElem ; i++ )
		{
			if( IsSelected(i) && pElem[i].GetY()!=iY )
			{
				pElem[i].SetY( iY ) ;
				iRV = 1 ;
			}
		}
		return iRV ;
	}
	int MoveDS( int iDx , int iDy )
	{
		int iRV = 0 ;
		for( int i=0 ; i<iNOElem ; i++ )
		{
			if( IsSelected(i) )
			{
				iRV |= pElem[i].MoveD( iDx , iDy ) ;
			}
		}
		return iRV ;
	}
	virtual void Draw( MyDIBObj3 *pMDO , int iSfc , int x , int y )
	{
		for( int i=0 ; i<iNOElem ; i++ )
		{
			pElem[i].Draw( pMDO , iSfc , x , y ) ;
		}
		if( iRectSelection )
		{
			pMDO->Box( MDO3WINAPI , iSfc , iRectOrgX+x , iRectOrgY+y , iRectPreX+x ,iRectPreY+y , myRGB(0,31,0) ) ;
		}
	}
	virtual int DoEdit( int iBx , int iBy )
	{
		if( iRectSelection ){ return DoEdit_Sub2( iBx , iBy ) ; }
		if( iDragging<0 ){ return DoEdit_Sub0( iBx , iBy ) ; }
		return DoEdit_Sub1( iBx , iBy ) ;
	}
	
	int GetCount(){ return iNOElem ; }
	int GetX( int iDest ){  if( IsCorrectSuffix( iDest )){ return pElem[iDest].GetX() ; }return -1; }
	int GetY( int iDest ){  if( IsCorrectSuffix( iDest )){ return pElem[iDest].GetY() ; }return -1; }


	int GetElemByPosition( int iX , int iY , int iRevScan=0 )
	{
		for( int i=0 ; i<iNOElem ; i++ )
		{
			int iOffset = i ;
			if( iRevScan )
			{ iOffset = iNOElem-i-1 ;}
			if( pElem[iOffset].IsInRect( iX , iY ) )
			{ return iOffset ;}
		}
		return -1 ;
	}
	int GetElemInArea( int iX , int iY , int iW , int iH , int iSkip=-1 , int iRevScan=0 )
	{
		for( int i=iSkip+1 ; i<iNOElem ; i++ )
		{
			int iOffset = i ;
			if( iRevScan )
			{ iOffset = iNOElem-i-1 ;}

			int iEx , iEy ;
			iEx = pElem[iOffset].GetX() ;
			iEy = pElem[iOffset].GetY() ;
			if( iEx >= iX  &&  iEy >= iY  &&  iEx < iX+iW  &&  iEy < iY+iH )
			{ return iOffset ;}
		}
		return -1 ;
	}
	void SetClipFilename( LPCTSTR strFilename )
	{
		this->ptcClipFilename = strFilename ;
	}
	void LoadClipFile( LPCTSTR strFilename , int iScreenX , int iScreenY )
	{
		FILE *fp ;
		if( !_tfopen_s( &fp , strFilename , _T("rt") ) )
		{
			int iInsPosition = GetSelectSuffix( 2 ) ; //最後に見つかった選択オブジェクトの後ろに移動
			DeselectAll() ; //選択解除
			int iDestObj=-1 ;
			int iOrgX , iOrgY ;
			int iBaseX , iBaseY ;
			iBaseX = iBaseY = 0x7FFFFFFF ;
			if( iInsPosition>=0 )
			{
				iOrgX = pElem[iInsPosition].GetX()+20 ;
				iOrgY = pElem[iInsPosition].GetY() ;
			}
			else
			{
				iOrgX = iScreenX ;
				iOrgY = iScreenY ;
			}

			for(;;)
			{
				TCHAR atcTmp[256] ;
				TCHAR aatcCmd[2][256] ;
				if( !_fgetts( atcTmp , _countof(atcTmp) , fp ) ){ break; }
				if( !_tcscmp( atcTmp , _T("NewElem\n") ) )
				{
					iDestObj = Add() ;
					if( iDestObj<0 ){ break; }
					if( iInsPosition>=0 )
					{
						SwapLong( iDestObj , iInsPosition+1 ) ;
						iDestObj = iInsPosition+1 ;
						iInsPosition++ ;
					}
					Select( iDestObj ) ;
					LoadClipFile_Add( iDestObj ) ;
					continue ;
				}
				if( iDestObj<0 ){ continue; }
				if( _stscanf_s( atcTmp , _T("%s %s") , aatcCmd[0] , _countof(aatcCmd[0]) , aatcCmd[1] , _countof(aatcCmd[1]) ) == 2 )
				{
					LoadClipFile_Cmd( iDestObj , iOrgX , iOrgY , &iBaseX , &iBaseY , aatcCmd[0] , aatcCmd[1] ) ;
				}
			}
			fclose( fp ) ;
		}
	}
	virtual void LoadClipFile_Add( int iDestObj )
	{
		pElem[iDestObj].Move( 0 , 0 ) ;
	} 
	virtual void LoadClipFile_Cmd( int iDestObj , int iOrgX , int iOrgY , int *piBaseX , int *piBaseY , TCHAR *ptcCmd , TCHAR *ptcVal )
	{
		if( !_tcscmp( ptcCmd , _T("X") ) )
		{
			int iVal ;
			if( _stscanf_s( ptcVal , _T("%d") , &iVal ) == 1 )
			{
				if( *piBaseX == 0x7FFFFFFF ){ *piBaseX = iVal ; }
				pElem[iDestObj].SetX( iVal-(*piBaseX)+iOrgX ) ;
			}
		}
		if( !_tcscmp( ptcCmd , _T("Y") ) )
		{
			int iVal ;
			if( _stscanf_s( ptcVal , _T("%d") , &iVal ) == 1 )
			{
				if( *piBaseY == 0x7FFFFFFF ){ *piBaseY = iVal ; }
				pElem[iDestObj].SetY( iVal-(*piBaseY)+iOrgY ) ;
			}
		}
		LoadClipFile_CmdHook( iDestObj , ptcCmd , ptcVal ) ;
	} 
	virtual void LoadClipFile_CmdHook( int iDestObj , TCHAR *ptcCmd , TCHAR *ptcVal ){ ; }
protected:
	void ConstructorSub( int iMaxElem )
	{
		pElem = NULL ;
		iXmin = iYmin = (int)0x80000000 ;
		iXmax = iYmax = 0x7FFFFFFF ;
		Initialize( iMaxElem ) ;
		this->ptcClipFilename = _T("clipped.elemclip") ;
	}

	int iMaxElem ;
	int iNOElem ;
	int iDragging ;
	int iDragOrgX , iDragOrgY ;
	int iDragPreX , iDragPreY ;
	int iRectSelection ;
	int iRectOrgX , iRectOrgY ;
	int iRectPreX , iRectPreY ;
	ElemType *pElem ;
	int iXmin , iXmax , iYmin , iYmax ;
	LPCTSTR ptcClipFilename ;


	int IsCorrectSuffix( int iSuffix ){ if( iSuffix>=0 && iSuffix<iNOElem ){ return 1 ;}return 0 ;}

	virtual int DoEdit_Sub0( int iBx , int iBy )
	{
		int iIsUpdated = 0 ;
		int iMx , iMy ;
		iMx = GetMousePosX() - iBx ;
		iMy = GetMousePosY() - iBy ;
		if( KeyOn( KC_CTRL ) && KeyPush( KC_A ) )
			{ iIsUpdated |= Edit_0CtrlA() ;}
		if( KeyPush( KC_DEL ) )
			{ iIsUpdated |= Edit_0Del() ; }
		if( KeyPush( KC_C ) )
			{ iIsUpdated |= Edit_0C() ; }
		iIsUpdated |= Edit_0KeyProc( iBx , iBy ) ;
		/*
		メモ:どちらのボタンでも選択することが出来るが
		     右ボタンだとそのままドラッグに移行しない
		     また、シフトを押しながら選択をすると、裏側から選択を行う。
		*/
		if( MousePush( MB_L ) || MousePush( MB_R ) )
		{
			int iRV = GetElemByPosition( iMx , iMy , KeyOn( KC_SHIFT ) ) ;
			if( iRV < 0 )
			{ //空振り:左クリックなら選択解除/配置
				if( MousePush( MB_L ) )
				{
					if( KeyOn( KC_CTRL ) )
					{//コントロールを押しながら空振り:配置
						iIsUpdated |= Edit_0NohitCtrl( iMx , iMy , Add() ) ;
					}
					else
					{//普通に空振り:選択解除/領域選択開始
						iIsUpdated |= Edit_0NoHit( iMx , iMy ) ;
						RectSelectionInit( iMx , iMy ) ;
					}
				}
			}
			else
			{ //選択実行
				iIsUpdated |= Edit_0Hit( iMx , iMy , iRV ) ;
			}
		}
		if( MousePush( MB_C ) )
		{ /*中央ボタンクリック*/
			int iRV = GetElemByPosition( iMx , iMy , KeyOn( KC_SHIFT ) ) ;
			if( iRV < 0 )
			{ //空振り
				iIsUpdated |= Edit_0CClickNoHit( iMx , iMy ) ;
			}
			else
			{ //ヒット
				iIsUpdated |= Edit_0CClickHit( iMx , iMy , iRV ) ;
			}
		}
		return iIsUpdated ;
	}
	virtual int Edit_0CtrlA(){ InvalidateKeyCode( KC_A ) ; SelectAll() ; return 1 ; }
	virtual int Edit_0Del(){ InvalidateKeyCode( KC_DEL ) ; DeleteS() ; return 1 ;}
	virtual int Edit_0C()
	{
		FILE *fp = NULL ;
		int iRV = 0 ;
		int iMaxOffset = iNOElem ;
		{
			if( KeyOn( KC_CTRL ) ){ _tfopen_s( &fp , ptcClipFilename , _T("wt") ) ; }
			if( fp ){ Edit_0C_CF_AfterOpening( fp ) ; }
		}
		for( int i=0 ; i<iMaxOffset ; i++ ) //処理を始めた段階での最大値でループ
		{
			if( IsSelected( i ) )
			{
				int iNewObj = Add() ; //末端に追加
				if( iNewObj<0 ){ break ; }
				pElem[iNewObj].Duplicate( pElem+i ) ; //コピー実行
				if( fp )
				{
					Edit_0C_CF_Duplicated1( fp , iNewObj ) ;
					Edit_0C_CF_Duplicated2( fp , iNewObj ) ;
					Edit_0C_CF_Duplicated3( fp , iNewObj ) ;
				}
				Deselect( iNewObj ) ;
				Edit_0C_DeltaCopyPosition( iNewObj ) ;
				iRV = 1 ;
			}
		}
		if( iRV )
		{ //コピー処理が実行されたら、適切な位置に移動
			int iInsPosition = GetSelectSuffix( 2 ) ; //最後に見つかった選択オブジェクトの後ろに移動
			DeselectAll() ; //選択解除
			for( int i=iMaxOffset ; i<iNOElem ; i++ )
			{
				Select( i ) ; //コピー先を選択
				SwapLong( i , iInsPosition+1 ) ;
				iInsPosition ++ ;
			}
		}
		if( fp )
		{
			Edit_0C_CF_BeforeClosing( fp ) ;
			fclose(fp) ;
		}
		return iRV ;
	}
	virtual void Edit_0C_DeltaCopyPosition( int iNewObj )
	{
		pElem[iNewObj].MoveD(20,0) ;
	}
	virtual void Edit_0C_CF_AfterOpening( FILE *fp ){ ; } ;
	virtual void Edit_0C_CF_Duplicated1( FILE *fp , int iNewObj )
	{
		_ftprintf_s( fp , _T("NewElem\n") ) ;
		_ftprintf_s( fp , _T("X %d\n") , pElem[iNewObj].GetX() ) ;
		_ftprintf_s( fp , _T("Y %d\n") , pElem[iNewObj].GetY() ) ;
	}
	virtual void Edit_0C_CF_Duplicated2( FILE *fp , int iNewObj ){;}
	virtual void Edit_0C_CF_Duplicated3( FILE *fp , int iNewObj )
	{
		_ftprintf_s( fp , _T("\n") ) ;
	}
	virtual void Edit_0C_CF_BeforeClosing( FILE *fp ){ ; } ;
	virtual int Edit_0KeyProc( int iMx , int iMy ) { return 0;}
	virtual int Edit_0NohitCtrl( int iMx , int iMy , int iNewObj )
	{
		if( iNewObj < 0 )
		{ return 0 ; }
		int iSrc = GetSelectSuffix( 1 ) ;
		DeselectAll() ;
		if( iSrc >= 0 )
		{
			SwapLong( iNewObj , iSrc+1 ) ;
			iNewObj = iSrc+1 ;
			pElem[iNewObj].Duplicate( pElem+iSrc ) ;
		}
		pElem[iNewObj].Move( iMx , iMy ) ;
		Select( iNewObj ) ;
		DragInit( iNewObj , iMx , iMy ) ;
		return 1 ;
	}
	virtual int Edit_0NoHit( int iMx , int iMy ){ DeselectAll() ;return 1 ;}
	virtual int Edit_0Hit( int iMx , int iMy , int iDestObj )
	{
		int iRV = 0 ;
		int iIsDragStarted = 0 ;
		if( KeyOn( KC_CTRL ) )
		{ //選択スイッチ
			SwitchSelection( iDestObj ) ; iRV = 1 ;
			if( IsSelected( iDestObj ) ){ iIsDragStarted = 1 ; }
		}
		else
		{ //単一選択
			if( !IsSelected( iDestObj ) )
			{
				DeselectAll() ;
				Select( iDestObj ) ; iRV = 1 ;
			}
			iIsDragStarted = 1 ;
		}
		//iIsDragStartedは、単一選択か、複数選択で「選択」にしたときに1
		if( MousePush( MB_L ) && iIsDragStarted )
		{
			DragInit( iDestObj , iMx , iMy ) ;
		}
		return iRV ;
	}
	virtual int Edit_0CClickNoHit( int iMx , int iMy ){ return 0 ; }
	virtual int Edit_0CClickHit( int iMx , int iMy , int iDestObj ){ return 0 ; }

	virtual int DoEdit_Sub1( int iBx , int iBy )
	{
		if( !MouseOn( MB_L ) )
		{
			PositionLimitS() ;
			Edit_1DraggingEnded() ;
			iDragging = -1 ;
			return 1 ;
		}
		int iIsUpdated = 0 ;
		int iMx , iMy ;
		int iDx , iDy ;
		iMx = GetMousePosX() - iBx ;
		iMy = GetMousePosY() - iBy ;
		iDx = iMx - iDragPreX ;
		iDy = iMy - iDragPreY ;
		if( iDx || iDy )
		{
			assert( IsCorrectSuffix( iDragging ) ) ;
			if( KeyOn( KC_CTRL ) )
			{ pElem[iDragging].Snapping( &iDx , &iDy ) ; }
			Edit_1ElemPreMove( &iDx , &iDy ) ;
			if( iDx || iDy )
			{
				iIsUpdated = MoveDS( iDx , iDy ) ;
				iDragPreX += iDx ;
				iDragPreY += iDy ;
			}
			Edit_1ElemMoved() ;
		}
		return iIsUpdated ;
	}
	virtual void Edit_1DraggingEnded(){;}
	virtual void Edit_1ElemPreMove( int *piDx , int *piDy ){;}
	virtual void Edit_1ElemMoved(){;}
	virtual int DoEdit_Sub2( int iBx , int iBy )
	{
		if( !MouseOn( MB_L ) )
		{
			Edit_2DraggingEnded() ;
			iRectSelection = 0 ;
			return 1 ;
		}
		int iMx , iMy ;
		iMx = GetMousePosX() - iBx ;
		iMy = GetMousePosY() - iBy ;
		if( iRectPreX != iMx || iRectPreY != iMy )
		{
			iRectPreX = iMx ;
			iRectPreY = iMy ;
			DeselectAll() ;
			for( int i=0 ; i<iNOElem ; i++ )
			{
				int iTx , iTy ;
				iTx = pElem[i].GetX() ;
				iTy = pElem[i].GetY() ;
				if(
					(
						( iRectOrgX <= iTx && iTx <= iMx ) ||
						( iMx <= iTx && iTx <= iRectOrgX )
					) && (
						( iRectOrgY <= iTy && iTy <= iMy ) ||
						( iMy <= iTy && iTy <= iRectOrgY )
					)
				)
				{
					pElem[i].Select() ;
					Edit_2ObjSelected(i) ;
				}
			}
			return 1 ;
		}
		return 0 ;
	}
	virtual void Edit_2ObjSelected(int iDestObj){;}
	virtual void Edit_2DraggingEnded(){;}
	void DragInit( int iCore , int iOrgX , int iOrgY )
	{
		iDragging = iCore ;
		iDragOrgX = iDragPreX = iOrgX ;
		iDragOrgY = iDragPreY = iOrgY ;
	}
	void RectSelectionInit( int iOrgX , int iOrgY )
	{
		iRectSelection = 1 ;
		iRectOrgX = iRectPreX = iOrgX ;
		iRectOrgY = iRectPreY = iOrgY ;
	}
} ;

class Elem
{
public:
	virtual void Duplicate( Elem *pSrc )
	{
		iX    = pSrc->iX    ;
		iY    = pSrc->iY    ;
		iFlag = pSrc->iFlag ;
	}
	virtual void Swap( Elem *pSrc )
	{
		Elem tTmp ;
		tTmp.Duplicate( this ) ;
		this->Duplicate( pSrc ) ;
		pSrc->Duplicate( &tTmp ) ;
	}

	virtual void Clear()
	{
		iX = iY = iFlag = 0 ;
	}
	void Add()
	{
		iFlag = ciFlagExist ;
	}
	int IsExist(){ return iFlag&ciFlagExist; }
	int IsSelected(){ if(!IsExist()){ return 0 ;}return iFlag&ciFlagSelected ; }
	void Select(){ if(IsExist()){iFlag|=ciFlagSelected ;} }
	void Deselect(){ if(IsExist()){iFlag&=~ciFlagSelected ;} }
	void SwitchSelection(){ if(IsExist()){iFlag^=ciFlagSelected ;} }
	int GetX(){ return iX ; }
	int GetY(){ return iY ; }
	void SetX( int x ){ iX=x ; }
	void SetY( int y ){ iY=y ; }
	int Move( int iX , int iY )
	{
		if( !IsExist() ){ return 0 ; }
		if( this->iX == iX && this->iY == iY )
		{ return 0 ;}
		this->iX = iX ;
		this->iY = iY ;
		return 1 ;
	}
	int MoveD( int iDx , int iDy )
	{
		if( !IsExist() ){ return 0 ; }
		iX += iDx ;
		iY += iDy ;
		if( iDx || iDy )
		{ return 1 ;}
		return 0 ;
	}
	void Snapping( int *piDx , int *piDy )
	{
		if( !IsExist() ){ return ; }
		int iTx , iTy ;
		iTx = iX + *piDx ;
		iTy = iY + *piDy ;
		iTx = GaussDivision( iTx , 4 ) * 4 ;
		iTy = GaussDivision( iTy , 4 ) * 4 ;
		(*piDx) = iTx - iX ;
		(*piDy) = iTy - iY ;
	}
	void PositionLimit( int iX0 , int iY0 , int iX1 , int iY1 )
	{
		DurCorrect( &iX , iX0 , iX1 ) ;
		DurCorrect( &iY , iY0 , iY1 ) ;
	}
	virtual int IsInRect( int iX , int iY ){ return 0 ; }
	virtual void Draw( MyDIBObj3 *pMDO , int iSfc , int x , int y ){ ; }
protected:
	static const int ciFlagExist = 1 ;
	static const int ciFlagSelected = 2 ;
	int iX ;
	int iY ;
	int iFlag ;
} ;


#endif /*VERSATILE_ELEMENT_EDITOR_HEADER_INCLUDED*/


