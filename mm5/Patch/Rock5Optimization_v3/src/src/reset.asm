	BANKORG_D $1FFE39
	lda #$06
	sta $8000
	lda #BANK(RESET_11_Org)
	sta $8001
	jmp RESET_11_Org
	END_BOUNDARY_TEST $1FFE55
