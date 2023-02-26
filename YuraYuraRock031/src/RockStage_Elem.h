#ifndef ROCK_STAGE_ELEM_HEADER_INCLUDED
#define ROCK_STAGE_ELEM_HEADER_INCLUDED

#include "VersatileElemEditor.h"


class Object : public Elem
{
public:
	unsigned char ucType ;
	int GetT(){ return ucType ; }
	void SetT( int iType ){ ucType=iType ; }
	virtual void Clear()
	{
		Elem::Clear() ;
		ucType = 0 ;
	}
	virtual void Duplicate( Object *pSrc )
	{
		Elem::Duplicate( pSrc ) ;
		ucType = pSrc->ucType ;
	}
	virtual void Swap( Object *pSrc )
	{
		Object tTmp ;
		tTmp.Duplicate( this ) ;
		this->Duplicate( pSrc ) ;
		pSrc->Duplicate( &tTmp ) ;
	}
	virtual void Draw( MyDIBObj3 *pMDO , int iSfc , int x , int y ) ;
	virtual int IsInRect( int iX , int iY )
	{
		int iTx , iTy ;
		iTx = iX - this->iX + 8 ;
		iTy = iY - this->iY + 8 ;
		if( iTx>=0 && iTy>=0 && iTx<16 && iTy<16 )
		{ return 1 ; }
		return 0 ;
	}
	void SetType( unsigned char ucType ){ this->ucType = ucType; }
	unsigned char GetType(){ return ucType; }
} ;

class ObjectUnit : public ElemUnit_c<Object>
{
public:
	ObjectUnit( int iMaxElem )
	{
		ConstructorSub( iMaxElem ) ;
	}
	ObjectUnit()
	{
		ConstructorSub( 0 ) ;
	}
	void Initialize( int iMaxObject , int iEditMode )
	{
		this->iEditMode = iEditMode ;
		ElemUnit_c<Object>::Initialize(iMaxObject) ;
	}
	void ImportFromROM( int iMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT , int iMaxObj , int iMaxPage ) ;
	void ImportFromROM_m( int iMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT , int iMaxObj , int iMaxPage , int iDeltaPage ) ;
	void ExportToROM( int iMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT  , int iCnt=-1 ) ;
	void ExportToROM_m( int iMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT , int iDeltaPage ) ;
	void ExportToROMTerm( int iMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT  , int iTermPage ) ;
	void SetParamPointer( unsigned char *pucParamOut , int *piParamOut )
	{
		this->pucParamOut = pucParamOut ;
		this->piParamOut = piParamOut ;
	}
	void ReleaseParamPointer( unsigned char *pucParamOut , int *piParamOut )
	{
		if( this->pucParamOut == pucParamOut ){ this->pucParamOut = NULL ; }
		if( this->piParamOut == piParamOut){ this->piParamOut = NULL ; }
	}
	
	void ClearDeltaYList()
	{
		for( int i=0 ; i<_countof( aiDeltaY ) ; i++ ){ aiDeltaY[i]=0; }
	}
	void SetDeltaYList( int (*paiSrc)[256] )
	{
		memcpy( aiDeltaY , *paiSrc , sizeof( aiDeltaY ) ) ;
	}

	int GetT( int iDest ){  if( IsCorrectSuffix( iDest )){ return pElem[iDest].GetT() ; }return -1; }

	int SetTS( int iT )
	{
		int iRV = 0 ;
		for( int i=0 ; i<iNOElem ; i++ )
		{
			if( IsSelected(i) && pElem[i].GetT()!=iT )
			{
				pElem[i].SetT( iT ) ;
				iRV = 1 ;
			}
		}
		return iRV ;
	}
	int SetXByteS( int iOffset , int iValue )
	{
		int iRV = 0 ;
		if( iOffset>=0 && iOffset<=1 )
		{
			static const int aiTblMask[]={0xFF,0xFF00} ;
			static const int aiTblShift[]={0,8} ;
			int iMask = aiTblMask[iOffset] ;
			iValue <<= aiTblShift[iOffset] ;
			for( int i=0 ; i<iNOElem ; i++ )
			{
				int iTmp = pElem[i].GetX() ;
				if( IsSelected(i) && (iTmp&iMask)!=iValue )
				{
					pElem[i].SetX( (iTmp&~iMask)|iValue ) ;
					iRV = 1 ;
				}
			}
		}
		return iRV ;
	}
	int GetElemOffsetPerPage( int iPage )
	{
		iPage <<=8 ;
		for( int i=0 ; i<iNOElem ; i++ )
		{
			if ((pElem[i].GetX() & 0xFF00 ) == iPage )
			{
				return i ;
			}
		}
		for( int i=0 ; i<iNOElem ; i++ )
		{
			if ((pElem[i].GetX() & 0xFF00 ) >= iPage )
			{
				return i ;
			}
		}
		return iNOElem ;
	}
	int GetElemOffsetPerPage_m( int iPage ,  int iDeltaPage )
	{
		int iFirstOffset=iNOElem ;
		for( int i=0 ; i<iNOElem ; i++ )
		{
			if ( pElem[i].GetX()/256 >= iDeltaPage )
			{
				iFirstOffset = i ;
				break ;
			}
		}

		for( int i=iFirstOffset ; i<iNOElem ; i++ )
		{
			if ( pElem[i].GetX()/256-iDeltaPage == iPage )
			{
				return i-iFirstOffset ;
			}
		}
		for( int i=iFirstOffset ; i<iNOElem ; i++ )
		{
			if ( pElem[i].GetX()/256-iDeltaPage >= iPage )
			{
				return i-iFirstOffset ;
			}
		}
		return iNOElem ;
	}
	int GetMaxPage()
	{
		int iCurMax = 0 ;
		for( int i=0 ; i<iNOElem ; i++ )
		{
			int iVal = pElem[i].GetX()/256 ;
			if ( iVal >= iCurMax )
			{
				iCurMax = iVal ;
			}
		}
		return iCurMax ;
	}
	virtual void Draw( MyDIBObj3 *pMDO , int iSfc , int x , int y )
	{
		int ix , iy ;
		ix = pElem[0].GetX()+x ;
		iy = pElem[0].GetY()+y ;
		for( int i=1 ; i<iNOElem ; i++ )
		{
			int tx , ty ;
			tx = pElem[i].GetX()+x ;
			ty = pElem[i].GetY()+y ;
			pMDO->Line( MDO3normal , iSfc , ix , iy , tx , ty , myRGB(0,31,0) ) ;
			ix = tx ;
			iy = ty ;
		}
		ElemUnit_c<Object>::Draw( pMDO , iSfc , x , y ) ;
	}
protected:
	void ConstructorSub( int iMaxElem )
	{
		ClearDeltaYList() ;
	}

