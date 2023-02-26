#include "common.h"
#include "HT/NESSys.h"


static void CLSFUNC( int sfc , int x , int y , int w , int h , UINT c )
{
	GL::mdo.Cls( MDO3WINAPI , sfc , x , y , w , h , c ) ;
}

void TaskAppManager::Finit()
{
	GL::SetupNESColor( GLMsg(1) ) ;
	GL::mdo.Initialize( GL::hWnd , GL::hInstance );
	SetNESDrawRoutine( CLSFUNC , NULL ) ;
	GL::mdo.CreateSurface( GL::SFC_CHR  , 128 , 128 ) ;
	GL::mdo.CreateSurface( GL::SFC_CHR_BW , 256 , 256 ) ;
	GL::mdo.CreateSurface( GL::SFC_CHIP , 128 , 512 ) ;
	GL::mdo.CreateSurface( GL::SFC_CHIPINFO  , 256 , 256 ) ;
/*//numbers.bmpの作製
	{
		GL::mdo.Cls( MDO3normal , GL::SFC_CHIPINFO , 0 , 0 , 256 , 256 , myRGB(31,0,31) ) ;
		for( int i=0 ; i<256 ; i++ )
		{
			int iTx , iTy ;
			TCHAR atcTmp[256] ;
			iTx = i%16*16 ;
			iTy = i/16*16 ;
			_stprintf_s( atcTmp , _countof(atcTmp) , _T("%02X") , i ) ;
			GL::mdo.Text( GL::SFC_CHIPINFO , atcTmp , iTx+1-1 , iTy+1   , 14 , 7 , RGB(0,0,0) ) ;
			GL::mdo.Text( GL::SFC_CHIPINFO , atcTmp , iTx+1+1 , iTy+1   , 14 , 7 , RGB(0,0,0) ) ;
			GL::mdo.Text( GL::SFC_CHIPINFO , atcTmp , iTx+1   , iTy+1-1 , 14 , 7 , RGB(0,0,0) ) ;
			GL::mdo.Text( GL::SFC_CHIPINFO , atcTmp , iTx+1   , iTy+1+1 , 14 , 7 , RGB(0,0,0) ) ;
			GL::mdo.Text( GL::SFC_CHIPINFO , atcTmp , iTx+1   , iTy+1   , 14 , 7 , RGB(255,255,255) ) ;
		}
		GL::mdo.SaveBitmapFile( _T("numbers.bmp") , GL::SFC_CHIPINFO ) ;
	}
//*/
	GL::mdo.LoadBitmapFile( GL::SFC_CHIPINFO  , GLMsg(2) ) ;
	GL::RS.SetDrawParam( GL::SFC_CHR , GL::SFC_CHIP , GL::SFC_CHIPINFO , GL::NESColor , GL::SFC_TMP_RS ) ;

	TaskObjectManager::SetupAllMember( &GL::mdo , GL::RequestRedraw ,
		&GL::WINWIDTH , &GL::WINHEIGHT ) ;

	new TaskFrameInit( this , TP_FRAMEINIT , true ) ;
	new TaskFrameEnd ( this , TP_FRAMEEND  , true ) ;
	new AlertManager ( this ) ;
	new ModeManager  ( this ) ;

	return ;
}
void TaskAppManager::Fmain()
{
	return ;
}
void TaskAppManager::Fdest()
{
	return ;
}
void TaskAppManager::Fdraw()
{
	return ;
}

void TaskFrameEnd::Fmain()
{
#ifdef _DEBUG
	static int iRD,iFl ; //本当に今頃だがフリップって意味違うよなーｗ
#endif
	KeyMove();
	if(isredraw)
	{
		GL::mdo.Cls( MDO3normal , 0 , 0 , 0 , GL::WINWIDTH , GL::WINHEIGHT , myRGB(28,31,28) );
		Task0810 *Pptr ;
		Pptr = Task0810::SolveHandle( GL::HAM ) ;
		if( Pptr ) Pptr->DrawCP() ;
		isredraw = 0;
		isflip = 1;

#ifdef _DEBUG
		iRD += 8 ;
		RotateCorrect( &iRD , GL::WINWIDTH ) ;
		GL::mdo.Cls( MDO3normal , 0 , iRD , 0 , 8 , 4 , myRGB(31,0,0) );
#endif
	}
	if(isflip)
	{
#ifdef _DEBUG
		iFl += 8 ;
		RotateCorrect( &iFl , GL::WINWIDTH ) ;
		GL::mdo.Cls( MDO3normal , 0 , iFl , 4 , 8 , 4 , myRGB(31,0,0) );
#endif
		GL::mdo.Flip( MDO3FT_NORMAL );
		isflip = 0;
	}
	return;
}

