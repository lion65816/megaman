
	lda <V_PadPush ; RLDUTEBA
	and #$02
	beq .secrts
	;�኱���r���[����[2-7]���g�������A[5]�̑��݂�
	;���ˉ\���ǂ����̊�ɂȂ�
	lda A_ObjFlag+5 ;���E�H�H�e�d�H��
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
	jmp $DA87 ;�V���b�g�p���ŃV���b�g�����I��
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

