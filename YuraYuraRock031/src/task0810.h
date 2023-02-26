/*
	���낢��j�]�����A���̃^�X�N�V�X�e���̃��[�`���B
	�{���Ƀ^�X�N�V�X�e���Ȃ񂾂��悭�킩��Ȃ��B
	���A���������ǂ����^�X�N�V�X�e���B�̂悤�Ȃ��́B
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

//�^�X�N�̃t���O
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
#define TASK_CALLED_BEFORE_CHILD	0x1000 //��
#define TASK_DRAWN_BEFORE_CHILD		0x1000 //���̂Q�͋���

#define	TASK_DEFAULT				(TASK_PROCESS_BEFORE_CHILD | TASK_DRAW_AFTER_CHILD )


class Task0810 ;

class Task0810
{
public:
	Task0810( Task0810 *Pparent , TaskP itaskp , bool handle_enabled ) ;
	Task0810() ;

	TaskP GetKind(){return kind;}
	TASKHANDLE GetHandle(){return handle;}

	void DoCN() ; //�q���ƁA���̃��C���֐������s�B�q���̑O��Ɏ����̊֐������s
	void DrawCN() ; //�q���ƁA���̕`��B�q���̑O��Ɏ������`��B
	void DrawCP() ; //�Ō���̎q���ƁA�O�̕`��B�q���̑O��Ɏ������`��B
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

	//�^�X�N��Q����
	void Sleep(){flag|=TASK_SLEEP;};
	static void Sleep( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->Sleep() ;}
		return ;
	}
	//�^�X�N���N����
	void Wake(){flag&=~TASK_SLEEP;};
	static void Wake( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->Wake() ;}
		return ;
	}
	//�^�X�N������Q����
	void SleepProcess(){flag|=TASK_SLEEP_PROCESS;};
	static void SleepProcess( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->SleepProcess() ;}
		return ;
	}
	//�^�X�N�������N����
	void WakeProcess(){flag&=~TASK_SLEEP_PROCESS;};
	static void WakeProcess( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->WakeProcess() ;}
		return ;
	}
	//�^�X�N�`���Q����
	void SleepDraw(){flag|=TASK_SLEEP_DRAW;};
	static void SleepDraw( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->SleepDraw() ;}
		return ;
	}
	//�^�X�N�`����N����
	void WakeDraw(){flag&=~TASK_SLEEP_DRAW;};
	static void WakeDraw( TASKHANDLE hHandle )
	{
		if( Task0810 *pTask = SolveHandle( hHandle ) )
				{ return pTask->WakeDraw() ;}
		return ;
	}
	//���E�\��
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

	//�e�����ǂ��Ă����Ax,y�𑫂�������
	//���ǂ�񐔂��w�肵�����Ƃ��́Adepth��^����i�f�t�H���g�ł́A���[�g�܂Łj
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
	virtual void Finit(){;}; //�^�X�N�쐬���֐�
	virtual void Fmain(){;}; //�^�X�N�֐�
	virtual void Fdest(){;}; //�f�X�g���N�^�֐�
	virtual void Fdraw(){;}; //�`��֐�

	//�����������֐��͌Ă�
	void InitFuncCalled(){flag|=TASK_INIT_CALLED;};

/*
	Task0810 *GetPrevTask(){ return PprevTask ; }
	Task0810 *GetNextTask(){ return PnextTask ; }
	Task0810 *GetCheadTask(){ return PCheadTask ; }
	Task0810 *GetCtailTask(){ return PCtailTask ; }
	Task0810 *GetParentTask(){ return PparentTask ; }
*/
private:
	TaskP kind;                 //TCB�̗D��E���

	unsigned __int16 flag;      //�t���O

	TASKHANDLE handle ;

	Task0810 *PprevTask;        //�O�̃^�X�N
	Task0810 *PnextTask;        //���̃^�X�N
	Task0810 *PCheadTask;       //�q���̐擪
	Task0810 *PCtailTask;       //�q���̍Ō��
	Task0810 *PparentTask;      //�e

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