	int iEditMode ;
	unsigned char *pucParamOut ;
	int *piParamOut ;
	int aiDeltaY[256] ;
	void UpdateParamOut( int iOffset )
	{
		assert( iOffset>=0 && iOffset<iNOElem ) ;
		if( pucParamOut && piParamOut )
		{
			pucParamOut[0] = pElem[iOffset].GetX()>>8 ;
			pucParamOut[1] = pElem[iOffset].GetX()&0xFF ;
			pucParamOut[2] = pElem[iOffset].GetY() ;
			*piParamOut = pucParamOut[3] = pElem[iOffset].GetT() ;
		}
	}
	virtual int Edit_0KeyProc( int iMx , int iMy )
	{
		int iRV = 0 ;
		if( KeyPush( KC_ENTER ) )
		{
			InvalidateKeyCode( KC_ENTER ) ;
			DeselectAll() ;
			for( int i=0 ; i<iNOElem ; i++ )
			{
				for( int q=i+1 ; q<iNOElem ; q++ )
				{
					if( pElem[i].GetX() > pElem[q].GetX() )
					{
						Swap( i , q ) ;
						iRV = 1 ;
					}
				}
			}
		}
		return iRV;
	}
	virtual int Edit_0Hit( int iMx , int iMy , int iDestObj )
	{
		int iRV = ElemUnit_c<Object>::Edit_0Hit( iMx , iMy , iDestObj ) ;
		UpdateParamOut( iDestObj ) ;
		return iRV ;
	}
	virtual void Edit_1ElemPreMove( int *piDx , int *piDy )
	{
		int iFixY = aiDeltaY[ pElem[iDragging].GetT() ] ;
		int iCurY = pElem[iDragging].GetY() ;
		int iExpY = iCurY + *piDy ;

		if( KeyOn(KC_SHIFT) && iFixY < 256 )
		{
			RotateCorrect( &iFixY , 16 ) ;
			int iTmpY = iExpY ;
			iTmpY = ( (iTmpY&0xF0) | iFixY ) ;
			*piDy = iTmpY - iCurY ;
		}
	}
	virtual int Edit_0CClickNoHit( int iMx , int iMy )
	{
		if( KeyOff( KC_CTRL ) || iMx<0 || iMy<0 || iMy>=256 ){ return 0 ; }
		int iRV = 0 ;
		if( KeyOff( KC_SHIFT ) )
		{//ページ挿入
			for( int i=0 ; i<iNOElem ; i++ )
			{
				int iTmp = pElem[i].GetX() ;
				if( iTmp >= iMx ){ pElem[i].SetX(iTmp+256); iRV=1; }
			}
		}
		else
		{//ページ詰め
			for( int i=0 ; i<iNOElem ; i++ )
			{
				int iTmp = pElem[i].GetX() ;
				if( iTmp >= iMx ){ pElem[i].SetX(iTmp-256); iRV=1; }
			}

		}
		return iRV ;
	}
	virtual int Edit_0CClickHit( int iMx , int iMy , int iDestObj )
	{
		if( aiDeltaY[ pElem[iDestObj].GetT() ] < 256 )
		{
			int iTmpY = pElem[iDestObj].GetY() ;
			iTmpY = (iTmpY + 8)&0xF0 ;
			iTmpY += aiDeltaY[ pElem[iDestObj].GetT() ] ;
			pElem[iDestObj].SetY( iTmpY ) ;
			UpdateParamOut( iDestObj ) ;
		}
		return 1 ;
	}
	virtual void Edit_1ElemMoved()
	{
		UpdateParamOut(iDragging) ;
	}
	virtual void Edit_2ObjSelected(int iDestObj)
	{
		UpdateParamOut( iDestObj ) ;
	}
} ;

#endif /*ROCK_STAGE_ELEM_HEADER_INCLUDED*/
