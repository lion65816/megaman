AtRoomScrolling_Body:
	.IF Enable_WRAMMap
	jsr WRAMMap_LoadMap
	.ENDIF

	rts
