#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include <locale.h>
#include <io.h>
#include <malloc.h>
#include <memory.h>

#include "ips.h"

#define FREE(arg)			{if(arg){free(arg);}arg=NULL;}

static int LoadFile( const TCHAR *ptcFilename , unsigned char **ppucBuffer )
{
	int  iBufferSize ;
	FILE *fp ;

	FREE( (*ppucBuffer) ) ;

	if( _tfopen_s( &fp , ptcFilename , _T("rb") ) )
	{
		return -1 ;
	}
	if( fseek( fp , 0 , SEEK_END ) ||
		( iBufferSize = ftell( fp )) <= 0 ||
		fseek( fp , 0 , SEEK_SET ) ||
		!((*ppucBuffer) = (unsigned char*)malloc( iBufferSize ) ) ||
		(int)fread( (*ppucBuffer) , 1 , iBufferSize , fp ) != iBufferSize ||
		0 )
	{
		FREE( (*ppucBuffer) ) ;
		fclose( fp ) ;
		return -2 ;
	}
	fclose( fp ) ;
	return iBufferSize ;
}
static int SaveFile( const TCHAR *ptcFilename , unsigned char *pucBuffer , int iFileSize )
{
	FILE *fp ;
	if( _tfopen_s( &fp , ptcFilename , _T("wb") ) )
	{
		return -1 ;
	}
	if( (int)fwrite( pucBuffer , 1 , iFileSize , fp ) < iFileSize )
	{
		return -2 ;
	}
	fclose( fp ) ;
	return 0 ;
}

