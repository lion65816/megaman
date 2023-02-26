	SETBANK8000
WRAMMap_LoadMapParam:
	lda <vCurStage
	ora #$20
	sta <vNewPrgA
	jsr rPrgBankSwap
	ldy #$00
.loop
	lda $A000,y
	sta aChipGrp+$000,y
	lda $A100,y
	sta aChipGrp+$100,y
	lda $A200,y
	sta aChipGrp+$200,y
	lda $A300,y
	sta aChipGrp+$300,y
	lda $A400,y
	sta aChipHit,y
	dey
	bne .loop
	rts

	SETBANK8000
WRAMMap_LoadMap:

.aWPtr  = $0A;array2
.vLoops = $0C
.vRPage = $0D
.vWorkE = $0E
.vWorkF = $0F

	lda <vScrollXhi
	sta <.vRPage
	lda <vLastNTDrawDirection
	cmp #$03
	bcs .NotHorizontalScrolling
	;ワイリーマシンのマップが縦スクロール扱いになっているので、
	;読み込みルームがずれてしまう。;そのため、例外的に+1しない
	lda <vCurStage
	cmp #$0E
	bne .IncLoadPage
	lda <vScrollXhi
	cmp #$0B
	beq .NotIncLoadPage
.IncLoadPage
	inc <.vRPage
.NotIncLoadPage
.NotHorizontalScrolling

.WRAMMap_LoadMap_Ent_conf
	;分岐/戻る時に、部屋左端以外に出現する時を考慮
	sec
	lda <.vRPage
	sbc <vPageInRoom
	sta <.vRPage
	and #$0F
	ora #$60
	sta <.aWPtr+1
	lda #$00
	sta <.aWPtr+0
	sta vWaterFlag
	sta vLoadMap_Step

	clc
	lda <vPagesOfRoom
	adc #$01
	cmp #$10
	bcc .LoadPagesLT10
	lda #$10
.LoadPagesLT10
	sta <.vLoops

	;各種初期アドレスを設定
	lda #LOW (WRAMMap_HB_NoExc)
	sta aProcTerrainHB_Exc+0
	lda #HIGH(WRAMMap_HB_NoExc)
	sta aProcTerrainHB_Exc+1
	lda #LOW (WRAMMap_VB_NoExc)
	sta aProcTerrainVB_Exc+0
	lda #HIGH(WRAMMap_VB_NoExc)
	sta aProcTerrainVB_Exc+1

	lda #LOW (WRAMMAP_HB_Init_NoExc)
	sta aProcTerrainHB_InitExc+0
	lda #HIGH(WRAMMAP_HB_Init_NoExc)
	sta aProcTerrainHB_InitExc+1
	lda #LOW (WRAMMAP_VB_Init_NoExc)
	sta aProcTerrainVB_InitExc+0
	lda #HIGH(WRAMMAP_VB_Init_NoExc)
	sta aProcTerrainVB_InitExc+1
	lda #LOW (WRAMMap_HBar_Exit2)
	sta aProcTerrainHB_EndExc+0
	lda #HIGH(WRAMMap_HBar_Exit2)
	sta aProcTerrainHB_EndExc+1

	.IF SW_AnywhereIce
	lda #LOW (AnywhereIce_SkipProc0)
	ldy #HIGH(AnywhereIce_SkipProc0)
	sta aProcIce0+0
	sty aProcIce0+1
	lda #LOW (AnywhereIce_SkipProc1)
	ldy #HIGH(AnywhereIce_SkipProc1)
	sta aProcIce1+0
	sty aProcIce1+1
	lda #LOW (AnywhereIce_SkipProc2)
	ldy #HIGH(AnywhereIce_SkipProc2)
	sta aProcIce2+0
	sty aProcIce2+1
	.ENDIF
	.IF SW_CustomBlock
	lda #LOW (CustomBlock_SkipSand)
	ldy #HIGH(CustomBlock_SkipSand)
	sta aProcCustomBlock_Sand+0
	sty aProcCustomBlock_Sand+1
	lda #LOW (CustomBlock_SkipConveyor)
	ldy #HIGH(CustomBlock_SkipConveyor)
	sta aProcCustomBlock_Conv+0
	sty aProcCustomBlock_Conv+1
	lda #LOW (CustomBlock_SkipFlowSnow)
	ldy #HIGH(CustomBlock_SkipFlowSnow)
	sta aProcCustomBlock_FlSn+0
	sty aProcCustomBlock_FlSn+1
	.ENDIF
	.IF SW_RainbowStep
	lda #LOW ($C779)
	ldy #HIGH($C779)
	sta aProcRainbowStep+0
	sty aProcRainbowStep+1
	.ENDIF


	;敵リストをシーク
	ldy <.vRPage
	ldx $B300,y
