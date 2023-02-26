WRAMMap_Org:
	;ロックマンの処理/ジャイロマンステージ落下足場
	BANKORG_D $1B821A
	jmp [aFallStepProc]
WRAMMap_SkipFallStepProc:
	BANKORG_D $1B97DF
WRAMMap_FallStepProc:
	lda #HIGH(WRAMMap_SkipFallStepProc-1)
	pha
	lda #LOW (WRAMMap_SkipFallStepProc-1)
	pha
	bcc $9844
	php
	;ロックマンの処理/水
	BANKORG_D $1B96F3
	jmp [aProcRockIntoWater]
	;ロックマンの処理/背景に回る
	BANKORG_D $1B9795
	jmp [aProcForeground]


	;●横棒
WRAMMap_HB_Data_Offset = $C807
WRAMMap_HB_Data_Base   = $C837

	BANKORG_D $1EC4A4
	lda WRAMMap_HB_Data_Offset,y
	tay
	lda WRAMMap_HB_Data_Base,y
	sta <$06 ;総判定回数
	clc
	lda WRAMMap_HB_Data_Base+1,y
	jmp [aProcTerrainHB_InitExc]
WRAMMAP_HB_Init_NoExc:
	bmi .Dy_n
	;Dy>=0
	adc <$11 ;oYhi,x
	bcc .Y_InScreen
.Y_OutOfScreen
	lda #$00
	ldy <$06 ;総判定回数
.Y_OutOfScreen_loop
	sta aTerrainValue,y
	dey
	bpl .Y_OutOfScreen_loop
	jmp $C737
.Dy_n
	adc <$11 ;oYhi,x
	bcc .Y_OutOfScreen
.Y_InScreen
	sta <$11
	lda oYhe,x
	bne .Y_OutOfScreen
WRAMMAP_HB_Init_ConfFromEV:
;	lda #$00
	sta <$02 ;何回目の判定か
	sta <$04
	sty <$40
	lda WRAMMap_HB_Data_Base+2,y
	bpl .Dx_p
	dec <$04
.Dx_p
	clc
	adc oXhi,x
	sta <$12
	lda <$13 ;oXhe,x
	adc <$04
;	sta <$13

;	lda <$13
	and #$0F
	ora #HIGH(aMap)
	sta <$01
	lda <$11
	lsr a
	lsr a
	lsr a
	lsr a
	sta <$00
.Next
	lda <$12
	and #$F0
	tay
	lda [$00],y
	tay
	lda aChipHit,y
	and #Const_16TileAttributeBits
	;例外処理を書くならここに書く
;	jmp [aProcTerrainHB_Exc]
.GlobalLabel
	;続き
	ldy <$02
	sta aTerrainValue,y
	cmp <$42
	bcc .NotSignificantValue
	sta <$42
.NotSignificantValue
	ora <$10
	sta <$10
	lda <$02
	cmp <$06
	beq WRAMMap_HBar_Exit
	inc <$02
	inc <$40
	ldy <$40

	lda <$12
	clc
	adc WRAMMap_HB_Data_Base+2,y
	sta <$12
	bcc .Next
	clc
	lda <$01
	adc #$01
	and #$6F
	sta <$01
	bne .Next

	GLOBALIZE .GlobalLabel,WRAMMap_HB_NoExc
WRAMMap_HBar_Exit:
	jmp $C737
WRAMMap_HB_Init_EV:
	bmi .Dy_n
	;Dy>=0
	adc <$11 ;oYhi,x
	bcs .DecYpage
	cmp #$F0
	bcc .InScreen
.DecYpage
	clc
	adc #$10
	sta <$11
	dec <$13 ;oXhe,x
	jmp .OutScreen_conf
.Dy_n
	adc <$11 ;oYhi,x
	bcs .InScreen
	adc #$F0
	sta <$11
	inc <$13 ;oXhe,x
	bne .OutScreen_conf
.InScreen
	sta <$11
.OutScreen_conf

	lda oYhe,x
	bne .NotSubPage
	lda vTerrainHP_SpCd_SubPage
	bpl .NotW1
	txa
	beq .NotSubPage
