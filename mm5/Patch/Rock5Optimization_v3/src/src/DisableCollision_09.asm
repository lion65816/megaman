DisableCollision_MoveXY_Stone2:
	jsr rXpmeVx
	jsr rYpmeVy
	bit vEnableEraser
	bmi .rts
	lda <vCurWeapon
	cmp #$06
	beq .rts
	jmp SkipCollision_SkipDamage
.rts
	rts

