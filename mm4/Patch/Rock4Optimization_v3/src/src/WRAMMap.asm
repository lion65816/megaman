WRAMMap_Org:
	;水に入る処理
	BANKORG_D $3FF0FC
	jmp RockIntoWater

	;オブジェクトによるロックマンの強制移動処理のバンク退避を無効に
	;さらに、SW_FixTerrainThroughに対応
	.IF SW_FixTerrainThrough1
	BANKORG_D $3FF398
	TRASH_GLOBAL_LABEL
	ldy #$00
	lda <vRockmanState
	cmp #$02
	beq .SlidingProc
	cmp #$06
	bne .Conf
	lda oVal0+0
	cmp #$02
	bne .Conf
.SlidingProc
	ldy #$04
	bne .Conf
.Conf
	ldx #$00
	jsr rXpmeVxT
	bit <$00
	ORG_TEST $F3B6
	.ELSE
	BANKORG_D $3FF3A2
	ldx #$00
	jsr rXpmeVxT
	jmp $F3B6
	
	.ENDIF



	;●横棒
	BANKORG_D $3ED2FF
	jmp [aProcTerrainHB_InitExc]
WRAMMAP_HB_Init_NoExc:

	lda WRAMMap_HB_Data_Offset,y
	tay
	lda WRAMMap_HB_Data_Base,y
	sta <$06 ;総判定回数
	iny
	;※原作では16bitの座標を意識しているようにも見えてしていない。
	;　なのでばっさり処理をカット。y>=F0の処理も無視。
	clc
	lda WRAMMap_HB_Data_Base,y
	bmi .Dy_n
	;Dy>=0
	adc oYhi,x
	bcc .Y_InScreen
.Y_OutOfScreen
	lda #$00
	ldy <$06 ;総判定回数
.Y_OutOfScreen_loop
	sta $0045,y
	dey
	bpl .Y_OutOfScreen_loop
	jmp WRAMMap_HBar_Exit2
.Dy_n
	adc oYhi,x
	bcc .Y_OutOfScreen
.Y_InScreen
	sta <$11
	lda oYhe,x
	bne .Y_OutOfScreen
;	lda #$00
	sta <$02 ;何回目の判定か
	sta <$04
	iny
	sty <$40
	lda WRAMMap_HB_Data_Base,y
	bpl .Dx_p
	dec <$04
.Dx_p
	clc
	adc oXhi,x
	sta <$12
	lda oXhe,x
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
	jmp [aProcTerrainHB_Exc]
.GlobalLabel
	;続き
	cpx #$00
	bne .NotRockSpike
	cmp #$30
	bne .NotRockSpike
	sta <$3D
.NotRockSpike
	ldy <$02
	sta $0045,y
	cmp <$41
	bcc .NotSignificantValue
	sta <$41
.NotSignificantValue
	ora <$10
	sta <$10
	lda <$02
	cmp <$06
	beq WRAMMap_HBar_Exit1
	inc <$02
	inc <$40
	ldy <$40

	lda <$12
	clc
	adc WRAMMap_HB_Data_Base,y
	sta <$12
	bcc .Next
	clc
	lda <$01
	adc #$01
	and #$6F
	sta <$01
	bne .Next
	
	GLOBALIZE .GlobalLabel,WRAMMap_HB_NoExc
WRAMMap_HBar_Exit1:
	jmp [aProcTerrainHB_EndExc]
WRAMMap_HBar_Exit2:
	lda <$42
	sta oYhi,x
	rts
WRAMMap_HB_DiveExc:
	ldy <$11
	cpy $013E
	bcs WRAMMap_HB_NoExc
	lda #$00
	beq WRAMMap_HB_NoExc
WRAMMap_HB_DrillExc:
	;※判定Xheは保持していません
	cmp #$70
	bne WRAMMap_HB_NoExc
	lda <$01
	and #$0F
	tay
	lda $0680,y
	and #$F0
	jmp WRAMMap_HB_NoExc


	END_BOUNDARY_TEST $3ED3FD
	BANKORG_D $3ED425
	jmp WRAMMap_HBar_Exit2

	;●縦棒
	BANKORG_D $3ED42B
	jmp [aProcTerrainVB_InitExc]