.NotW1
	lda WRAMMap_HB_Data_Base+1,y
	bmi .NotSubPage
	clc
	adc oYhi,x
	cmp vTerrainHP_SpCd_MaxY
	bcc .NotSubPage
	sta <$11 ;oYhi,x
	lda vTerrainHP_SpCd_SubPage
	bmi .NotSubPage
	sta <$13 ;oXhe,x
.NotSubPage

	lda #$00
	jmp WRAMMAP_HB_Init_ConfFromEV

	FillTest $1EC5AA


	;●縦棒
WRAMMap_VB_Data_Offset = $C8E2
WRAMMap_VB_Data_Base   = $C912
	BANKORG_D $1EC5AD
	lda WRAMMap_VB_Data_Offset,y
	tay
	lda WRAMMap_VB_Data_Base,y
	sta <$06 ;総判定回数

	lda #$00
	sta <$02 ;何回目の判定か
	sta <$04 ;16bit演算hi
	sta <$05 ;画面外

	lda WRAMMap_VB_Data_Base+1,y
	bpl .Dx_p
	dec <$04
.Dx_p
	clc
	adc oXhi,x
	sta <$12 ;判定Xhi※出力用に必要です
	and #$F0
	sta <$00 ;読出lo
	lda <$13 ;oXhe,x
	adc <$04 ;16bit演算hi
	and #$0F
;	sta <$13 ;判定Xhe
	ora #HIGH(aMap)
	sta <$01 ;読出hi
	sty <$40 ;判定位置テーブルオフセット
	jmp [aProcTerrainVB_InitExc]
WRAMMAP_VB_Init_NoExc:
	lda oYhe,x
	bmi .ScreenOut_U
	bne .ScreenOut_D
	clc
	lda <$11 ;oYhi,x
	adc WRAMMap_VB_Data_Base+2,y
	sta <$11 ;判定Y
	lda WRAMMap_VB_Data_Base+2,y
	bpl .Dy_p
	;Dy<0
	bcc .ScreenOut_U
	bcs .NotScreenOut
.Dy_p
	;Dy>=0
	bcs .ScreenOut_D
	;※y>=F0の確認を省略
	bcc  .NotScreenOut
.ScreenOut_D
	ldy #$FF
	.db $2C ;Bit $****
.ScreenOut_U
	ldy #$00
	sty <$11 ;判定Y
	dey
	sty <$05 ;画面外
.NotScreenOut
WRAMMAP_VB_Init_ConfFromEV:
.Loop
	lda <$11
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	lda [$00],y
	tay
	lda aChipHit,y
	and #Const_16TileAttributeBits
	cmp #$40
	bne .NotLadderTop
	lda #$20
.NotLadderTop
	;例外処理を書くならここに書く
;	jmp [aProcTerrainVB_Exc]
.GlobalLabel
	;続き
	ldy <$02 ;何回目の判定か
	sta aTerrainValue,y
	cmp <$42
	bcc .NotSignificantValue
	sta <$42
.NotSignificantValue
	ora <$10
	sta <$10
	cpy <$06 ;判定回数
	beq .ExitProc
	inc <$02 ;何回目の判定か
	inc <$40 ;判定位置テーブルオフセット
	lda <$05 ;画面外
	bne .Loop
	ldy <$40 ;判定位置テーブルオフセット
	lda <$11 ;判定Y
	clc
	adc WRAMMap_VB_Data_Base+2,y
	sta <$11 ;判定Y
	ldy <vSpecialCoordinates
	bne .SpCd
	bcc .Loop
	lda #$FF
	sta <$11 ;判定Y
	bne .Loop
.ExitProc
	jmp $C737
.SpCd
	bcs .SpCd_DecPage
	cmp #$F0
	bcc .Loop
.SpCd_DecPage
	adc #$0F ;10-1
	sta <$11 ;判定Y
	dec <$01
	lda <$01
	and #$0F
	ora #$60
	sta <$01
	bne .Loop

	GLOBALIZE .GlobalLabel,WRAMMap_VB_NoExc
