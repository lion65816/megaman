	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;[2]�����݂��Ă��Ȃ�
	bit A_ObjFlag+2 ;���E�H�H�e�d�H��
	bmi .secrts
	ldx #$02
	ldy #$03
	jsr R_CreateWeapon
	lda #$39
	jsr R_SoundOn
	dec A_WeaponEnergy+3-1
	jmp $DA87 ;�V���b�g�p���ŃV���b�g�����I��
;	jmp $DC4A ;�����p���ŃV���b�g�����I��
.secrts
	sec
	rts
