	.inesprg $10 ;プログラムバンク数
	.ineschr $10 ;キャラクタバンク数
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman3.prgchr"
	.include "mylib.asm"

	;音を鳴らす部分を飛ばす
	BANKORG_D $1C811D
	beq $8149

	;音を鳴らすルーチンは不要になったのでつぶす
	BANKORG_D $1C8144
	.db $00,$00,$00,$00,$00

	;無敵かどうかで分岐
	BANKORG_D $1C81BB
	jsr BLINK_THROUGH_SUB
	nop
	nop
;	BANKORG_D $1C81BD
;	jmp $F89A

;デバッグの、転落死無効化の部分。
	BANKORG_D $1FF0B3
	beq $F0B9
	.db $00,$00,$00,$00
	BANKORG_D $1FF0D1
HIT_SOUND:
	lda <$00
	pha
	lda <$01
	pha
	lda #$18
	jsr $F89A
	pla
	sta <$01
	pla
	sta <$00
	rts
;	Addr<=1FF0E6

;デバッグの、スローの部分。
;（ちなみにクロック数節約にもなる）
	BANKORG_D $1FF145
	bne $F157
BLINK_THROUGH_SUB:
	beq .SoundOn
	pla
	pla
	jmp $823F
.SoundOn
	jmp HIT_SOUND


;	Addr<=1FF157


