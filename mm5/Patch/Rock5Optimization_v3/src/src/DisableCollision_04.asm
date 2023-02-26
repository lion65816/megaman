;DisableCollision_47:
;	lda #HIGH(SkipCollision_Bullet-1)
;	pha
;	lda #LOW (SkipCollision_Bullet-1)
;	pha
;	jmp $A538
DisableCollision_A6:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	jmp $A16A
DisableCollision_A7:
	lda #HIGH(SkipCollision_Bullet-1)
	pha
	lda #LOW (SkipCollision_Bullet-1)
	pha
	jmp $A1AA
DisableCollision_A8:
	lda #HIGH(SkipCollision_Bullet-1)
	pha
	lda #LOW (SkipCollision_Bullet-1)
	pha
	jmp $A1D9
