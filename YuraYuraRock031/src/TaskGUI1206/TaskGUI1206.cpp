#define TASK_GUI_CPP
#include "TaskGUI1206.h"

#ifdef _ORE_SENYOU
#include "myeinput.h"
#include "keycode.h"
#include "nnsys.h"
#else
#include "../myeinput.h"
#include "../keycode.h"
#include "../nnsys.h"
#endif


MyDIBObj3 *TaskObjectManager::Pmdo = NULL ;
void (*TaskObjectManager::Prr)(void) = NULL ;
int (*TaskObjectManager::piWinW) = NULL ;
int (*TaskObjectManager::piWinH) = NULL ;

void TaskObjectBoxText::Fmain()
{
	UpdateXY() ;
	if( iTimer>=0 )
	{
		iTimer-- ;
		if( iTimer<0 )
		{
			TaskObjectManager::RequestRedraw() ;
			Suicide() ;
			return ;
		}	
	}
	return ;
}

void TaskObjectBoxText::UpdateXY()
{
	if(!TaskObjectManager::Pmdo)
	{
		assert(0);
		return ;
	}
	if( strPrev != strText )
	{
		strPrev = strText ;

		int iLines = 0 ;
		int iMaxWidth = 0 ;
		for( int i=0 ; i>=0 ; iLines++ )
		{
			tstring strTmp ;
			int iPos ;
			SIZE tTmpSize ;

			strTmp = strText.c_str()+i ;
			iPos = strTmp.find( _T('\n') ) ;
			if( iPos == string::npos ) {
				i = -1 ;
			} else {
				i += iPos+1 ;
				strTmp.at(iPos) = _T('\0') ;
			}
			tTmpSize = TaskObjectManager::Pmdo->TestText( 0 , strTmp.c_str() , tRect0.h , tRect0.w ) ;
			iMaxWidth = max( iMaxWidth , tTmpSize.cx ) ;
		}
		tSize.cx = iMaxWidth ;
		tSize.cy = iLines * tRect0.h ;
	}
	tRect.w = tSize.cx ;
	tRect.h = tSize.cy ;
	TaskObject::UpdateXY() ;
}


void TaskObjectBoxText::Fdraw()
{
	if(!TaskObjectManager::Pmdo)
	{
		assert(0);
		return ;
	}
	int iPrev = 0 ;
	int iCury = y ;
	
	for( int i=0 ; i>=0 ; )
	{
		tstring strTmp ;
		int iPos ;
		strTmp = strText.c_str()+i ;
		iPos = strTmp.find( _T('\n') ) ;
		if( iPos == string::npos ) {
			i = -1 ;
		} else {
			i += iPos+1 ;
			strTmp.at(iPos) = _T('\0') ;
		}

		int tx = x ;
		if( tRect.coordinates&1 )
		{
			SIZE tTmpSize ;
			tTmpSize = TaskObjectManager::Pmdo->TestText( 0 , strTmp.c_str() , tRect0.h , tRect0.w ) ;
			tx += tRect.w - tTmpSize.cx ;
		}
		
		TaskObjectManager::Pmdo->Text( 0 , strTmp.c_str() , tx-1 , iCury   , tRect0.h , tRect0.w , uiCol2 ) ;
		TaskObjectManager::Pmdo->Text( 0 , strTmp.c_str() , tx+1 , iCury   , tRect0.h , tRect0.w , uiCol2 ) ;
		TaskObjectManager::Pmdo->Text( 0 , strTmp.c_str() , tx   , iCury-1 , tRect0.h , tRect0.w , uiCol2 ) ;
		TaskObjectManager::Pmdo->Text( 0 , strTmp.c_str() , tx   , iCury+1 , tRect0.h , tRect0.w , uiCol2 ) ;
		TaskObjectManager::Pmdo->Text( 0 , strTmp.c_str() , tx   , iCury   , tRect0.h , tRect0.w , uiCol1 ) ;
		iCury += tRect0.h ;

	}
	return ;
}

