	.inesprg $10 ;プログラムバンク数
	.ineschr $00 ;キャラクタバンク数
	.inesmir 1   ;ミラーリング
	.inesmap 1   ;マッパー

	;要環境変数NES_INCLUDE
	.include "mylib_r2.asm"

	;ROM読み込み
	BANKORG_D $000000
	.incbin "rockman2.prg"

	.include "src/main.asm"


