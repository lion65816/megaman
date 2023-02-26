
	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;若干中途半端だが[2-7]を使ううち、[5]の存在が
	;発射可能かどうかの基準になる
	lda A_ObjFlag+5 ;存右？？弾重？当
	bmi .secrts

	ldx #$02
.Shot_loop
	ldy #$02
	jsr R_CreateWeapon
	lda .WaitTable-2,x
	sta A_ObjVal0,x

	inx
	cpx #$08
	bne .Shot_loop


	lda #$27
	jsr R_SoundOn
	dec A_WeaponEnergy+2-1
	jmp $DA87 ;ショット姿勢でショット処理終了
.secrts
	sec
	rts
.WaitTable
	.db 1+4*0
	.db 1+4*1
	.db 1+4*2
	.db 1+4*3
	.db 1+4*4
	.db 1+4*5

