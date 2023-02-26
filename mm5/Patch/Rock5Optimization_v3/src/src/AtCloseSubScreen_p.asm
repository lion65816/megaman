AtCloseSubScreen_Body:
	.IF Enable_Disable_Collision
	jsr DisableCollision_SetEraseFlag
	.ENDIF
	.IF Enable_WRAMMap
	jsr WRAMMap_AtCloseScreen
	.ENDIF
	jmp rFadeIn
