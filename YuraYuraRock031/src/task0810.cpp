#include "task0810.h"
#include <assert.h>


TASKHANDLE Task0810::handle_next = 1 ;
 

static Task0810 *PtrTable[TASK0810_HANDLE_TABLE_SIZE] ;
//static TASKHANDLE HandleTable[TASK0810_HANDLE_TABLE_SIZE] ;
static bool tableinit = false ;

static void TableInit()
{
	for( int i=0 ; i<TASK0810_HANDLE_TABLE_SIZE ; i++ )
	{
//		HandleTable[i] = 0x00000000 ;
		PtrTable[i] = NULL ;
	}
	tableinit = true ;
}

Task0810 *Task0810::SolveHandle( TASKHANDLE ihandle )
{
	if( !tableinit )TableInit();
	Task0810 *Ptmp ;
	Ptmp = PtrTable[ ihandle & TASK0810_HANDLE_MASK ] ;
	if( !Ptmp )return NULL ;
	//Ptmpは確実に存在するタスク
	if( Ptmp->handle == ihandle )return Ptmp ;
	return NULL ;
}

TASKHANDLE Task0810::SearchTask( TaskP ifrom , TaskP ifor , int iSkip )
{
	if( ifor == TP_NOVALUE )ifor = ifrom ;

	Task0810 *Ptmp ;
	for( Ptmp = PCheadTask ; Ptmp ; Ptmp=Ptmp->PnextTask )
	{
		if( Ptmp->GetKind() >= ifrom && Ptmp->GetKind() <= ifor && !(Ptmp->flag&TASK_DEATH_RESERVED) )
		{
			if( iSkip--<=0 )
				{return Ptmp->GetHandle() ; }
		}
	}
	return 0 ;
}


#ifdef _DEBUG

void Task0810::Debug_GetHandleState( int *PValidHandle , int *PNOHandle , Task0810 ***PAPptr )
{
	int nov = 0 ;
	for( int i=0 ; i<TASK0810_HANDLE_TABLE_SIZE ; i++ )
	{
		if( PtrTable[i] ) nov++ ;
	}
	(*PValidHandle) = nov ;
	(*PNOHandle) = TASK0810_HANDLE_TABLE_SIZE ;
	(*PAPptr) = PtrTable ;
}


#endif

Task0810::Task0810( Task0810 *Pparent , TaskP itaskp , bool handle_enabled )
{
	if( !tableinit )TableInit();

	PCheadTask =
	PCtailTask = NULL ;
	PparentTask = Pparent ;
	kind = itaskp ;
	flag = TASK_DEFAULT ;
	if( handle_enabled )
	{
		flag |= TASK_HOLD_HANDLE ;

		//空きを探す
		{
			TASKHANDLE i ;
			for( i=handle_next ; i<handle_next+(unsigned int)TASK0810_HANDLE_TABLE_SIZE ; i++ )
			{
				if( !PtrTable[i&TASK0810_HANDLE_MASK] )
				{
					handle = i ;
					PtrTable[i&TASK0810_HANDLE_MASK] = this ;
//					HandleTable[i&TASK0810_HANDLE_MASK] = i ;
					handle_next = i+1 ;
					i = -1 ;
					break ;
				}
			}
			if( i != -1 )
			{
				//ハンドルに空きスペース無し
				//（本当は、なにかエラーを返すべき！）
				flag &= ~TASK_HOLD_HANDLE ;
			}
		}
	}
	else
	{
		handle = 0 ;
	}

	x = y = 0 ;

	if( !Pparent )
	{
		PprevTask =
		PnextTask = NULL ;
	}
	else
	{
		Pparent->SetChildPointer( this , &PprevTask , &PnextTask ) ;
	}
}
Task0810::Task0810()
{
	assert( 0 ) ;
}

