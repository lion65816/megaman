	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .clcrts
	ldx #$02
.SeekLoop
	lda A_ObjFlag+2,x ;���E�H�H�e�d�H��
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
	jmp $DA87 ;�V���b�g�p���ŃV���b�g�����I��
;	jmp $DC4A ;�����p���ŃV���b�g�����I��
.clcrts
.secrts
	sec
	rts
