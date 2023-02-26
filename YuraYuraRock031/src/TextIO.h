#ifndef TEXT_INPUT_OUTPUT_HEADER_INCLUDED
#define TEXT_INPUT_OUTPUT_HEADER_INCLUDED

#include <windows.h>
#include <tchar.h>
#include <stdio.h>


typedef struct TextIOItem_tag
{
	int mode ;
	LPTSTR token ;
	void *Pdata ;
	int size ;
} TextIOItem ;

class TextIOManager
{
private:
	//コマンドにつける行頭の印
	_TCHAR command_token ;
	//コメントにつける行頭の印
	_TCHAR comment_token ;
	//入出力するファイル名
	LPCTSTR filename ;
	//ＩＯアイテムのバッファ（インスタンス作成時に確保後、固定）
	TextIOItem *PItem ;
	//ＩＯアイテムを詰めている位置
	int itempos ;
	//ＩＯアイテムの最大数
	int maxitem ;
public:
	TextIOManager::TextIOManager( LPCTSTR filename , int NOIOItem , _TCHAR command_token , _TCHAR comment_token );
	TextIOManager::~TextIOManager() ;
/*
	以下の関数でデータに適当な名前（トークン）をつけて指定するが
	それぞれ固有の名前である必要があり、
	また、「BIN」は使ってはいけない、スペースやタブを含んではいけない。
*/
	//適当なコメントをつける（セーブ時に有効）
	bool AddIOItem_Comment( LPCTSTR token ) ;
	//１６ビットの値。int型で受ける。
	bool AddIOItem_16Value( LPCTSTR token , int *Pval ) ;
	//メモリブロック。適当な型で受ける。
	bool AddIOItem_Block( LPCTSTR token , void *Pblock , int size ) ;
	//１６ビットの値の連続。int型で受ける。
	bool AddIOItem_16Array( LPCTSTR token , int *Pval , int size ) ;
	//セーブを実行
	int DoSaving() ;
	//ロードを実行
	int DoLoading() ;
};


#endif /*TEXT_INPUT_OUTPUT_HEADER_INCLUDED*/

