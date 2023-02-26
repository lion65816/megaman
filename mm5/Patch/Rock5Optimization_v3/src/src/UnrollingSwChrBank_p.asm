;by rock5_lite/Rock5easily

UnrollingSwChrBank_Org:

	BANKORG_D $1EC0AC
	jmp	Switch_Chr

	BANKORG UnrollingSwChrBank_Org
Switch_Chr:				; ƒ‹[ƒv“WŠJ
	ldx	#$05
	stx	$8000
	lda	<$EF
	sta	$8001
	dex
	stx	$8000
	lda	<$EE
	sta	$8001
	dex
	stx	$8000
	lda	<$ED
	sta	$8001
	dex
	stx	$8000
	lda	<$EC
	sta	$8001
	dex
	stx	$8000
	lda	<$EB
	sta	$8001
	dex
	stx	$8000
	lda	<$EA
	sta	$8001
	jmp	$C0B9			; ‘±‚«‚Ìˆ—‚É–ß‚é
