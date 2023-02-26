	.inesprg $08 ;プログラムバンク数
	.ineschr $00 ;キャラクタバンク数
	.inesmir 1 ;

	.inesmap 2

	.bank 0
	.org $0000

	.incbin "rockman1.prg"
	.include "mylib.asm"


;●方針
;（１）ヒットフラグは、ヒット時に下ろすようにする。
;　　　デフォルトでは、２フレームに１回下ろされている
;（２）無敵時間を導入する。
;　　　ヒットフラグが受理されたときに無敵発生。
;　　　無敵時間中は、ヒット自体を無効にし、武器もスルーする
;（３）無敵時間は、普段はヒットフラグを下ろしている部分でデクリメント。


;ヒットしていないときのとび先を少々修正
	BANKORG_D $0BBE56
	beq $BE5E

;ヒット時に命中フラグを下ろす
	BANKORG_D $0BBEC2
	asl $0420,x ;フラグ
	lsr $0420,x ;フラグ

;無敵時間のセット
;本来は0か1かという処理であることに留意すること
;大きな値にしても、それなりにはまともに動作する。
;（……誰も得しないですが）
	BANKORG_D $0BBEE6+1
	.db 2

;命中ビットをOFFにする処理の代わりに
;無敵時間デクリメント
	BANKORG_D $0BA261
	TRASH_GLOBAL_LABEL
	ldx #$1F
.DecThroughTime_loop
	lda $0580,x ;無敵時間
	beq .DecThroughTime_next
	dec $0580,x ;無敵時間
.DecThroughTime_next
	dex
	cpx #$0F
	bne .DecThroughTime_loop
	beq $A277
;	Addr <=0BA277

;無敵スルー
	BANKORG_D $0EC9A1
	jmp MUTEKI_THROUGH

;未使用領域だと信じて利用
	BANKORG_D $0FFF00
MUTEKI_THROUGH:
	lda $0580,x ;無敵時間
	bne .through
	asl $0420,x ;フラグ
	sec
	ror $0420,x ;フラグ
	jmp $C9A9
.through
	rts
