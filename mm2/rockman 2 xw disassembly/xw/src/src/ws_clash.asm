
	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;[2]が存在していない
	lda A_ObjFlag+2 ;存右？？弾重？当
	bmi .secrts
	ldx #$02
	ldy #$06
	jsr R_CreateWeapon
	lda A_ObjFlag+2 ;存右？？弾重？当
	ora #$02
	sta A_ObjFlag+2 ;存右？？弾重？当
	lda #$2E
	jsr R_SoundOn
	dec A_WeaponEnergy+8-1
	jmp $DA87 ;ショット姿勢でショット処理終了
.secrts
	sec
	rts
