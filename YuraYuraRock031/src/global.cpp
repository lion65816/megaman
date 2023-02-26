#include "common.h"
#include "FileManager.h"
#include "mymemorymanage.h"
#include "FileManager.h"
#include "ips.h"
#include <io.h>
#include <time.h>


const _TCHAR *GL::COMMON_CONST_WINDOW_CLASS_NAME   = _T("YuraYuraRock_WCN") ;
const _TCHAR *GL::COMMON_CONST_DEFAULT_WINDOW_TEXT = _T("ゆらゆらロック") ; //使いません


HWND GL::hWnd;
HINSTANCE GL::hInstance;
MyDIBObj3 GL::mdo( MAXSFC , WINWIDTH , WINHEIGHT );
TASKHANDLE GL::HAM ;
TASKHANDLE GL::handle_frame_end = 0 ;
int GL::WINWIDTH  = GL::ciDefaultWinWidth ;
int GL::WINHEIGHT = GL::ciDefaultWinHeight ;
tstring GL::Msg[ciMaxMsg] ;
const _TCHAR *GL::pctcFilenameMsg = _T("data\\msg.txt") ;
unsigned char *GL::pucRom ;
int GL::iRomSize ;
BMPD GL::NESColor[0x40] ;
RockStage GL::RS ;
tstring GL::strDropReserve=_T("") ;
int GL::iDirectEditMode=0 ;
int GL::iDirectEditStage=0 ;
int GL::iStageUpdated=0 ;
tstring GL::strDirectEditROMFileName=_T("") ;



int GL::AppPrepare(HWND hwnd , HINSTANCE hinstance)
{
	Task0810 *Ptmp ;
	Ptmp = new TaskAppManager( NULL , TP_APP_MANAGER , true ) ;
	HAM = Ptmp->GetHandle() ;
	if( GL::strDropReserve != _T("") )
	{
		GL::DropRoutineSub( GL::strDropReserve.c_str() ) ;
		GL::strDropReserve = _T("") ;
	}
	return 0;
}
int GL::AppRelease()
{

	return 0;
}





void GL::MainRoutine(int fps)
{
	Task0810 *Ptask ;
	Ptask = Task0810::SolveHandle( HAM ) ;
	if( Ptask )Ptask->DoCN() ;
	else DestroyWindow( hWnd ) ;
}



bool GL::CheckFE()
{
	if( !handle_frame_end )
	{	
		Task0810 *Pptr ;
		Pptr = Task0810::SolveHandle( HAM ) ;
		if( !Pptr )return false ;
		handle_frame_end = Pptr->SearchTask( TP_FRAMEEND ) ;
		if( !handle_frame_end )return false ;
	}
	return true ;
}
void GL::RequestRedraw()
{
	if( !CheckFE() )return ;
	Task0810 *Pptr ;
	Pptr = Task0810::SolveHandle( handle_frame_end ) ;
	if( !Pptr )return ;
	((TaskFrameEnd*)Pptr)->RequestRedraw() ;
}
void GL::RequestFlip()
{
	if( !CheckFE() )return ;
	Task0810 *Pptr ;
	Pptr = Task0810::SolveHandle( handle_frame_end ) ;
	if( !Pptr )return ;
	((TaskFrameEnd*)Pptr)->RequestFlip() ;
}




