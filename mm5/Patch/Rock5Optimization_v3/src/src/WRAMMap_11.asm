	SETBANK8000
WRAMMap_LoadMapParam:
	ldy <vCurStageMain
	lda $D4C2,y
	cpy #$0E
	bne .NotBossRushStage
	ldy <vScrollXPage
	lda $D793,y
.NotBossRushStage
	sta <vCurStageBG
	sta <vNewPrgA
	jsr rPrgBankSwap
	ldy #$00
.loop
	lda $AD00,y
	sta aChipGrp+$000,y
	lda $AE00,y
	sta aChipGrp+$100,y
	lda $AF00,y
	sta aChipGrp+$200,y
	lda $B000,y
	sta aChipGrp+$300,y
	lda $B100,y
	sta aChipHit,y
;	lda #$00
;	sta aMap+$000,y
;	sta aMap+$100,y
;	sta aMap+$200,y
;	sta aMap+$300,y
;	sta aMap+$400,y
;	sta aMap+$500,y
;	sta aMap+$600,y
;	sta aMap+$700,y
;	sta aMap+$800,y
;	sta aMap+$900,y
;	sta aMap+$A00,y
;	sta aMap+$B00,y
;	sta aMap+$C00,y
;	sta aMap+$D00,y
;	sta aMap+$E00,y
;	sta aMap+$F00,y
	dey
	bne .loop
	rts

	SETBANK8000
WRAMMap_LoadMap_Rts:
	rts
WRAMMap_LoadMap:

.aWPtr  = $0A;array2
.vLoops = $0C
.vRPage = $0D
.vWorkE = $0E
.vWorkF = $0F

	lda <vScrollXPage
	sta <.vRPage
	lda <vLastNTDrawDirection
	cmp #$03
	bcs .NotHorizontalScrolling
	;左右スクロール時
	;きれいなやり方だとは思わないが、ロックマンの座標によってどちらのスクロールだか判断する
	;少し処理を入れ替えれば、vLastNTDrawDirectionの値だけで区別できるようにもなるとは思うが。
	dec <.vRPage
	lda oXhi+0
	cmp #$10
	beq WRAMMap_LoadMap_Rts
	inc <.vRPage
	inc <.vRPage
	jsr $D4E2 ;画面左端の描画
;.LeftScrolling
.NotHorizontalScrolling
	lda #$00
.WRAMMap_LoadMap_Ent_conf ;突入時のロードから合流する
	pha

	;分岐/戻る時に、部屋左端以外に出現する時を考慮
	sec
	lda <.vRPage
	sbc <vPageInRoom
	sta <.vRPage
	sta vNTTransferLimit
	and #$0F
	ora #$60
	sta <.aWPtr+1
	lda #$00
	sta <.aWPtr+0
	sta vLoadMap_Step ;ついでに初期化

	;読み込むページ数
	clc
	lda <vPagesOfRoom
	adc #$01
	cmp #$10
	bcc .LoadPagesLT10
	lda #$10
.LoadPagesLT10
	sta <.vLoops
	sec ;+1
	lda vNTTransferLimit
	adc <vPagesOfRoom
	sta vNTTransferLimit

	;処理アドレスを設定
	lda #LOW (WRAMMap_BP_Rts)
	ldy #HIGH(WRAMMap_BP_Rts)
	sta aBusterProc+0
	sty aBusterProc+1
	lda #LOW (WRAMMap_SkipFallStepProc)
	ldy #HIGH(WRAMMap_SkipFallStepProc)
	sta aFallStepProc+0
	sty aFallStepProc+1
	lda #LOW (WRAMMAP_HB_Init_NoExc)
	ldy #HIGH(WRAMMAP_HB_Init_NoExc)
	sta aProcTerrainHB_InitExc+0
	sty aProcTerrainHB_InitExc+1
	lda #LOW (WRAMMAP_VB_Init_NoExc)
	ldy #HIGH(WRAMMAP_VB_Init_NoExc)
	sta aProcTerrainVB_InitExc+0
	sty aProcTerrainVB_InitExc+1
	lda #LOW ($96F9)
	ldy #HIGH($96F9)
	sta aProcRockIntoWater+0
	sty aProcRockIntoWater+1
	lda #LOW ($97C1)
	ldy #HIGH($97C1)
	sta aProcForeground+0
	sty aProcForeground+1

	lda <vCurStageMain
	sta <vNewPrgA
	jsr rPrgBankSwap

	ldy <.vRPage
	ldx $AC00,y
