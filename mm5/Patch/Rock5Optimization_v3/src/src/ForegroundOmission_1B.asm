;by rock5_lite/Rock5easily
;※　本来定位置に置いておくべきテーブルの位置が
;　　可変になってしまっているのだが、たぶんどうにかしてくれるだろう。


ForegroundOmission_Org:
	BANKORG_D $1B9795
	jmp	UsingFG_Check

	BANKORG ForegroundOmission_Org
FG_table:
	.db	$00,$00,$01,$01,$00,$00,$01,$00
	.db	$00,$01,$00,$00,$00,$00,$01,$00

UsingFG_Check:
	ldy	<$26
	lda	FG_table,y
	bne	.Using
.NotUsing
	jmp	$97C1			; 背景裏に隠れる処理の次の処理へジャンプ
.Using
	lda	<$9D			; 潰した処理を実行して元の場所へジャンプ
	lsr	a			; |
	jmp	$9798			; |
