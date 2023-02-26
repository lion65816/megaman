;by Rock5easily

	.IF Enable_6BitAttribute ;{

; 下からジャンプして乗れるブロック
SixBitAttr_AttributeC0Chk1:
	lda	<$42		;
	and	#$70		;
	cmp	#$40		;
	jmp	$E826
SixBitAttr_AttributeC0Chk2:
	lda	<$42		;
	and	#$70		;
	cmp	#$40		;
	jmp	$E8C6

SixBitAttr_AttributeC0Chk3:		; 下方向移動
	and	#$10		;
	bne	SixBitAttr_AC0_R1		;
	lda	<$42		;
	
	cmp	#$C0		;
	beq	SixBitAttr_AC0_R1		;
	clc
	rts			;
SixBitAttr_AC0_R1:
	jmp	$E77B		;

;SixBitAttr_AttributeC0Chk4:		; 上方向移動
;	and	#$10		;
;	bne	AC0_R2		;
;	lda	<$42		;
;	cmp	#$C0		;
;	beq	AC0_R2		;
;	clc
;	rts			;
;SixBitAttr_AC0_R2:
;	jmp	$E7B2		;

SixBitAttr_Main2:
; ベルトコンベア処理
	lda	#$01		; Platform directionに#$01(右)をセット
	sta	<$39		; |
	lda	<$49		; インデックス1のBlock types in each tested positionをロード
	tay			; A -> Y
	and	#$F0		; 上位4bit取り出し

	cmp	#$50		; #$50(コンベア右)ならば$967Cにジャンプ
	beq	SixBitAttr_SetConveyorSpeed		; |
	cmp	#$70		; #$70(コンベア左)ならば$967Aにジャンプ
	beq	SixBitAttr_L1		; |
	cmp	#$90		; #$90(すべる床)ならば
	beq	SixBitAttr_SlipBlock_Main	; |
	
	lda	<$48		; インデックス0のBlock types in each tested positionをロード
	cmp	<$49		; インデックス1のBlock types in each tested positionと等しくないなら$9672にジャンプ
	bne	SixBitAttr_L2		; |
	lda	<$4A		; インデックス2のBlock types in each tested positionをロード
SixBitAttr_L2:
	tay			; A -> Y
	and	#$F0		; 上位4bit取り出し
	
	cmp	#$50		; #$50なら$967Cにジャンプ
	beq	SixBitAttr_SetConveyorSpeed		; |
	cmp	#$70		; #$70でなければ$96C0にジャンプ
	beq	SixBitAttr_L1		; |
	cmp	#$90		; #$90(すべる床)ならば
	beq	SixBitAttr_SlipBlock_Main	; |
	
	lda	#$00		;
	sta	<$5C		;
SixBitAttr_JumpTo96C0:
	jmp	$96C0		;
SixBitAttr_L1:
	inc	<$39		; Platform directionをインクリメント(#$02=左にする)

; ベルトコンベアの速度
SixBitAttr_SetConveyorSpeed:
	tya			; Y -> A
	lsr	a		;
	and	#$06		;
	tay			;
	lda	SixBitAttr_ConveyorSpeedTable,y
	sta	<$3A		; |
	lda	(SixBitAttr_ConveyorSpeedTable+1),y
	sta	<$3B		; |
	jmp	$9684		;

; すべる床の処理
; $5C -> 方向(01 -> 右, 02 -> 左)
; $122 -> すべったかフラグ
; $120-121 -> 速度

SixBitAttr_SlipBlock_Main:
	lda	<$30		; 地面着地中でなければ無効
	bne	SixBitAttr_JumpTo96C0	; |

	lda	<$5C		; すべるなら.L1にジャンプ
	bne	.L1		; |
	
	lda	$0558		; ロックマンのAnimationが#$04,05でなければリターン
	cmp	#$04		; |
	beq	.L3		; |
	cmp	#$05		; |
	bne	SixBitAttr_JumpTo96C0	; |
.L3
	lda	<$31		; すべる方向セット
	sta	<$5C		; |

.L1
	lda	<$16		; キー入力方向 <> すべる方向 ならすべる
	and	#$03		; |
	cmp	<$5C		; |
	bne	.L4		; |

	lda	#$4C		; すべる速度セット
	sta	$120		; |
	lda	#$01		; |
	sta	$121		; |
	jmp	$96C0		;
.L4
	lda	$120		; [$120-121] := [$120-121] - #$0003
	sec			; |
	sbc	#$02		; |
	sta	$120		; |
	lda	$121		; |
	sbc	#$00		; |
	sta	$121		; |

	bcs	.L2		;
	lda	#$00		;
	sta	<$5C		;
	sta	$120		;
	sta	$121		;
	beq	SixBitAttr_JumpTo96C0	;
.L2
	inc	$122		;
	
	lda	<$5C		;
	sta	<$39		;
	lda	$120		;
	sta	<$3A		;
	lda	$121		;
	sta	<$3B		;
	jmp	$9684		;



SixBitAttr_Slip1:
	;lda	<$31		;
	lda	$122		; すべったかフラグ
	beq	.L1		; すべってなければ普通にX方向移動
	jmp	$EC30		; グラフィックの向きを方向データに合わせる
.L1
	jmp	$EA3F		; X方向移動

SixBitAttr_Slip2:
	ldy	#$00		; 着地時にすべる方向クリア
	sty	<$5C		; |
	jmp	$EA98		; アニメーション番号セット

SixBitAttr_Slip3:
	lda	<$5C		; 滑る床で滑っているか
	beq	.L		; 滑っていなければ普通にX方向移動
	lda	<$31		; 滑る床で滑る方向をスライディング方向に合わせる
	sta	<$5C		; |
.L
	jmp	$EA3F		; X方向移動

SixBitAttr_Slip4_R:		; 後ずさり中
	lda	<$5C		;
	beq	.L		;
	lda	#$01		;
	sta	<$5C		;
.L
	jmp	$E6C7		;
SixBitAttr_Slip4_L:		; 後ずさり中
	lda	<$5C		;
	beq	.L		;
	lda	#$02		;
	sta	<$5C		;
.L
	jmp	$E708		;

	.ENDIF ;}
	
	.IF Enable_SpriteAutoCoordination ;{
	; スプライトパターン展開の自動協調
SprAutCd_BANK1F_SpritePatternEx:
	bne	.CheckBank
	jmp	$E182			; ジャンプ元で潰した処理を実行
.CheckBank
	txa				; もう一方のBANKを選択
	eor	#$01			; |
	tax				; |
	lda	<$EC,x			; もう一方のBANKも使用済みなら処理終了
	bmi	.Main			; |
	cmp	[$02],y			; |
	bne	.R			; |
.Main
	lda	[$02],y
	sta	<$EC,x
	ldy	#$01
	lda	[$02],y
	sta	<$04
	iny
	lda	[$02],y
	tax
	lda	$8400,x
	sec
	sbc	#$03
	sta	<$05
	lda	$8500,x
	sbc	#$00
	sta	<$06
	ldx	<$9F
	bne	.Loop
.R
	rts
.Loop
	iny
	lda	[$02],y			; スプライトパターン番号を計算
	eor	#$40			; |
	sta	$0201,x
	lda	[$05],y
	sta	<$07
	lda	<$10
	bpl	.CalcY
	lda	#$F8
	sec
	sbc	<$07
	sta	<$07
.CalcY
	lda	<$12
	clc
	adc	<$07
	sta	$0200,x
	lda	<$07
	bmi	.L1
	bcc	.L2
	bcs	.NotDrawn1
.L1
	bcc	.NotDrawn1
.L2
	iny
	lda	[$02],y
	eor	<$10
	ora	<$11
	sta	$0202,x
	lda	[$05],y
	sta	<$07
	lda	<$10
	and	#$40
	beq	.CalcX
	lda	#$F8
	sec
	sbc	<$07
	sta	<$07
.CalcX
	lda	<$13
	clc
	adc	<$07
	sta	$0203,x
	lda	<$07
	bmi	.L3
	bcc	.L4
	bcs	.NotDrawn2
.L3
	bcc	.NotDrawn2
.L4
	inx
	inx
	inx
	inx
	stx	<$9F
	beq	.R
.Next
	dec	<$04
	bpl	.Loop
	rts

.NotDrawn1
	iny
.NotDrawn2
	lda	#$F8
	sta	$0200,x
	bne	.Next
	.ENDIF ;}
