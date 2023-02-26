	SETBANK8000
StageInit_Body:
	.IF Enable_WRAMMap
	jsr WRAMMap_LoadMapParam
	jsr WRAMMap_LoadMap_Ent
	.ENDIF
	.IF Enable_Disable_Collision
	jsr DisableCollision_SetEraseFlag
	.ENDIF
	rts