WRAMMAP_VB_Init_EV:
	clc
	lda <$11 ;oYhi,x
	adc WRAMMap_VB_Data_Base+2,y
	sta <$11 ;判定Y
	lda WRAMMap_VB_Data_Base+2,y
	bpl .Dy_p
	;Dy<0
	bcc .ScreenOut_U
	bcs .NotScreenOut
.Dy_p
	;Dy>=0
	bcs .ScreenOut_D
	cmp #$F0
	bcc  .NotScreenOut
;	bcs .ScreenOut_D
.ScreenOut_D
	adc #$0F ;10-1
	sta <$11 ;判定Y
	dec <$01
	bne .ScreenOut_conf
.ScreenOut_U
	adc #$F0
	sta <$11 ;判定Y
	inc <$01
.ScreenOut_conf
	lda <$01
	and #$0F
	ora #$60
	sta <$01
.NotScreenOut

	jmp WRAMMAP_VB_Init_ConfFromEV
	;別の処理で使うテーブルやプログラムを隙間に間借り
WRAMMap_AndMask:
	DB4444 $FCFCFCFC,$F3F3F3F3,$CFCFCFCF,$3F3F3F3F

	FillTest $1EC6DB



	;地形判定後のバンク切り替え無効化
	BANKORG_D $1EC747
	rts
	;別の処理で使うテーブルやプログラムを隙間に間借り
UpdateChipHit_OnObj:
	lda oXhi,x
	sta <$00
	lda oYhi,x
	sta <$02
	lda oXhe,x
	sta <$01
	jmp UpdateChipHit


WRAMMap_RockForegroundProc:
	lda <vFrameCounterS
	lsr a
	jmp $9798

WRAMMap_AtCloseScreen:
	lda <vCurStageMain
	cmp #$0E
	bne .NotBossRushStage
	ldy oXhe+0
	lda $D793,y
	sta <vCurStageBG
.NotBossRushStage
	rts


WRAMMap_Tbl_NTColorTblOffset:
	.db $00,$00,$08,$08,$10,$10,$18,$18
	.db $20,$20,$28,$28,$30,$30,$38

MISC_TblAudioRegOffset:
	.db $0C,$08,$04,$00

WRAMMap_OrMask: ;LTCC※CCの上位下位が入れ替わっている
;	DB4444 $00010203,$0004080C,$00102030,$004080C0
	DB4444 $00020103,$0008040C,$00201030,$008040C0


WRAMMap_Tbl_VRAMQueueOffset:
	DB4 $21FF25FF
	DB4 $29FF2DFF
	DB4 $31FF35FF
	DB3 $39FF3D

;MISC_TblAudioRegOffsetの続き
	.db $00,$00,$00,$00,$00
MISC_TblAudioRegOffset_2:
	.db $0C,$08,$04,$00
	.IF (MISC_TblAudioRegOffset_2)-(MISC_TblAudioRegOffset)!=$28
	.FAIL MISC_TblAudioRegOffsetテーブルが不正です
	.ENDIF

	FillTest $1EC7AA ;地形判定終了後～変化チップ対応～チップ判定逆転


;●変化する地形への対応
	;ジャイロマンステージの床
	;オブジェクト
	BANKORG_D $05A1AA
	jsr UpdateChipOnObj
	BANKORG_D $05A1C1
	jmp rDeleteObjX
	BANKORG_D $05A1D1
	rts
	;ロックマンが床に触れた時
	BANKORG_D $1B9831
	ldy #$10
	nop
	jsr UpdateChipHit_OnObj
	;ブルース３の動く床
	BANKORG_D $05A596
	ldy #$9C
	jsr UpdateChipHit_OnObj
	jmp $A5B3
	BANKORG_D $05A64B
	jsr rXpmeVx
	jsr rYpmeVy
	jsr $A6A3
	BANKORG_D $05A6A3
	ldy #$00
	jmp UpdateChipHit_OnObj
	;ワイリー３のプレスへのカプセル
	BANKORG_D $0B808F
	lda #$06
	sta aMap+$300+$71
	sta aMap+$300+$81
	jmp WRAMMap_W3_Capsure_cont
	BANKORG_D $0B809C
WRAMMap_W3_Capsure_rp:
	BANKORG_D $0B812D
