	.inesprg $10 ;プログラムバンク数
	.ineschr $00 ;キャラクタバンク数
	.inesmir 1 ;

	.inesmap 1

	.bank 0
	.org $0000

	.incbin "rockman2.prg"
	.include "mylib.asm"
	.include "src/main.asm"

