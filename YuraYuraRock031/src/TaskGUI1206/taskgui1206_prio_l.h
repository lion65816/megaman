#ifndef TASKPRIORITY_HEADER_INCLUDED
#define TASKPRIORITY_HEADER_INCLUDED
enum TaskP
{
	TP_NONE=-3,
	TP_NOVALUE=-2,
	TP_HIGHEST=-1,
////////////////////////
#include "TaskGUI1206_Prio.h"
	//ここに他の優先度定数が入る


////////////////////////
	TP_LOWEST=0x7FFF,
};
#endif /* TASKPRIORITY_HEADER_INCLUDED */