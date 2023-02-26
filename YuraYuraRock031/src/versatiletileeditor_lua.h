/*
コンソールの表示方法は、OrangeMakerさんを参照しました。
http://www.orangemaker.sakura.ne.jp/labo/memo/sdk-mfc/
luaのprint関数をハックする方法は、FCEUXのソースを参照しました。
http://www.fceux.com/web/home.html
//*/


#ifndef VERSATILE_TILE_EDITOR_LUA_HEADER_INCLUDED
#define VERSATILE_TILE_EDITOR_LUA_HEADER_INCLUDED

#include "versatiletileeditor.h"
#include "lua.hpp"
#include <iostream>
#pragma comment(lib, "lua52.lib")

using namespace std;

#define LUA_HOOK(str)			{                 \
		lua_getglobal(L,str);                     \
		if( lua_type(L,1)!=LUA_TNIL )             \
		{                                         \
			lua_pcall(L,0,1,0);                   \
			iRV|=lua_tointeger(L,1);              \
		}                                         \
		lua_pop(L,1);                             \
	}

template <class ChipType>class VersatileTileEditor_Lua : public VersatileTileEditor<ChipType>
{
public:
	VersatileTileEditor_Lua( ChipType *pucData , int iDataWidth , int iDataHeight , int iUndoBuffer , int iIsClearMap=1 ) ;
	~VersatileTileEditor_Lua() ;
	static int Lua_AND(lua_State* L) ;
	static int Lua_OR(lua_State* L) ;
	static int Lua_EOR(lua_State* L) ;
	static int Lua_print(lua_State* L) ;
	static int Lua_iskeyholded(lua_State* L) ;
	static int Lua_iskeypressed(lua_State* L) ;
	static int Lua_iskeyreleased(lua_State* L) ;
	static int Lua_getmouse(lua_State* L) ;
	static int Lua_getterrain(lua_State* L) ;
	static int Lua_gettile(lua_State* L) ;
	static int Lua_settile(lua_State* L) ;
	static int Lua_getselectedrect(lua_State* L) ;
	static int Lua_setselectedrect(lua_State* L) ;
	static int Lua_updateundo(lua_State* L) ;

	virtual int DoEdit() ;
	virtual void DrawEditor( MyDIBObj3 *pMDO , int iSFC ) ;
	virtual void DrawMap( MyDIBObj3 *pMDO , int iSFC , int RuleW=-1 , int RuleH=-1 , int iOutSrc = 0 ) ;

	int LoadLua(LPCTSTR filename) ;
	void UnloadLua() ;
	void CloseConsole(){ if( iHaveConsole ){ FreeConsole(); } iHaveConsole=0; }
	void SetChipHitPointer( unsigned char *pucChipHit ){ this->pucChipHit = pucChipHit; }
	void LuaRegister( const char *pcFunctionName , int pFunction(lua_State*) )
		{ if(iLuaIsEnabled){lua_register(L,pcFunctionName,pFunction);}  }
	int LuaHook( const char *pcFunctionName )
		{ int iRV=0; LUA_HOOK(pcFunctionName); return iRV; }
protected:
	//恐らくとても良くない方法だが、処理中のインスタンスのポインタをstaticなポインタに格納しておく
	static class VersatileTileEditor_Lua<ChipType> *pProcessing ;
private:
	lua_State *L ;
	int iHaveConsole ;
	int iLuaIsEnabled ;
	void LuaInit() ;
	unsigned char *pucChipHit ;
} ;
template<class ChipType> VersatileTileEditor_Lua<ChipType>::VersatileTileEditor_Lua
( ChipType *pucData , int iDataWidth , int iDataHeight , int iUndoBuffer , int iIsClearMap )
:VersatileTileEditor<ChipType>(pucData , iDataWidth , iDataHeight , iUndoBuffer , iIsClearMap)
{
	iHaveConsole = 0 ;
	iLuaIsEnabled = 0 ;
	L = NULL ;
	LuaInit() ;

}

