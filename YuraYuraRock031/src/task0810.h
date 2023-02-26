/*
	いろいろ破綻した、自称タスクシステムのルーチン。
	本当にタスクシステムなんだかよくわからない。
	を、すこし改良したタスクシステム。のようなもの。
*/


#ifndef TASK0810_HEADER_INCLUDED
#define TASK0810_HEADER_INCLUDED

#include <windows.h>

#ifndef TASK0810_NO_TASK_PRIORITY_HEADER_INCLUDE
#include "TaskP.h"
#endif


#define	TASK0810_HANDLE_TABLE_SIZE_BITS		9
#define	TASK0810_HANDLE_TABLE_SIZE			(1<<TASK0810_HANDLE_TABLE_SIZE_BITS)
#define TASK0810_HANDLE_MASK				(TASK0810_HANDLE_TABLE_SIZE-1)
#define TASK0810_HANDLE_MASK_DUP			(~TASK0810_HANDLE_MASK)


typedef unsigned __int32 TASKHANDLE ;

//タスクのフラグ
#define	TASK_SLEEP					0x0001
#define	TASK_SLEEP_PROCESS			0x0002
#define	TASK_SLEEP_DRAW				0x0004
#define TASK_HOLD_HANDLE			0x0010
#define TASK_DEATH_RESERVED			0x0020
#define TASK_INIT_CALLED			0x0040
#define TASK_PROCESS_BEFORE_CHILD	0x0100
#define TASK_PROCESS_AFTER_CHILD	0x0200
#define TASK_DRAW_BEFORE_CHILD		0x0400
#define TASK_DRAW_AFTER_CHILD		0x0800
#define TASK_CALLED_BEFORE_CHILD	0x1000 //↓
#define TASK_DRAWN_BEFORE_CHILD		0x1000 //この２つは共通

#define	TASK_DEFAULT				(TASK_PROCESS_BEFORE_CHILD | TASK_DRAW_AFTER_CHILD )


class Task0810 ;

class Task0810
{
public:
	Task0810( Task0810 *Pparent , TaskP itaskp , bool handle_enabled ) ;
	Task0810() ;

	TaskP GetKind(){return kind;}
	TASKHANDLE GetHandle(){return handle;}

