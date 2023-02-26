	.inesprg $20 ;プログラムバンク数
	.ineschr $00 ;キャラクタバンク数
	.inesmir 0 ;

	.inesmap 4

	.include "src/[]switch.asm"
	.bank 0
	.org $0000
	.incbin "rockman6.prg"

	.include "mylib_r6.asm"
	BANKORG_D $008000
	.include "src/label.asm"


	.include "src/pool.asm"

	.IF SW_DebugTestMap
	.include "TEST_MAP.asm"
	.ENDIF
