;by rock5_lite/Rock5easily

Misc_R5E_org:
;{●最適化


	.IF Enable_JoypadOmission
;------------------------------------------------
; パッド入力読み取り処理軽量化(2Pを無視する)
;------------------------------------------------
	BANKORG_D $1EC2E5
ReadPad:
	ldx	#$01
	stx	$4016
	dex
	stx	$4016

	ldx	#$04
.LOOP
	lda	$4016
	lsr	a
	rol	<$14
	lsr	a
	rol	<$00
	lda	$4016
	lsr	a
	rol	<$14
	lsr	a
	rol	<$00
	dex
	bne	.LOOP

	lda	<$00
	ora	<$14
	sta	<$14

	tay
	eor	<$16
	and	<$14
	sta	<$14
	sty	<$16
CheckCrossKey1
	lda	<$14
	and	#$0C
	cmp	#$0C
	beq	.ClearCrossKey
	lda	<$14
	and	#$03
	cmp	#$03
	bne	CheckCrossKey2
.ClearCrossKey
	lda	<$14
	and	#$F0
	sta	<$14
CheckCrossKey2
	lda	<$16
	and	#$0C
	cmp	#$0C
	beq	.ClearCrossKey
	lda	<$16
	and	#$03
	cmp	#$03
	bne	.Return
.ClearCrossKey
	lda	<$16
	and	#$F0
	sta	<$16
.Return
	rts
ReadPadEnd:
	.ENDIF

	.IF Enable_DebugModeOmission
;------------------------------------------------
; デバッグモード確認処理スキップ
;------------------------------------------------
	.IF !Enable_WRAMMap ;※WRAMMapと衝突します
	BANKORG_D $1EC4A4
	jmp	$C4AD

	BANKORG_D $1EC5AD
	jmp	$C5B6
	.ENDIF


	BANKORG_D $1EDE73
	jmp	$DE7F

	BANKORG_D $1EDF2A
	jmp	$DF47
	.ENDIF

	.IF Enable_UpdateOAMPointer
;------------------------------------------------
; OAMテーブルポインタ更新処理軽量化
;------------------------------------------------
	BANKORG_D $1FE1F3
UpdateOAMOffset:
	inx
	inx
	inx
	inx
	beq	.R
.Next
	dec	<$04
	bpl	$E19F
.R
	stx	<$9F
	rts
	; E200
	iny
	lda	#$F8
	sta	$200,x
	bne	.Next
	.ENDIF


	.IF Enable_ObjMoveLR
;------------------------------------------------
; オブジェクトの右移動処理軽量化
;------------------------------------------------
	BANKORG_D $1FE8E6
Move_Right:
	lda	$318,x
	clc
	adc	$3A8,x
	sta	$318,x
	lda	$330,x
	adc	$3C0,x
	sta	$330,x
	bcc	.R
	inc	$348,x
.R
	rts

;------------------------------------------------
; オブジェクトの左移動処理軽量化
;------------------------------------------------
	BANKORG_D $1FE90C
Move_Left:
	lda	$318,x
	sec
	sbc	$3A8,x
	sta	$318,x
	lda	$330,x
	sbc	$3C0,x
	sta	$330,x
	bcs	.R
	dec	$0348,x
.R
	rts
	.ENDIF

	.IF Enable_Rock2ObjCollision
;------------------------------------------------
; ロックマンとオブジェクトの接触判定処理軽量化
;------------------------------------------------
	BANKORG_D $1FEF87
Collision_Check:
	sec
	lda	$0528
	bpl	.R
	lda	$390
	ora	$390,x
	bne	.R
	lda	$0528,x
	bpl	.R
	and	#$04
	bne	.R
	lda	$408,x
	and	#$3F
	tay
	lda	$330
	; sec			; 必ずC=1なので省略
	sbc	$330,x
	pha
	lda	$348
	sbc	$348,x
	sta	<$00
	pla
	bcs	.Check_X
.Calc_Abs
	eor	#$FF
	adc	#$01
	pha
	lda	<$00
	eor	#$FF
	adc	#$00
	sta	<$00
	pla
.Check_X
	cmp	$F0F1,y
	bcs	.R
	sec
	lda	<$00
	bne	.R

	lda	$F0B1,y
	sta	<$00
	lda	$0558
	cmp	#$14
	beq	.Fix_val
	lda	<$30
	cmp	#$02
	bne	.Check_Y
.Fix_val
	lda	<$00
	;sec			; 必ずC=1なので省略
	sbc	#$07
	sta	<$00
.Check_Y
	lda	$378
	sec
	sbc	$378,x
	bcs	.Compare_val
	eor	#$FF
	adc	#$01
.Compare_val
	cmp	<$00
.R
	rts
	.ENDIF

	.IF Enable_BankSwitch
;------------------------------------------------
; PRGバンク切り替え処理軽量化
;------------------------------------------------
	BANKORG_D $1FFF43
Switch_Bank:
	inc	<$F7		; In PRG changeをインクリメント
	lda	#$06		; Last MMC3 commandに#$06をセット
	sta	<$F2		; |
	sta	$8000		;MMC3 Selector/Command Set
	lda	<$F5		;
	;sta	<$F3		; ゲーム中ロードされることがないのでコメントアウト
	sta	$8001		;MMC3 SetPageNumber
	lda	#$07		;
	sta	<$F2		;
	sta	$8000		;MMC3 Selector/Command Set
	lda	<$F6		;
	;sta	<$F4		; ゲーム中ロードされることがないのでコメントアウト
	sta	$8001		;MMC3 SetPageNumber
	dec	<$F7		; In PRG changeをデクリメント
	lda	<$F8		; Postponed PRG changeをロード
	bne	$FF68		; 0でなければ$FF68にジャンプ
	rts
	.ENDIF

;}●最適化
;{●機能改善
	.IF Enable_WeaponSelect
	BANKORG_D $1EDE95+1
	.db $30

	BANKORG_D $1EDEA4
	nop			;
	lda	<$14		; スタートボタンを押しているならばZ=0
	and	#$10		; |
	jsr	Misc_WeaponSelect_Main		; 下の処理を呼び出す

	.ENDIF

	.IF Enable_BossRoomJump ;{
	BANKORG_D $1B8759
BossRoomJump_CMove_0F_Main:
	ldy	#$00		; Yレジスタに#$00をロード
	jsr	$E7B7		; Y方向に(ブロックにめり込まないように)移動(重力加算有り？)、上下のブロックにぶつかったらキャリー1？
	bcc	BossRoomJump_cm0F_L1		; めり込んでいなければ$8794にジャンプ
	
	lda	#$04		;
BossRoomJump_cm0F_L8:
	cmp	$0558		;
	beq	BossRoomJump_cm0F_L6		;
	jsr	$EA98		;
	
BossRoomJump_cm0F_L6:
	lda	#BANK(BossRoomJump_cm0F_L7)		;
	sta	<$F6		;
	jsr	$FF43		;
	jmp	BossRoomJump_cm0F_L7		;
BossRoomJump_cm0F_R1:
	rts			;
BossRoomJump_cm0F_L1:
	lda	#$07		;
	ldy	$0468		;
	;cpy	#$80		;
	beq	BossRoomJump_cm0F_L8		;
	
	lda	$03F0		; ロックマンのY方向速度(high)をロード
	bpl	BossRoomJump_cm0F_R1		; 非負ならばリターン
	lda	#$78		; #$78 ≧ ロックマンのY座標(low) ならばリターン
	cmp	$0378		; |
	bcs	BossRoomJump_cm0F_R1		; |
	sta	$0378		; ロックマンのY座標(low)に#$78をセット
	lda	$0498		; ロックマンの変数Aをロード
	bne	BossRoomJump_JumpToL4	; 0でなければ$8801にジャンプ
	lda	$0480		; ロックマンの変数Bをロード
	cmp	#$80		; #$80でなければ$87B6にジャンプ
	bne	BossRoomJump_JumpToL5	; |
	inc	<$30		;
	jmp	$EA1E		; xのY方向速度をFF.00にセットする

BossRoomJump_JumpToL4:
	jmp	BossRoomJump_cm0F_L4		;
BossRoomJump_JumpToL5:
	jmp	BossRoomJump_cm0F_L5		;


	BANKORG_D $1B87B6
BossRoomJump_cm0F_L5:

	BANKORG_D $1B8801
BossRoomJump_cm0F_L4:

	BANKORG_DB $1B87FA,$98
	BANKORG_DB $1B8802,$98

	.ENDIF ;}

	.IF Enable_6BitAttribute ;{
	.IF !Enable_WRAMMap ;{
	BANKORG_DB $1EC551+1,$FC
	BANKORG_DB $1EC659+1,$FC
	BANKORG_DB $1EC770+1,$FC
	.ENDIF ;}
	
; すべる床用
	BANKORG_D $1B81DB
	jsr	SixBitAttr_Slip1	; 歩行・停止時
	
	BANKORG_D $1B827B
	jsr	SixBitAttr_Slip2	; 着地時

	BANKORG_D $1B82E5
	jsr	SixBitAttr_Slip3	; スライディング中
	
	BANKORG_D $1B8498
	jsr	SixBitAttr_Slip4_R	; 後ずさり中

	BANKORG_D $1B849F
	jsr	SixBitAttr_Slip4_L	; 後ずさり中

	BANKORG_D $1B964C
SixBitAttr_Main:
	php			; ステータスレジスタをスタックにプッシュ
	lda	<$49		; インデックス1のBlock types in each tested positionをロード
	pha			; スタックにプッシュ
	lda	<$11		; $11の値をスタックにプッシュ
	pha			; |

	lda	#$00		;
	sta	$122		;

	lda	<$39		; Platform directionをロード
	bne	$9684		; 0でなければ$9684にジャンプ
	bcs	.L		; キャリーが1(地面に足がついている)なら$965Cにジャンプ
	jmp	$96E5		; $96E5にジャンプ

.L
	jmp	SixBitAttr_Main2

;	BANKORG_D $1B9664
SixBitAttr_ConveyorSpeedTable:
	.dw	$0080
	.dw	$0100
	.dw	$0180
	.dw	$0200

; 下からジャンプして乗れるブロック
	BANKORG_D $1FE822
	jmp	SixBitAttr_AttributeC0Chk1
	
	BANKORG_D $1FE8C2
	jmp	SixBitAttr_AttributeC0Chk2
	
	BANKORG_D $1FE777
	jmp	SixBitAttr_AttributeC0Chk3

	; 下から上はスルー
	;BANKORG_D $1FE7AE
	;jmp	AttributeC0Chk4

	.ENDIF ;}

	.IF Enable_SpriteAutoCoordination ;{
	; ここからプログラム
	BANKORG_D $1FE17B
	; beq	$E182			; 元の処理
	; rts				;
	jmp	SprAutCd_BANK1F_SpritePatternEx
	.ENDIF ;}

;}●機能改善
	BANKORG Misc_R5E_org
