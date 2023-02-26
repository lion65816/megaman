	.inesprg $10 ;プログラムバンク数
	.ineschr $10 ;キャラクタバンク数
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman3.prgchr"
	.include "mylib.asm"

;●ラッシュ捏造バグの修正
;　スパークショック・シャドーブレードで右を押すと
;　持っていなくてもマリンやジェットを選択してしまうバグの修正。
;　02A9EA-02A9FFを利用。

	BANKORG_D $02A3CB
	jmp Fix_RushForgeryGlitch

	BANKORG_D $02A9EA
Fix_RushForgeryGlitch:
	lsr a
	bcs .NotMoveCursor
	asl a
	adc #$06+1
	tay
	lda $00A2,y ;武器エネルギー
	bpl .NotHaveRushAdapter
	jmp $A3CF
.NotHaveRushAdapter
	;ラッシュコイルに合わせる
	lda #$01
	sta <$A1
.NotMoveCursor
	jmp $A477 ;カーソル移動処理終了
	ORG_TEST $02AA00

;●ワイリーステージ以降コンティニュー時カーソルを"CONTINUE"に固定
;　これにより、城登り直しを避ける事が出来る。
;　189FF4-189FFFを利用。
	BANKORG_D $1898BE
	jsr Fix_WilyContinue
	BANKORG_D $189FF4
Fix_WilyContinue:
	lda <$22
	cmp #$0C
	bcs .IsInWilyStage
	jmp $93CE
.IsInWilyStage
	jmp $93DA
	ORG_TEST $8000

;●イエローデビルの判定修正
;　デビルの判定が何もない空間に移動する仕様を変更。
;　目玉の表示の有無により判定が決まるようになる。
	BANKORG_D $12A154
	TRASH_GLOBAL_LABEL
	and #$04
	bne .Nohit
	jsr $8009
	bit $0000
	bit $0000
.Nohit
	ORG_TEST $A161

;●ジャイアントメットールのアイテムの修正
;　ジャイアントメットールがアイテムを落とした時
;　近づくとロックマンが痛がる謎のアイテムになる不具合を修正。
	BANKORG_D $12B480
	TRASH_GLOBAL_LABEL
	pla
	ldy $04E0,x ;ObjHP/Blink
	beq .Hp0
	sta $0480,x ;ObjHitFlag,x
	bne $B4E2
.Hp0
	sty <$F8
	ORG_TEST $B48D

;●フラッシュマンからの連続ダメージ修正
;　ドクロフラッシュが時間を止めたり元に戻したりする時に
;　ノックバックしていると無敵時間がなく連続ダメージを喰らう仕様を修正。
;　ただし、ノックバック中は時が止まらなくなる。
;　04A9F3-04A9FFを利用。
	BANKORG_D $04A0F0
	nop
	jsr FixFlashCombo0
	BANKORG_D $04A1DA
	nop
	jsr FixFlashCombo7

	BANKORG_D $04A9F3
FixFlashCombo0:
	ldy #$00
	beq FixFlashComb_conf
FixFlashCombo7:
	ldy #$07
FixFlashComb_conf:
	;ノックバック中だったら状態を変更しない
	cmp #$06
	beq .NotStopRockman
	sty <$30 ;ロックマンの状態
.NotStopRockman
	rts
	ORG_TEST $04AA00
