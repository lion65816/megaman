	.inesprg $10 ;�v���O�����o���N��
	.ineschr $20 ;�L�����N�^�o���N��
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000
	.incbin "rockman5.prgchr"
	.bank 0
	.org $0000
	.include "src/_main.asm"

