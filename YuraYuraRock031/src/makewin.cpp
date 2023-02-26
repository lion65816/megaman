#include "common.h"
#include "mytimer.h"
#include "FileManager.h"

extern LRESULT CALLBACK windowproc(HWND hwnd,UINT message,WPARAM wparam,LPARAM lparam);


HWND hWnd;
HINSTANCE hInstance;


int WINAPI WinMain(HINSTANCE hinstance,HINSTANCE hpinstance,
				   LPSTR lpszcmdline,int ncmdshow)
{
	_tsetlocale( LC_ALL , _T("japanese") ) ; //ロケール設定
#ifndef ENABLE_MULTIPLE_RUN
HWND tmpwnd;
	//簡易二重起動禁止
	if((tmpwnd=FindWindow( GL::COMMON_CONST_WINDOW_CLASS_NAME , NULL )) != NULL)
	{
	    ShowWindow( tmpwnd , SW_RESTORE );
	    SetForegroundWindow( tmpwnd );
	    return -1 ;
	}
#endif

	if( GL::LoadNameTable10( GL::Msg , _countof(GL::Msg) , GL::pctcFilenameMsg ) )
	{
		MessageBox( NULL , _T("data/msg.txt\nが開けません") , _T("error") , MB_OK ) ;
		return -1 ;
	}

	{
		LPTSTR ptRaw ;
		LPWSTR *ppwTmp ;
		int iArgc ;
		if( ptRaw=GetCommandLine() )
		{
			if( ppwTmp=CommandLineToArgvW( ptRaw , &iArgc ) )
			{
				if( iArgc==1 )
				{
					;
				}else if( iArgc==2 ){
					tstring strTmp =  ppwTmp[0] ;
					tstring strPath = strTmp.substr(0,strTmp.rfind(_T("\\"))) ;
					if( !MyIsGlobalPath( ppwTmp[1] ) )
					{
						strPath += ppwTmp[1] ;
					}else{
						strPath = ppwTmp[1] ;
					}
					if( MyPathIsDirectory( strPath.c_str() ) )
					{
						int iRV = GL::DropRoutineSub( strPath.c_str() , 1 ) ;
						GlobalFree( ppwTmp ) ;
						return iRV ;
					}
					GL::strDropReserve = strPath ;
				}else{
					_TCHAR aucTmp[512] ;
					_stprintf_s( aucTmp , _countof(aucTmp) , 
								GLMsg(191) , iArgc , ptRaw ) ;
					MessageBox( NULL , aucTmp , _T("Error") , MB_OK ) ;
					GlobalFree( ppwTmp ) ;
					return -1 ;
				}

				GlobalFree( ppwTmp ) ;
			}
		}
//		LPTSTR ptTmp = GetCommandLine() ;
//		ptTmp[0] = ptTmp[0] ;

	}

	HWND hwnd = NULL;
	WNDCLASS wc;
	MSG msg;
	wc.lpszClassName=GL::COMMON_CONST_WINDOW_CLASS_NAME;
	wc.lpszMenuName=NULL;
	wc.hInstance=hinstance;
	wc.lpfnWndProc=windowproc;
	wc.hCursor=LoadCursor(NULL,IDC_ARROW);
	wc.hIcon=LoadIcon(NULL,IDI_APPLICATION);
	wc.hbrBackground=(HBRUSH)GetStockObject(WHITE_BRUSH);
	wc.style=CS_HREDRAW | CS_VREDRAW | CS_DBLCLKS;
	wc.cbClsExtra=0;
	wc.cbWndExtra=0;

	if(!RegisterClass(&wc))
		return 1;
	if((hwnd = CreateWindowEx(
#ifdef	MY_DROP_ACCEPT
		WS_EX_ACCEPTFILES
#else
		0
#endif	
		, wc.lpszClassName, GL::Msg[0].c_str() ,
		WS_CAPTION | WS_SYSMENU
#ifdef 		WINDOW_RESIZABLE
		| WS_SIZEBOX
#endif
#ifdef 		WINDOW_MINIMIZABLE
		| WS_MINIMIZEBOX 
#endif
//#define	WINDOW_RESIZABLE //ウインドウサイズを変更可能にする
//#define	WINDOW_MINIMIZABLE //ウインドウを最小化可能かどうか
		
		, 0, 0,
		GL::WINWIDTH
#ifndef 		WINDOW_RESIZABLE
		+ GetSystemMetrics(SM_CXFIXEDFRAME) * 2
#else
		+ GetSystemMetrics(SM_CXSIZEFRAME) * 2
#endif
		,
		GL::WINHEIGHT + GetSystemMetrics(SM_CYCAPTION)
#ifndef 		WINDOW_RESIZABLE
		+ GetSystemMetrics(SM_CYFIXEDFRAME) * 2 		
#else
		+ GetSystemMetrics(SM_CYSIZEFRAME) * 2
#endif
		,
		HWND_DESKTOP, NULL, hinstance, NULL)) == NULL)
	{
		return -1;
	}
	GL::hWnd = hwnd;
	GL::hInstance = hinstance;


	ShowWindow(hwnd,ncmdshow);
	UpdateWindow(hwnd);
	RedrawWindow(hwnd,NULL,NULL,RDW_INTERNALPAINT | RDW_UPDATENOW);

	if( GL::AppPrepare( hwnd , hinstance ))
	{
		DestroyWindow(hwnd);
	}


MyTimerObj mto(60);

	for(;;)
	{
		GL::MainRoutine( mto.GetFPS() );
		if(mto.Wait(&msg))break;
	}
	GL::AppRelease();

	return msg.wParam;
}