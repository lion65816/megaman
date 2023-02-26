	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;[2,3][4,5][6,7]がセットで存在していない
	ldx #$02
.seekloop
	lda A_ObjFlag+0,x ;存右？？弾重？当
	ora A_ObjFlag+1,x ;存右？？弾重？当
	bpl .found
	inx
	inx
	cpx #$08
	bne .seekloop
	beq .secrts
.found
	ldy #$07
	jsr R_CreateWeapon
	lda #$23
	jsr R_SoundOn
	lda A_ObjFlag,x ;存右？？弾重？当
	ora #$02
	sta A_ObjFlag,x ;存右？？弾重？当
	dec A_WeaponEnergy+7-1
	jmp $DA87 ;ショット姿勢でショット処理終了
;	jmp $DC4A ;投擲姿勢でショット処理終了
.secrts
	sec
	rts
