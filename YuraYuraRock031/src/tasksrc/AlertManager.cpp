#include "../common.h"

void AlertManager::Finit()
{
	return ;
}
void AlertManager::Fmain()
{
	int iCurY = 0 ;
	for( int i=0 ;; i++ )
	{
		TASKHANDLE hTask ;
		hTask = SearchTask( TP_BOX_TEXT , TP_BOX_TEXT , i ) ;
		if( !hTask )
		{
			break ;
		}
		TaskObjectBoxText *pTask = (TaskObjectBoxText*)SolveHandle( hTask ) ;
		Task1206Rect tRect ;
		tRect = pTask->GetRect() ;
		if( iCurY != tRect.y )
		{
			tRect.y = iCurY ;
			GL::RequestRedraw() ;
			pTask->SetRect( tRect ) ;
		}
		iCurY += tRect.h ;
	}
	return ;
}
void AlertManager::Fdest()
{
	return ;
}
void AlertManager::Fdraw()
{
	return ;
}
