
	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;[2]��[3,4,5,6,7]�̂����A[2]�����݂��Ă��Ȃ�
	lda A_ObjFlag+2 ;���E�H�H�e�d�H��
	bmi .secrts
	ldx #$02
	ldy #$08
	jsr R_CreateWeapon
	lda #$21
	jsr R_SoundOn
	lda A_ObjFlag+2 ;���E�H�H�e�d�H��
	ora #$02
	sta A_ObjFlag+2 ;���E�H�H�e�d�H��
	dec A_WeaponEnergy+6-1
	jmp $DA87 ;�V���b�g�p���ŃV���b�g�����I��
;	jmp $DC4A ;�����p���ŃV���b�g�����I��
.secrts
	sec
	rts
