;by rock5_lite/Rock5easily

UseTableAtTerrainProc_Org:

	BANKORG_D $1ED7B9
Map64:
	tay
	lda	Map64_table,y
	sta	<$20
	lda	(Map64_table+$28),y
	sta	<$21
	rts

	BANKORG UseTableAtTerrainProc_Org
Map64_table:
	.db $00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0
	.db $00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0
	.db $00,$40,$80,$C0,$00,$40,$80,$C0
	.db $B6,$B6,$B6,$B6,$B7,$B7,$B7,$B7,$B8,$B8,$B8,$B8,$B9,$B9,$B9,$B9
	.db $BA,$BA,$BA,$BA,$BB,$BB,$BB,$BB,$BC,$BC,$BC,$BC,$BD,$BD,$BD,$BD
	.db $BE,$BE,$BE,$BE,$BF,$BF,$BF,$BF
