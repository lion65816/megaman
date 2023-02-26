#ifndef FILE_MANAGER_HEADER_INCLUDED
#define FILE_MANAGER_HEADER_INCLUDED

/*
　煩雑なファイルシステムの操作をとりあえずまとめたいと思っているだけなので、
　互換性などイロイロ問題がありそう。
　あまりに勉強不足なので下手なことを書きたくないのだが、
　こういう操作は環境依存が特に凄そうなので、ラップしておくことに意味はあると思う……たぶん。
　そもそも、Windows（というか自分の動く環境）以外での動作は
　まったく考えていない（考える能力がない）ので無意味といっちゃ無意味。
*/

#include <windows.h>
#include <tchar.h>
#include <stdio.h>

#include <shlwapi.h>
#pragma comment(lib, "shlwapi.lib")

inline int MyPathIsDirectory( LPCTSTR filename )
{
	if( !PathIsDirectory( filename ) )return 0 ;
	return 1 ;
}
inline int MyFileIsExists( LPCTSTR filename )
{
	if( !PathFileExists( filename ) )return 0 ;
	return 1 ;
}
inline int MyIsGlobalPath( LPCTSTR filename )
{
	TCHAR iTmp = filename[0] ;
	if( ( iTmp >= _T('a') && iTmp <= _T('z') ) ||
		( iTmp >= _T('A') && iTmp <= _T('Z') ) )
	{
		if( filename[1] == _T(':') &&
			filename[2] == _T('\\') )
			{ return 1 ; }
	}
	return 0 ;
}
inline int MyGetFileSize( LPCTSTR filename )
{
	FILE *fp ;
	if( _tfopen_s( &fp , filename , _T("r") ) )
	{
		return -1 ;
	}
	if( fseek( fp , 0 , SEEK_END ) )
	{
		fclose( fp ) ;
		return -1 ;
	}
	int iTmp ;
	iTmp = ftell( fp ) ;
	fclose( fp ) ;
	return iTmp ;
}


#endif  /*FILE_MANAGER_HEADER_INCLUDED*/

