

	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	ldx #$02
	lda A_ObjFlag,x ;���E�H�H�e�d�H��
	bpl .found
	inx
	lda A_ObjFlag,x ;���E�H�H�e�d�H��
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
	jmp $DA87 ;�V���b�g�p���ŃV���b�g�����I��
.secrts
	sec
	rts
