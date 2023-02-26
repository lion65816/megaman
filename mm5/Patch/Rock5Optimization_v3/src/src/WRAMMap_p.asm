;※一部は、WRAMMap.asmの方に移動してあります。

WRAMMap_SetupNTTransfer:
;0 2 3 4 5 10
;20 21 29
.aSrc    = $20;array2
.vLoop   = $00
.v32Tile = $03
.vTmpCol = $04
.v16Tile = $05
.vVRAMQueueOffset = $02
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
;偶数ライン
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
;奇数ライン
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
	lda WRAMMap_Tbl_VRAMQueueOffset,y
	sta <.vVRAMQueueOffset
	lda WRAMMap_Tbl_NTColorTblOffset,y
	ora <.v32Tile
	tax

	lda .v16Tile
	lsr a
	lda <.vLoop
	rol a
	ror <.vTmpCol
	rol a
	ror <.vTmpCol
	rol a
	and #$0F
	tay
	lda aPreNTColor,x
	and WRAMMap_AndMask,y
	ora WRAMMap_OrMask,y
	sta aPreNTColor,x
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

UpdateChipOnObj:
	lda oXhi,x
	sta <$00
	lda oYhi,x
	sta <$02
UpdateChipOnObj_:
	lda oXhe,x
	sta <$01
UpdateChip:
	sty vUpdateChipWork
	lda #$08
	sta aVRAMQueueChip+0
	lda <$02
	asl a
	rol aVRAMQueueChip+0
	asl a
	rol aVRAMQueueChip+0
	and #$C0
	sta aVRAMQueueChip+1
	lda <$00
	lsr a
	lsr a
	lsr a
	and #$1E
	ora aVRAMQueueChip+1
	sta aVRAMQueueChip+1
	ora #$20
	sta aVRAMQueueChip+1+5
	lda aVRAMQueueChip+0
	sta aVRAMQueueChip+0+5
	lda #$01
	sta aVRAMQueueChip+2
	sta aVRAMQueueChip+2+5
	lda aChipGrp+$000,y
	sta aVRAMQueueChip+3
	lda aChipGrp+$100,y
	sta aVRAMQueueChip+4
	lda aChipGrp+$200,y
	sta aVRAMQueueChip+3+5
	lda aChipGrp+$300,y
	sta aVRAMQueueChip+4+5

	lda #$00
	sta aVRAMQueueChip+2+10
	sta <$10
	;00yy yxxx
	lda <$02
	lsr a
	lsr a
	and #$38
	sta <$04
	lda <$00
	asl a
	rol a
	rol a
	rol a
	and #$07
	ora <$04
	sta <$22
	lda <$02
	and #$10
	beq .NotY_XXX1XXXX
	inc <$10
.NotY_XXX1XXXX
	rol <$10

	lda aChipHit,y
	lsr a
	rol <$10
	lsr a
	rol <$10
	;TTCC (CCは上位下位入れ替わっている)
	ldy <$10
	lda WRAMMap_AndMask,y
	sta <$10
	lda WRAMMap_OrMask,y
	ldy <$22
	sta <$22
	lda aPreNTColor,y
	and <$10
	ora <$22
	sta aPreNTColor,y
	sta aVRAMQueueChip+3+10
	tya
	ora #$C0
	sta aVRAMQueueChip+1+10
	lda #$23
	sta aVRAMQueueChip+0+10

	lda #$FF
	sta aVRAMQueueChip+14
	sta <vVRAMTrigC

	ldy vUpdateChipWork
UpdateChipHit:
	lda <$01
	and #$0F
	ora #HIGH(aMap)
	sta <$04
	lda <$02
	lsr a
	lsr a
	lsr a
	lsr a
	sta <$03
	sty <$02
	lda <$00
	and #$F0
	tay
	lda <$02
	sta [$03],y
	rts
