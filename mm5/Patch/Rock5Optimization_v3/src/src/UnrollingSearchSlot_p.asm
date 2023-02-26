;by rock5_lite/Rock5easily

UnrollingSearchSlot_Org:

	BANKORG_D $1FF16F
	ldy	#$08
	jmp	Search_Slot

	BANKORG UnrollingSearchSlot_Org
Search_Slot:
.LOOP
	lda	$300,y
	beq	.Found
	iny
	lda	$300,y
	beq	.Found
	iny
	lda	$300,y
	beq	.Found
	iny
	lda	$300,y
	beq	.Found
	iny
	cpy	#$18
	bne	.LOOP
.NotFound
	; sec			; ã‚Ìcpy‚ÅƒLƒƒƒŠ[1‚Æ‚È‚é‚Ì‚ÅÈ—ª
	rts
.Found
	clc
	rts
