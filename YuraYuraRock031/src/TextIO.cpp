#include "TextIO.h"
#include <assert.h>

TextIOManager::TextIOManager( LPCTSTR filename , int NOIOItem , _TCHAR command_token , _TCHAR comment_token )
{
	this->filename = filename ;
	this->command_token = command_token ;
	this->comment_token = comment_token ;
	PItem = (TextIOItem*)malloc( NOIOItem*sizeof(TextIOItem) ) ;
	itempos = 0 ;
	maxitem = NOIOItem ;
}
TextIOManager::~TextIOManager()
{
	for( int i=0 ; i<itempos ; i++ )
	{
		free( PItem[i].token ) ;
	}
	if( PItem )free( PItem ) ;
}
bool TextIOManager::AddIOItem_Comment( LPCTSTR token )
{
	if( itempos>=maxitem )return false ;

	TextIOItem *Pdest = PItem+itempos ;

	int iTokenLength ;
	iTokenLength = _tcslen(token)+1 ;
	Pdest->token = (LPTSTR)malloc( iTokenLength*sizeof(_TCHAR) ) ;
	if( !Pdest->token ) return false ;
	_tcscpy_s( Pdest->token , iTokenLength , token ) ;

	Pdest->mode = 0 ;
	Pdest->size = iTokenLength ;
	Pdest->Pdata = NULL ;
	itempos ++ ;
	return true ;
}
bool TextIOManager::AddIOItem_16Value( LPCTSTR token , int *Pval )
{
	if( itempos>=maxitem )return false ;

	TextIOItem *Pdest = PItem+itempos ;

	int iTokenLength ;
	iTokenLength = _tcslen(token)+1 ;
	Pdest->token = (LPTSTR)malloc( iTokenLength*sizeof(_TCHAR) ) ;
	if( !Pdest->token ) return false ;
	_tcscpy_s( Pdest->token , iTokenLength , token ) ;

	Pdest->mode = 10 ;
	Pdest->size = 1 ;
	Pdest->Pdata = Pval ;
	itempos ++ ;
	return true ;
}
bool TextIOManager::AddIOItem_Block( LPCTSTR token , void *Pblock , int size )
{
	if( itempos>=maxitem )return false ;

	TextIOItem *Pdest = PItem+itempos ;

	int iTokenLength ;
	iTokenLength = _tcslen(token)+1 ;
	Pdest->token = (LPTSTR)malloc( iTokenLength*sizeof(_TCHAR) ) ;
	if( !Pdest->token ) return false ;
	_tcscpy_s( Pdest->token , iTokenLength , token ) ;

	Pdest->mode = 20 ;
	Pdest->size = size ;
	Pdest->Pdata = Pblock ;
	itempos ++ ;
	return true ;
}
bool TextIOManager::AddIOItem_16Array( LPCTSTR token , int *Pval , int size )
{
	if( itempos>=maxitem )return false ;

	TextIOItem *Pdest = PItem+itempos ;

	int iTokenLength ;
	iTokenLength = _tcslen(token)+1 ;
	Pdest->token = (LPTSTR)malloc( iTokenLength*sizeof(_TCHAR) ) ;
	if( !Pdest->token ) return false ;
	_tcscpy_s( Pdest->token , iTokenLength , token ) ;

	Pdest->mode = 30 ;
	Pdest->size = size ;
	Pdest->Pdata = Pval ;
	itempos ++ ;
	return true ;
}