int GL::LoadNameTable10( tstring *pstrDest , int iSize , LPCTSTR filename )
{
FILE *fp ;
	if( _tfopen_s( &fp , filename  , _T("rt") ) )
	{
		return -1 ;
	}
	for(;;)
	{
		_TCHAR buf[512] ;
		if( !_fgetts( buf , 512 , fp ) )break ;
		if( buf[_tcslen(buf)-1]==_T('\n') )
			buf[_tcslen(buf)-1]=_T('\0') ;
		if( buf[0] != _T('#') )continue ;

		int number ;
		_TCHAR name[512] ;
		if( _stscanf_s( buf , _T("#%4d %512s") , &number , name , _countof(name) ) == 2 && number>=0 && number<iSize )
		{
			_TCHAR *pTmp ;
			while( pTmp=_tcschr( name , _T('\\') )){ *pTmp='\n'; }
			pstrDest[number] = name ;
		}
	}
	fclose( fp ) ;
	return 0 ;
}
int GL::LoadNameTable( tstring *pstrDest , int iSize , LPCTSTR filename )
{
FILE *fp ;
	if( _tfopen_s( &fp , filename  , _T("rt") ) )
	{
		return -1 ;
	}
	for(int i=0 ; i<iSize ; i++ )
	{
		pstrDest[i] = _T("") ;
	}
	for(;;)
	{
		_TCHAR buf[512] ;
		if( !_fgetts( buf , 512 , fp ) )break ;
		if( buf[_tcslen(buf)-1]==_T('\n') )
			buf[_tcslen(buf)-1]=_T('\0') ;
		if( buf[0] != _T('#') )continue ;

		int number ;
		_TCHAR name[512] ;
		if( _stscanf_s( buf , _T("#%2X %64s") , &number , name , _countof(name) ) == 2 && number>=0 && number<iSize )
		{
			pstrDest[number] = name ;
		}
	}
	fclose( fp ) ;
	return 0 ;
}
void GL::Alert( const _TCHAR *ptcMsg , int iTimer )
{
	Task0810 *pTask ;
	Task1206Rect tRect = {0,0,10,20,0} ;
	pTask = Task0810::SolveHandle( Task0810::SearchTask( HAM , TP_AlertManager ) ) ;
	if( pTask )
		new TaskObjectBoxText( pTask , true , tRect , ptcMsg , RGB(255,255,255) , RGB(192,64,0) , iTimer ) ;
}
void GL::AlertS( const _TCHAR *ptcMsg , int iTimer )
{
	Task0810 *pTask ;
	Task1206Rect tRect = {0,0,10,20,0} ;
	pTask = Task0810::SolveHandle( Task0810::SearchTask( HAM , TP_AlertManager ) ) ;
	if( pTask )
		new TaskObjectBoxText( pTask , true , tRect , ptcMsg , RGB(255,255,255) , RGB(16,196,96) , iTimer ) ;
}
int GL::LoadROM( int iEditMode )
{
	return LoadROMex( iEditMode , &pucRom , &iRomSize ) ;
}
int GL::LoadROMex( int iEditMode , unsigned char **ppucRom , int *piRomSize )
{
	int iFNMsgNO = iEditMode-1+164 ;
	if( (*ppucRom) ){ free( (*ppucRom) ) ; (*ppucRom) = NULL ; }
	(*piRomSize) = LoadMemoryFromFile( GLMsg(iFNMsgNO) ,  &(*ppucRom) ) ;
	if( (*piRomSize) <= 0x10 )
	{
		_TCHAR atcTmp[256] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(175) , GLMsg(iFNMsgNO) ) ;
		Alert( atcTmp ) ;
		return -1 ;
	}
	{
		static char acHeader[7] = "NES\032  " ;
		static const int aciPrgSize[6] = {0x08,0x10,0x10,0x20,0x10,0x20} ;
		static const int aciChrSize[6] = {0x00,0x00,0x10,0x00,0x20,0x00} ;
		acHeader[4] = aciPrgSize[iEditMode-1] ;
		acHeader[5] = aciChrSize[iEditMode-1] ;
		if( memcmp( acHeader , (*ppucRom) , 6 ) )
		{
			_TCHAR atcTmp[256] ;
			_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(176) , GLMsg(iFNMsgNO) ) ;
			Alert( atcTmp ) ;
			return -2 ;
		}
	}
	if( (*ppucRom)[4]*0x4000+(*ppucRom)[5]*0x2000+0x10 > (*piRomSize) )
	{
		_TCHAR atcTmp[256] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(177) , GLMsg(iFNMsgNO) ) ;
		Alert( atcTmp ) ;
		return -3 ;
	}
	{
		static const int aciEHash[6] = { 0x475141 , 0xE9F881 , 0x9c770b , 0x3245FB , 0x409C33 , 0x095bc1 } ;
		if( EHash( (*ppucRom)+0x10 , (*ppucRom)[4]*0x4000+(*ppucRom)[5]*0x2000 ) != aciEHash[iEditMode-1]  )
		{
			_TCHAR atcTmp[256] ;
			_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(178) , GLMsg(iFNMsgNO) ) ;
			Alert( atcTmp ) ;
			free( (*ppucRom) ) ;
			(*ppucRom) = NULL ;
			return -4 ;
		}
	}
	return 0 ;
}
int GL::LoadROMDirect( LPCTSTR filename )
{
	if( pucRom ){ free( pucRom ) ; pucRom = NULL ; }
	GL::RS.SetRom( NULL , 0 ) ;

	for( int i=0 ; i<6 ; i++ )
	{
		tstring strTmp = _T("\\") ;
		strTmp += GL::Msg[164+i] ;
		if( _tcsstr( filename , strTmp.c_str() ) )
		{
			return -2 ;
		}
	}
	strDirectEditROMFileName = filename ;
	iRomSize = LoadMemoryFromFile( filename ,  &pucRom ) ;
	if( iRomSize<=0 )
	{
		return -1 ;
	}
	{
		static char acHeader[7] = "NES\032" ;
		static const int aciPrgSize[6] = {0x08,0x10,0x10,0x20,0x10,0x20} ;
		static const int aciChrSize[6] = {0x00,0x00,0x10,0x00,0x20,0x00} ;
		if( memcmp( acHeader , pucRom , 4 ) )
		{
			return -3 ;
		}
		int i ;
		for( i=0 ; i<6 ; i++ )
		{
			if( pucRom[4]==aciPrgSize[i] &&
				pucRom[5]==aciChrSize[i] )
			{
				break ;
			}
		}
		if( i==6 )
		{
			return -4 ;
		}
		if( i==3 )
		{//4と6は更に仕分けが必要
			int iScore = 0 ;
			if( pucRom[0x1E*0x2000+0x10] == 0x4C ){ iScore--; }
			if( pucRom[0x34*0x2000+0x10] == 0x4C ){ iScore++; }
			if( pucRom[0x3E*0x2000+0x10+0x0126] == 0x40 ){ iScore--; }
			if( pucRom[0x3E*0x2000+0x10+0x00BF] == 0x40 ){ iScore++; }
			if( pucRom[0x3E*0x2000+0x10+0x0317] == 0x40 ){ iScore--; }
			if( pucRom[0x3E*0x2000+0x10+0x0162] == 0x40 ){ iScore++; }
			if( iScore<=0 ){ i=3; }
			else { i=5; }
		}
		iDirectEditMode = i+1 ;
	}
	if( pucRom[4]*0x4000+pucRom[5]*0x2000+0x10 > iRomSize )
	{
		return -3 ;
	}
	return 0 ;
}