WRAMMAP_VB_Init_NoExc:
	lda $D808,y
	sta <$5A
	lda $D848,y
	sta <$5B
	ldy #$00
	sty <$02 ;何回目の判定か
	sty <$04 ;16bit演算hi
	sty <$05 ;画面外
	lda [$5A],y
	sta <$06 ;判定回数
	iny
	lda [$5A],y
	bpl .Dx_p
	dec <$04
.Dx_p
	clc
	adc oXhi,x
	sta <$12 ;判定Xhi※出力用に必要です
	and #$F0
	sta <$00 ;読出lo
	lda oXhe,x
	adc <$04 ;16bit演算hi
	and #$0F
;	sta <$13 ;判定Xhe
	ora #HIGH(aMap)
	sta <$01 ;読出hi
	iny
	sty <$40 ;判定位置テーブルオフセット
	lda oYhe,x
	bmi .ScreenOut_U
	bne .ScreenOut_D
	clc
	lda oYhi,x
	adc [$5A],y
	sta <$11 ;判定Y
	lda [$5A],y
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
	lda #$EF
	.db $2C ;Bit $****
.ScreenOut_U
	lda #$00
	sta <$11 ;判定Y
	sty <$05 ;画面外
.NotScreenOut
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
	jmp [aProcTerrainVB_Exc]
.GlobalLabel
	;続き
	cpx #$00
	bne .NotRockSpike
	cmp #$30
	bne .NotRockSpike
	sta <$3D
.NotRockSpike
	ldy <$02 ;何回目の判定か
	sta $0045,y
	cmp <$41
	bcc .NotSignificantValue
	sta <$41
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
	adc [$5A],y
	sta <$11 ;判定Y
	bcc .Loop
	lda #$FF
	sta <$11 ;判定Y
	bne .Loop
.ExitProc
;	jmp $D58D
	lda <$42
	sta oYhi,x
	rts
	GLOBALIZE .GlobalLabel,WRAMMap_VB_NoExc
WRAMMap_VB_DiveExc:
	ldy <$11
	cpy $013E
	bcs WRAMMap_VB_NoExc
	lda #$00
	beq WRAMMap_VB_NoExc
WRAMMap_VB_DrillExc:
	;※判定Xheは保持していません
	cmp #$70
	bne WRAMMap_VB_NoExc
	lda <$01
	and #$0F
	tay
	lda $0680,y
	and #$F0
	jmp WRAMMap_VB_NoExc
WRAMMAP_VB_DustInitExc:
	lda #HIGH($D42E-1)
	pha
	jmp WRAMMap_VB_DustConf
WRAMMap_Whopper:
	lda <vScrollXhi
	cmp #$0A
	bne .EndProc
	lda #$00
	ldx #.Tbl_end-.Tbl-1
.loop
	ldy .Tbl,x
	sta aMap+$A00,y
	dex
	bpl .loop
	ldx <vProcessingObj
.EndProc
	jmp rDeleteObjX
.Tbl
	.db $3A,$4A,$5A,$6A
	.db $3B,$4B,$5B,$6B
	.db     $4C,$5C
	.db     $4D,$5D
	.db     $4E,$5E
	.db     $4F,$5F
.Tbl_end
	END_BOUNDARY_TEST $3ED53A
	;地形判定前のバンク切り替え無効化
	BANKORG_D $3ED540
	lda oYhi,x
	sta <$42
	rts

	;ダストプレスの処理
	BANKORG_D $3ED552
WRAMMAP_HB_DustInitExc:
	lda #HIGH($D302-1)
	pha
	lda #LOW ($D302-1)
	pha
	BANKORG_D $3ED55D
	bne $D56C
	BANKORG_D $3ED566
	beq $D56C
	nop
WRAMMap_VB_DustConf:
	lda #LOW ($D42E-1)
	pha
	ORG_TEST $3ED56C

	BANKORG_D $3ED55D
;	bit <$00
	BANKORG_D $3ED564
