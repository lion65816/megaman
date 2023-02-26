	.inesprg $20 ;プログラムバンク数
	.ineschr $00 ;キャラクタバンク数
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman4.prg"
	.include "mylib.asm"

	BANKORG_D $3A815C
	jsr BOSS_THROUGH_PROC


	;恐らく使われていない掛け算のルーチン。
	;もし使われていたらクラッシュするけど……
	;使われていないという根拠は、ルーチンがバグってるから。
	BANKORG_D $3FFC7B
BOSS_THROUGH_PROC:
	lda $0132 ;ボスゲージ
	bpl .DoHitProc
	cpx $0146 ;ボス扱いしている敵の番号
	bne .DoHitProc
	;ボスにヒット
	lda $05b8,x ;Obj一時停止・一時点滅[0]
	bmi .DoHitProc
	beq .DoHitProc
	;ボスゲージが出ていて
	;当たった相手がボス扱いのオブジェクトで
	;点滅しているときは処理を行わない
	rts
.DoHitProc
	jmp $82A4
;	Addr<=3FFC9E

