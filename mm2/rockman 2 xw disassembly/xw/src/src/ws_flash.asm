
	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;[2]と[3,4,5,6,7]のうち、[2]が存在していない
	lda A_ObjFlag+2 ;存右？？弾重？当
	bmi .secrts
	ldx #$02
	ldy #$08
	jsr R_CreateWeapon
	lda #$21
	jsr R_SoundOn
	lda A_ObjFlag+2 ;存右？？弾重？当
	ora #$02
	sta A_ObjFlag+2 ;存右？？弾重？当
	dec A_WeaponEnergy+6-1
	jmp $DA87 ;ショット姿勢でショット処理終了
;	jmp $DC4A ;投擲姿勢でショット処理終了
.secrts
	sec
	rts
