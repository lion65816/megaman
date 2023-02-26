	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .clcrts
	ldx #$02
.SeekLoop
	lda A_ObjFlag+2,x ;存右？？弾重？当
	bpl .found
	dex
	bpl .SeekLoop
	bmi .secrts
.found
	inx
	inx
	ldy #$05
	jsr R_CreateWeapon
	lda #$31
	jsr R_SoundOn
	dec A_WeaponEnergy+5-1
	jmp $DA87 ;ショット姿勢でショット処理終了
;	jmp $DC4A ;投擲姿勢でショット処理終了
.clcrts
.secrts
	sec
	rts