.SeekEnemy_loop
	sec
	lda $B100,x ;敵Xpage
	sbc <.vRPage
	cmp <vPagesOfRoom
	beq .SeekEnemy_do
	bcs .SeekEnemy_End
.SeekEnemy_do
	lda $B280,x ;敵配置type
	.IF SW_RainbowStep
	cmp #$08
	bcc .SeekEnemy_NotRainbowStep
	cmp #$10
	bcc .SeekEnemy_RainbowStep
.SeekEnemy_NotRainbowStep
	.ENDIF
	cmp #$44 ;ダストプレス
	beq .SeekEnemy_DustPress
	cmp #$41 ;ドリルレバー
	beq .SeekEnemy_DrillLever
	cmp #$16 ;潮位変動1
	beq .SeekEnemy_Dive
	cmp #$17 ;潮位変動2
	bne .SeekEnemy_Next
.SeekEnemy_Dive
	lda #LOW (WRAMMap_HB_DiveExc)
	ldy #HIGH(WRAMMap_HB_DiveExc)
	sta aProcTerrainHB_Exc+0
	sty aProcTerrainHB_Exc+1
	lda #LOW (WRAMMap_VB_DiveExc)
	ldy #HIGH(WRAMMap_VB_DiveExc)
	sta aProcTerrainVB_Exc+0
	sty aProcTerrainVB_Exc+1
	bne .SeekEnemy_Next
	.IF SW_RainbowStep
.SeekEnemy_RainbowStep
	lda #LOW (RainbowStep_Setup16x16Transfer)
	ldy #HIGH(RainbowStep_Setup16x16Transfer)
	sta aProcRainbowStep+0
	sty aProcRainbowStep+1
	bne .SeekEnemy_Next
	.ENDIF
.SeekEnemy_DrillLever
	lda #LOW (WRAMMap_HB_DrillExc)
	ldy #HIGH(WRAMMap_HB_DrillExc)
	sta aProcTerrainHB_Exc+0
	sty aProcTerrainHB_Exc+1
	lda #LOW (WRAMMap_VB_DrillExc)
	ldy #HIGH(WRAMMap_VB_DrillExc)
	sta aProcTerrainVB_Exc+0
	sty aProcTerrainVB_Exc+1
	bne .SeekEnemy_Next
.SeekEnemy_DustPress
	lda #LOW (WRAMMAP_HB_DustInitExc)
	ldy #HIGH(WRAMMAP_HB_DustInitExc)
	sta aProcTerrainHB_InitExc+0
	sty aProcTerrainHB_InitExc+1
	lda #LOW (WRAMMAP_VB_DustInitExc)
	ldy #HIGH(WRAMMAP_VB_DustInitExc)
	sta aProcTerrainVB_InitExc+0
	sty aProcTerrainVB_InitExc+1
	lda #LOW ($D403)
	ldy #HIGH($D403)
	sta aProcTerrainHB_EndExc+0
	sty aProcTerrainHB_EndExc+1
.SeekEnemy_WriteValue
.SeekEnemy_Next
	inx
	bpl .SeekEnemy_loop
.SeekEnemy_End
	;含む地形のリストをクリア
	ldy #(($10<<(SW_CustomBlock*2))-1)
	lda #$00
.ResetTerrainExistsList_loop
	sta aTerrainExists,y
	dey
	bpl .ResetTerrainExistsList_loop
	;実際の読み込み
	jsr .Loading_Main
	;存在する地形に応じた特別な処理
	lda aTerrainExists+($6<<(SW_CustomBlock*2))
	beq .NotHaveWater
	sta vWaterFlag
