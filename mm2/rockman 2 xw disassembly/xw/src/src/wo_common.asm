FIELD_TEST:
	lda A_ObjXhi,x
	sta <$08
	lda A_ObjXhe,x
	sta <$09
	lda A_ObjYhi,x
	sta <$0A
	lda #$00
	sta <$0B
	jsr R_FieldTest ;�n�`(9~8,B~A)�̑����擾
	ldx <V_ProcessingObj
	ldy <$00
;�N���b�V���{���̔���e�[�u�����Q�Ƃɂ���
	lda $E14C,y
	rts



