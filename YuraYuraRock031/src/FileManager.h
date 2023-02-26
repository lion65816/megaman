#ifndef FILE_MANAGER_HEADER_INCLUDED
#define FILE_MANAGER_HEADER_INCLUDED

/*
�@�ώG�ȃt�@�C���V�X�e���̑�����Ƃ肠�����܂Ƃ߂����Ǝv���Ă��邾���Ȃ̂ŁA
�@�݊����ȂǃC���C����肪���肻���B
�@���܂�ɕ׋��s���Ȃ̂ŉ���Ȃ��Ƃ����������Ȃ��̂����A
�@������������͊��ˑ������ɐ������Ȃ̂ŁA���b�v���Ă������ƂɈӖ��͂���Ǝv���c�c���Ԃ�B
�@���������AWindows�i�Ƃ����������̓������j�ȊO�ł̓����
�@�܂������l���Ă��Ȃ��i�l����\�͂��Ȃ��j�̂Ŗ��Ӗ��Ƃ������ᖳ�Ӗ��B
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

