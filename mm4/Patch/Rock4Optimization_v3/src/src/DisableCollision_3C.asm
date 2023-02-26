	SETBANK8000
DisableCollision_SetSkullFlag:
	ldy #$00
	lda <vCurWeapon
	cmp #$0D
	bne .NotSkull
	dey
.NotSkull
	sty vEnableSkull

	rts