;	bit <$00
;	BANKORG_D $3ED56C

	;ここに地形変化用のルーチンを書く
	BANKORG_D $3ED58D

	END_BOUNDARY_TEST $3ED69E

	;横棒判定データの設定
	BANKORG_D $3ED69E
WRAMMap_HB_Data_Offset:
	.db $16,$1B,$1F,$22,$27,$2C,$31,$36,$3B,$36,$40,$36,$45,$4A,$4F,$53
	.db $57,$1F,$1F,$5A,$5F,$62,$67,$6B,$6F,$74,$79,$7E,$83,$87,$8B,$8F
	.db $93,$97,$9C,$1F,$A1,$A4,$A8,$AD,$B2,$B6,$BA,$BE,$C2,$C6,$C9,$CF
	.db $D5,$DA,$DF,$E4,$E9,$EC,$EF,$F2,$F5,$F8,$FD
	.db $00 ;3B 予約
	.db $00 ;3C 予約
	.db $00 ;3D 予約
	.db $00 ;3E 予約
	.db $00 ;3F 予約
	.db $00 ;40 予約
	.db $00 ;41 予約
	.db $00 ;42 予約
	.db $00 ;43 予約
	.db $00 ;44 予約
	.db $00 ;45 予約
	.db $00 ;46 予約
	.db $00 ;47 予約
	.db $00 ;48 予約
	.db $00 ;49 予約
	.db $00 ;4A 予約
	.db $00 ;4B 予約
	.db $00 ;4C 予約
	.db $00 ;4D 予約
	.db $00 ;4E 予約
	.db $00 ;4F 予約
	.db $00 ;50 予約
	.db $00 ;51 予約
	.db $00 ;52 予約
	.db $00 ;53 予約
	.db $00 ;54 予約
	.db $00 ;55 予約
	.db $00 ;56 予約
	.db $00 ;57 予約
	.db $00 ;58 予約
	.db $00 ;59 予約
	.db $00 ;5A 予約
	.db $00 ;5B 予約
	.db $00 ;5C 予約
	.db $00 ;5D 予約
	.db $00 ;5E 予約
	.db $00 ;5F 予約
	BANKORG_D $3ED708
WRAMMap_HB_Data_Base:

	;オブジェクトの地形判定を簡略化していた場合のデータをここで設定
	BANKORG WRAMMap_HB_Data_Offset+$3B
	.db $5F ;$3B 落石の上移動のため
	.db $5F ;$3C
	.db $3B ;$3D
	.db WRAMMap_HB_Data_3E-WRAMMap_HB_Data_Base ;$3E
	BANKORG WRAMMap_HB_Data_Base
WRAMMap_HB_Data_3E:
	.db $01,$F0,$F5,$16 ;２点
	END_BOUNDARY_TEST $3ED71E



;●変化する地形への対応
	;ダストマンステージの壊せる壁
	BANKORG_D $3A886F
	lda <$01
	sta $140
	lda <$00
	sta $141
	lda oXhi,x
	sta $142
	ORG_TEST $3A887F

	BANKORG_D $3FE4E2
	lda <vVRAMTrig1
	ora <vVRAMTrig32
	bne $E4DC
	lda $0140
	sta <$01
	lda $0142
	and #$F0
	ora $0141
	sta <$00
	lda #$00
	sta aVRAMQueue+$0
	tay
	sta [$00],y
	sta <$01
;	lda <$00 ;XXXX yyyy
;	lda <$01 ;0110 PPPP
;	lda #0142;XXXX xxxxx

