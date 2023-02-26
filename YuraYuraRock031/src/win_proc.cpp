#include "common.h"



LRESULT CALLBACK windowproc(HWND hwnd,UINT message,WPARAM wparam,LPARAM lparam)
{
static bool cap[2]={false,false};
	switch(message)
	{
	case WM_KEYDOWN:
		//OutputDebugString(Int2Char(wparam));
		ProOn(wparam);
	break;
	case WM_KEYUP:
		ProOff(wparam);
	break;
	case WM_MOUSEMOVE:
		ProMMove(lparam);
	break;
	case WM_LBUTTONDOWN:
		ProMOn(MB_L);
		if( ! cap[1] ) SetCapture( hwnd ) ;
		cap[0] = true; 
	break;
	case WM_LBUTTONUP:
		ProMOff(MB_L);
		if( ! cap[1] ) ReleaseCapture() ;
		cap[0] = false; 
	break;
	case WM_RBUTTONDOWN:
		ProMOn(MB_R);
		if( ! cap[0] ) SetCapture( hwnd ) ;
		cap[1] = true; 
	break;
	case WM_RBUTTONUP:
		ProMOff(MB_R);
		if( ! cap[0] ) ReleaseCapture() ;
		cap[1] = false; 
	break;
	case WM_MBUTTONDOWN:
		ProMOn(MB_C);
	break;
	case WM_MBUTTONUP:
		ProMOff(MB_C);
	break;
	case WM_ACTIVATE:
		if( LOWORD(wparam) == WA_INACTIVE )
		{
			ForceReleaseKey() ;
			ForceReleaseMouse() ;
		}
		return DefWindowProc(hwnd,message,wparam,lparam);
	break ;
#ifdef	MY_DROP_ACCEPT
	case WM_DROPFILES:
		GL::DropRoutine(wparam);
	break;
#endif
#ifdef WINDOW_RESIZABLE
	case WM_EXITSIZEMOVE:
		{
			RECT tRect ;
			if( GetWindowRect( hwnd , &tRect ) )
			{
				int iNewWidth , iNewHeight ;
				iNewWidth   = tRect.right-tRect.left ;
				iNewHeight  = tRect.bottom-tRect.top ;
				iNewWidth  -= GetSystemMetrics(SM_CXSIZEFRAME) * 2 ;
				iNewHeight -= + GetSystemMetrics(SM_CYSIZEFRAME) * 2 + GetSystemMetrics(SM_CYCAPTION) ;
				DurCorrect( &iNewWidth  , GL::ciMinWinWidth  , GL::ciMaxWinWidth  ) ;
				DurCorrect( &iNewHeight , GL::ciMinWinHeight , GL::ciMaxWinHeight ) ;

				if( GL::WINWIDTH != iNewWidth ||
					GL::WINHEIGHT != iNewHeight )
				{
					GL::WINWIDTH  = iNewWidth ;
					GL::WINHEIGHT = iNewHeight ;
					GL::mdo.ReleaseSurface( GL::SFC_BACK ) ;
					GL::mdo.CreateSurface( GL::SFC_BACK , iNewWidth , iNewHeight ) ;
					GL::RequestRedraw() ;
				}
				MoveWindow( hwnd , tRect.left , tRect.top , 
					iNewWidth  + GetSystemMetrics(SM_CXSIZEFRAME) * 2 ,
					iNewHeight + GetSystemMetrics(SM_CYSIZEFRAME) * 2 + GetSystemMetrics(SM_CYCAPTION) , 
					true ) ;
			}
		}
	break ;
#endif
	case WM_CLOSE:
		DestroyWindow(hwnd);
        return 0;
	break;//念
	case WM_DESTROY :
		PostQuitMessage(0);
	break;
	case WM_PAINT:
		GL::RequestFlip();
		return DefWindowProc(hwnd,message,wparam,lparam);
	break;
	default:
		return DefWindowProc(hwnd,message,wparam,lparam);
	}
	return 0;
}
