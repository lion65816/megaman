AtRoomScrolling_Trig:
	lda #BANK(AtRoomScrolling_Body)
	sta <vNewPrg8
	jsr rPrgBankSwap
	jsr AtRoomScrolling_Body
	jmp $CEE1
