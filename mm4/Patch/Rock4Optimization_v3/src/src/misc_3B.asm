;�œK��{
;�œK��}
;�g���@�\��{
	.IF SW_FixWireGlitch
FixWireGlitch:
	bcs .NotCorrectValue
	lda #$00
.NotCorrectValue
	sta oVal0+4
	rts
	.ENDIF
;�g���@�\��}