void GL::SetupNESColor( LPCTSTR filename )
{
	{//計算でかなりテキトーなパレットを作成する
		int i;
		for( i=0 ; i<3 ; i++ ) NESColor[i*16] = myRGB(i*6+17,i*6+17,i*6+17);
		for( i=0 ; i<2 ; i++ ) NESColor[i*16+0x2D] = myRGB(i*8+12 ,i*8+12 ,i*8+12 );
		NESColor[0x30] = NESColor[0x20] ;

		//Wikipedia HSV色空間
		//ja.wikipedia.org/wiki/HSV%E8%89%B2%E7%A9%BA%E9%96%93
		//NTSC信号に対応するようなもっと良い方法があるのだろうか？

		//SとVのテーブル、テキトーです
		static double STable[4] = {1.0,1.0,0.8,0.5} ;
		static double VTable[4] = {0.5,0.7,0.9,1.0} ;
		for( int iC=0 ; iC<12 ; iC++ )
		{
		for( int iB=0 ; iB<4 ; iB++ )
		{
			double r,g,b ;
			double H,S,V ;
			int Hi ;
			double f , p , q , t ;
			H = ( 360+210+iC*30 ) % 360 ;
			S = STable[iB] ;
			V = VTable[iB] ;
			Hi = (int)(H/60)%6 ;
			f = H/60 - Hi ;
			p = V * ( 1 - S ) ;
			q = V * ( 1 - f * S ) ;
			t = V * ( 1 - ( 1 - f ) * S ) ;
			switch( Hi )
			{
			case 0:
				r=V; g=t ; b=p ;
			break ;
			case 1:
				r=q; g=V ; b=p ;
			break ;
			case 2:
				r=p; g=V ; b=t ;
			break ;
			case 3:
				r=p; g=q ; b=V ;
			break ;
			case 4:
				r=t; g=p ; b=V ;
			break ;
			case 5:
				r=V; g=p ; b=q ;
			break ;
			}
			NESColor[1+iC+iB*16] = 
				myRGB(
				(min( (int)(r*31+0.5) , 31 ))
				,
				(min( (int)(g*31+0.5) , 31 ))
				,
				(min( (int)(b*31+0.5) , 31 ))
				);
		}
		}
	}
	{//パレットファイルを読み出す
		FILE *fp ;
		if( !_tfopen_s( &fp , filename , _T("rb") ) )
		{
			BYTE buf[3*64] ;
			if( fread( buf , 1 , 3*64 , fp ) == 3*64 )
			{
	int r,g,b;
	int i;
				for( i=0 ; i<64 ; i++ )
				{
					r = buf[i*3+0] ;
					g = buf[i*3+1] ;
					b = buf[i*3+2] ;
					r >>= 3;
					g >>= 3;
					b >>= 3;
					NESColor[i] = (r<<10) | (g<<5) | b ;
				}
			}
			fclose( fp ) ;
		}
	}
}






