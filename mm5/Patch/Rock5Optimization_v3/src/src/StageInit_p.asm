StageInit_Trig:
	lda #BANK(StageInit_Body)
	sta <vNewPrg8
	jsr rPrgBankSwap
	jmp StageInit_Body
