	SETBANK8000
StageInit_Body:
	.IF SW_WRAMMap
	jsr WRAMMap_LoadMapParam
	jsr WRAMMap_LoadMap_Ent
	.ENDIF
	.IF SW_DisableCollision
	lda #$00
	sta vEnableSkull
	.ENDIF
	.IF SW_EffectEnemyEx
	lda #$00
	sta <vEffectEnemyEx
	.ENDIF
	rts