template<class ChipType> VersatileTileEditor_Lua<ChipType>::~VersatileTileEditor_Lua()
{
	//Luaを閉じる
	lua_close(L) ;
	CloseConsole() ;
}
template<class ChipType> void VersatileTileEditor_Lua<ChipType>::LuaInit()
{
	if( L ){ lua_close(L); }
	//Lua開く
	L = luaL_newstate() ;
	//Lua標準関数
	luaL_openlibs(L) ;
	//ビット演算
	lua_register(L,"AND",Lua_AND) ;
	lua_register(L,"OR",Lua_OR) ;
	lua_register(L,"EOR",Lua_EOR) ;
	//追加関数
	lua_register(L,"print",Lua_print) ;
	lua_register(L,"iskeyholded",Lua_iskeyholded) ;
	lua_register(L,"iskeypressed",Lua_iskeypressed) ;
	lua_register(L,"iskeyreleased",Lua_iskeyreleased) ;
	lua_register(L,"getmouse",Lua_getmouse) ;
	lua_register(L,"getterrain",Lua_getterrain) ;
	lua_register(L,"gettile",Lua_gettile) ;
	lua_register(L,"settile",Lua_settile) ;
	lua_register(L,"getselectedrect",Lua_getselectedrect) ;
	lua_register(L,"setselectedrect",Lua_setselectedrect) ;
	lua_register(L,"updateundo",Lua_updateundo) ;
	
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::LoadLua(LPCTSTR filename)
{
	{
		if( !iHaveConsole )
		{
			AllocConsole() ;
			FILE *fp ;
			freopen_s( &fp , "CONOUT$" , "w" , stdout );
			printf("この窓を消すと本体のアプリケーションも終了するのでご注意下さい。\n") ;
			printf("\n") ;
			printf("LuaはMIT Licenseで公開されています。\n") ;
			printf("http://www.lua.org/license.html\n") ;
			printf("\n") ;
			printf("(注意)\n") ;
			printf("Luaスクリプトからは任意のコードを実行する事が可能です。\n") ;
			printf("つまり素性の知れないスクリプトを実行する事は\n") ;
			printf("素性の知れない実行可能ファイルを実行する事と同じリスクを持ちます。\n") ;
			printf("スクリプトの中をよく確認してから実行して下さい。\n") ;
		}
		printf("\n") ;
		iHaveConsole = 1 ;
	}
	LuaInit() ;
	//Luaファイルをロード
	char acFilename[MAX_PATH*2] ;
#ifdef UNICODE
	if( !WideCharToMultiByte( CP_THREAD_ACP , 0 , filename , _tcslen(filename)+1 , acFilename , _countof(acFilename) , NULL , NULL ) )
	{
		return -1 ;
	}
#else
	strcpy_s( acFilename , _countof(acFilename) , filename ) ; 
#endif
	if( luaL_dofile(L, acFilename) )
	{
		string strErr = lua_tostring(L , -1);
		printf("%s",strErr.c_str()) ;
	}
	else
	{
		iLuaIsEnabled = 1 ;
	}
	return 0 ;
}
template<class ChipType> void VersatileTileEditor_Lua<ChipType>::UnloadLua()
{
	LuaInit() ;
	if(iLuaIsEnabled)
	{
		printf("Luaスクリプトはアンロードされました。\n") ;
		printf("(この窓を閉じることも出来ます。)\n") ;
		CloseConsole() ;
		iLuaIsEnabled = 0 ;
	}
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_AND(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	if( !iArgs ){ return 0; }
	lua_Integer iTmp = ~0 ;
	for( int i=1 ; i<=iArgs ; i++ )
	{
		iTmp &= lua_tointeger(L,i) ;
	}
	lua_pushinteger(L,iTmp) ;
	return 1 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_OR(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	if( !iArgs ){ return 0; }
	lua_Integer iTmp = 0 ;
	for( int i=1 ; i<=iArgs ; i++ )
	{
		iTmp |= lua_tointeger(L,i) ;
	}
	lua_pushinteger(L,iTmp) ;
	return 1 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_EOR(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	if( !iArgs ){ return 0; }
	lua_Integer iTmp = 0 ;
	for( int i=1 ; i<=iArgs ; i++ )
	{
		iTmp ^= lua_tointeger(L,i) ;
	}
	lua_pushinteger(L,iTmp) ;
	return 1 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_print(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	for( int i=1 ; i<=iArgs ; i++ )
	{
		printf( "%s" , lua_tostring(L,i) ) ;
	}
	return 0 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_iskeyholded(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	if( iArgs!=1 ){ return 0; }
	lua_Integer iTmp = lua_tointeger(L,1) ;
	if( KeyOn( (int)iTmp ) )
	{
		lua_pushboolean( L , true ) ;
		return 1 ;
	}
	return 0 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_iskeypressed(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	if( iArgs!=1 ){ return 0; }
	lua_Integer iTmp = lua_tointeger(L,1) ;
	if( KeyPush( (int)iTmp ) )
	{
		lua_pushboolean( L , true ) ;
		return 1 ;
	}
	return 0 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_iskeyreleased(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	if( iArgs!=1 ){ return 0; }
	lua_Integer iTmp = lua_tointeger(L,1) ;
	if( KeyRelease( (int)iTmp ) )
	{
		lua_pushboolean( L , true ) ;
		return 1 ;
	}
	return 0 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_getmouse(lua_State* L)
{
	int iTX , iTY ;
	pProcessing->GetMousePosition(&iTX,&iTY) ;
	lua_pushinteger(L,(lua_Integer)iTX ) ;
	lua_pushinteger(L,(lua_Integer)iTY ) ;
	return 2 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_getterrain(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	if( iArgs!=2 ){ return 0; }
	lua_Integer iX = lua_tointeger(L,1) ;
	lua_Integer iY = lua_tointeger(L,2) ;

	if( !pProcessing->IsPositionInWindow( (int)iX , (int)iY ) )
	{
		return 0 ;
	}
	lua_pushinteger(L,(lua_Integer)pProcessing->pucChipHit[pProcessing->pucData[iY*pProcessing->iDataWidth+iX]] ) ;
	return 1 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_gettile(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	if( iArgs!=2 ){ return 0; }
	lua_Integer iX = lua_tointeger(L,1) ;
	lua_Integer iY = lua_tointeger(L,2) ;

	if( !pProcessing->IsPositionInWindow( (int)iX , (int)iY ) )
	{
		return 0 ;
	}
	lua_pushinteger(L,(lua_Integer)pProcessing->pucData[iY*pProcessing->iDataWidth+iX] ) ;
	return 1 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_settile(lua_State* L)
{
	int iArgs = lua_gettop(L) ;
	if( iArgs!=3 ){ return 0; }
	lua_Integer iX = lua_tointeger(L,1) ;
	lua_Integer iY = lua_tointeger(L,2) ;
	lua_Integer iT = lua_tointeger(L,3) ;

	if( !pProcessing->IsPositionInWindow( (int)iX , (int)iY ) )
	{
		return 0 ;
	}
	if( pProcessing->pucData[iY*pProcessing->iDataWidth+iX] == (int)iT )
	{
		lua_pushinteger(L,(lua_Integer)0 ) ;
		return 1 ;
	}
	pProcessing->pucData[iY*pProcessing->iDataWidth+iX] = (int)iT ;
	lua_pushinteger(L,(lua_Integer)1 ) ;
	return 1 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_getselectedrect(lua_State* L)
{
	lua_pushinteger(L,(lua_Integer)pProcessing->iSelectedX0 ) ;
	lua_pushinteger(L,(lua_Integer)pProcessing->iSelectedY0 ) ;
	lua_pushinteger(L,(lua_Integer)pProcessing->iSelectedX1 ) ;
	lua_pushinteger(L,(lua_Integer)pProcessing->iSelectedY1 ) ;
	return 4 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_setselectedrect(lua_State* L)
{
	int iX0 = (int)lua_tointeger(L,1) ;
	int iY0 = (int)lua_tointeger(L,2) ;
	int iX1 = (int)lua_tointeger(L,3) ;
	int iY1 = (int)lua_tointeger(L,4) ;
	if( pProcessing->IsPositionInWindow( iX0 , iY0 ) && 
		pProcessing->IsPositionInWindow( iX1 , iY1 ) )
	{
		pProcessing->iSelectedX0 = iX0 ;
		pProcessing->iSelectedY0 = iY0 ;
		pProcessing->iSelectedX1 = iX1 ;
		pProcessing->iSelectedY1 = iY1 ;
	}
	return 0 ;
}
template<class ChipType> int VersatileTileEditor_Lua<ChipType>::Lua_updateundo(lua_State* L)
{
	pProcessing->pUndo->Preserve() ;
	return 0 ;
}


template<class ChipType> int VersatileTileEditor_Lua<ChipType>::DoEdit()
{
	int iRV=0 ;
	pProcessing = this ;
	LUA_HOOK("pEdit") ;
	iRV|=VersatileTileEditor<ChipType>::DoEdit() ;
	LUA_HOOK("fEdit") ;
	return iRV ;
}
template<class ChipType> void VersatileTileEditor_Lua<ChipType>::DrawEditor( MyDIBObj3 *pMDO , int iSFC )
{
	int iRV=0 ; //LUA_HOOKで必要
	pProcessing = this ;
	LUA_HOOK("pDrawEditor") ;
	VersatileTileEditor<ChipType>::DrawEditor(pMDO,iSFC) ;
	LUA_HOOK("fDrawEditor") ;
}
template<class ChipType> void VersatileTileEditor_Lua<ChipType>::DrawMap( MyDIBObj3 *pMDO , int iSFC , int RuleW=-1 , int RuleH=-1 , int iOutSrc = 0 )
{
	int iRV=0 ; //LUA_HOOKで必要
	pProcessing = this ;
	LUA_HOOK("pDrawMap") ;
	VersatileTileEditor<ChipType>::DrawMap(pMDO,iSFC ,RuleW,RuleH,iOutSrc) ;
	LUA_HOOK("fDrawMap") ;
}



#endif /*VERSATILE_TILE_EDITOR_LUA_HEADER_INCLUDED*/
