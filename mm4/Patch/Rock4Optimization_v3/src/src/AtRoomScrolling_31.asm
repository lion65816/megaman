AtRoomScrolling_Body:
	.IF SW_WRAMMap
	jsr WRAMMap_LoadMap
	.ENDIF

	rts
