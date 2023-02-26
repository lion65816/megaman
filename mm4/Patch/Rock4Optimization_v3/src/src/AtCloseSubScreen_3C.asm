	SETBANK8000
AtCloseSubScreen_Body:
	.IF SW_DisableCollision
	jsr DisableCollision_SetSkullFlag
	.ENDIF
	jmp rFadeIn
