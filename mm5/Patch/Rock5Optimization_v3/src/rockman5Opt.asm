	.inesprg $10 ;プログラムバンク数
	.ineschr $20 ;キャラクタバンク数
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000
	.incbin "rockman5.prgchr"
	.bank 0
	.org $0000
	.include "src/_main.asm"

