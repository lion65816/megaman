	.inesprg $10 ;�v���O�����o���N��
	.ineschr $00 ;�L�����N�^�o���N��
	.inesmir 1   ;�~���[�����O
	.inesmap 1   ;�}�b�p�[

	;�v���ϐ�NES_INCLUDE
	.include "mylib_r2.asm"

	;ROM�ǂݍ���
	BANKORG_D $000000
	.incbin "rockman2.prg"

	.include "src/main.asm"


