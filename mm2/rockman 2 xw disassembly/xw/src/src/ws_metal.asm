	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;[2,3][4,5][6,7]���Z�b�g�ő��݂��Ă��Ȃ�
	ldx #$02
.seekloop
	lda A_ObjFlag+0,x ;���E�H�H�e�d�H��
	ora A_ObjFlag+1,x ;���E�H�H�e�d�H��
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
	lda A_ObjFlag,x ;���E�H�H�e�d�H��
	ora #$02
	sta A_ObjFlag,x ;���E�H�H�e�d�H��
	dec A_WeaponEnergy+7-1
	jmp $DA87 ;�V���b�g�p���ŃV���b�g�����I��
;	jmp $DC4A ;�����p���ŃV���b�g�����I��
.secrts
	sec
	rts
