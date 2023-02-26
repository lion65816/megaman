#ifndef TASKPRIORITY_HEADER_INCLUDED
#define TASKPRIORITY_HEADER_INCLUDED
enum TaskP
{
	TP_NONE=-3,
	TP_NOVALUE=-2,
	TP_HIGHEST=-1,
////////////////////////
	TP_APP_MANAGER ,
	TP_FRAMEINIT ,
		TP_AlertManager ,
#include "TaskGUI1206/TaskGUI1206_Prio.h"

		TP_MODE_MANAGER ,
			TP_FirstInfo ,
			TP_RomModeManager ,
			TP_StageSelectionMode ,
			TP_MainMode ,
				TP_ChipEditor ,
				TP_VChipEditor ,
				TP_MapEditor ,
					TP_UILayer ,
				TP_ObjectEditor ,
				TP_SpEditor ,
				TP_ColorEditor ,
					TP_ColorEditor_sub ,
				TP_GraphicsBankEditor ,
				TP_R1_VariableField ,
				TP_R1_GraphicsBank ,
				TP_LockTileEditor ,
				TP_LockPageEditor ,
//AddHere:TaskPriority

	TP_FRAMEEND ,
////////////////////////
	TP_LOWEST=0x7FFF,
};
#endif /* TASKPRIORITY_HEADER_INCLUDED */
