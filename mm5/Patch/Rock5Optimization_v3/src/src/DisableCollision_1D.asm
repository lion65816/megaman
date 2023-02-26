DisableCollision_2E:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	jmp $966A
DisableCollision_58:
	sta oXhe,x
	;Å´
DisableCollision_Bank1D_Skip:
	jmp SkipCollision
DisableCollision_B6B7:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	lda oType,x
	jmp $AE45
DisableCollision_5B:
	lda #HIGH(SkipCollision_Bullet-1)
	pha
	lda #LOW (SkipCollision_Bullet-1)
	pha
	jmp $84FC
DisableCollision_B8:
	cmp #$04
	beq .EndAnim
	jmp SkipCollision
.EndAnim
	jmp $AE60
DisableCollision_4E7F:
	jsr rYpmeVy
	lda oYhe,x
	bne .delete
	jmp SkipCollision_Bullet_MoveX
.delete
	jmp rDeleteObjX
DisableCollision_MoveXY_Stone:
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
DisableCollision_24:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	jmp $977D
DisableCollision_BF:
	lda #HIGH(SkipCollision-1)
	pha
	lda #LOW (SkipCollision-1)
	pha
	lda oYhi,x
	and #$0F
	beq .DoTest
	lda oVal0,x
	beq .DoTestInc
	jmp rYmeVy
.DoTestInc
	inc oVal0,x
.DoTest
	jmp $9BF3

