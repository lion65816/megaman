StageInit_Trig:
	lda #BANK(StageInit_Body)
	sta <vNewPrg8
	jsr rPrgBankSwap
	jsr StageInit_Body
	jmp rFadeIn
