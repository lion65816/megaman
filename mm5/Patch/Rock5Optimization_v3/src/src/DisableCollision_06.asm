DisableCollision_6A_2:
	jsr rSetupPolarVelocity
	jmp SkipCollision_Bullet
DisableCollision_6C:
	lda #HIGH(SkipCollision_Bullet-1)
	pha
	lda #LOW (SkipCollision_Bullet-1)
	pha
	jmp $A3C5
DisableCollision_6C_2:
	jsr $E968
	jmp SkipCollision_Bullet
