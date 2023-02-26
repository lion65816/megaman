#include <windows.h>
#include "RockStage_Elem.h"

void Object::Draw( MyDIBObj3 *pMDO , int iSfc , int x , int y )
{
	int tx , ty ;
	tx = iX + x - 8 ;
	ty = iY + y - 8 ;

	{
		BMPD color = myRGB(31,31,0) ;
		if( IsSelected() ){ color = myRGB(31,0,0); }
		pMDO->Cls( MDO3WINAPI , iSfc , tx , ty , 16 , 16 , color ) ;
	}
	_TCHAR aucTmp[16] ;
	int iTmp = ucType ;
	_stprintf_s( aucTmp , _countof(aucTmp) , _T("%02X") , iTmp ) ;
	pMDO->Text( iSfc , aucTmp , tx , ty , 16 , 8 , RGB(0,0,0) ) ;
}

void ObjectUnit::ImportFromROM( int iMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT , int iMaxObj , int iMaxPage )
{
	Clear() ;
	int iMul=1 ;
	if( iEditMode==1 )
	{
		pucX = pucPage+1 ;
		pucY = pucPage+2 ;
		pucT = pucPage+3 ;
		iMul=4; 
	}
	for( int i=0 ; i<iMaxObj ; i++ )
	{
		int iTx,iTy,iTt ;
		iTx = pucPage[i*iMul]*256 + pucX[i*iMul] ;
		iTy = pucY[i*iMul] ;
		iTt = pucT[i*iMul] ;
		if( iTx/256>=iMaxPage ){ break; }
		int iSuffix = Add() ;
		if( iSuffix<0 ){ assert(0); }
		pElem[iSuffix].Move( iTx , iTy ) ;
		pElem[iSuffix].SetType( iTt ) ;
	}
}
void ObjectUnit::ImportFromROM_m( int iMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT , int iMaxObj , int iMaxPage , int iDeltaPage )
{
	int iMul=1 ;
	if( iEditMode==1 )
	{
		pucX = pucPage+1 ;
		pucY = pucPage+2 ;
		pucT = pucPage+3 ;
		iMul=4; 
	}
	for( int i=0 ; i<iMaxObj ; i++ )
	{
		int iTx,iTy,iTt ;
		iTx = (pucPage[i*iMul]+iDeltaPage)*256 + pucX[i*iMul] ;
		iTy = pucY[i*iMul] ;
		iTt = pucT[i*iMul] ;
		if( iTx/256>=iMaxPage ){ break; }
		int iSuffix = Add() ;
		if( iSuffix<0 ){ break; }
		pElem[iSuffix].Move( iTx , iTy ) ;
		pElem[iSuffix].SetType( iTt ) ;
	}
}
void ObjectUnit::ExportToROM( int iEditMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT , int iCnt )
{
	int iMul=1 ;
	if( iEditMode==1 )
	{
		pucX = pucPage+1 ;
		pucY = pucPage+2 ;
		pucT = pucPage+3 ;
		iMul=4; 
	}
	for( int i=0 ; i<iCnt ; i++ )
	{
		if( !pElem[i].IsExist() )
		{
			pucPage[i*iMul] = 
			pucX[i*iMul]    = 
			pucY[i*iMul]    = 
			pucT[i*iMul]    = 0xFF ;
		}
		else
		{
			pucPage[i*iMul] = pElem[i].GetX()/256 ;
			pucX[i*iMul]    = pElem[i].GetX()%256 ;
			pucY[i*iMul]    = pElem[i].GetY() ;
			pucT[i*iMul]    = pElem[i].GetT() ;
		}
	}
}
void ObjectUnit::ExportToROM_m( int iEditMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT , int iDeltaPage )
{
	int iMul=1 ;
	if( iEditMode==1 )
	{
		pucX = pucPage+1 ;
		pucY = pucPage+2 ;
		pucT = pucPage+3 ;
		iMul=4; 
	}
	int iWp=0 ;
	for( int i=0 ; iWp<iMaxElem ; iWp++,i++ )
	{
		if( i>=iMaxElem || !pElem[i].IsExist() )
		{
			pucPage[iWp*iMul] = 
			pucX[iWp*iMul]    = 
			pucY[iWp*iMul]    = 
			pucT[iWp*iMul]    = 0xFF ;
		}
		else
		{
			if( pElem[i].GetX()/256-iDeltaPage >= 0 )
			{
				pucPage[iWp*iMul] = pElem[i].GetX()/256-iDeltaPage ;
				pucX[iWp*iMul]    = pElem[i].GetX()%256 ;
				pucY[iWp*iMul]    = pElem[i].GetY() ;
				pucT[iWp*iMul]    = pElem[i].GetT() ;
			}
			else
			{
				iWp-- ;
			}
		}
	}
}
void ObjectUnit::ExportToROMTerm( int iEditMode , unsigned char *pucPage , unsigned char *pucX , unsigned char *pucY , unsigned char *pucT  , int iTermPage )
{
	int iMul=1 ;
	if( iEditMode==1 )
	{
		pucX = pucPage+1 ;
		pucY = pucPage+2 ;
		pucT = pucPage+3 ;
		iMul=4; 
	}
	for( int i=0 ; i<iMaxElem ; i++ )
	{
		if( pucPage[i*iMul]>=iTermPage )
		{
			pucPage[i*iMul] = 
			pucX[i*iMul]    = 
			pucY[i*iMul]    = 
			pucT[i*iMul]    = 0xFF ;
		}
	}
}
