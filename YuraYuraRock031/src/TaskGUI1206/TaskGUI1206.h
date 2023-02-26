#ifndef TASK_GUI0810_HEADER_INCLUDED
#define TASK_GUI0810_HEADER_INCLUDED

#include <windows.h>
#include <assert.h>
#include <tchar.h>

#ifdef TASK_GUI_CPP
#define TASK0810_NO_TASK_PRIORITY_HEADER_INCLUDE
#include "TaskGUI1206_Prio_l.h"
#endif

#ifdef _ORE_SENYOU
#include "task0810.h"
#include "mydibobj3.h"
#else
#include "../task0810.h"
#include "../mydibobj3.h"
#endif

#include "../TypedFunction.h"
using namespace std ;

class TaskObjectManager
{
public:
	static void SetupAllMember(
		MyDIBObj3 *Pmdo ,
		void (*Prr)(void) ,
		int *piWinW ,
		int *piWinH
		)
	{
		TaskObjectManager::Pmdo = Pmdo ;
		TaskObjectManager::Prr  = Prr ;
		TaskObjectManager::piWinW = piWinW ;
		TaskObjectManager::piWinH = piWinH ;
	}
	static MyDIBObj3 *Pmdo ; //MDOオブジェクトへのポインタ
	static void (*Prr)(void) ; //RequestRedraw関数へのポインタ
	static int *piWinW ;
	static int *piWinH ;
	static void RequestRedraw()
	{
		if( TaskObjectManager::Prr ) TaskObjectManager::Prr() ;
	}
};

struct Task1206Rect
{
	int x ;
	int y ;
	int w ;
	int h ;
	int coordinates ;
	int UpdateXY( int *piX , int *piY )
	{
		int tx,ty ;
		if( coordinates&1 && TaskObjectManager::piWinW )
		{
			tx = *TaskObjectManager::piWinW - w - x ;
		}
		else
		{
			tx = x ;
		}
		if( coordinates&2 && TaskObjectManager::piWinH )
		{
			ty = *TaskObjectManager::piWinH - h - y ;
		}
		else
		{
			ty = y ;
		}
		if( *piX != tx || *piY != ty )
		{
			*piX = tx ;
			*piY = ty ;
			return 1 ;
		}
		return 0 ;
	}
	void MoveD( int dx , int dy )
	{
		if( coordinates&1 ){ dx*=-1; }
		if( coordinates&2 ){ dy*=-1; }
		x += dx ;
		y += dy ;
	}
};

class TaskObject : public Task0810
{
public:
	TaskObject( Task0810 *pParent , TaskP Prio , bool handle_enabled , Task1206Rect tRect )
		: Task0810( pParent , Prio , handle_enabled )
	{
		Validate() ;
		this->tRect0 = this->tRect = tRect ;
	}
	TaskObject() : Task0810() {;};
	Task1206Rect GetRect(){ return tRect ; }
	void SetRect( Task1206Rect tRect ){ this->tRect = tRect ; }
	void Validate(){ iValid=1 ; }
	void Invalidate(){ iValid=0 ; }
protected:
	Task1206Rect tRect0 ;
	Task1206Rect tRect ;
	int iValid ;
	void UpdateXY()
	{
		if( tRect.UpdateXY( &x , &y ) )
		{
			TaskObjectManager::RequestRedraw() ;
		}
	}

};



class TaskObjectBoxText : public TaskObject
{
public:
	TaskObjectBoxText( Task0810 *Pparent , bool handle_enabled ,  Task1206Rect tRect , LPCTSTR str , UINT col1 , UINT col2 , int timer )
		: TaskObject( Pparent , TP_BOX_TEXT , handle_enabled , tRect )
	{
		this->strText = str ;
		if( col1 == 0xFFFFFFFF ){ col1 = RGB(0,0,0); }
		if( col2 == 0xFFFFFFFF ){ col2 = RGB(255,255,255); }
		this->uiCol1 = col1 ;
		this->uiCol2 = col2 ;
		this->iTimer = timer ;
		UpdateXY() ;
		this->InitFuncCalled() ;
		Finit();
		TaskObjectManager::RequestRedraw() ;
	}
	TaskObjectBoxText() : TaskObject() {;};
	void SetString( tstring strText ){ this->strText = strText; } ;
	void SetColor1( UINT color ){ uiCol1 = color; } ;
	void SetColor2( UINT color ){ uiCol2 = color; } ;
protected:
	void Finit() {;}
	void Fmain() ;
	void Fdest() {;}
	void Fdraw() ;

	tstring strText ;
	int iTimer ;
	UINT uiCol1 ;
	UINT uiCol2 ;

	tstring strPrev ;
	SIZE tSize ;

	void UpdateXY() ;

private:
} ;