int IPSPatch( unsigned char *pucDest , int iDestSize , unsigned char *pucSrc , int iSrcSize  , unsigned char **ppucExpDest , int *piExpSize )
{
	int iRV = 0 ;
	unsigned char *pucWork=NULL;
	int iWorkSize = iDestSize ;
	int iMaxSize = iDestSize ;
	try
	{
		int iRPos;
		if( !pucDest && !ppucExpDest ){ throw -1; }
		if( iDestSize<=0 ){ throw -2; }
		pucWork = (unsigned char*)malloc( iWorkSize ) ;
		if( !pucWork ){ throw -3; }
		if( pucDest )
		{
			memcpy( pucWork , pucDest , iWorkSize ) ;
		}
		else
		{
			memcpy( pucWork , *ppucExpDest , iWorkSize ) ;
		}
		if( memcmp( pucSrc , "PATCH" , 5 ) ){ throw -4; }
		iRPos = 5 ;
		for(;;)
		{
			int iStart,iLength;
			int iCont ;
			if( iSrcSize - iRPos == 3 )
			{
				if( memcmp(&pucSrc[iRPos], "EOF" , 3 ) ){ throw -5; }
				//正常終了
				break;
			}
			if( iSrcSize - iRPos < 5 ){ throw -6; }
			iStart  = (pucSrc[iRPos]<<16)+(pucSrc[iRPos+1]<<8)+pucSrc[iRPos+2];
			iLength = (pucSrc[iRPos+3]<<8) + pucSrc[iRPos+4];
			iRPos += 5;
			iCont = -1 ;
			if( !iLength )
			{
				if( iSrcSize - iRPos < 3 ){ throw -7; }
				iLength = (pucSrc[iRPos]<<8) + pucSrc[iRPos+1];
				iCont = pucSrc[iRPos+2] ;
				iRPos += 3 ;
			}
			else
			{
				if( iSrcSize - iRPos < iLength ){ throw -8; }
			}
			if( iStart+iLength > iWorkSize )
			{
				//拡張なしモードの場合エラー
				if( pucDest ){ throw -9; }
				iWorkSize *= 2 ;
				pucWork = (unsigned char*)realloc( pucWork , iWorkSize ) ;
				if( !pucWork ){ throw -10; }
				memset( pucWork+iWorkSize/2 , 0 , iWorkSize/2 ) ;
			}
			if( iStart+iLength > iMaxSize ){ iMaxSize = iStart+iLength; }

			if( iCont == -1 )
			{
				for( int i=0 ; i<iLength ; i++ )
				{
					pucWork[iStart+i] = pucSrc[iRPos];
					iRPos++;
				}
			}
			else
			{
				for( int i=0 ; i<iLength ; i++ )
				{
					pucWork[iStart+i] = iCont ;
				}
			}
		}
	}
	catch( int iErr )
	{
		iRV = iErr ;
	}
	if( !iRV )
	{
		if( pucDest)
		{//拡張なしの場合
			memcpy( pucDest , pucWork , iDestSize ) ;
		}
		else if( iDestSize==iMaxSize )
		{//拡張有り+拡張は行われなかった場合
			memcpy( *ppucExpDest , pucWork , iDestSize ) ;
		}
		else
		{//拡張有り+拡張が行われた場合
			unsigned char *pTmp = (unsigned char*)realloc( *ppucExpDest , iMaxSize ) ;
			if( !pTmp ){ iRV = -11; }
			else
			{
				*ppucExpDest = pTmp ;
				memcpy( *ppucExpDest , pucWork , iMaxSize ) ;
				if( piExpSize ){ *piExpSize = iMaxSize ; }
			}
		}
	}
	if( pucWork ){ free( pucWork ) ; }
	return iRV ;
}
int IPSCreate( unsigned char *pucDest , unsigned char *pucBase , int iDestSize , unsigned char **ppucOut )
{
	unsigned char *pucBuf ;
	int iWPos ;
	*ppucOut = NULL ;
	pucBuf = (unsigned char*)malloc( iDestSize*3+8 );//1バイト置きに変更があると、2バイトにつき6バイト消費するので3倍
	if( !pucBuf ) return -1 ;
	iWPos = 0;
	pucBuf[0] = 'P';
	pucBuf[1] = 'A';
	pucBuf[2] = 'T';
	pucBuf[3] = 'C';
	pucBuf[4] = 'H';
	iWPos = 5;
	for( int i=0 ; i<iDestSize ; i++ )
	{
		if ( pucBase[i] != pucDest[i] )
		{
			int q ;
			pucBuf[iWPos  ] = (i>>16)&0xFF;
			pucBuf[iWPos+1] = (i>> 8)&0xFF;
			pucBuf[iWPos+2] = (i    )&0xFF;
			for( q=i ; q<iDestSize&&q<i+0xFFFF ; q++ )
			{
				if( pucBase[q] == pucDest[q] )break;
			}
			int iSize = q-i;
			pucBuf[iWPos+3] = (iSize>>8)&0xFF;
			pucBuf[iWPos+4] = (iSize   )&0xFF;
			iWPos+=5;
			for( q=i ; q<i+iSize ; q++ )
			{
				pucBuf[iWPos] = pucDest[q];
				iWPos++;
			}
			//i=qでは、サイズオーバーによって書き出しが行われたときに
			//１バイト落としてしまう
			i=q-1;
		}
	}
	pucBuf[iWPos  ] = 'E';
	pucBuf[iWPos+1] = 'O';
	pucBuf[iWPos+2] = 'F';
	iWPos += 3;

	{
		unsigned char *pucOut ;
		pucOut = (unsigned char*)malloc( iWPos ) ;
		if( !pucOut )
		{
			free( pucBuf ) ;
			return -1 ;
		}
		memcpy( pucOut , pucBuf , iWPos ) ;
		free( pucBuf ) ;
		*ppucOut = pucOut ;
	}
	return iWPos ;
}

int IPSPatch_f( unsigned char *pucDest , int iDestSize , const TCHAR *filename  , unsigned char **ppucExpDest , int *piExpSize )
{
	unsigned char *pucSrc = NULL ;
	int iRV = LoadFile( filename , &pucSrc ) ;
	if( iRV>=0 )
	{
		iRV = IPSPatch( pucDest , iDestSize , pucSrc , iRV , ppucExpDest , piExpSize ) ;
		free( pucSrc ) ;
	}
	else
	{
		iRV*=10 ;
	}
	return iRV ;
}
int IPSCreate_f( unsigned char *pucDest , unsigned char *pucBase , int iDestSize , const TCHAR * filename )
{
	unsigned char *pucOut=NULL ;
	int iRV = IPSCreate( pucDest , pucBase , iDestSize , &pucOut ) ;
	if( iRV>=0 )
	{
		iRV = SaveFile( filename , pucOut , iRV )*10 ;
		free( pucOut ) ;
	}
	return iRV ;
}
