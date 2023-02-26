	SETBANK8000
RESET_31_Org:
	;WRAM�L����
	lda #$80
	sta $A001
	;RAM�N���A
	lda #$00
	tax
.ResetRAM_loop
	sta <$00,x
	sta $0100,x
	sta $0200,x
	sta $0300,x
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
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
	.IF SW_EffectEnemyEx
	lda #$00
	sta <vEffectEnemyEx
	.ENDIF
	.IF SW_SpriteSetup_WireMoth
	ldx #$DD
	stx aProcSpriteSetup_Wire+1
	inx
	stx aProcSpriteSetup_Moth+1
	lda #$E9
	sta aProcSpriteSetup_Wire+0
	lda #$0C
	sta aProcSpriteSetup_Moth+0
	.ENDIF
	;���̃��[�`����
	jmp $FE55

