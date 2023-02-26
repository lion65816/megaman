	SETBANKA000
WRAMMap_Moth:
	sta $079C
	ldy #$03

	ldx #$05
.Loop
	ldy .Tbl_FlagOffset,x
	lda $0696,y
	and .Tbl_FlagAnd,x
	beq .Next
	lda #$00
	ldy .Tbl_MapOffset,x
	sta aMap+$200,y
	sta aMap+$210,y
.Next
	dex
	bpl .Loop
	;‚±‚±‚Ìx‚ğ–ß‚èæ‚Å—˜—p
	rts
.Tbl_FlagOffset
	.db 0,0,1,2,2,3
.Tbl_FlagAnd
	.db $18,$80,$18
	.db $18,$80,$18
.Tbl_MapOffset
	.db $3B,$7B,$BB
	.db $3C,$7C,$BC


WRAMMap_DrillFloor:
	sta $0640,y
	stx <$01

	;00YY YXXX  -> XXX0 YYY0
	tya
	and #$07
	sta <$03
	tya
	and #$38
	asl a
	asl a
	ora <$03
	;0YYY 0XXX
	asl a
	rol a
	rol a
	rol a
	rol a
	sta <$02
	ldx <vProcessingObj
	lda oXhe,x
	and #$0F
	ora #HIGH(aMap)
	sta <$03
	
	ldy #$00
	jsr .Sub
	ldy #$01
	jsr .Sub
	ldy #$10
	jsr .Sub
	ldy #$11
	jsr .Sub


	ldx <$01
	rts
.Sub
	.IF !SW_WRAMMap_DrillLeverEx
	;’Êíˆ—
	lda [$02],y
	sec
	ldx #$10
	sbc #$25
	cmp #$02
	bcc .Sub_Swap_end
	ldx #$18
	sbc #$08
	cmp #$02
	bcc .Sub_Swap_end
	ldx #$01
	sbc #$2B
	cmp #$04
	bcc .Sub_Swap_end
	ldx #$09
	sbc #$08
	cmp #$02
	bcc .Sub_Swap_end
	ldx #$06
	sbc #$02
	cmp #$02
	bcs .Sub_Swap_rts
.Sub_Swap_end
	clc
	stx <$04
	adc <$04
	sta [$02],y
.Sub_Swap_rts
	rts
	.ELSE
	;‰ü‘¢Œü‚¯
	lda [$02],y
	tax
	lda aChipHit,x
	and #Const_16TileAttributeBits
	cmp #$70
	bne .Sub_Swap_rts
	clc
	lda [$02],y
	adc #$10
	sta [$02],y
.Sub_Swap_rts
	rts
	.ENDIF