void TaskObjectSubWindow::Finit()
{
	SetProcessOrderPandC( false , true ) ;
	SetDrawOrderPandC( true , true ) ;
}
void TaskObjectSubWindow::Fmain()
{
	UpdateXY() ;
	if( (MouseOn( MB_L ) || MouseOn( MB_R ) || MouseOn( MB_C ) ) &&
		RectIn( GetMousePosX() , GetMousePosY() , x , y , tRect.w , tRect.h ) )
	{
		InvalidateMouse() ;
	}
}
void TaskObjectSubWindow::Fdraw()
{
	if(!TaskObjectManager::Pmdo)
	{
		assert(0);
		return ;
	}
	if( IsDrawingBeforeChild() )
	{
		TaskObjectManager::Pmdo->GetClipper( 0 , &iClipX , &iClipY , &iClipW , &iClipH ) ;
		TaskObjectManager::Pmdo->SetClipper( 0 , x , y , tRect.w , tRect.h ) ;
		if( Col < 0x8000 )
		{
			TaskObjectManager::Pmdo->Cls( MDO3WINAPI , 0 , x , y , tRect.w , tRect.h , Col ) ;
		}
	}
	else
	{
		TaskObjectManager::Pmdo->SetClipper( 0 , iClipX , iClipY , iClipW , iClipH ) ;
	}
}
void TaskObjectSubWindow::UpdateXY()
{
	TaskObject::UpdateXY() ;
}

