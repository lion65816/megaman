;by rock5_lite/Rock5easily
;※元ソースより、消費容量を少なく済むように改造しています
;　しかしながら……この発想はすごい……
;　さらに勝手ながら、サブルーチン呼び出しの部分の最適化を加えております。

SetupGaugeSprites_Org:

;ここからぷれさべーによる追加分
	BANKORG_D $1EDF78
	jsr Misc_SetupGauges
	BANKORG_D $1EDF9B
	jsr Misc_SetupGauges
	BANKORG_D $1EDFB5
	jsr Misc_SetupGauges

	BANKORG_D $1FE260
Misc_SetupGauges:
	ldx #$02
	jsr Misc_SetupAGauge
	ldx #$01
	jsr Misc_SetupAGauge
	ldx #$00
	jmp Misc_SetupAGauge
	
	BANKORG_D $1FE27E
Misc_SetupAGauge:
;ここまでぷれさべーによる追加分

	BANKORG_D $1FE2A9
	ldy	<$00
	lda	.Tbl_Offset,y
	tay
	sec
	jmp	Draw_Gauge
.Tbl_Offset
	.db $2E,$2D,$20,$13,$06,$2C,$1F,$12
	.db $05,$2B,$1E,$11,$04,$2A,$1D,$10
	.db $03,$29,$1C,$0F,$02,$28,$1B,$0E
	.db $01,$27,$1A,$0D,$00

	BANKORG SetupGaugeSprites_Org
Draw_Gauge:
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
	stx	<$9F
	rts
.Tbl_TileNo
	.db $64,$64,$64,$64,$64,$64,$64,$60
	.db $60,$60,$60,$60,$60,$64,$64,$64
	.db $64,$64,$64,$63,$60,$60,$60,$60
	.db $60,$60,$64,$64,$64,$64,$64,$64
	.db $62,$60,$60,$60,$60,$60,$60,$64
	.db $64,$64,$64,$64,$64,$61,$60,$60
	.db $60,$60,$60,$60,$60

