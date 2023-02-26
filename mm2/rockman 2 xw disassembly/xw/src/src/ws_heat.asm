	lda <V_PadOn ; RLDUTEBA
	and #$02
	beq .secrts
	lda A_ObjFlag+2 ;存右？？弾重？当
	bmi .secrts
	ldx #$02
	ldy #$01
	jsr R_CreateWeapon
	lda #$82
	sta A_ObjFlag+2 ;存右？？弾重？当
	dec A_WeaponEnergy+1-1
	lda #10
	sta <V_WeaponEnergyCounter
	jmp $DA87 ;ショット姿勢でショット処理終了
.secrts
	sec
	rts