.NotHaveWater
	.IF SW_Haikei
	;前景の有無に寄ってフラグを設定するが
	;もし、フラグがOn->Offの場合は、強制的にロックマンが裏に回るフラグをOffにする
	ldy aTerrainExists+($E<<(SW_CustomBlock*2))
	bne .HaveForeground
	lda vForegroundFlag
	beq .NotSwitchRockHideFlag
	lda oFlag+0 ; <画向優補外見ブ乗>
	and #~$20
	sta oFlag+0 ; <画向優補外見ブ乗>
.NotSwitchRockHideFlag
	ldy #$00
.HaveForeground
	sty vForegroundFlag
	.ENDIF
	.IF SW_AnywhereIce
	lda aTerrainExists+($B<<(SW_CustomBlock*2))
	beq .NotHaveIce
	lda #LOW (AnywhereIce_Proc0)
	ldy #HIGH(AnywhereIce_Proc0)
	sta aProcIce0+0
	sty aProcIce0+1
	lda #LOW (AnywhereIce_Proc1)
	ldy #HIGH(AnywhereIce_Proc1)
	sta aProcIce1+0
	sty aProcIce1+1
	lda #LOW (AnywhereIce_Proc2)
	ldy #HIGH(AnywhereIce_Proc2)
	sta aProcIce2+0
	sty aProcIce2+1
.NotHaveIce
	.ENDIF
	.IF SW_CustomBlock
	lda aTerrainExists+($C4>>2)
	beq .NotHaveSand
	lda #LOW (CustomBlock_Sand)
	ldy #HIGH(CustomBlock_Sand)
	sta aProcCustomBlock_Sand+0
	sty aProcCustomBlock_Sand+1
.NotHaveSand
	lda aTerrainExists+($D0>>2)
	ora aTerrainExists+($D4>>2)
	beq .NotHaveConveyor
	lda #LOW (CustomBlock_Conveyor)
	ldy #HIGH(CustomBlock_Conveyor)
	sta aProcCustomBlock_Conv+0
	sty aProcCustomBlock_Conv+1
.NotHaveConveyor
	lda aTerrainExists+($80>>2) ;→
	ora aTerrainExists+($A0>>2) ;←
	ora aTerrainExists+($C0>>2) ;↓
	ora aTerrainExists+($C8>>2) ;雪
	beq .NotHaveFlowSnow
	lda #LOW (CustomBlock_FlowSnow)
	ldy #HIGH(CustomBlock_FlowSnow)
	sta aProcCustomBlock_FlSn+0
	sty aProcCustomBlock_FlSn+1
.NotHaveFlowSnow
	.ENDIF
	;でかい部屋でなければ少し先まで追加で読み込む
	;（画面外の判定のため）
	lda vPagesOfRoom
	cmp #$0F
	bcs .NotAdditionalLoading
	lda #$01
	sta <.vLoops
	sta vLoadMap_Step
	jsr .Loading_Main
.NotAdditionalLoading

	;ワイリー３のカプセル出現
	ldy <vClearedCapsule
	iny
	bne .NotPlaceCapsule
	ldy #$03
.PlaceCapsule_loop
	lda .Tbl_CapsuleChip,y
	sta aMap+$900+$72,y
	clc
	adc #$01
	sta aMap+$900+$82,y
	dey
	bpl .PlaceCapsule_loop

.NotPlaceCapsule

	rts

.Loading_Main

.Map_loop
	ldy <.vRPage
	jsr rGetPageAddr_bs
	inc <.vRPage

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
	stx <$29
	lsr <$29
	lsr <$29
	lsr <$29
	txa
	asl a
	asl a
	asl a
	and #$38
	ora <$29
	sta <$29
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
	lda $A400,y
	lsr a
	lsr a
	.IF !SW_CustomBlock
	lsr a
	lsr a
	.ENDIF
	tay
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

.Tbl_OffsetOfTile
	.db $00,$10,$01,$11
.Tbl_CapsuleChip
	.db $18,$1A,$14,$1C
.Tbl_InPageLoopSize
	.db $3F,$07

.WRAMMap_LoadMap_Ent
	lda <vScrollXhi
	sta <.vRPage
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
