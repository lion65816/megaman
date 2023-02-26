DisableCollision_84:
	lda #HIGH(SkipCollision_Bullet-1)
	pha
	lda #LOW (SkipCollision_Bullet-1)
	pha
	jmp $A434
