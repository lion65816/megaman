	.inesprg $20 ;プログラムバンク数
	.ineschr $00 ;キャラクタバンク数
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman6.prg"
	.include "mylib.asm"


	BANKORG_D $38909F
	jmp BLINK_THROUGH

	;たぶん未使用の領域
	BANKORG_D $3FFAA9
BLINK_THROUGH:
	lda $0642 ;これが非ゼロだとボスゲージが出るらしい
	beq .delete

	lda <$51 ;現在のステージ
	cmp #$0E ;ボスラッシュ
	beq ._8Boss
	cmp #$08 
	bcc ._8Boss
;後半ボス
	lda $05E7 ;ボスの無敵時間(89ABCDF)
	bne .rts
	beq .delete
;８ボス
._8Boss
	lda $0640 ;ボスの無敵時間(01234567E)
	cmp #$02
	bcs .rts
.delete
	jmp $E45A ;処理中オブジェクト削除
.rts
	rts