class TaskObjectSubWindow : public TaskObject
{
public:
	TaskObjectSubWindow( Task0810 *Pparent , bool handle_enabled , Task1206Rect tRect , BMPD col = 0xFFFF )
		: TaskObject( Pparent , TP_SUB_WINDOW , handle_enabled , tRect )
	{
		this->Col = col ;
		UpdateXY() ;
		this->InitFuncCalled() ;
		Finit();
		TaskObjectManager::RequestRedraw() ;
	}
	TaskObjectSubWindow() : TaskObject() {;};
	int IsInWindow( int iX , int iY , int depth )
	{
		int tx , ty ;
		GetGlobalPosition( &tx , &ty , depth ) ;
		iX -= tx ;
		iY -= ty ;
		if( iX>=0 && iX<tRect.w && iY>=0 && iY<tRect.h )
			{ return 1 ;}
		return 0 ;
	}
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() {;}
	void Fdraw() ;
	void UpdateXY() ;

	int iClipX , iClipY , iClipW , iClipH ;
	UINT Col ;
private:
} ;

class TaskObjectBinaryEditor : public TaskObject
{
public:
	TaskObjectBinaryEditor( Task0810 *Pparent , bool handle_enabled , Task1206Rect tRect ,  unsigned char *pData , int iMode , int iDataSize , int iDataPerLine=-1 )
		: TaskObject( Pparent , TP_BINARY_EDITOR , handle_enabled ,  tRect )
	{
		this->pData = pData ;
		this->iDataSize = iDataSize ;
		SetDataPerLine( iDataPerLine ) ;
		iWorkColumnWidth    = tRect.h/2 ;

		switch( iMode )
		{
		case 1:
			iWorkBytesPerNumber = 2 ;
			iWorkNumberSpan     = iWorkColumnWidth*(iWorkBytesPerNumber+1) ;
			ptcDrawFormat       = _T("%02X") ;
			pfuncGetValue         = GetValue ;
			pfuncModifyDataColumn = ModifyDataColumn ;
		break ;
		case 2:
			iWorkBytesPerNumber = 4 ;
			iWorkNumberSpan     = iWorkColumnWidth*(iWorkBytesPerNumber+1) ;
			ptcDrawFormat       = _T("%04X") ;
			pfuncGetValue         = GetValueW ;
			pfuncModifyDataColumn = ModifyDataColumnW ;
		break ;
		default:
			assert( 0 ) ;
		}
		UpdateXY() ;

		this->InitFuncCalled() ;
		iSelectedPosition = -1 ;
		iIsChanged = 0 ;
		iLastChanged = -1 ;
		Finit();
		TaskObjectManager::RequestRedraw() ;
	}
	TaskObjectBinaryEditor() : TaskObject() {;};
	void SetDataPerLine( int iDataPerLine )
	{
		this->iDataPerLine = iDataPerLine ;
		if( iDataPerLine <= 0 )
		{
			this->iDataPerLine = iDataSize ;
		}
	}
	bool IsChanged()
	{
		int iTmp = iIsChanged ;
		iIsChanged = 0 ;
		return (iTmp!=0) ;
	}
	int GetLastChanged(){ return iLastChanged ; }
	void SetSelectedPosition( int iPos )
	{
		iSelectedPosition = iPos ;
		if( iPos<0 || iPos>=iWorkBytesPerNumber*iDataSize )
		{
			iSelectedPosition = -1 ;
		}
	}
	int GetSelectedPosition(){ return iSelectedPosition; }
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;
	void UpdateXY() ;

	unsigned char *pData ;
	int iDataSize ;
	int iDataPerLine ;
	int iSelectedPosition ;
	int iIsChanged ;
	int iLastChanged ;

	int iWorkColumnWidth ;
	int iWorkNumberSpan ;
	int iWorkBytesPerNumber ;
	_TCHAR *ptcDrawFormat ;

	int (*pfuncGetValue)( TaskObjectBinaryEditor* , int ) ;
	void (*pfuncModifyDataColumn)( TaskObjectBinaryEditor* , int ) ;

