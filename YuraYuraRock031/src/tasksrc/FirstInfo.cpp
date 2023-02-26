#include "../common.h"

void FirstInfo::Finit()
{
	iButton = 0 ;
	Task1206Rect tRect = {48,20,8,16,0} ;
	{
		new TaskObjectBoxText( this , false , tRect ,  GLMsg(460) , -1 , -1 , -1 ) ;
	}
	tRect.y += tRect.h ;
	tRect.y += 160 ;
	tRect.w = 300 ;
	tRect.h = 32 ;
	new TaskObjectButton( this , false , tRect ,  14 , GLMsg(461) , NULL , &iButton , (void*)1 ) ;
	tRect.y += tRect.h ;
	return ;
}
void FirstInfo::Fmain()
{
	if( iButton )
	{
		Task0810 *pTmp = SolveHandle( GetParentHandle() ) ;
		new RomModeManager( pTmp , true ) ;
		Suicide() ;
		return ;
	}
	return ;
}
void FirstInfo::Fdest()
{
	return ;
}
void FirstInfo::Fdraw()
{
	return ;
}
