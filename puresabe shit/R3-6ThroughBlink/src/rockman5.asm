	.inesprg $10 ;プログラムバンク数
	.ineschr $20 ;キャラクタバンク数
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman5.prgchr"
	.include "mylib.asm"



	BANKORG_D $03A60A ;オクトパー
	jmp BOSS_THROUGH_PROC

	BANKORG_D $04A166 ;ワイリーマシン　無効化した方が良いかもしれないが……
	jmp BOSS_THROUGH_PROC

;	BANKORG_D $0AA557 ;ローリングドリル　スルー無効の方が良いだろう
;	jsr BOSS_THROUGH_PROC

	BANKORG_D $1C807F ;「その他」
	jsr BOSS_THROUGH_PROC

	BANKORG_D $1C8AF0 ;プカプーカーのボディ
	jsr BOSS_THROUGH_PROC

	BANKORG_D $1C9525 ;ダチョーン
	jmp BOSS_THROUGH_PROC

;	BANKORG_D $1DA4F5 ;ジェットボム　おそらく不要
;	jsr BOSS_THROUGH_PROC

	BANKORG_D $1DA645 ;コッコ
	jsr BOSS_THROUGH_PROC

;	BANKORG_D $1DA7ED ;落下クリスタル　おそらく不要
;	jsr BOSS_THROUGH_PROC

	BANKORG_D $1DAA11 ;ユードーン
	jmp BOSS_THROUGH_PROC





	;停止時のループ位置をちょっと調整
	BANKORG_D $1EDE86
	jmp $DE7F

	;メインルーチンのループ位置をちょっと調整
	BANKORG_D $1EDF4C
	jmp $DE7F

	;かなり狭いが……２コンデバッグの停止を潰す
	BANKORG_D $1EDE73
	bne $DE7F
BOSS_THROUGH_PROC:
	lda $05b8,x ;Obj無敵
	bne .rts
	jmp $809D
.rts
	rts
;	Addr<=1EDE7F
