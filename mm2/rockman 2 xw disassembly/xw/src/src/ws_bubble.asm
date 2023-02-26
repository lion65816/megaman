

	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	ldx #$02
	lda A_ObjFlag,x ;存右？？弾重？当
	bpl .found
	inx
	lda A_ObjFlag,x ;存右？？弾重？当
	bmi .secrts
.found
	ldy #$04
	jsr R_CreateWeapon
	lda <V_FrameCounter
	and #$0F
	sta A_ObjVal0,x
	lda #$3B
	jsr R_SoundOn
	dec <V_WeaponEnergyCounter
	beq .not_consume
	inc <V_WeaponEnergyCounter
	inc <V_WeaponEnergyCounter
	dec <A_WeaponEnergy+4-1
.not_consume
	jmp $DA87 ;ショット姿勢でショット処理終了
.secrts
	sec
	rts