WRAMMap_W3_Capsure_cont:
	lda #$0E
	sta aMap+$300+$72
	sta aMap+$300+$82
	jmp WRAMMap_W3_Capsure_rp
	;ダークマン４の部屋の崩れる床
	BANKORG_D $1B8925
	jmp $8933
	BANKORG_D $1B8936
	bit $0000
	BANKORG_D $1B893E
	bit $0000
	BANKORG_D $1B894D
	jmp $8953
	BANKORG_D $1B897C
	jsr UpdateChipOnObj
	BANKORG_D $1ED450 ;復活時処理をデフォルト位置では無効に
	bit $0000
	BANKORG_D $1ED482
	sta <vNewPrgA
	BANKORG_D $1ED48B ;復活時処理
	sty <$08
	lda $AF83,y
	sta <$02
	lda $AF84,y
	sta <$00
	lda #$03
	sta <$01
	lda $AF82,y
	tay
	jsr UpdateChipHit
	ldy <$08
	dey
	dey
	dey
	dey
	dey
	dey
	bpl $D48B
	rts
	END_BOUNDARY_TEST $1ED4B2

	;バスターの壊せる壁の対応
	BANKORG_D $1DAF69 ;**********
	jmp [aBusterProc]
WRAMMap_BP_PlaRts:
	pla
WRAMMap_BP_Rts:
	rts
WRAMMap_BP_Stone:
	sec
	lda oXhi,x
	sbc <vScrollX
	pha
	lda oXhe,x
	sbc <vScrollXPage
	bne WRAMMap_BP_PlaRts
	pla
	cmp #$18
	bcc WRAMMap_BP_Rts
	cmp #$F4
	bcs WRAMMap_BP_Rts
	lda <vVRAMTrigC
	bne WRAMMap_BP_Rts
	ldy #$06
	jsr rHBarTest
	lda <$10
	cmp #$30
	bne WRAMMap_BP_Rts
	beq WRAMMap_BP_Stone_2
	END_BOUNDARY_TEST $1DAFA2
	BANKORG_D $1DAFA2 ;**********
WRAMMap_BP_Conf:
	BANKORG_D $1DAFC8 ;**********
	rts
WRAMMap_BP_Stone_2:
	ldy #$00
	jsr UpdateChipOnObj
	jmp WRAMMap_BP_Conf
WRAMMap_BP_Blues4:
	lda <vScrollY
	and #$0F
	ora <vVRAMTrigC
	bne WRAMMap_BP_Rts
	ldy #$06
	jsr rHBarTest
	lda <$10
	cmp #$30
	bne WRAMMap_BP_Rts
	lda oXhi,x
	and #$F0
	ora #$08
	sta oXhi,x
	jmp $B039
	END_BOUNDARY_TEST $1DB020

	BANKORG_D $1DB098 ;**********
	jsr UpdateChipOnObj
	BANKORG_D $1DB0AC ;**********
	jmp WRAMMap_BP_Conf
WRAMMap_BP_Wily1:
	sec
	lda oXhi,x
	sbc <vScrollX
	pha
	lda oXhe,x
	sbc <vScrollXPage
	bne .plarts
	pla
	cmp #$18
	bcc .rts
	cmp #$F4
	bcs .rts
	lda <vVRAMTrigC
	bne .rts
	ldy #$06
	jsr rHBarTest
	lda <$10
	cmp #$30
	bne .rts
	lda oYhi,x
	pha
	lda <$11
	sta oYhi,x
	ldy #$00
	jsr UpdateChipOnObj
	pla
	sta oYhi,x
	jmp WRAMMap_BP_Conf
.rts
	rts
