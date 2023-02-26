DisableCollision_8A:
	lda #HIGH(SkipCollision_Bullet-1)
	pha
	lda #LOW (SkipCollision_Bullet-1)
	pha
	jmp $A18D
DisableCollision_8B:
	lda #HIGH(SkipCollision_Bullet-1)
	pha
	lda #LOW (SkipCollision_Bullet-1)
	pha
	jmp $A1AA