void TaskObjectBinaryEditor::Finit()
{
	iIsChanged = 0 ;
}
void TaskObjectBinaryEditor::Fmain()
{
	UpdateXY() ;
	if( !iValid ){ return; }
	if( iSelectedPosition >= 0 )
	{
int iTmp ;
		iTmp = GetNumberKey(true) ;
		if( iTmp != -1 )
		{
			pfuncModifyDataColumn( this , iTmp ) ;
			iLastChanged = iSelectedPosition/iWorkBytesPerNumber ;
			iSelectedPosition++ ;
			if( iSelectedPosition/iWorkBytesPerNumber>=iDataSize )iSelectedPosition = -1 ;
			TaskObjectManager::RequestRedraw() ;
			InvalidateKeyCode( KC_0 ) ;
			InvalidateKeyCode( KC_1 ) ;
			InvalidateKeyCode( KC_2 ) ;
			InvalidateKeyCode( KC_3 ) ;
			InvalidateKeyCode( KC_4 ) ;
			InvalidateKeyCode( KC_5 ) ;
			InvalidateKeyCode( KC_6 ) ;
			InvalidateKeyCode( KC_7 ) ;
			InvalidateKeyCode( KC_8 ) ;
			InvalidateKeyCode( KC_9 ) ;
			InvalidateKeyCode( KC_A ) ;
			InvalidateKeyCode( KC_B ) ;
			InvalidateKeyCode( KC_C ) ;
			InvalidateKeyCode( KC_D ) ;
			InvalidateKeyCode( KC_E ) ;
			InvalidateKeyCode( KC_F ) ;
			iIsChanged = 1 ;
		}
		int iShift = 0 ;
		KeyScroll( &iShift , KC_J , KC_M , 1  , 1 , 0 ) ;
		KeyScroll( &iShift , KC_H , KC_N , 16 , 1 , 0 ) ;
		if( iShift )
		{
			int iVal = pData[iSelectedPosition/iWorkBytesPerNumber] ;
			iVal += iShift ;
			RotateCorrect( &iVal , 256 ) ;
			pData[iSelectedPosition/iWorkBytesPerNumber] = iVal ;
			InvalidateKey() ;
			TaskObjectManager::RequestRedraw() ;
			iIsChanged = 1 ;
			iLastChanged = iSelectedPosition/iWorkBytesPerNumber ;
		}
	}
	int iInField = 1 ;
	int iPointed ;
	int iRX ;
	{
		int tx , ty , cx , cy ;
		tx = GetMousePosX() - x ;
		ty = GetMousePosY() - y ;
		cx = tx / iWorkNumberSpan ;
		cy = ty / tRect0.h ;
		iRX = tx % iWorkNumberSpan / iWorkColumnWidth ;
		iPointed = cx + cy * iDataPerLine ;
		if( tx<0 || ty<0 ){ iInField = 0 ; }
		if( cx>=iDataPerLine ){ iInField = 0 ; }
		if( iRX>=iWorkBytesPerNumber ){ iInField = 0 ; }
		if( iPointed>=iDataSize ){ iInField = 0 ; }
	}
	if( iInField )
	{
		if( MousePush( MB_L ) )
		{
			InvalidateMouse() ;
			iSelectedPosition = iPointed*iWorkBytesPerNumber+iRX ;
			TaskObjectManager::RequestRedraw() ;
		}
	}
	else
	{
		if( MouseOn( MB_L ) && iSelectedPosition >= 0 )
		{
			iSelectedPosition = -1 ;
			TaskObjectManager::RequestRedraw() ;
		}
	}
}
void TaskObjectBinaryEditor::Fdest()
{
}
void TaskObjectBinaryEditor::Fdraw()
{
	BMPD color = myRGB(31,31,31) ;
	if( !iValid ){ color=myRGB(10,10,10); }
	for( int i=0 ; i<iDataSize ; i++ )
	{
		int tx, ty ;
		tx = x + i % iDataPerLine * iWorkNumberSpan ;
		ty = y + i / iDataPerLine * tRect0.h ;
		TaskObjectManager::Pmdo->Cls( MDO3WINAPI , 0 , tx , ty , iWorkBytesPerNumber*iWorkColumnWidth , tRect0.h , color ) ;
		if( iSelectedPosition>=0 && iSelectedPosition/iWorkBytesPerNumber == i )
		{
			TaskObjectManager::Pmdo->Cls( MDO3WINAPI , 0 , tx+iSelectedPosition%iWorkBytesPerNumber*iWorkColumnWidth , ty , iWorkColumnWidth , tRect0.h , myRGB(0,31,0) ) ;
		}
		_TCHAR atcTmp[16] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , ptcDrawFormat , pfuncGetValue(this,i) ) ;
		TaskObjectManager::Pmdo->Text( 0 , atcTmp , tx , ty , tRect0.h , tRect0.h/2 , RGB(0,0,0) ) ;
	}
}
void TaskObjectBinaryEditor::UpdateXY()
{
	if( iDataPerLine < 0 )
	{
		tRect.w = iDataSize * tRect0.h * 3 / 2 - tRect0.h / 2 ;
		tRect.h = tRect0.h ;
	}
	else
	{
		tRect.w = iDataPerLine * tRect0.h * 3 / 2 - tRect0.h / 2 ;
		tRect.h = (iDataSize+iDataPerLine-1)/iDataPerLine * tRect0.h ;
	}
	TaskObject::UpdateXY() ;
}