.SeekEnemy_loop
	sec
	lda $AA00,x ;敵Xpage
	sbc <.vRPage
	cmp <vPagesOfRoom
	beq .SeekEnemy_do
	bcs .SeekEnemy_End
.SeekEnemy_do
	lda $AB80,x ;敵配置type
	cmp #$49 ;ジャイロマンステージエレベータ２
	beq .SeekEnemy_GyroEV2
	cmp #$55 ;ダークマン4マネージャ
	beq .SeekEnemy_Darkman4Mng
	cmp #$4B ;ワイリー１のプレス
	beq .SeekEnemy_Wily1Press
	cmp #$59 ;ビッグペッツ
	beq .SeekEnemy_Load2Screen
	cmp #$5C ;サークリングQ9
	beq .SeekEnemy_Load2Screen
	cmp #$5F ;ワイリーマシン
;	beq .SeekEnemy_Load4Screen
	bne .SeekEnemy_Next
.SeekEnemy_Load4Screen
	lda #$04
	.db $2C ;bit $****
.SeekEnemy_Load2Screen
	;ここに命令を追加しない事
	lda #$02
	sta <.vLoops
	jmp .SeekEnemy_Next ;bit命令のせいでbneが使えなくなる本末転倒？
.SeekEnemy_Wily1Press
	lda #$D0
	sta vTerrainHP_SpCd_MaxY
;	lda #$11
	lda #$FF
	sta vTerrainHP_SpCd_SubPage
	jsr .SeekEnemy_SetHPInitEV
	bne .SeekEnemy_Next
.SeekEnemy_Darkman4Mng
	lda #$03 ;3ページ読み込むようにする
	sta <.vLoops
	lda #$C0
	sta vTerrainHP_SpCd_MaxY
	lda #$00
	sta vTerrainHP_SpCd_SubPage
	jsr .SeekEnemy_SetHPInitEV
	bne .SeekEnemy_SetVBInitEV_Next
.SeekEnemy_GyroEV2
	lda #$03 ;3ページ読み込むようにする
	sta <.vLoops
	lda #$C0
	sta vTerrainHP_SpCd_MaxY
	lda #$13
	sta vTerrainHP_SpCd_SubPage
	jsr .SeekEnemy_SetHPInitEV
.SeekEnemy_SetVBInitEV_Next
	lda #LOW (WRAMMAP_VB_Init_EV)
	ldy #HIGH(WRAMMAP_VB_Init_EV)
	sta aProcTerrainVB_InitExc+0
	sty aProcTerrainVB_InitExc+1
;	bne .SeekEnemy_Next
.SeekEnemy_Next
	inx
	bpl .SeekEnemy_loop
.SeekEnemy_End
	;含む地形のリストをクリア
	ldy #$0F
	lda #$00
.ResetTerrainExistsList_loop
	sta aTerrainExists,y
	dey
	bpl .ResetTerrainExistsList_loop
	;実際の読み込み
	jsr .Loading_Main
	;存在する地形に応じて特別な処理をするためのポインタを設定
	lda aTerrainExists+$8
	beq .NotWaterExists
	lda #LOW ($96FF)
	ldy #HIGH($96FF)
	sta aProcRockIntoWater+0
	sty aProcRockIntoWater+1
.NotWaterExists

	lda aTerrainExists+$6
	beq .NotForegroundExists
	lda #LOW (WRAMMap_RockForegroundProc)
	ldy #HIGH(WRAMMap_RockForegroundProc)
	sta aProcForeground+0
	sty aProcForeground+1
.NotForegroundExists

	lda aTerrainExists+$3
	beq .NotSetBreakableWallPtr
	ldx <vCurStageMain
	lda .Tbl_BPNumberPerStage,x
	pha
	and #$03
	tay
	lda .Tbl_BPlo,y
	sta aBusterProc+0
	lda .Tbl_BPhi,y
	sta aBusterProc+1
	pla
	lsr a
	lsr a
	lsr a
	bcc .NotSetFallStepProc
	lda #LOW (WRAMMap_FallStepProc)
	sta aFallStepProc+0
	lda #HIGH(WRAMMap_FallStepProc)
	sta aFallStepProc+1
