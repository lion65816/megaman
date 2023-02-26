#include "common.h"



void ModeManager::Finit()
{
//	new RomModeManager( this ) ;
	new FirstInfo( this ) ;
	GL::RequestRedraw() ;
	return ;
}
void ModeManager::Fmain()
{
	return ;
}
void ModeManager::Fdest()
{
	return ;
}
void ModeManager::Fdraw()
{
	return ;
}