void Task0810::SetChildPointer( Task0810 *Pdest , Task0810 **PPp , Task0810 **PPn )
{
	if( !PCheadTask )
	{
		PCheadTask = 
		PCtailTask = Pdest ;
		(*PPp) =
		(*PPn) = NULL ;
		return ;
	}
	Task0810 *Ptmp , *Pprev ;
	Pprev = NULL ;
	for( Ptmp=PCheadTask ; ; Pprev=Ptmp,Ptmp=Ptmp->PnextTask )
	{
		if( !Ptmp )
		{//一番後ろに追加
			assert( Pprev );//１回はループしているはず
#ifdef _DEBUG
			//そいつの後ろは不在のはず
			assert( !Pprev->Debug_GetPnextTask() ) ;
#endif
			Pprev->SetNextPointer( Pdest ) ;
			(*PPp) = Pprev ;
			(*PPn) = NULL ;
			assert( PCtailTask == Pprev ) ;
			PCtailTask = Pdest ;
			return ;
		}
		if( Ptmp->GetKind() > Pdest->GetKind() )
		{//Pprev と Ptmp の間に追加
			if( !Pprev )
			{//最初に追加
#ifdef _DEBUG
				//そいつの前は不在のはず
				assert( !Ptmp->Debug_GetPprevTask() ) ;
#endif
				Ptmp->SetPrevPointer( Pdest ) ;
				(*PPp) = NULL ;
				(*PPn) = Ptmp ;
				assert( PCheadTask == Ptmp ) ;
				PCheadTask = Pdest ;
				return ;
			}
			//中ほどに追加
#ifdef _DEBUG
			//互いに参照しているはず
			assert( Pprev->Debug_GetPnextTask() == Ptmp && Ptmp->Debug_GetPprevTask() == Pprev ) ;
#endif
			Ptmp ->SetPrevPointer( Pdest ) ;
			Pprev->SetNextPointer( Pdest ) ;
			(*PPp) = Pprev ;
			(*PPn) = Ptmp ;
			return ;
		}
	}
	assert( 0 ) ;
	return ;
}
void Task0810::SetNextPointer( Task0810 *Pdest )
{
	PnextTask = Pdest ;
}
void Task0810::SetPrevPointer( Task0810 *Pdest )
{
	PprevTask = Pdest ;
}

void Task0810::DoCN()
{
	//初回実行
	if( !(flag&TASK_INIT_CALLED) )
	{
		flag |= TASK_INIT_CALLED ;
		Finit() ;
	}

	//次に実行するタスクを控えておく(削除される可能性がある)
	Task0810 *pNext = PnextTask ;

	for(;;)
	{
		if( flag&TASK_DEATH_RESERVED )
		{
			Dispose() ;
			break ;
		}
		if( !(flag&TASK_SLEEP) && !(flag&TASK_SLEEP_PROCESS))
		{
			//子供より前に実行
			flag |= TASK_CALLED_BEFORE_CHILD ;
			if( flag&TASK_PROCESS_BEFORE_CHILD )Fmain() ;
			if( flag&TASK_DEATH_RESERVED )
			{
				Dispose() ;
				break ;
			}
			//子供実行
			if( PCheadTask )PCheadTask->DoCN() ;
			if( flag&TASK_DEATH_RESERVED )
			{
				Dispose() ;
				break ;
			}
			//子供より後の実行
			flag &= ~TASK_CALLED_BEFORE_CHILD ;
			if( flag&TASK_PROCESS_AFTER_CHILD )Fmain() ;
			if( flag&TASK_DEATH_RESERVED )
			{
				Dispose() ;
				break ;
			}
		}
		break ;
	}
	//次を実行
	if( pNext )pNext->DoCN() ;
}
void Task0810::DrawCN()
{
	if( !(flag&(TASK_SLEEP|TASK_SLEEP_DRAW|TASK_DEATH_RESERVED))  )
	{
		//子供より前に描画
		flag |= TASK_DRAWN_BEFORE_CHILD ;
		if( flag&TASK_DRAW_BEFORE_CHILD )Fdraw() ;
		//子供描画
		if( PCheadTask )PCheadTask->DrawCN() ;
		//子供より後の描画
		flag &= ~TASK_DRAWN_BEFORE_CHILD ;
		if( flag&TASK_DRAW_AFTER_CHILD )Fdraw() ;
	}
	//次を実行
	if( PnextTask )PnextTask->DrawCN() ;
}
void Task0810::DrawCP()
{
	if( !(flag&(TASK_SLEEP|TASK_SLEEP_DRAW|TASK_DEATH_RESERVED))  )
	{
		//子供より前に描画
		flag |= TASK_CALLED_BEFORE_CHILD ;
		if( flag&TASK_DRAW_BEFORE_CHILD )Fdraw() ;
		//最後尾の子供描画
		if( PCtailTask )PCtailTask->DrawCP() ;
		//子供より後の描画
		flag &= ~TASK_CALLED_BEFORE_CHILD ;
		if( flag&TASK_DRAW_AFTER_CHILD )Fdraw() ;
	}
	//次を実行
	if( PprevTask )PprevTask->DrawCP() ;
}