void GL::DropRoutine( WPARAM wp )
{
	_TCHAR fn[512];

	{
		HDROP hd;
		int  NOfile;
		//ハンドルを得る
		hd = (HDROP) wp;
		//ドロップされたファイル数を取得
		NOfile = DragQueryFile( hd , 0xFFFFFFFF , NULL , 0 );
		if( NOfile >= 2 )
		{
			Alert( GLMsg(180) ) ; 
			return ;
		}
		DragQueryFile( hd , 0 , fn , sizeof(fn) );
		DragFinish( hd );
	}
	DropRoutineSub( fn ) ;
}

int GL::DropRoutineSub( LPCTSTR filename , int iCmdLine ) 
{
	TASKHANDLE hMM ;
	hMM = Task0810::SearchTask(HAM,TP_MODE_MANAGER) ;
	if( !iCmdLine && !hMM )
	{//まず起きない
		assert(0) ;
		return -1 ;
	}

	
#define EXT_CHECK(ext)			(!_tcscmp( (ext) , &filename[_tcslen(filename)-_tcslen(ext)] ))
	if( MyPathIsDirectory( filename ) )
	{//コンパイルを実行
		if( Compile( filename ) )
		{
			_TCHAR atcTmp[256] ;
			_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(189) , filename , GLMsg(190) ) ;
			Alert( atcTmp ) ; 
			return -1 ;
		}
		_TCHAR atcTmp[256] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(188) , filename ) ;
		AlertS( atcTmp ) ; 
		return 0 ;
	}
	else if( EXT_CHECK( GLMsg(182) ) )
	{//.rstg
		iDirectEditMode = 0 ;
		Task0810::KillP( hMM , TP_HIGHEST , TP_LOWEST ) ;
		GL::RequestRedraw() ;
		if( GL::RS.Load( filename ) )
		{
			Alert( GLMsg(183) ) ; 
			return -1 ;
		}
		AlertS( GLMsg(185) ) ; 
		if( GL::LoadROM( GL::RS.GetEditMode() ) )
		{
			Alert( GLMsg(186) ) ; 
			return -1 ;
		}
		AlertS( GLMsg(187) ) ; 
		GL::RS.SetRom( GL::pucRom , GL::iRomSize ) ;
		new MainMode( Task0810::SolveHandle(hMM) ) ;
		return 0 ;
	}
	else if( EXT_CHECK( GLMsg(184) ) )
	{//rstgclip
		//編集モードによって挙動を分ける
		TASKHANDLE hMainMode,hTmp ;
		hMainMode=Task0810::SearchTask(hMM,TP_MainMode);
		if( hTmp=Task0810::SearchTask(hMainMode,TP_ChipEditor) )
		{
			ChipEditor *pTask = (ChipEditor*)Task0810::SolveHandle(hTmp) ;
			pTask->SetClipFile( filename ) ;
		}
		else if( Task0810::SearchTask(hMainMode,TP_MapEditor) )
		{
			GL::RS.LoadClipFile( filename ) ;
		}
		return 0 ;
	}
	else if( EXT_CHECK( GLMsg(410) ) )
	{ //.nes
		int iRV ;
		GL::RequestRedraw() ;
		iDirectEditMode = 0 ;
		if( iRV=GL::LoadROMDirect( filename ) )
		{
			iDirectEditMode = 0 ;
			Alert( GLMsg(411) ) ;
			switch( iRV )
			{
			case -1:Alert( GLMsg(416) ) ; break;
			case -2:Alert( GLMsg(412) ) ; break;
			case -3:Alert( GLMsg(413) ) ; break;
			case -4:Alert( GLMsg(414) ) ; break;
			}
			return -1 ;
		}
		iDirectEditStage = 0 ;
		AlertS( GLMsg(415) ) ; 
		GL::RS.Clear() ;
		GL::RS.SetEditMode( iDirectEditMode ) ;
		GL::RS.SetRom( GL::pucRom , GL::iRomSize ) ;
		GL::RS.ImportFromRom( 0 ) ;
		GL::SetDirectEditFileName() ;
		Task0810::KillP( hMM , TP_HIGHEST , TP_LOWEST ) ;
		new MainMode( Task0810::SolveHandle(hMM) ) ;
		return 0 ;
	}
	else if( EXT_CHECK( GLMsg(720) ) )
	{ //.lua
		GL::RequestRedraw() ;
		//マップ編集モードしか受け付けない
		TASKHANDLE hMainMode,hTmp ;
		hMainMode=Task0810::SearchTask(hMM,TP_MainMode);
		if( hTmp=Task0810::SearchTask(hMainMode,TP_MapEditor) )
		{
			GL::RS.LoadLua( filename ) ;
		}
		else
		{
			Alert( GLMsg(721) );
		}
		return 0 ;
	}



	{//処理できない拡張子
		_TCHAR atcTmp[256] ;
		LPCTSTR ptcExt=_T("") ;
		for( LPCTSTR ptcTmp=filename ; 
			ptcTmp ; 
			ptcExt=ptcTmp,ptcTmp=_tcschr( ptcTmp+1 , _T('.') ) );
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(181) , ptcExt ) ;
		Alert( atcTmp ) ;
	}
	return -1 ;
