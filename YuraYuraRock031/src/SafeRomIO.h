/*
pucRom,iRomSizeという名前の変数を利用し
安全に読み書きするためのincludeファイル
class内部のメンバ関数の位置にincludeされることが想定されている。

オプションとして、一定の定数をdefineしておくことで、動作を変更可能である。
・SAFE_ROM_IO_STATIC
　static関数にする。インスタンスを持たないclass向け。

・SAFE_ROM_IO_DEST
・SAFE_ROM_IO_SIZE
　変数の名前を指定可能である

・SAFE_ROM_IO_SUF(a)	(文字)##a##(文字)
　関数aの前後に、文字をつけたものを出力する。

どのdefineも、このヘッダファイルを抜ける際はundefされる。



#define SAFE_ROM_IO_STATIC
#define SAFE_ROM_IO_DEST   pucRom+0x10
#define SAFE_ROM_IO_SIZE   pucRom[4]*0x4000
#define SAFE_ROM_IO_SUF(a)  a##_prg

#include "SafeRomIO.h"

*/

#ifdef SAFE_ROM_IO_STATIC
#define SAFE_ROM_IO_STATIC_CONF static
#undef SAFE_ROM_IO_STATIC
#else
#define SAFE_ROM_IO_STATIC_CONF
#endif

#ifndef SAFE_ROM_IO_DEST
#define SAFE_ROM_IO_DEST pucRom
#endif
#ifndef SAFE_ROM_IO_SIZE
#define SAFE_ROM_IO_SIZE iRomSize
#endif
#ifndef SAFE_ROM_IO_SUF
#define SAFE_ROM_IO_SUF(a)	a
#endif

	SAFE_ROM_IO_STATIC_CONF unsigned char *SAFE_ROM_IO_SUF(ROM)( int iAddr )
	{
		unsigned int uiAddr ;
		uiAddr = ((iAddr>>16)&0xFF) * 0x2000 ;
		uiAddr += (iAddr&0x1FFF) ;
		uiAddr %= (SAFE_ROM_IO_SIZE) ;
		return (SAFE_ROM_IO_DEST)+uiAddr ;
	}
	SAFE_ROM_IO_STATIC_CONF void SAFE_ROM_IO_SUF(SetROM8 )( int iAddr , int iVal ){ SAFE_ROM_IO_SUF(ROM)(iAddr)[0]=iVal; }
	SAFE_ROM_IO_STATIC_CONF void SAFE_ROM_IO_SUF(SetROM16)( int iAddr , int iVal ){ SAFE_ROM_IO_SUF(SetROM8 )(iAddr+0,iVal);SAFE_ROM_IO_SUF(SetROM8 )(iAddr+1,iVal>>8); }
	SAFE_ROM_IO_STATIC_CONF void SAFE_ROM_IO_SUF(SetROM24)( int iAddr , int iVal ){ SAFE_ROM_IO_SUF(SetROM16)(iAddr+0,iVal);SAFE_ROM_IO_SUF(SetROM8 )(iAddr+2,iVal>>16); }
	SAFE_ROM_IO_STATIC_CONF void SAFE_ROM_IO_SUF(SetROM32)( int iAddr , unsigned int iVal ){ SAFE_ROM_IO_SUF(SetROM16)(iAddr+0,iVal);SAFE_ROM_IO_SUF(SetROM16)(iAddr+2,iVal>>16); }

	SAFE_ROM_IO_STATIC_CONF int SAFE_ROM_IO_SUF(GetROM8 )( int iAddr ){ return SAFE_ROM_IO_SUF(ROM)(iAddr)[0]; }
	SAFE_ROM_IO_STATIC_CONF int SAFE_ROM_IO_SUF(GetROM16)( int iAddr ){ return SAFE_ROM_IO_SUF(ROM)(iAddr)[0]|(SAFE_ROM_IO_SUF(ROM)(iAddr+1)[0]<<8); }
	SAFE_ROM_IO_STATIC_CONF int SAFE_ROM_IO_SUF(GetROM24)( int iAddr ){ return SAFE_ROM_IO_SUF(ROM)(iAddr)[0]|(SAFE_ROM_IO_SUF(ROM)(iAddr+1)[0]<<8)|(SAFE_ROM_IO_SUF(ROM)(iAddr+2)[0]<<16); }
	SAFE_ROM_IO_STATIC_CONF unsigned int SAFE_ROM_IO_SUF(GetROM32)( int iAddr ){ return SAFE_ROM_IO_SUF(ROM)(iAddr)[0]|(SAFE_ROM_IO_SUF(ROM)(iAddr+1)[0]<<8)|(SAFE_ROM_IO_SUF(ROM)(iAddr+2)[0]<<16)|((unsigned int)(SAFE_ROM_IO_SUF(ROM)(iAddr+3)[0])<<24); }
	SAFE_ROM_IO_STATIC_CONF int SAFE_ROM_IO_SUF(ROMRem)( int iAddr ){ return SAFE_ROM_IO_SUF(ROM)(-1)-SAFE_ROM_IO_SUF(ROM)(iAddr)+1 ; }
	/*Remainder*/


#undef SAFE_ROM_IO_SUF
#undef SAFE_ROM_IO_SUF
#undef SAFE_ROM_IO_DEST
#undef SAFE_ROM_IO_SIZE
#undef SAFE_ROM_IO_STATIC_CONF
