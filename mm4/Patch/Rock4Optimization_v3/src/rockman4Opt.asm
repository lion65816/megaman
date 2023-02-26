	.inesprg $20 ;プログラムバンク数
	.ineschr $00 ;キャラクタバンク数
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000
	.incbin "rockman4.prg"
	.bank 0
	.org $0000
	.include "src/_main.asm"
