	.inesprg $20 ;�v���O�����o���N��
	.ineschr $00 ;�L�����N�^�o���N��
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman6.prg"
	.include "mylib.asm"


	BANKORG_D $38909F
	jmp BLINK_THROUGH

	;���Ԃ񖢎g�p�̗̈�
	BANKORG_D $3FFAA9
BLINK_THROUGH:
	lda $0642 ;���ꂪ��[�����ƃ{�X�Q�[�W���o��炵��
	beq .delete

	lda <$51 ;���݂̃X�e�[�W
	cmp #$0E ;�{�X���b�V��
	beq ._8Boss
	cmp #$08 
	bcc ._8Boss
;�㔼�{�X
	lda $05E7 ;�{�X�̖��G����(89ABCDF)
	bne .rts
	beq .delete
;�W�{�X
._8Boss
	lda $0640 ;�{�X�̖��G����(01234567E)
	cmp #$02
	bcs .rts
.delete
	jmp $E45A ;�������I�u�W�F�N�g�폜
.rts
	rts

