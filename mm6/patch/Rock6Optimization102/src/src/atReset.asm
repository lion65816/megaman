AtReset_org:


	BANKORG AtReset_org
	SETBANK8000
AtReset_Body:
.Proc_org
;**************************************************
	;WRAM有効化
	lda #$80
	sta $A001
	;RAMクリア
	lda #$00
	tax
.ResetRAM_loop
	sta $6000,x
	sta $6100,x
	sta $6200,x
	sta $6300,x
	sta $6400,x
	sta $6500,x
	sta $6600,x
	sta $6700,x
	sta $6800,x
	sta $6900,x
	sta $6A00,x
	sta $6B00,x
	sta $6C00,x
	sta $6D00,x
	sta $6E00,x
	sta $6F00,x
	sta $7000,x
	sta $7100,x
	sta $7200,x
	sta $7300,x
	sta $7400,x
	sta $7500,x
	sta $7600,x
	sta $7700,x
	sta $7800,x
	sta $7900,x
	sta $7A00,x
	sta $7B00,x
	sta $7C00,x
	sta $7D00,x
	sta $7E00,x
	sta $7F00,x
	dex
	bne .ResetRAM_loop

	.IF SW_OptimizeObjectSpriteProc ;{
	ldx #$16
.SetupTable_SpriteOrder_loop
	txa
	sta aTblSpriteOrder+$00,x
	clc
	eor #$FF
	adc #$17
	sta aTblSpriteOrder+$18,x
	dex
	bpl .SetupTable_SpriteOrder_loop
	.ENDIF ;}
	.IF SW_OptimizeTerrain2 ;{
	ldy #$00
.CreateHighNibbleTbl_loop
	tya
	lsr a
	lsr a
	lsr a
	lsr a
	sta aTblHighNibble,y
	dey
	bne .CreateHighNibbleTbl_loop
	.ENDIF ;}
;**************************************************
.Proc_end

	;もし上の間に処理が記述されていれば、ジャンプ処理及び
	;このルーチン全体を呼び出すコードを記述
	.IF .Proc_org!=.Proc_end
	jmp $C51E ;※jmpするだけでも、LONG_CALLの影響は出ないはず

AtReset_org2:

	BANKORG $3FFFDA
	LONG_CALL AtReset_Body

	BANKORG AtReset_org2

	.ENDIF

