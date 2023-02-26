;by rock5_lite/Rock5easily
;……のロックマン４への移植
;５同様、勝手ながら、サブルーチン呼び出しの部分の最適化を加えております。
SetupGaugeSprites:

	BANKORG_D $3EDB44
	jsr SetupGaugeSprites_SetupGauges
	BANKORG_D $3EDB6E
	jmp SetupGaugeSprites_SetupGauges

	BANKORG_D $3EDF03
	bpl SetupGaugeSprites_rts
	BANKORG_D $3EDF1B
	beq SetupGaugeSprites_rts
	BANKORG_D $3EDF58
SetupGaugeSprites_rts:
	rts

	BANKORG_D $3EDEE2
SetupGaugeSprites_SetupGauges:
	ldx #$02
	jsr $DF00
	ldx #$01
	jsr $DF00
	ldx #$00
	jmp $DF00

	BANKORG_D $3EDF21
SetupGaugeSprites_SetupAGauge:
	ldy	<$00
	lda	.Tbl_Offset,y
	tay
	sec
	jmp	SetupGaugeSprites_DrawGauge
.Tbl_Offset
	.db $2E,$2D,$20,$13,$06,$2C,$1F,$12
	.db $05,$2B,$1E,$11,$04,$2A,$1D,$10
	.db $03,$29,$1C,$0F,$02,$28,$1B,$0E
	.db $01,$27,$1A,$0D,$00
	END_BOUNDARY_TEST $3EDF58

	BANKORG SetupGaugeSprites
SetupGaugeSprites_DrawGauge:
.LOOP
	lda	<$03
	sta	$200,x
	lda	<$02
	sta	$203,x
	lda	<$01
	sta	$202,x
	lda	(.Tbl_TileNo),y
	sta	$201,x
	iny
	inx
	inx
	inx
	inx
	beq	.R
	lda	<$03
	sbc	#$08
	sta	<$03
	cmp	#$10
	bne	.LOOP
.R
	stx	<vDMASrcPointer
	rts
.Tbl_TileNo
	.db $84,$84,$84,$84,$84,$84,$84,$80
	.db $80,$80,$80,$80,$80,$84,$84,$84
	.db $84,$84,$84,$83,$80,$80,$80,$80
	.db $80,$80,$84,$84,$84,$84,$84,$84
	.db $82,$80,$80,$80,$80,$80,$80,$84
	.db $84,$84,$84,$84,$84,$81,$80,$80
	.db $80,$80,$80,$80,$80
