Rockman_38_org:
;ロックマンに関係する処理/バンク38
	BANKORG Rockman_38_org
	.IF SW_FixRockMove_Sliding ;{

Rockman_38_IsSlidable:
	lda #$00
	sta <$11

	lda oDir+0
	lsr a
	lda #cRockSlideDx+1
	bcs .TowardL
	lda #-cRockSlideDx-1
.TowardL
	pha
	sta <$00
	lda #$0A
	sta <$01
	jsr rTerrainHit ;$11|=チップ属性,$13=チップ番号
	pla
	sta <$00
	lda #$FD
	sta <$01
	jsr rTerrainHit ;$11|=チップ属性,$13=チップ番号
	ldy <$11
	lda Rockman_FieldHitToRock,y
	bne .NotSlide
	jmp $828A
.NotSlide
	jmp $80A9 ;スライディングは行われない

	.ENDIF ;}