void Task0810::DetachChild( Task0810 *Pdest )
{
	Task0810 *Ptmp,*Ppre ;
	Ppre = NULL ;
	for( Ptmp = PCheadTask ; Ptmp ; Ppre=Ptmp,Ptmp=Ptmp->PnextTask )
	{
		if( Ptmp == Pdest )
		{
			Task0810 *Pnext ;
			Pnext = Ptmp->PnextTask ;
			if( Ppre )
			{
				if( Pnext )
				{
					Ppre->SetNextPointer( Pnext ) ;
					Pnext->SetPrevPointer( Ppre ) ;
					assert( PCheadTask != Ptmp ) ;
					assert( PCtailTask != Ptmp ) ;
				}
				else
				{
					Ppre->SetNextPointer( NULL ) ;
					assert( PCheadTask != Ptmp ) ;
					assert( PCtailTask == Ptmp ) ;
					PCtailTask = Ppre ;
				}
			}
			else
			{
				if( Pnext )
				{
					Pnext->SetPrevPointer( NULL ) ;
					assert( PCheadTask == Ptmp ) ;
					assert( PCtailTask != Ptmp ) ;
					PCheadTask = Pnext ;
				}
				else
				{
					assert( PCheadTask == Ptmp ) ;
					assert( PCtailTask == Ptmp ) ;
					PCtailTask = Ppre ;
					PCheadTask = Pnext ;
				}
			}
			return ;
		}
	}
#ifdef _DEBUG
	assert(0) ;
#endif

}

void Task0810::KillP( TaskP org , TaskP end )
{
	Task0810 *Ptmp ;
	for( Ptmp = PCheadTask ; Ptmp ;  )
	{
		if( Ptmp->kind > end )break ;
		if( Ptmp->kind >= org )
		{
			Task0810 *Pkill ;
			Pkill = Ptmp ;
			Ptmp=Ptmp->PnextTask ;
			Pkill->ReserveDeath() ;
			continue ;
		}
		Ptmp=Ptmp->PnextTask ;
	}
}
void Task0810::Kill( Task0810 *Pdest )
{
	Task0810 *Ptmp ;
	for( Ptmp = PCheadTask ; Ptmp ; Ptmp=Ptmp->PnextTask )
	{
		if( Ptmp == Pdest )
		{
			Ptmp->ReserveDeath() ;
			return ;
		}
	}
#ifdef _DEBUG
	assert(0) ;
#endif
}
void Task0810::Dispose()
{
	Fdest() ;

	//子供たちを始末
//	KillP( TP_HIGHEST , TP_LOWEST ) ;
	{
		Task0810 *pTmp , *pPre ;
		for( pTmp = PCheadTask ; pTmp ; pTmp=pPre )
		{
			pPre = pTmp->PnextTask ;
			pTmp->Dispose() ; 
		}
	}

	//親のポインタを修正
	if( PparentTask )
	{
		PparentTask->DetachChild( this ) ;
	}
	//前後の関係を整える
	if( PprevTask )
	{
		if( PnextTask )
		{
			PprevTask->SetNextPointer( PnextTask ) ;
			PnextTask->SetPrevPointer( PprevTask ) ;
		}
		else
		{
			PprevTask->SetNextPointer( NULL ) ;
		}
	}
	else
	{
		if( PnextTask )
		{
			PnextTask->SetPrevPointer( NULL ) ;
		}
		else
		{

		}
	}
	//ハンドルを削除
	if( flag & TASK_HOLD_HANDLE )
	{
		PtrTable[handle&TASK0810_HANDLE_MASK] = NULL ;
	}

	delete this ;
	return ;
}


