;by rock5_lite/Rock5easily

UnrollingPalTransfer_Org:

	BANKORG_D $1EC092
	jmp UpdatePal

	BANKORG UnrollingPalTransfer_Org
UpdatePal:
	ldy	#$04
	clc
.LOOP
	lda	$600,x
	sta	$2007
	lda	$601,x
	sta	$2007
	lda	$602,x
	sta	$2007
	lda	$603,x
	sta	$2007
	lda	$604,x
	sta	$2007
	lda	$605,x
	sta	$2007
	lda	$606,x
	sta	$2007
	lda	$607,x
	sta	$2007
	txa
	adc	#$08
	tax
	dey
	bne	.LOOP
	jmp	$C09E
