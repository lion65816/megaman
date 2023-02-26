Terrain_S_org:
	BANKORG Terrain_S_org
;地形判定の最適化
	.IF SW_OptimizeTerrain ;{
;Out
;<$11 一番強い判定
;<$13 チップ番号
;<$4D 判定したXhi
;<$4E 判定したYhi
Misc_OptTerrain:
;X : 000X XXXX xxxv ****
;Y : YYYy ****

; 0000 0YYY XXXX Xxxx

	lda #$00
	sta <$03

	lda <$4D ;τXhi
	asl a
	rol <$4F ;τXhe
	asl a
	rol <$4F ;τXhe
	asl a
	bpl .LocalTile_Is_LeftSide
	inc <$03
.LocalTile_Is_LeftSide
	rol <$4F ;τXhe
	ldy <$4F ;τXhe

	lda <$4E ;τYhi
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bcc .LocalTile_Is_TopSide
	inc <$03
	inc <$03
.LocalTile_Is_TopSide
	lsr a
	bcs .YTile_Is_1357
	;Y=0246
	lsr a
	bcs .YTile_Is_26
	;Y=04
	lsr a
	bcs .YTile_Is_4
	lda aPage+$000,y
	bcc .YTile_conf
.YTile_Is_4
	lda aPage+$400,y
	bcs .YTile_conf
.YTile_Is_26
	;Y=26
	lsr a
	bcs .YTile_Is_6
	lda aPage+$200,y
	bcc .YTile_conf
.YTile_Is_6
	lda aPage+$600,y
	bcs .YTile_conf
.YTile_Is_1357
	;Y=1357
	lsr a
	bcs .YTile_Is_37
	;Y=15
	lsr a
	bcs .YTile_Is_5
	lda aPage+$100,y
	bcc .YTile_conf
.YTile_Is_5
	lda aPage+$500,y
	bcs .YTile_conf
.YTile_Is_37
	;Y=37
	lsr a
	bcs .YTile_Is_7
	lda aPage+$300,y
	bcc .YTile_conf
.YTile_Is_7
	lda aPage+$700,y
;	bcs .YTile_conf
.YTile_conf

;33
	asl a
	bcs .Chip_Is_23
	asl a
	ora <$03
	tay
	bcs .Chip_Is_1
	lda aTile+$000,y
	bcc .Chip_conf
.Chip_Is_1
	lda aTile+$100,y
	bcs .Chip_conf
.Chip_Is_23
	asl a
	ora <$03
	tay
	bcs .Chip_Is_3
	lda aTile+$200,y
	bcc .Chip_conf
.Chip_Is_3
	lda aTile+$300,y
;	bcs .Chip_conf
.Chip_conf

;チップ番号
	sta <$13 ;出力用に必須
	and #$07
	tay
	lda dBitTable,y
	sta <$02
	lda <$13
	lsr a
	lsr a
	lsr a
	tay
	lda aChipVaried,y
	ldy <$13
	and <$02
	bne .ChipIsVaried
	lda aChipFlag,y
	jmp .ChipIsVaried_conf
.ChipIsVaried
	lda aChipFlagV,y
.ChipIsVaried_conf
	lsr a
	lsr a
	lsr a
	lsr a
	jmp $DAE6

	.ENDIF ;}
	.IF SW_OptimizeTerrain2 ;{
Terrain_TrigLoadNextRoom:
	tya
	pha
	jsr $D716
	pla
	LONG_CALL Terrain_LoadRoom
	rts
	jmp $D716
Terrain_LoadTerrainFlag80:
	sta aChipVaried,y
	LONG_CALL Terrain_LoadTerrainFlag80_body
	rts

Terrain_ShutterResume:
	LONG_CALL Terrain_ShutterResume_Body
	jmp $D720

Terrain_WeaponGetScreen:
	LONG_CALL Terrain_WeaponGetScreen_Body
	jmp $C9BF

Terrain_CapsuleWarp:
	LONG_CALL Terrain_CapsuleWarp_Body
	jmp $89F5

Terrain_VaryFlag:
	LONG_CALL Terrain_VaryFlag_Body
	rts

Terrain_EndingBossDemo:
	;aは変更してはならない
	ldy $05B3
	ldx $8D18,y
	stx vCheckPointPage
	jmp $DBDB
	.ENDIF ;}