void TaskObjectCheckBox::Fmain()
{
	UpdateXY() ;
	if( !iValid ){ return; }
	int tx , ty ;
	tx = GetMousePosX() - x ;
	ty = GetMousePosY() - y ;
	if( tx>=0 && ty>=0 && tx<tRect0.w && ty<tRect0.h )
	{
		if( MousePush( MB_L ) )
		{
			InvalidateMouse() ;
			if( *pucData ){ *pucData = 0 ; }
			else { *pucData = 1 ; }
			TaskObjectManager::RequestRedraw() ;
		}
	}

}
void TaskObjectCheckBox::Fdraw()
{
	BMPD color = myRGB(31,31,31) ;
	if( !iValid ){ color=myRGB(10,10,10); }
	TaskObjectManager::Pmdo->Cls( MDO3WINAPI , 0 , x , y , tRect0.w , tRect0.h , color ) ;
	if( *pucData )
	{
		int x0,x1,x2,y0,y1,y2 ;
		x0 = x + tRect0.w*1/8 ;
		x1 = x + tRect0.w*3/8 ;
		x2 = x + tRect0.w*7/8 ;
		y0 = y + tRect0.h*4/8 ;
		y1 = y + tRect0.h*7/8 ;
		y2 = y + tRect0.h*1/8 ;

		TaskObjectManager::Pmdo->Line( MDO3normal , 0 , x0 , y0 , x1 , y1 , myRGB(0,0,0) ) ;
		TaskObjectManager::Pmdo->Line( MDO3normal , 0 , x1 , y1 , x2 , y2 , myRGB(0,0,0) ) ;
	}
	TaskObjectManager::Pmdo->Text( 0 , strText.c_str() , x+tRect0.w , y , tRect0.h , tRect0.h/2 , RGB(0,0,0) ) ;
}
void TaskObjectCheckBox::UpdateXY()
{
	if(!TaskObjectManager::Pmdo)
	{
		assert(0);
		return ;
	}
	tRect.w = tRect0.w ;
	tRect.h = tRect0.h ;
	if( strPrev != strText )
	{
		strPrev = strText ;

		SIZE tTmpSize ;
		tTmpSize = TaskObjectManager::Pmdo->TestText( 0 , strText.c_str() , tRect0.h , tRect0.h/2 ) ;
		tRect.w += tTmpSize.cx ;
	}

	TaskObject::UpdateXY() ;
}
void TaskObjectRotateList::Fmain()
{
	UpdateXY() ;
	if( !iValid ){ return; }
	int tx , ty ;
	tx = GetMousePosX() - x ;
	ty = GetMousePosY() - y ;


	if( !iDragging )
	{
		if( tx>=0 && ty>=0 && tx<tRect0.w && ty<tRect0.h*iRows )
		{
			int iDoSelect=0 ;
			if( MousePush( MB_L ) )
			{
				InvalidateMouse() ;
				iDoSelect = 1 ;
			}
			if( MouseOn( MB_R ) )
			{
				InvalidateMouse() ;
				if( iAutoScroll && (--iAutoScrollCnt)<0 )
				{
					iAutoScrollCnt = iAutoScroll ;
					iDoSelect = 1 ;
				}
			}
			if( iDoSelect )
			{
				int iTmp ;
				iTmp = *piData - iRows/2 + ty/tRect0.h ;
				RotateCorrect( &iTmp , iMaxItem ) ;
				if(VAR_LET(*piData,iTmp))
				{
					TaskObjectManager::RequestRedraw() ;
					iIsChanged = 1 ;
				}
			}

			if( MousePush( MB_C ) )
			{
				InvalidateMouse() ;
				iDragging = 1 ;
				iDragPreX = GetMousePosX() ;
				iDragPreY = GetMousePosY() ;
			}
		}
	}
	else
	{
		if( !MouseOn( MB_C ) )
		{
			iDragging = 0 ;
			TaskObjectManager::RequestRedraw() ;
		}
		else
		{
			InvalidateMouse() ;
			int dx , dy ;
			dx = GetMousePosX() - iDragPreX ;
			dy = GetMousePosY() - iDragPreY ;
			tRect.MoveD( dx , dy ) ;
			if( dx && dy )
			{
				TaskObjectManager::RequestRedraw() ;
			}
			iDragPreX = GetMousePosX() ;
			iDragPreY = GetMousePosY() ;
		}
	}
	if( MouseOff( MB_R ) ){ iAutoScrollCnt = 0 ; }
}
void TaskObjectRotateList::Fdraw()
{
	int iTopItem ;
	iTopItem = *piData - iRows/2 ;
	BMPD invcolor = myRGB(31,31,31) ;
	if( !iValid ){ invcolor=myRGB(10,10,10); }

	for( int i=0 ; i<iRows ; i++ )
	{
		int iItemNum ;
		int iY ;
		BMPD color=invcolor ;
		iItemNum = iTopItem+i ;
		RotateCorrect( &iItemNum , iMaxItem ) ;
		iY = y + i*tRect0.h ;
		if( i==iRows/2 )
			{ color = myRGB(0,31,0) ; }
		_TCHAR atcTmp[16] ;
		_stprintf_s( atcTmp , _countof(atcTmp) , _T("%02X") , iItemNum ) ;
		TaskObjectManager::Pmdo->Cls ( MDO3WINAPI , 0 , x , iY , tRect0.w , tRect0.h , color ) ;
		TaskObjectManager::Pmdo->Text( 0 , atcTmp                     , x          , iY , tRect0.h , tRect0.h/2 , RGB(0,0,0) ) ;
		if( pstrItem )
		{
		TaskObjectManager::Pmdo->Text( 0 , pstrItem[iItemNum].c_str() , x+tRect0.h , iY , tRect0.h , tRect0.h/2 , RGB(0,0,0) ) ;
		}
	}
}
void TaskObjectRotateList::UpdateXY()
{
	tRect.w = tRect0.w ;
	tRect.h = tRect0.h * iRows ;
	TaskObject::UpdateXY() ;
}
void TaskObjectButton::Finit()
{

}
void TaskObjectButton::Fmain()
{
	UpdateXY() ;
	if( !iValid ){ iDragging=0 ; return; }
	int iPreDragging = iDragging ;
	if( RectIn( GetMousePosX() , GetMousePosY() , x , y , tRect.w , tRect.h ) )
	{
		if( MousePush( MB_L ) || iDragging )
		{
			iDragging = 1 ;
			if( MouseRelease( MB_L ) )
			{
				if( pFunc )
				{
					pFunc( pvArgument1 , pvArgument2 ) ;
				}else if( pvArgument1!=NULL ){
					*(int*)pvArgument1 = (int)pvArgument2 ;
				}
				iDragging = 0 ;
			}
		}
		if( MouseOn( MB_L ) )
		{
			InvalidateMouse() ;
		}
	}
	else
	{
		if( iDragging )
		{
			iDragging = 2 ;
			if( !MouseOn( MB_L ) )
			{
				iDragging = 0 ;
			}
		}
	}
	if( iPreDragging != iDragging )
	{
		TaskObjectManager::RequestRedraw() ;
	}
}
void TaskObjectButton::Fdest()
{

}
void TaskObjectButton::Fdraw()
{
	UINT color = RGB(0,0,0) ;
	if( !iValid ){ color=RGB(64,64,64); }
	int iSW ;
	int iDY ;
	int iW,iH ;
	iW = tRect.w ;
	iH = tRect.h ;
	BMPD Color1 , Color2 ;

	iSW = min(iW,iH)/32+1 ;
	Color1 = myRGB(31,31,31) ;
	Color2 = myRGB( 0, 0, 0) ;
	iDY = 0 ;
	if( iDragging&1 )
	{
		MYSWAP( &Color1 , &Color2 ) ;
		iDY = iSW ;
	}

	TaskObjectManager::Pmdo->Cls ( MDO3WINAPI , 0 , x     , y     , iW       , iH       , Color1 ) ;
	TaskObjectManager::Pmdo->Cls ( MDO3WINAPI , 0 , x+iSW , y+iSW , iW-iSW*1 , iH-iSW*1 , Color2 ) ;
	TaskObjectManager::Pmdo->Cls ( MDO3WINAPI , 0 , x+iSW , y+iSW , iW-iSW*2 , iH-iSW*2 , myRGB(25,25,25) ) ;

	int iX ;
	SIZE tFontRect ;
	tFontRect = TaskObjectManager::Pmdo->TestText( 0 , strCaption.c_str() , iFontSize , iFontSize/2 ) ;
	iX = x + ( iW - tFontRect.cx ) / 2 ;
	TaskObjectManager::Pmdo->Text( 0 , strCaption.c_str() , iX+iDY  , y+(iH-iFontSize)/2+iDY , iFontSize , iFontSize/2 , color ) ;


}
void TaskObjectButton::UpdateXY()
{
	TaskObject::UpdateXY() ;
}