;0010 00YY YY0X XXX0
	lda <$00
	lsr a    ;0XXX Xyyy  ... y
	ror a    ;y0XX XXyy  ... y
	ror a    ;yy0X XXXy  ... y
	rol <$01 ;yy0X XXXy  0000 000y
	lsr a    ;0yy0 XXXX  ...y
	rol <$01 ;0yy0 XXXX  0000 00yy
	asl a    ;yy0X XXX0  0000 00yy
	sta aVRAMQueue+$1
	ora #$20
	sta aVRAMQueue+$6
	lda <$01
	eor #$03
	ora #$20
	sta aVRAMQueue+$0
	sta aVRAMQueue+$5
	ldy #$01
	sty aVRAMQueue+$2
	sty aVRAMQueue+$7
	dey
	sty aVRAMQueue+$3
	sty aVRAMQueue+$4
	sty aVRAMQueue+$8
	sty aVRAMQueue+$9
	sty $0140
	dey
	sty aVRAMQueue+$A
	sty <vVRAMTrig1
	rts
	END_BOUNDARY_TEST $3FE578

	;虹足場（→空間）
	BANKORG_D $3DA112
	TRASH_GLOBAL_LABEL
	jsr WRAMMap_RainbowStep
	;clc
	and #$0F
	ora #HIGH(aMap)
	sta <$01
	lda oXhi,x
	and #$F0
	tay

	lda oVal2,x
	adc #$12

	sta [$00],y
	ORG_TEST $3DA128

	;虹足場（→虹・リング）
	BANKORG_D $3DA1EB
	jsr WRAMMap_RainbowStep
	and #$0F
	ora #HIGH(aMap)
	sta <$01
	lda oXhi,x
	and #$F0
	tay
	lda #$00
	lda oVal2,x
	sta [$00],y
	ORG_TEST $3DA201
	
	;ドリルマンステージの出現床
	BANKORG_D $3DAE14
	jsr WRAMMap_DrillFloor

	;モスラーヤの床破壊
	BANKORG_D $3DB494
	jsr WRAMMap_Moth
	stx <vVRAMTrig1

	BANKORG_D $3DA22E
WRAMMap_RainbowStep:
	lda oYhi,x
	lsr a
	lsr a
	lsr a
	lsr a
	sta <$00
	lda oXhe,x
	clc ;続く処理に容量が足りなくなったのでここでclc
	rts
	END_BOUNDARY_TEST $3DA241
	
	BANKORG_D $3DA89A
	jsr WRAMMap_Whopper

;●3ED4C8:2099D5 jsr $3ED599 ;リングマンステージ、虹足場判定;
;●3ED4CB:20DAD5 jsr $3ED5DA ;コサック１例外(モスラーヤ);
;●●●3ED4CE:20E6D5 jsr $3ED5E6 ;ラスター5(ダイブS水位変動)/ドリルマン出現床/リングマンワッパー;
;●3ED4D1:2024D6 jsr $3ED624 ;ラスター4にて90の処理（ダストマン壁）;
;●3ED4D4:2061D6 jsr $3ED661 ;ワイリー３ワイリーマシンへのカプセル;


;3EC5AA:20B1CF jsr $3ECFB1 ;PPU書き込みキューに追加:スクロールによるネームテーブル描画;
;3ECAC9:20B1CF jsr $3ECFB1 ;PPU書き込みキューに追加:スクロールによるネームテーブル描画;
;3ECBB5:20B1CF jsr $3ECFB1 ;PPU書き込みキューに追加:スクロールによるネームテーブル描画;
;3FE61B:20B1CF jsr $3ECFB1 ;PPU書き込みキューに追加:スクロールによるネームテーブル描画;
;	BANKORG_D $3EC5AA
;	jsr WRAMMap_SetupNTTransfer
	BANKORG_D $3ECAC9
	jsr WRAMMap_SetupNTTransfer
;	BANKORG_D $3ECBB5
;	jsr WRAMMap_SetupNTTransfer
;	BANKORG_D $3FE61B
;	jsr WRAMMap_SetupNTTransfer

	.IF SW_WRAMMap_OrgHack
	;リングマンステージの虹・リングにより生じる空欄
	BANKORG_D $24A000+$1B
	.db $00
	BANKORG_D $24A100+$1B
	.db $00
	BANKORG_D $24A200+$1B
	.db $00
	BANKORG_D $24A300+$1B
	.db $00
	BANKORG_D $24A400+$1B
	.db $02
	BANKORG_D $24A000+$9E
	.db $00
	BANKORG_D $24A100+$9E
	.db $00
	BANKORG_D $24A200+$9E
	.db $00
	BANKORG_D $24A300+$9E
	.db $00
	BANKORG_D $24A400+$9E
	.db $01
	.ENDIF


	BANKORG WRAMMap_Org
