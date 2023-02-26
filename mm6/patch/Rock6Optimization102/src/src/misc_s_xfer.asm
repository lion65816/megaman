Misc_S_Xfer_org:
;高速転送用プログラム(固定バンク配置)
	BANKORG Misc_S_Xfer_org

	.IFDEF SW_FastTransfer ;{
Misc_FastTransferBody:
.loop
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	lda [$83],y
	sta $2007
	iny
	dex
	bne .loop
.test
	;0x63バイト
	.IF SW_DebugWarnSlowTransfer & HIGH(.test)!=HIGH(.loop)
	.FAIL ;Misc_FastTransferBody/遅いプログラム配置
	.ENDIF
	sty <$89 ;画像転送量
	rts
	.ENDIF ;}