#undef EXT_CHECK
}
int GL::Compile( LPCTSTR dirname )
{
	unsigned char *apucRom[6] = { NULL , NULL , NULL , NULL , NULL , NULL } ;
	unsigned char *apucRomOrg[6] = { NULL , NULL , NULL , NULL , NULL , NULL } ;
	unsigned char *apucRomMask[6] = { NULL , NULL , NULL , NULL , NULL , NULL } ;
	int aiRomSize[6] = { 0 } ;
	tstring strPath = dirname ;
	tstring strLogFile ;
	tstring strSearchWord ;
	RockStage RSWork ;
	FILE *fp = NULL ;
	int iRV = 0 ;

	if( dirname[_tcslen(dirname)-1]!='\\' )strPath += _T("\\") ;
	strLogFile = strPath ;
	strLogFile += GLMsg(190) ;
	strSearchWord = strPath ;
	strSearchWord += _T("*.rstg") ;

	try
	{
		if( _tfopen_s( &fp , strLogFile.c_str() , _T("wt") ) )
		{
			_TCHAR atcTmp[512] ;
			_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(210) , strLogFile.c_str() ) ;
			Alert( atcTmp ) ;
			throw -1 ;
		}
		{
			time_t tTime ;
			_TCHAR atcTmp[512] ;
			time( &tTime ) ;
			_ftprintf_s( fp , GLMsg(211) ) ;
			_tstrdate_s( atcTmp , _countof(atcTmp) ) ;
			_ftprintf_s( fp , _T("%s ") , atcTmp ) ;
			_tstrtime_s( atcTmp , _countof(atcTmp) ) ;
			_ftprintf_s( fp , _T("%s\n") , atcTmp ) ;
		}
		_ftprintf_s( fp , _T("\n") ) ;
		_ftprintf_s( fp , GLMsg(212) , strPath.c_str() ) ; //対象ディレクトリ
		_ftprintf_s( fp , _T("\n") ) ;

		intptr_t hFind ;
		_tfinddata_t tFind ;

		hFind = _tfindfirst( strSearchWord.c_str() , &tFind ) ;
		if( hFind != -1 )
		{
			for(;;)
			{
				_ftprintf_s( fp , GLMsg(213) , tFind.name ) ; //対象
				_ftprintf_s( fp , GLMsg(221) ) ; //開始
				{
					tstring strRSTGName = strPath ;
					strRSTGName += tFind.name ;
					if( RSWork.Load( strRSTGName.c_str() ) )
					{
						_ftprintf_s( fp , GLMsg(216) ) ;
						throw -1 ;
					}
				}
				_ftprintf_s( fp , GLMsg(215) ) ;
				int iEM = RSWork.GetEditMode()-1 ;
				if( !apucRom[iEM] )
				{
					if( GL::LoadROMex( RSWork.GetEditMode() , apucRom+iEM , aiRomSize+iEM ) )
					{
						_ftprintf_s( fp , GLMsg(218) , GLMsg(164+iEM) ) ;
						throw -1 ;
					}
					apucRomOrg[iEM] = (unsigned char *)malloc( aiRomSize[iEM] ) ;
					if( !apucRomOrg[iEM] ){ throw -1 ; }
					memcpy( apucRomOrg[iEM] , apucRom[iEM] , aiRomSize[iEM] ) ;
					apucRomMask[iEM] = (unsigned char*)malloc( aiRomSize[iEM] ) ;
					if( !apucRomMask[iEM] )
					{
						_ftprintf_s( fp , GLMsg(224) , GLMsg(164+iEM) ) ;
						throw -1 ;
					}
					memset( apucRomMask[iEM] , 0 , aiRomSize[iEM] ) ;
					_ftprintf_s( fp , GLMsg(217) , GLMsg(164+iEM) ) ;
				}
				RSWork.SetRom( apucRom[iEM] , aiRomSize[iEM] ) ;
				{
					int iP,iT,iPm,iTm ;
					if( int iRV = RSWork.ExportToRom(&iP,&iT,&iPm,&iTm,apucRomMask[iEM]) )
					{
						_ftprintf_s( fp , GLMsg(220) ) ;
						switch( iRV )
						{
						case -2:
							_ftprintf_s( fp , GLMsg(223) , iP , iPm , iT , iTm ) ;
						break ;
						case -3:
							_ftprintf_s( fp , GLMsg(390) , iP , iT ) ; //変数名と用途が一致していない
						break ;
						default:
							assert(0) ;
						}
						throw -1 ;
					}
					_ftprintf_s( fp , GLMsg(219) , iP , iPm , iT , iTm ) ;
				}

				_ftprintf_s( fp , GLMsg(222) ) ; //終了
				if( _tfindnext( hFind , &tFind ) == -1 )break ;
			}
			_findclose( hFind ) ;
		}
	}
	catch( int iErr )
	{
		_ftprintf_s( fp , GLMsg(214) ) ;
		iRV = iErr ;
	}

	_ftprintf_s( fp , _T("\n") ) ;
	_ftprintf_s( fp , _T("\n") ) ;
	_ftprintf_s( fp , GLMsg(225) ) ; //終了
	{
		for( int i=0 ; i<6 ; i++ )
		{
			if( apucRom[i] )
			{
				if( !iRV )
				{
					if( apucRomMask[i] )
					{//Exportパッチ作成
						_TCHAR aucFileName[512] ;
						FILE *fpEX ;
						_stprintf_s( aucFileName , _countof(aucFileName) , _T("%s%s") , strPath.c_str() , GLMsg(345+i) ) ;
						if( _tfopen_s( &fpEX , aucFileName , _T("wb") ) )
						{
							_ftprintf_s( fpEX , GLMsg(351) , aucFileName ) ;
						}
						else
						{
							static const unsigned char pucHeader[5] = { 'P' , 'A' , 'T' , 'C' , 'H' } ;
							static const unsigned char pucEOF[3] = { 'E' , 'O' , 'F' } ;
							fwrite( pucHeader , 1 , 5 , fpEX ) ;
							int iPrevPosition=-1 ;
							int iRP ;
							for( iRP=0 ; iRP<aiRomSize[i]+1 ; iRP++ )
							{
								if( iPrevPosition>=0 )
								{
									if( iRP==aiRomSize[i] || !apucRomMask[i][iRP] )
									{
										unsigned char aucTmp[16] ;
										int iSize = iRP-iPrevPosition ;
										aucTmp[0] = (iPrevPosition>>16)&0xFF ;
										aucTmp[1] = (iPrevPosition>> 8)&0xFF ;
										aucTmp[2] = (iPrevPosition    )&0xFF ;
										aucTmp[3] = (iSize        >> 8)&0xFF ;
										aucTmp[4] = (iSize            )&0xFF ;
										fwrite( aucTmp , 1 , 5 , fpEX ) ;
										fwrite( apucRom[i]+iPrevPosition , 1 , iSize , fpEX ) ;
										iPrevPosition = -1 ;
									}
								}
								else if( iRP!=aiRomSize[i] )
								{
									if( apucRomMask[i][iRP] )
									{
										iPrevPosition = iRP ;
									}
								}
							}
							fwrite( pucEOF , 1 , 3 , fpEX ) ;
							fclose( fpEX ) ;
							_ftprintf_s( fp , GLMsg(352) , aucFileName ) ;
						}
					}
					{//パッチ当て
						_TCHAR aucDirName[512] ;
						_stprintf_s( aucDirName , _countof(aucDirName) , _T("%s%s\\%s") , strPath.c_str() , GLMsg(333+i) , GLMsg(339) ) ;
						HANDLE hSearch ;
						WIN32_FIND_DATA tRet ;
						hSearch = FindFirstFile( aucDirName , &tRet ) ;
						if( hSearch != INVALID_HANDLE_VALUE )
						{
							for( int bFlag=1 ; bFlag ; bFlag=FindNextFile( hSearch , &tRet ) )
							{
								int q=q ;
								_TCHAR atcFileName[2048] ;
								_stprintf_s( atcFileName , _countof(atcFileName) , _T("%s%s\\%s") , strPath.c_str() , GLMsg(333+i) , tRet.cFileName ) ;
								_ftprintf_s( fp , GLMsg(340) , atcFileName ) ;
								if( IPSPatch_f( apucRom[i] , aiRomSize[i] , atcFileName ) )
								{
									_ftprintf_s( fp , GLMsg(341) ) ;
								}
							}
							FindClose( hSearch ) ;
						}
					}
					{//nes出力
						_TCHAR aucFileName[512] ;
						_stprintf_s( aucFileName , _countof(aucFileName) , _T("%s%s") , strPath.c_str() , GLMsg(226+i) ) ;
						if( WriteFileFromMemory( aucFileName , apucRom[i] , aiRomSize[i] ) )
						{
							_ftprintf_s( fp , GLMsg(233) , aucFileName ) ;
						}
						else
						{
							_ftprintf_s( fp , GLMsg(232) , aucFileName ) ;
						}
					}
					{//パッチ作成
						unsigned char *pucBase=NULL ;
						int iSize ;
						if( GL::LoadROMex( i+1 , &pucBase , &iSize ) )
						{
							_ftprintf_s( fp , GLMsg(320) ) ;
						}
						else
						{
							_TCHAR aucFileName[512] ;
							_stprintf_s( aucFileName , _countof(aucFileName) , _T("%s%s") , strPath.c_str() , GLMsg(321+i) ) ;
							int iRV2 = IPSCreate_f( apucRom[i] , pucBase , aiRomSize[i] , aucFileName ) ;
							if( !iRV2 ){ _ftprintf_s( fp , GLMsg(328) , aucFileName ) ; }
							else{ _ftprintf_s( fp , GLMsg(327) , iRV2 ) ; }
							free( pucBase ) ;
						}
					}
				}
				free(apucRom[i]) ;
				apucRom[i]=NULL;
				if( apucRomMask[i] ){ free(apucRomMask[i]); }
				apucRomMask[i]=NULL;
			}
			if( apucRomOrg[i] )
			{
				free(apucRomOrg[i]) ;
				apucRomOrg[i] = NULL ;
			}
		}
		if( fp ){ fclose( fp ) ; }
	}
	return iRV ;
}

void GL::SetDirectEditFileName()
{
	if( iDirectEditMode )
	{
		TCHAR atcTmp[128] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(420) , GL::RS.GetEditMode() , iDirectEditStage ) ;
		GL::RS.SetFileName( atcTmp ) ;
	}
}
