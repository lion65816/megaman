	.inesprg $20 ;�v���O�����o���N��
	.ineschr $00 ;�L�����N�^�o���N��
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000
	.incbin "rockman4.prg"
	.bank 0
	.org $0000
	.include "src/_main.asm"
