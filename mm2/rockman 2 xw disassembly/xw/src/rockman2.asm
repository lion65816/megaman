	.inesprg $10 ;�v���O�����o���N��
	.ineschr $00 ;�L�����N�^�o���N��
	.inesmir 1 ;

	.inesmap 1

	.bank 0
	.org $0000

	.incbin "rockman2.prg"
	.include "mylib.asm"
	.include "src/main.asm"

