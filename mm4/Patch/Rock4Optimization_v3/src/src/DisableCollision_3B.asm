	SETBANKA000
DisableCollision_C1:
	jsr rHitTestToRock
	bcs .NoHit
	jmp $BC59
.NoHit
DisableCollision_9D_Skip:
DisableCollision_66_Skip:
	jmp SkipCollision
DisableCollision_9D:
	bne DisableCollision_9D_Skip
	jmp rDeleteObjX
DisableCollision_66:
	dec oYhi,x
	beq .Suicide
	lda <vCurRaster
	bne .ForceHitTest
	lda oVal0,x
	beq .ForceHitTest
	lda oYhi,x
	and #$0F
	cmp #$0F
	bne DisableCollision_66_Skip
.ForceHitTest
	inc oVal0,x
	ldy #$23
	jsr $D2FC
	lda <$10
	cmp #$60
	beq DisableCollision_66_Skip
.Suicide
	jmp rDeleteObjX
DisableCollision_B5:
	sta oHitFlag,x
	jmp SkipCollision

