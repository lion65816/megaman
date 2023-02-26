	SETBANKA000
DisableCollision_CF:
	sta oYhi,x
	jmp SkipCollision_SkipDamage
DisableCollision_6F:
	sta oYhi,x
DisableCollision_20_Skip:
	jmp SkipCollision
DisableCollision_74:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	lda oVal2,x
	jmp $B036
DisableCollision_74_2:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	jmp $B099
DisableCollision_74_3:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	jmp $B0D5
DisableCollision_20_1:
	jsr rHitTestToRock
	bcs DisableCollision_20_Skip
	jmp $A020
DisableCollision_20_2:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	jmp $A0CB
DisableCollision_20_3:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	jmp $A1A4
DisableCollision_96:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	jmp $BD89
