	.inesprg $10 ;プログラムバンク数
	.ineschr $10 ;キャラクタバンク数
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman3.prgchr"

BANKORG_D .macro
	.bank (\1>>16)
	.org (\1&$FFFF)
	.endm

END_BOUNDARY_TEST	.macro
CurrentPosition\@:
	.IF ((CurrentPosition\@)&$FFFF)>((\1)&$FFFF)
	.FAIL ;END_BOUNDARY_TEST \1
	.ENDIF
	.endm


	;停止撃ち
	BANKORG_D $1ECEFA
	jsr $D09B
	lda <$31
	pha
	jmp $CEEE

	;着地撃ち
	BANKORG_D $1ED08F
	stx <$30
	jsr $CF55
	lda #$0D
	jsr TouchDown_Shot
	bit <$00

	;エアブレーキのVy
	BANKORG_D $1ED006
	bmi AirBrakeVy_ResetRushFlag
	BANKORG_D $1ED00A
	bne AirBrakeVy_ResetRushFlag_End
	bit <$16
	bmi $D018
	stx $0460+0
	jsr AirBrake_Do
	nop
AirBrakeVy_ResetRushFlag:
	stx <$3A
AirBrakeVy_ResetRushFlag_End

	;振り向き撃ち
	BANKORG_D $1ED0FC
	jmp TurnProc

	;モーションバグ修正
	;サブ画面を閉じたときのAni値変更時
	BANKORG_D $02A152
	jsr SetAniNo_ResetMotion

	;登場時の棒ワープにAni値変更時
	BANKORG_D $1ECA68
	jsr SetAniNo_ResetMotion

	;スライディングのAni値変更時
	BANKORG_D $1ED3AF
	jsr SetAniNo_ResetMotion



	;以下は適当に空きスペースに向けてください
	;この場所が空いているかどうかも検討していませんが……
	BANKORG_D $1FFFCF
AirBrake_Do:
	lda #$3F
	sta $0440+0
	rts

TouchDown_Shot:
	jsr $F835 ;Obj[x]のAni値=a/各種リセット
	inc $05A0
	rts
TurnProc:
	lda <$16 ;PadHold1P[ABETUDLR;
	and #$03
	beq .end
	sta <$31
	lsr a
	lda $0580
	and #~$40
	bcc .L
	ora #$40
.L
	sta $0580
.end
	jmp [$0000]
SetAniNo_ResetMotion:
	stx <$32 ;姿勢変化タイマー
	jmp $F835 ;Obj[x]のAni値=a/各種リセット
	END_BOUNDARY_TEST $1FFFFA