.plarts
	pla
	rts
	END_BOUNDARY_TEST $1DB0F7

	;シャッターを閉じる
	BANKORG_D $1ED192
	lda $D2B1+0,x
	sta oXhi+5
	lda $D2B1+1,x
	sta oYhi+5
	lda oXhe+0
	sta oXhe+5
	jmp $D1A8

	BANKORG_D $1ED1BC
	ldx #$05
	jsr UpdateChipOnObj
	lda #$FF
	sta <vVRAMTrigC
	bne $D1E6
	BANKORG_D $1ED20B
	clc
	lda oYhi+5
	adc #$10
	sta oYhi+5
	jmp $D1BA


	.IF WRAMMap_ModifyMap ;{
	;シャッター情報
	BANKORG_D $1ED2B1
	.db $08,$98,$00,$00,$17 ;
	.db $08,$98,$00,$00,$FF
	.db $08,$98,$00,$00,$78
	.db $08,$98,$00,$00,$FF
	.db $08,$98,$00,$00,$78 ;
	.db $08,$98,$00,$00,$B2
	.db $08,$98,$00,$00,$FF
	.db $08,$98,$00,$00,$FF
	.db $08,$98,$00,$00,$FF ;
	.db $08,$98,$00,$00,$FF
	.db $08,$98,$00,$00,$FF
	.db $08,$68,$00,$00,$FF
	.db $08,$98,$00,$00,$FF ;
	.db $08,$98,$00,$00,$FF
	.db $08,$98,$00,$00,$88
	.db $08,$98,$00,$00,$8F

WRAMMap_SetShutterChip .macro
	BANKORG_DB (\1)*$10000+$AD00+$000+(\2),(\3)
	BANKORG_DB (\1)*$10000+$AD00+$100+(\2),(\4)
	BANKORG_DB (\1)*$10000+$AD00+$200+(\2),(\3)
	BANKORG_DB (\1)*$10000+$AD00+$300+(\2),(\4)
	BANKORG_DB (\1)*$10000+$AD00+$400+(\2),(\5)
	.endm

	WRAMMap_SetShutterChip $0,$17,$AE,$AF,$10
	WRAMMap_SetShutterChip $1,$FF,$02,$03,$10
	WRAMMap_SetShutterChip $2,$78,$8F,$9F,$13
	WRAMMap_SetShutterChip $3,$FF,$DE,$DF,$10
	WRAMMap_SetShutterChip $4,$78,$8F,$9F,$10
	WRAMMap_SetShutterChip $5,$B2,$DE,$DF,$11
	WRAMMap_SetShutterChip $6,$FF,$1A,$1B,$13
	WRAMMap_SetShutterChip $7,$FF,$1E,$1F,$10
	WRAMMap_SetShutterChip $8,$FF,$13,$14,$13
	WRAMMap_SetShutterChip $9,$FF,$12,$13,$11
	WRAMMap_SetShutterChip $A,$FF,$16,$17,$11
;	WRAMMap_SetShutterChip $B,$FF,$AE,$AF,$10
	WRAMMap_SetShutterChip $C,$FF,$20,$21,$11
	WRAMMap_SetShutterChip $D,$FF,$1C,$1D,$12
	WRAMMap_SetShutterChip $E,$88,$14,$15,$12
	WRAMMap_SetShutterChip $E,$8F,$04,$05,$12

	;ついでに他のステージの修正(画面下部の判定による)
	BANKORG_DB $07B600+$40*3+1+$8*7,$40 ;クリスタルマンステージ
	BANKORG_DB $02B600+$40*4+6+$8*7,$7D ;ストーンマンステージ
	BANKORG_DB $02B200+$4*$76+3,$08 ;ストーンマンステージ(32x32定義)

	.ENDIF ;}

	;オープニングでの偽ブルースの動き
	BANKORG_D $0CA21C
	jsr rMoveYG

	BANKORG_D $1ECB3B ;ルーム右端では、次の画面の左端を描画しない等も含む
	TRASH_GLOBAL_LABEL
	bne .DoNTTransfer
	lda <vNTDrawhi
	cmp vNTTransferLimit
	bne .DoNTTransfer
	beq .SkipNTTransfer
.DoNTTransfer
	jsr WRAMMap_SetupNTTransfer
.SkipNTTransfer
	jmp $CD10

	BANKORG_D $1ECBFB ;右スクロール
	jsr WRAMMap_SetupNTTransfer
	BANKORG_D $1ECCDC ;左スクロール
	jsr WRAMMap_SetupNTTransfer


	BANKORG WRAMMap_Org
