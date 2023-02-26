#include "../common.h"

void RomModeManager::Finit()
{

	Task1206Rect tRect = {48,20,8,16,0} ;

	{
		_TCHAR atcTmp[512] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , GLMsg(10) , GLMsg(3) ) ;
		new TaskObjectBoxText( this , false , tRect ,  atcTmp , -1 , -1 , -1 ) ;
	}

	tRect.y = 128 ;
	tRect.w = 300 ;
	tRect.h = 32 ;
	new TaskObjectButton( this , false , tRect ,  14 , GLMsg(12) , NULL , &iSelectedRomMode , (void*)1 ) ;
	tRect.y += tRect.h ;
	new TaskObjectButton( this , false , tRect ,  14 , GLMsg(13) , NULL , &iSelectedRomMode , (void*)2 ) ;
	tRect.y += tRect.h ;
	new TaskObjectButton( this , false , tRect ,  14 , GLMsg(14) , NULL , &iSelectedRomMode , (void*)3 ) ;
	tRect.y += tRect.h ;
	new TaskObjectButton( this , false , tRect ,  14 , GLMsg(15) , NULL , &iSelectedRomMode , (void*)4 ) ;
	tRect.y += tRect.h ;
	new TaskObjectButton( this , false , tRect ,  14 , GLMsg(16) , NULL , &iSelectedRomMode , (void*)5 ) ;
	tRect.y += tRect.h ;
	new TaskObjectButton( this , false , tRect ,  14 , GLMsg(17) , NULL , &iSelectedRomMode , (void*)6  ) ;
	tRect.y += tRect.h ;

	iSelectedRomMode = -1 ;

	//	new TaskObjectBinaryEditor2( this , false , tRect , 18 , aucTest , 1 , 0x10 , 8 ) ;
	GL::RequestRedraw() ;
	return ;
}
void RomModeManager::Fmain()
{
	if( iSelectedRomMode >= 1 )
	{
		Task0810 *pTmp = SolveHandle( GetParentHandle() ) ;
		new StageSelectionMode( pTmp , true , iSelectedRomMode ) ;
		Suicide() ;
		return ;
	}
	return ;
}
void RomModeManager::Fdest()
{
	return ;
}
void RomModeManager::Fdraw()
{
	return ;
}
