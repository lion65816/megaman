;ステージ突入時の処理
AtEnteringStage_org:

	BANKORG $3EDC58
	LONG_CALL AtEnteringStage_Body
	;使ってよさげの変数
	;00
	;08 09 (3A8032)
	;0A-0F (スプライト処理)
	;11 12 (3A8252)
	;15 16 (3ECB28)

	BANKORG AtEnteringStage_org
	SETBANK8000
AtEnteringStage_Body:
	sta $0680
	jsr $DC6A ;ゲーム画面を復元
	;↑元処理

	.IF SW_OptimizeTerrain
;●マップ読み込み{
	lda <vCurBnkA
	pha ;0

	;ページの読み込み
	lda <vMapBankA
	jsr rBankCngXA ;(*,a)にバンク切り替え
	lda <aAddrPage+0
	sta <$00
	lda <aAddrPage+1
	sta <$01
	lda #LOW (aPage)
	sta <$02
	lda #HIGH(aPage)
	sta <$03
	lda #$07
	sta <$04
	ldy #$00
.LoadPage_loop_o
.LoadPage_loop_i
	lda [$00],y
	sta [$02],y
	iny
	bne .LoadPage_loop_i
	inc <$01
	inc <$03
	dec <$04
	bpl .LoadPage_loop_o

	;タイル/チップ定義(400)の読み込み
	lda <vMapBank8
	jsr rBankCngXA ;(*,a)にバンク切り替え
	lda #$03
	sta <$00

	lda #$00
	sta <$08
	lda <vAddrTileHi
	ora #$20
	sta <$09

	lda #LOW (aTile)
	sta <$0A
	lda #HIGH(aTile)
	sta <$0B

	lda #$00
	sta <$0C
	lda <vAddrChipHi
	ora #$20
	sta <$0D

	lda #LOW (aChip)
	sta <$0E
	lda #HIGH(aChip)
	sta <$0F

	;破壊後
	lda #$00
	sta <$11
	lda #$BB
	sta <$12

	lda #LOW (aChipV)
	sta <$15
	lda #HIGH(aChipV)
	sta <$16

	ldy #$00
.LoadTileChip_loop_o
.LoadTileChip_loop_i
	lda [$08],y
	sta [$0A],y
	lda [$0C],y
	sta [$0E],y
	lda [$11],y
	sta [$15],y
	iny
	bne .LoadTileChip_loop_i
	inc <$09
	inc <$0B
	inc <$0D
	inc <$0F
	inc <$12
	inc <$16
	dec <$00
	bpl .LoadTileChip_loop_o

	;フラグ
;	ldy #$00
.LoadChipFlag_loop
	lda [$0C],y
	sta aChipFlag,y
	lda [$11],y
	sta aChipFlagV,y
	iny
	bne .LoadChipFlag_loop

	;ポインタ差し替え
	lda #HIGH(aChip)
	sta <vAddrChipHi
	lda #HIGH(aTile)
	sta <vAddrTileHi
	lda #LOW (aPage)
	sta <aAddrPage+0
	lda #HIGH(aPage)
	sta <aAddrPage+1

	;バンク戻す
	pla ;0
	jsr rBankCngXA ;(*,a)にバンク切り替え

;●マップ読み込み}
	.ENDIF
	.IF SW_OptimizeTerrain2 ;{
	lda <vScreenXhe
	LONG_CALL Terrain_LoadRoom
	LONG_CALL Terrain_Load16Flag
	.ENDIF ;}
	.IF SW_FixRockMove_HoverJump ;{
	lda #LOW (Rockman_HoverJump_Walk)
	ldy #HIGH(Rockman_HoverJump_Walk)
	ldx <vCurStage
	cpx #$00 ;00だが敢えてcmp0する（変更可能のように）
	bne .NotBlizStage
	lda #LOW (Rockman_HoverJump_Walk_Bliz)
	ldy #HIGH(Rockman_HoverJump_Walk_Bliz)
.NotBlizStage
	sta aProcIsFalling+0
	sty aProcIsFalling+1
	.ENDIF ;}


	.IF SW_NerfedSpike ;{
	lda #$00
	sta vSpikeTouched
	.ENDIF ;}
	rts
