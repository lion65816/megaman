
	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;[2]�����݂��Ă��Ȃ�
	lda A_ObjFlag+2 ;���E�H�H�e�d�H��
	bmi .secrts
	ldx #$02
	ldy #$06
	jsr R_CreateWeapon
	lda A_ObjFlag+2 ;���E�H�H�e�d�H��
	ora #$02
	sta A_ObjFlag+2 ;���E�H�H�e�d�H��
	lda #$2E
	jsr R_SoundOn
	dec A_WeaponEnergy+8-1
	jmp $DA87 ;�V���b�g�p���ŃV���b�g�����I��
.secrts
	sec
	rts
