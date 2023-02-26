	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;[2]が存在していない
	bit A_ObjFlag+2 ;存右？？弾重？当
	bmi .secrts
	ldx #$02
	ldy #$03
	jsr R_CreateWeapon
	lda #$39
	jsr R_SoundOn
	dec A_WeaponEnergy+3-1
	jmp $DA87 ;ショット姿勢でショット処理終了
;	jmp $DC4A ;投擲姿勢でショット処理終了
.secrts
	sec
	rts
