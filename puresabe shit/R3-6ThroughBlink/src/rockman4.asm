	.inesprg $20 ;�v���O�����o���N��
	.ineschr $00 ;�L�����N�^�o���N��
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman4.prg"
	.include "mylib.asm"

	BANKORG_D $3A815C
	jsr BOSS_THROUGH_PROC


	;���炭�g���Ă��Ȃ��|���Z�̃��[�`���B
	;�����g���Ă�����N���b�V�����邯�ǁc�c
	;�g���Ă��Ȃ��Ƃ��������́A���[�`�����o�O���Ă邩��B
	BANKORG_D $3FFC7B
BOSS_THROUGH_PROC:
	lda $0132 ;�{�X�Q�[�W
	bpl .DoHitProc
	cpx $0146 ;�{�X�������Ă���G�̔ԍ�
	bne .DoHitProc
	;�{�X�Ƀq�b�g
	lda $05b8,x ;Obj�ꎞ��~�E�ꎞ�_��[0]
	bmi .DoHitProc
	beq .DoHitProc
	;�{�X�Q�[�W���o�Ă���
	;�����������肪�{�X�����̃I�u�W�F�N�g��
	;�_�ł��Ă���Ƃ��͏������s��Ȃ�
	rts
.DoHitProc
	jmp $82A4
;	Addr<=3FFC9E