.NotSetFallStepProc
.NotSetBreakableWallPtr
	;でかい部屋でなければ少し先まで追加で読み込む
	;（画面外の判定のため。これがないとアローの画面右への刺さり方等が変わってしまう）
	lda vPagesOfRoom
	cmp #$0F
	bcs .NotAdditionalLoading
	lda #$01
	sta <.vLoops
	sta vLoadMap_Step
	jsr .Loading_Main
.NotAdditionalLoading

	jsr $D474 ;ダークマンステージ４のイベント後の追加処理
	pla
	bpl .NotCloseShutter
	jmp $D16B
.NotCloseShutter
	rts

.Loading_Main
.Map_loop
	ldy <.vRPage
	jsr rGetPageAddr_bs
	inc <.vRPage

	lda <vCurStageBG 
	sta <vNewPrgA
	jsr rPrgBankSwap

	ldy vLoadMap_Step
	ldx .Tbl_InPageLoopSize,y
.Page_loop
	;サブルーチンに渡す$22は、画面上に以下のように対応
	;00yy yxxx
	;00 01 02 ... 05 06 07
	;08 09 0A ... 0D 0E 0F
	;         ...
	;38 39 3A ... 3B 3E 3F
	;ただし、この処理では、以下の順番に走査する
	;00 08 10 ... 38
	;01 09 11 ... 39
	;         ...
	;07 0F 17 ... 3F
	stx <$22
	lsr <$22
	lsr <$22
	lsr <$22
	txa
	asl a
	asl a
	asl a
	and #$38
	ora <$22
	sta <$22
	jsr rGetTileAddr

	txa
	asl a
	pha
	and #$0F
	sta <.vWorkF
	pla
	asl a
	and #$E0
	ora <.vWorkF
	sta <.vWorkF

	ldy #$03
.Tile_loop
	sty <.vWorkE
	lda [$00],y
	pha
	lda <.vWorkF
	ora .Tbl_OffsetOfTile,y
	tay
	pla
	sta [.aWPtr],y
	tay
	lda $B100,y
	lsr a
	lsr a
	lsr a
	lsr a
	tay
;	lda #$01
	sta aTerrainExists,y

	ldy <.vWorkE
	dey
	bpl .Tile_loop
	dex
	bpl .Page_loop
	clc
	lda <.aWPtr+1
	adc #$01
	and #$6F
	sta <.aWPtr+1
	dec <.vLoops
	bne .Map_loop
	rts


.SeekEnemy_SetHPInitEV ;※zフラグ0を返すこと
	lda #LOW (WRAMMap_HB_Init_EV)
	ldy #HIGH(WRAMMap_HB_Init_EV)
	sta aProcTerrainHB_InitExc+0
	sty aProcTerrainHB_InitExc+1
	rts

.Tbl_InPageLoopSize
	.db $3F,$0F

.Tbl_BPNumberPerStage
	DB4 $01010104
	DB4 $01010101
	DB4 $01010103
	DB4 $02010101

.Tbl_BPlo
	.db LOW (WRAMMap_BP_Rts)
	.db LOW (WRAMMap_BP_Stone)
	.db LOW (WRAMMap_BP_Wily1)
	.db LOW (WRAMMap_BP_Blues4)
.Tbl_BPhi
	.db HIGH(WRAMMap_BP_Rts)
	.db HIGH(WRAMMap_BP_Stone)
	.db HIGH(WRAMMap_BP_Wily1)
	.db HIGH(WRAMMap_BP_Blues4)


.Tbl_OffsetOfTile
	.db $00,$10,$01,$11

.WRAMMap_LoadMap_Ent
	lda <vScrollXPage
	sta <.vRPage
	lda <$0F
	jmp .WRAMMap_LoadMap_Ent_conf

	GLOBALIZE .WRAMMap_LoadMap_Ent,WRAMMap_LoadMap_Ent

;???0 ???0

;0001020304050607
;08090A0B0C0D0E0F
;10
;18
;20
;28
;30
;38

;00102030405060708090A0B0C0D0E0F0
;01
;02
;03
;04
;05
;06
;07
;08
;09
;0A
;0B
;0C
;0D
;0E
;0F

