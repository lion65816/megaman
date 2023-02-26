RockIntoWater:
	stx oVal3
	lda vWaterFlag
	bne .WaterEnabled
	jmp $F16A
.WaterEnabled
	jmp $F0FF

WRAMMap_SetupNTTransfer:
;0 2 3 4 5 10
;20 21 29
.aSrc    = $20;array2
.vLoop   = $00
.v32Tile = $03
.vTmpCol = $04
.v16Tile = $05
.vAndMask = $10
.vVRAMQueueOffset = $29
	lda #$20
	sta aVRAMQueue+$0
	lda #$1D
	sta aVRAMQueue+$2

	lda <vNTDrawlo
	sta aVRAMQueue+$1
	asl a
	asl a
	asl a
	and #$F0
	sta <.aSrc+0
	lda <vNTDrawhi
	and #$0F
	ora #HIGH(aMap)
	sta <.aSrc+1

	lda <vNTDrawlo
	lsr a
	bcs .OddLine
;‹ô”ƒ‰ƒCƒ“
	ldy #$0E
.EvenLine_loop
	lda [.aSrc],y
	sty <.vLoop
	tax
	tya
	asl a
	tay
	lda aChipGrp+$000,x
	sta aVRAMQueue+$3,y
	lda aChipGrp+$200,x
	sta aVRAMQueue+$4,y
	ldy <.vLoop
	dey
	bpl .EvenLine_loop

	lda #$FF
	sta aVRAMQueue+$21
	sta <vVRAMTrig32
	rts
.OddLine
;Šï”ƒ‰ƒCƒ“
	sta <.v16Tile
	lsr a
	sta <.v32Tile

	ldy #$0E
.OddLine_loop
	lda [.aSrc],y
	sty <.vLoop
	tax
	tya
	asl a
	tay
	lda aChipGrp+$100,x
	sta aVRAMQueue+$3,y
	lda aChipGrp+$300,x
	sta aVRAMQueue+$4,y
;=====
	lda aChipHit,x
	sta <.vTmpCol
	ldy <.vLoop
	lda .Tbl_VRAMQueueOffset,y
	sta <.vVRAMQueueOffset
	lda .Tbl_NTColorTblOffset,y
	ora <.v32Tile
	tax

	lda .v16Tile
	lsr a
	lda <.vLoop
	rol a
	and #$03
	tay
	lda .Tbl_AndMask,y
	sta <.vAndMask
	tya
	ror <.vTmpCol
	rol a
	ror <.vTmpCol
	rol a
	tay
	lda aNTColor,x
	and <.vAndMask
	ora .Tbl_OrMask,y
	sta aNTColor,x
	ldy <.vVRAMQueueOffset
	bmi .SkipUpdateColor
	sta aVRAMQueue+3,y
	lda #$00
	sta aVRAMQueue+2,y
	lda #$23
	sta aVRAMQueue+0,y
	txa
	ora #$C0
	sta aVRAMQueue+1,y
.SkipUpdateColor
;=====
	ldy <.vLoop
	dey
	bpl .OddLine_loop
	lda #$FF
	sta aVRAMQueue+$41
	sta <vVRAMTrig32
	rts

.Tbl_NTColorTblOffset
	.db $00,$00,$08,$08,$10,$10,$18,$18
	.db $20,$20,$28,$28,$30,$30,$38

.Tbl_ForAudioProc
	.db $0C,$08,$04,$00

.Tbl_AndMask
	DB4 $FCF3CF3F
.Tbl_OrMask

;LTCC¦CC‚ÌãˆÊ‰ºˆÊ‚ª“ü‚ê‘Ö‚í‚Á‚Ä‚¢‚é
;	DB4444 $00010203,$0004080C,$00102030,$004080C0
	DB4444 $00020103,$0008040C,$00201030,$008040C0


.Tbl_VRAMQueueOffset
	DB4 $21FF25FF
	DB4 $29FF2DFF
	DB4 $31FF35FF
	DB3 $39FF3D

;.Tbl_ForAudioProc‚Ì‘±‚«
	.db $00,$0C,$08,$04,$00

	GLOBALIZE .Tbl_ForAudioProc,MISC_TblAudioRegOffset
