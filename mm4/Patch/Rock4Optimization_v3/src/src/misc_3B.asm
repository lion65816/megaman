;最適化{
;最適化}
;拡張機能等{
	.IF SW_FixWireGlitch
FixWireGlitch:
	bcs .NotCorrectValue
	lda #$00
.NotCorrectValue
	sta oVal0+4
	rts
	.ENDIF
;拡張機能等}