	void DoCN() ; //子供と、次のメイン関数も実行。子供の前後に自分の関数も実行
	void DrawCN() ; //子供と、次の描画。子供の前後に自分も描画。
	void DrawCP() ; //最後尾の子供と、前の描画。子供の前後に自分も描画。
	void KillP( TaskP org , TaskP end ) ;
	static void KillP( TASKHANDLE hHandle , TaskP org , TaskP end )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
			{ pTask->KillP( org , end ) ;}
	}

	void Kill( Task0810 *Pdest ) ;
	void Kill( TASKHANDLE hHandleDest )
	{
		if( Task0810 *pTask = SolveHandle( hHandleDest ) )
			{ Kill( pTask ) ;}
	}
	static void Kill( TASKHANDLE hHandle , TASKHANDLE hHandleDest )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
			{ pTask->Kill( hHandleDest ) ;}
	}

	//タスクを寝かす
	void Sleep(){flag|=TASK_SLEEP;};
	static void Sleep( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->Sleep() ;}
		return ;
	}
	//タスクを起こす
	void Wake(){flag&=~TASK_SLEEP;};
	static void Wake( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->Wake() ;}
		return ;
	}
	//タスク処理を寝かす
	void SleepProcess(){flag|=TASK_SLEEP_PROCESS;};
	static void SleepProcess( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->SleepProcess() ;}
		return ;
	}
	//タスク処理を起こす
	void WakeProcess(){flag&=~TASK_SLEEP_PROCESS;};
	static void WakeProcess( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->WakeProcess() ;}
		return ;
	}
	//タスク描画を寝かす
	void SleepDraw(){flag|=TASK_SLEEP_DRAW;};
	static void SleepDraw( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->SleepDraw() ;}
		return ;
	}
	//タスク描画を起こす
	void WakeDraw(){flag&=~TASK_SLEEP_DRAW;};
	static void WakeDraw( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->WakeDraw() ;}
		return ;
	}
	//自殺予約
	void Suicide(){flag|=TASK_DEATH_RESERVED;};
	void ReserveDeath(){flag|=TASK_DEATH_RESERVED;};
	static void ReserveDeath( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->ReserveDeath() ;}
		return ;
	}

	void SetProcessOrderPandC( bool ProcessBeforeChild , bool ProcessAfterChild )
	{
		flag &= ~(TASK_PROCESS_BEFORE_CHILD|TASK_PROCESS_AFTER_CHILD) ;
		flag |= (ProcessBeforeChild*TASK_PROCESS_BEFORE_CHILD)|(ProcessAfterChild*TASK_PROCESS_AFTER_CHILD ) ;
	}
	void SetDrawOrderPandC( bool DrawBeforeChild , bool DrawAfterChild )
	{
		flag &= ~(TASK_DRAW_BEFORE_CHILD|TASK_DRAW_AFTER_CHILD) ;
		flag |= (DrawBeforeChild*TASK_DRAW_BEFORE_CHILD)|(DrawAfterChild*TASK_DRAW_AFTER_CHILD ) ;
	}
	bool IsProcessingBeforeChild()
	{
		if( flag&TASK_CALLED_BEFORE_CHILD )return true ;
		return false ;
	}
	bool IsDrawingBeforeChild()
	{
		if( flag&TASK_DRAWN_BEFORE_CHILD )return true ;
		return false ;
	}


	TASKHANDLE SearchTask( TaskP ifrom , TaskP ifor = TP_NOVALUE , int iSkip=0 );
	static TASKHANDLE SearchTask( TASKHANDLE hHandle , TaskP ifrom , TaskP ifor = TP_NOVALUE , int iSkip=0 )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->SearchTask( ifrom , ifor , iSkip ) ;}
		return 0 ;
	}


	TASKHANDLE GetParentHandle() { if(!PparentTask)return 0; return PparentTask->GetHandle() ; }
	TASKHANDLE GetParentHandleN( int iTimes )
	{
		Task0810 *pTask = this ;
		for( ; pTask && iTimes>0 ; iTimes-- )
		{
			pTask = pTask->PparentTask ;
		}
		if( !pTask )
			{ return 0 ; }
		return pTask->GetHandle() ;
	}
	static TASKHANDLE GetParentHandle( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
					{ return pTask->GetParentHandle() ;}
		return 0 ;
	}
	static TASKHANDLE GetParentHandleN( TASKHANDLE hHandle , int iTimes )
	{
		for( ; iTimes>0 ; iTimes-- )
		{
			hHandle = GetParentHandle( hHandle ) ;
		}
		return hHandle ;
	}

	
	static Task0810 *SolveHandle( TASKHANDLE ihandle ) ;

	//親をたどっていき、x,yを足し続ける
	//たどる回数を指定したいときは、depthを与える（デフォルトでは、ルートまで）
	void GetGlobalPosition( INT32 *Pox , INT32 *Poy , int depth=0 )
	{
Task0810 *Ptmp;
__int32 tx,ty;
		tx = ty = 0 ;
		for( Ptmp = this ; Ptmp ; Ptmp=Ptmp->PparentTask )
		{
			tx += Ptmp->x ;
			ty += Ptmp->y ;
			depth -- ;
			if( !depth ) break;
		}
		*Pox = tx ;
		*Poy = ty ;
	}
	static void GetGlobalPosition( TASKHANDLE hHandle , INT32 *Pox , INT32 *Poy , int depth=0 )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ pTask->GetGlobalPosition( Pox , Poy , depth ) ;}
	}

#ifdef _DEBUG
	static void Debug_GetHandleState( int *PValidHandle , int *PNOHandle , Task0810 ***PAPptr ) ;
#endif


protected:
	__int32 x;
	__int32 y;

	~Task0810(){;};
	virtual void Finit(){;}; //タスク作成時関数
	virtual void Fmain(){;}; //タスク関数
	virtual void Fdest(){;}; //デストラクタ関数
	virtual void Fdraw(){;}; //描画関数

	//もう初期化関数は呼んだ
	void InitFuncCalled(){flag|=TASK_INIT_CALLED;};

/*
	Task0810 *GetPrevTask(){ return PprevTask ; }
	Task0810 *GetNextTask(){ return PnextTask ; }
	Task0810 *GetCheadTask(){ return PCheadTask ; }
	Task0810 *GetCtailTask(){ return PCtailTask ; }
	Task0810 *GetParentTask(){ return PparentTask ; }
*/
private:
	TaskP kind;                 //TCBの優先・種類

	unsigned __int16 flag;      //フラグ

	TASKHANDLE handle ;

	Task0810 *PprevTask;        //前のタスク
	Task0810 *PnextTask;        //次のタスク
	Task0810 *PCheadTask;       //子供の先頭
	Task0810 *PCtailTask;       //子供の最後尾
	Task0810 *PparentTask;      //親

	void Dispose() ;
	void SetChildPointer( Task0810 *Pdest , Task0810 **PPp , Task0810 **PPn ) ;
	void DetachChild( Task0810 *Pdest ) ;
	void SetNextPointer( Task0810 *Pdest ) ;
	void SetPrevPointer( Task0810 *Pdest ) ;
#ifdef _DEBUG
	Task0810 *Debug_GetPprevTask  (){return PprevTask  ;}
	Task0810 *Debug_GetPnextTask  (){return PnextTask  ;}
	Task0810 *Debug_GetPCheadTask (){return PCheadTask ;}
	Task0810 *Debug_GetPCtailTask (){return PCtailTask ;}
	Task0810 *Debug_GetPparentTask(){return PparentTask;}
#endif

	static TASKHANDLE handle_next ;
};


#endif /* TASK0810_HEADER_INCLUDED */
