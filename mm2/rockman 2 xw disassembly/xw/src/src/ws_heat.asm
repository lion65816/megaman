	lda <V_PadOn ; RLDUTEBA
	and #$02
	beq .secrts
	lda A_ObjFlag+2 ;���E�H�H�e�d�H��
	bmi .secrts
	ldx #$02
	ldy #$01
	jsr R_CreateWeapon
	lda #$82
	sta A_ObjFlag+2 ;���E�H�H�e�d�H��
	dec A_WeaponEnergy+1-1
	lda #10
	sta <V_WeaponEnergyCounter
	jmp $DA87 ;�V���b�g�p���ŃV���b�g�����I��
.secrts
	sec
	rts
