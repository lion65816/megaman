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
	; sec			; ���cpy�ŃL�����[1�ƂȂ�̂ŏȗ�
	rts
.Found
	clc
	rts
