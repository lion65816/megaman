
	jsr R_CommonWeaponProc ;���ʕ��폈��
	jsr FIELD_TEST
	bne .Hit_Wall

	clc
	lda <$0A
	adc #$0C
	sta <$0A
	jsr R_FieldTest ;�n�`(9~8,B~A)�̑����擾
	ldx <V_ProcessingObj
	ldy <$00
	lda $E14C,y ;�b��E�N���b�V���{���̃e�[�u��
	beq .return
;���ɖ�������
	lda #$00
	sta A_ObjVylo,x
	sta A_ObjVyhi,x
	lda <$0A
	and #$F0
	sec
	sbc #$0C
	sta A_ObjYhi,x
.return
	rts
;�ǂɖ�������
.Hit_Wall
	lda A_ObjFlag,x ;���E�H�H�e�d����
	eor #$40
	sta A_ObjFlag,x ;���E�H�H�e�d����
	lda A_ObjVal0,x
	bmi .suicide
	dec A_ObjVal0,x
	rts
.suicide
	lsr A_ObjFlag,x ;���E�H�H�e�d����
	rts