int TextIOManager::DoSaving()
{
	FILE *fp ;
	int rv = 0 ;
	if( _tfopen_s( &fp , filename , _T("wt") ) )return -2 ;
	try
	{
		for( int i=0 ; i<itempos ; i++ )
		{
			TextIOItem *Pdest = PItem+i ;
			switch( Pdest->mode )
			{
			case 0://コメント
				{
					if( _ftprintf_s( fp , _T("%c%s\n") , comment_token , Pdest->token ) < 0 )throw -1 ;
				}
			break; 
			case 10://１６ビット値
				{
					if( _ftprintf_s( fp , _T("%c%s %04X\n") , command_token , Pdest->token , *(short*)(Pdest->Pdata) ) < 0 )throw -1 ;
				}
			break ;
			case 20://ブロック
				{
					if( _ftprintf_s( fp , _T("%c%s\n") , command_token , Pdest->token ) < 0 )throw -1 ;
					for( int i=0 ;; i++ )
					{
						if( i>=Pdest->size )
						{
							if( _ftprintf_s( fp , _T("\n\n\n") , command_token ) < 0 )throw -1 ;
							break ;
						}
						if( (i%512)==0 )
						{
							if( _ftprintf_s( fp , _T("%cBIN ") , command_token ) < 0 )throw -1 ;
						}
						if( _ftprintf_s( fp , _T("%02X") , ((BYTE*)(Pdest->Pdata))[i] ) < 0 )throw -1 ;
						if( (i%512)==511 )
						{
							if( _ftprintf_s( fp , _T("\n") , command_token ) < 0 )throw -1 ;
						}
					}
				}
			break ;
			case 30://１６ビットブロック
				{
					if( _ftprintf_s( fp , _T("%c%s\n") , command_token , Pdest->token ) < 0 )throw -1 ;
					for( int i=0 ;; i++ )
					{
						if( i>=Pdest->size )
						{
							if( _ftprintf_s( fp , _T("\n\n\n") , command_token ) < 0 )throw -1 ;
							break ;
						}
						if( (i%256)==0 )
						{
							if( _ftprintf_s( fp , _T("%cBIN ") , command_token ) < 0 )throw -1 ;
						}
						_TCHAR tcb[16] ;
						_stprintf_s( tcb , sizeof(_TCHAR)*16 , _T("%08X") , ((int*)(Pdest->Pdata))[i] ) ;
						if( _ftprintf_s( fp , _T("%s") , tcb+4 ) < 0 )throw -1 ;
						if( (i%256)==255 )
						{
							if( _ftprintf_s( fp , _T("\n") , command_token ) < 0 )throw -1 ;
						}
					}
				}
			break ;
			}
		}
	}
	catch( int erv )
	{
		rv = erv ;
	}
	fclose( fp ) ;
	return rv ;
}
int TextIOManager::DoLoading()
{
	FILE *fp ;
	int rv = 0 ;
	//より内側に置くべきだが、デバッグに便利
	_TCHAR buf[2048] ;
	if( _tfopen_s( &fp , filename , _T("rt") ) )return -2 ;
	try
	{
		int wpos ;
		TextIOItem *Ploading = NULL ;

		for(;;)
		{
			if( !_fgetts( buf , sizeof(buf) , fp ) )break ;
			if( memcmp( buf , &command_token , sizeof(_TCHAR) ) )continue ;
			if( !memcmp( buf+1 , _T("BIN") , 3*sizeof(_TCHAR) ) )
			{
				if( !Ploading )
				{
//					throw -1 ;
					continue ;
				}
				int rpos = 5 ;
				for(;;)
				{
#define OrHex(dest,buf,suffix)	\
	if( buf[suffix]>=_T('0') && buf[suffix]<=_T('9') )		\
		{dest |= buf[suffix]-_T('0') ;}						\
	else if( buf[suffix]>=_T('A') && buf[suffix]<=_T('F') )	\
		{dest |= buf[suffix]-_T('A')+10 ;}					\
	else													\
		{forbreak=true;break ;}

					bool forbreak ;
					forbreak = false ;
					switch( Ploading->mode )
					{
					case 20:
						{
							int tmp ;

							/*
							//最初はこうしていたのだが、高々scanfも回数が多くなると少々重たい
							//そこで、機能を絞って最適化した
							//ポインタ演算の利用とかは……やらなくて良いとおもう。コンパイラがたぶんやる。
							if( _stscanf_s( buf+rpos , _T("%2X") , &tmp ) != 1 ){forbreak=true;break ;}
							*/

							tmp = 0 ;
							OrHex( tmp , buf , rpos+0 ) ;
							tmp <<= 4 ;
							OrHex( tmp , buf , rpos+1 ) ;
							if( wpos >= Ploading->size )throw -1 ;
							((BYTE*)(Ploading->Pdata))[wpos] = tmp ;
							rpos += 2 ;
							wpos ++ ;
						}
					break ;
					case 30:
						{
							int tmp ;
//							if( _stscanf_s( buf+rpos , _T("%4X") , &tmp ) != 1 ){forbreak=true;break ;}
							tmp = 0 ;
							OrHex( tmp , buf , rpos+0 ) ;
							tmp <<= 4 ;
							OrHex( tmp , buf , rpos+1 ) ;
							tmp <<= 4 ;
							OrHex( tmp , buf , rpos+2 ) ;
							tmp <<= 4 ;
							OrHex( tmp , buf , rpos+3 ) ;
							if( wpos >= Ploading->size )throw -1 ;
							((int*)(Ploading->Pdata))[wpos] = (short)tmp ;
							rpos += 4 ;
							wpos ++ ;
						}
					break ;
					default:
						assert(0) ;
					}
					if( forbreak )break ;
				}
				continue ;
			}
			for( int i=0 ; i<itempos ; i++ )
			{
				TextIOItem *Pdest = PItem+i ;
				if( !memcmp( buf+1 , Pdest->token , sizeof(_TCHAR)*_tcslen(Pdest->token) ) )
				{
					int rpos = 1+_tcslen(Pdest->token) ;
					if( !( buf[rpos] == _T(' ') || buf[rpos] == _T('\n') ) )continue ;
					switch( Pdest->mode )
					{
					case 0://コメント
					break ;
					case 10://１６ビット値
						{
							int tmp ;
							if( _stscanf_s( buf+rpos , _T("%X") , &tmp ) != 1 )throw -1 ;
							*((int*)(Pdest->Pdata)) = (short)tmp ;
						}
					break ;
					case 20://ブロック
						Ploading = Pdest ;
						wpos = 0 ;
					break ;
					case 30://16ビットブロック
						Ploading = Pdest ;
						wpos = 0 ;
					break ;
					default :
						assert(0) ;
					}
					break ;
				}
			}
		}
	}
	catch( int erv )
	{
		rv = erv ;
	}
	fclose( fp ) ;
	return rv ;
}