	static void ModifyDataColumn( TaskObjectBinaryEditor *pObj , int iNumber )
	{
unsigned char aucMask [2] = {0xF0,0x0F};
int iShift[2] = {4,0};
			pObj->pData[pObj->iSelectedPosition/2] &= ~aucMask       [pObj->iSelectedPosition%2] ;
			pObj->pData[pObj->iSelectedPosition/2] |= iNumber<<iShift[pObj->iSelectedPosition%2] ;
	}
	static int GetValue( TaskObjectBinaryEditor *pObj , int iOffset )
	{
		return pObj->pData[ iOffset ] ;
	}
	static void ModifyDataColumnW( TaskObjectBinaryEditor *pObj , int iNumber )
	{
		static const int aucMask[4] = {0xF000,0x0F00,0x00F0,0x000F,};
		static const int iShift[4]  = {12,8,4,0,};
		int iOffset = pObj->iSelectedPosition/pObj->iWorkBytesPerNumber ;
		int iTmp = GetValueW( pObj , iOffset )  ;
		iTmp &= ~aucMask       [pObj->iSelectedPosition%pObj->iWorkBytesPerNumber] ;
		iTmp |= iNumber<<iShift[pObj->iSelectedPosition%pObj->iWorkBytesPerNumber] ;
		pObj->pData[ iOffset*2+1 ] = (iTmp>>8) ;
		pObj->pData[ iOffset*2+0 ] = (iTmp&0xFF) ;
	}
	static int GetValueW( TaskObjectBinaryEditor *pObj , int iOffset )
	{
		return (pObj->pData[ iOffset*2+1 ]<<8) | pObj->pData[ iOffset*2 ] ;
	}

} ;


class TaskObjectCheckBox : public TaskObject
{
public:
	TaskObjectCheckBox( Task0810 *Pparent , bool handle_enabled , Task1206Rect tRect , tstring str , unsigned char *pucData )
		: TaskObject( Pparent , TP_CHECK_BOX , handle_enabled ,  tRect)
	{
		this->strText = str ;
		this->pucData = pucData ;

		UpdateXY() ;
		this->InitFuncCalled() ;
		Finit();
		TaskObjectManager::RequestRedraw() ;
	}
	TaskObjectCheckBox() : TaskObject() {;};
protected:
	void Finit() {;}
	void Fmain() ;
	void Fdest() {;}
	void Fdraw() ;
	void UpdateXY() ;

	tstring strText ;
	tstring strPrev ;
	unsigned char *pucData ;
private:
} ;
class TaskObjectRotateList : public TaskObject
{
public:
	TaskObjectRotateList( Task0810 *Pparent , bool handle_enabled , Task1206Rect tRect , int iRows , int *piData , tstring *pstrItem , int iMaxItem , int iAutoScroll=0 )
		: TaskObject( Pparent , TP_ROTATE_LIST , handle_enabled,  tRect)
	{
		this->iRows = iRows ;
		this->piData = piData ;
		this->iMaxItem = iMaxItem ;
		this->iIsChanged = 0 ;
		this->iDragging = 0 ;
		this->pstrItem = NULL ;
		this->iAutoScroll = iAutoScroll ;
		iAutoScrollCnt = 0 ;

		if( iMaxItem>=1 )
		{
			this->pstrItem = new tstring[ iMaxItem ] ;
			if( this->pstrItem )
			{
				for( int i=0 ; i<iMaxItem ; i++ )
				{
					this->pstrItem[i] = pstrItem[i] ;
				}
			}
		}
		UpdateXY() ;
		this->InitFuncCalled() ;
		Finit();
		TaskObjectManager::RequestRedraw() ;
	}
	TaskObjectRotateList() : TaskObject(){;};
	bool IsChanged()
	{
		int iTmp = iIsChanged ;
		iIsChanged = 0 ;
		return (iTmp!=0) ;
	}
protected:
	void Finit() {;}
	void Fmain() ;
	void Fdest()
	{
		delete []pstrItem ;
	}
	void Fdraw() ;
	void UpdateXY() ;

	int iRows ;
	int *piData ;
	tstring *pstrItem ;
	int iMaxItem ;
	int iAutoScroll ;
	int iAutoScrollCnt ;
	int iIsChanged ;

	int iDragging ;
	int iDragPreX ;
	int iDragPreY ;
private:
} ;

class TaskObjectButton : public TaskObject
{
public:
	TaskObjectButton( Task0810 *Pparent , bool handle_enabled , Task1206Rect tRect , int iFontSize , tstring strCaption , void (*pFunc)( void* , void* ) , void *pvArg1 , void *pvArg2 )
		: TaskObject( Pparent , TP_BUTTON , handle_enabled , tRect )
	{
		this->iFontSize = iFontSize ;
		this->strCaption = strCaption ;
		this->pFunc = pFunc ;
		this->pvArgument1 = pvArg1 ;
		this->pvArgument2 = pvArg2 ;

		iDragging = 0  ;
		UpdateXY() ;
		this->InitFuncCalled() ;
		Finit();
		TaskObjectManager::RequestRedraw() ;
	}
	TaskObjectButton() : TaskObject(){;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;
	void UpdateXY() ;

	int iFontSize ;
	tstring strCaption ;
	void (*pFunc)( void* , void* ) ;
	void *pvArgument1 ;
	void *pvArgument2 ;

	int iDragging ;
private:
} ;

#endif /*TASK_GUI_HEADER_INCLUDED*/
