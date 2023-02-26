#ifndef GLOBAL_CLASS_HEADER_INCLUDED
#define GLOBAL_CLASS_HEADER_INCLUDED
#include "RockStage.h"

#define GLMsg(n)			(GL::Msg[n].c_str())

class GL
{
public:
//グローバル定数
	static const _TCHAR *COMMON_CONST_WINDOW_CLASS_NAME ;
	static const _TCHAR *COMMON_CONST_DEFAULT_WINDOW_TEXT ;

	static const int MAXSFC = 10 ;
	static const int MAXTASK = 200 ;

	static const int SFC_BACK = 0 ;
	static const int SFC_CHR = 1 ;
	static const int SFC_CHIP = 2 ;
	static const int SFC_CHIPINFO = 3 ;
	static const int SFC_CHR_BW = 4 ;
	static const int SFC_TMP_RS = 5 ;

	static const int ciDefaultWinWidth  = 256*3 ;
	static const int ciDefaultWinHeight = 512 ;
	static const int ciMinWinWidth  = 320 ; // +
	static const int ciMinWinHeight = 240 ; // |ウインドウサイズ変更不可能なら
	static const int ciMaxWinWidth  = 1024 ; // |値は利用されません
	static const int ciMaxWinHeight = 800 ; // +

	static const int ciMaxMsg = 1000 ;
	static const _TCHAR *pctcFilenameMsg ;
//グローバル変数
	static HWND hWnd;
	static HINSTANCE hInstance;
	static MyDIBObj3 mdo;
	static TASKHANDLE HAM ;
	static int WINWIDTH ;
	static int WINHEIGHT ;

	static tstring Msg[ciMaxMsg] ;
	static unsigned char *pucRom ;
	static int iRomSize ;
	static BMPD NESColor[0x40] ;

	static RockStage RS ;
	static tstring strDropReserve ;
	static int iDirectEditMode ;
	static int iDirectEditStage ;
	static int iStageUpdated ;
	static tstring strDirectEditROMFileName ;
//グローバル関数
	static int AppPrepare(HWND hwnd , HINSTANCE hinstance);
	static int AppRelease();
	static void MainRoutine(int fps);

	static void RequestRedraw();
	static void RequestFlip();


	static void DropRoutine( WPARAM wp ) ;
	static int DropRoutineSub( LPCTSTR filename , int iCmdLine=0 ) ;
	static int LoadNameTable10( tstring *pstrDest , int iSize , LPCTSTR filename ) ;
	static int LoadNameTable( tstring *pstrDest , int iSize , LPCTSTR filename ) ;
	static void SetupNESColor( LPCTSTR filename ) ;

	static void Alert( const _TCHAR *ptcMsg , int iTimer=150 ) ;
	static void AlertS( const _TCHAR *ptcMsg , int iTimer=150 ) ;
	static int Compile( LPCTSTR dirname ) ;
	static void SetDirectEditFileName() ;

#define SAFE_ROM_IO_STATIC
#include "SafeRomIO.h"
#define SAFE_ROM_IO_STATIC
#define SAFE_ROM_IO_DEST   pucRom+0x10
#define SAFE_ROM_IO_SIZE   pucRom[4]*0x4000
#define SAFE_ROM_IO_SUF(a) a##p
#include "SafeRomIO.h"
#define SAFE_ROM_IO_STATIC
#define SAFE_ROM_IO_DEST   pucRom+0x10+pucRom[4]*0x4000
#define SAFE_ROM_IO_SIZE   pucRom[5]*0x2000
#define SAFE_ROM_IO_SUF(a) a##c
#include "SafeRomIO.h"

	static int LoadROM( int iEditMode ) ;
	static int LoadROMex( int iEditMode , unsigned char **ppucRom , int *piRomSize ) ;
	static int LoadROMDirect( LPCTSTR filename ) ;
private:
//ローカル変数
	static TASKHANDLE handle_frame_end ;
//ローカル関数
	static bool CheckFE() ;
};

#endif /*GLOBAL_CLASS_HEADER_INCLUDED*/

