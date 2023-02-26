MidExp_Ani:
	.db $89,$01
	.db $FF,$FE,$FD,$FC
	.db $FB,$FA,$F9,$F8
	.db $F7,$00

MidExp_NA0:
	.db $04
	.db $07,$FF
	.db $59+0,$01,$59+1,$01,$59+0,$41,$59+2,$01,$59+2,$41,$59+0,$81,$59+1,$81,$59+0,$C1
MidExp_NA1:
	.db $04
	.db $11,$FE
	.db $59+0,$01,$59+1,$01,$59+0,$41,$59+2,$01,$59+2,$41,$59+1,$81,$59+0,$C1,$59+3,$01
	.db $59+3,$41,$59+3,$81,$59+3,$C1,$59+0,$01,$59+1,$01,$59+2,$01,$59+2,$41,$59+0,$81
	.db $59+1,$81,$59+0,$C1
MidExp_NA2:
	.db $04
	.db $17,$FD
	.db $59+3,$01,$59+3,$41,$59+3,$81,$59+3,$C1,$59+0,$01,$59+1,$01,$59+0,$41,$59+0,$41
	.db $59+4,$01,$59+4,$41,$59+2,$41,$59+2,$01,$59+2,$01,$59+2,$41,$59+4,$81,$59+4,$C1
	.db $59+0,$81,$59+3,$01,$59+3,$41,$59+0,$81,$59+1,$81,$59+0,$C1,$59+3,$C1,$59+3,$81
MidExp_NA3:
	.db $04
	.db $1F,$FC
	.db $59+0,$01,$59+1,$01,$59+0,$41,$59+4,$41,$59+4,$01,$59+2,$01,$59+2,$41,$59+4,$C1
	.db $59+4,$81,$59+3,$41,$59+3,$01,$59+3,$41,$59+3,$01,$59+5,$41,$59+0,$C1,$59+5,$01
	.db $59+0,$01,$59+5,$81,$59+3,$81,$59+3,$C1,$59+3,$81,$59+3,$C1,$59+4,$41,$59+4,$01
	.db $59+2,$01,$59+2,$41,$59+5,$C1,$59+4,$C1,$59+4,$81,$59+0,$81,$59+1,$81,$59+0,$C1
MidExp_NA4:
	.db $04
	.db $24,$FB
	.db $59+0,$01,$59+1,$01,$59+0,$41,$59+3,$41,$59+3,$01,$59+5,$41,$59+5,$01,$59+2,$41
	.db $59+5,$C1,$59+3,$81,$59+3,$C1,$59+1,$81,$59+0,$C1,$59+4,$41,$59+4,$01,$59+4,$01
	.db $59+5,$81,$59+6,$01,$59+4,$41,$59+4,$81,$59+4,$C1,$59+4,$C1,$59+1,$01,$59+0,$01
	.db $59+3,$41,$59+3,$01,$59+5,$01,$59+4,$81,$59+5,$41,$59+2,$01,$59+3,$C1,$59+3,$81
	.db $59+5,$C1,$59+5,$81,$59+0,$81,$59+1,$81,$59+0,$C1
MidExp_NA5:
	.db $04
	.db $19,$FA
	.db $59+3,$01,$59+3,$41,$59+4,$01,$59+4,$41,$59+6,$01,$59+3,$81,$59+3,$C1,$59+4,$81
	.db $59+4,$C1,$59+5,$01,$59+5,$41,$59+5,$01,$59+5,$41,$59+5,$81,$59+5,$C1,$59+5,$81
	.db $59+5,$C1,$59+4,$01,$59+4,$41,$59+6,$01,$59+3,$01,$59+3,$41,$59+4,$81,$59+4,$C1
	.db $59+3,$81,$59+3,$C1
MidExp_NA6:
	.db $04
	.db $11,$F9
	.db $59+4,$01,$59+4,$41,$59+5,$01,$59+5,$41,$59+4,$81,$59+4,$C1,$59+5,$81,$59+5,$C1
	.db $59+6,$01,$59+6,$01,$59+5,$01,$59+5,$41,$59+4,$01,$59+4,$41,$59+5,$81,$59+5,$C1
	.db $59+4,$81,$59+4,$C1
MidExp_NA7:
	.db $04
	.db $09,$F8
	.db $59+5,$01,$59+5,$41,$59+6,$01,$59+5,$81,$59+5,$C1,$59+6,$01,$59+5,$01,$59+5,$41
	.db $59+5,$81,$59+5,$C1
MidExp_NA8:
	.db $04
	.db $01,$E7
	.db $59+6,$01,$59+6,$01

MidExp_L0:
	.db $F4,$F4,$F4,$FC,$F4,$04,$FC,$F4,$FC,$04,$04,$F4,$04,$FC,$04,$04
MidExp_L1:
	.db $E8,$00,$E8,$08,$E8,$10,$F0,$00,$F0,$10,$F8,$08,$F8,$10,$F8,$F8
	.db $F8,$00,$00,$F8,$00,$00,$00,$E8,$00,$F0,$08,$E8,$08,$F8,$10,$E8
	.db $10,$F0,$10,$F8
MidExp_L2:
	.db $EC,$04,$EC,$0C,$F4,$04,$F4,$0C,$F4,$E4,$F4,$EC,$F4,$F4,$F4,$14
	.db $F8,$F8,$F8,$00,$FC,$F4,$FC,$E4,$FC,$04,$FC,$14,$00,$F8,$00,$00
	.db $04,$E4,$04,$EC,$04,$F4,$04,$04,$04,$0C,$04,$14,$0C,$F4,$0C,$EC
MidExp_L3:
	.db $E8,$E8,$E8,$F0,$E8,$F8,$EC,$0C,$EC,$04,$F0,$E8,$F0,$F8,$F4,$0C
	.db $F4,$04,$F8,$10,$F8,$08,$F8,$F0,$F8,$E8,$F8,$00,$F8,$F8,$F8,$F8
	.db $00,$00,$00,$F8,$00,$E8,$00,$F0,$00,$08,$00,$10,$04,$F4,$04,$EC
	.db $08,$00,$08,$10,$00,$00,$0C,$F4,$0C,$EC,$10,$00,$10,$08,$10,$10
MidExp_L4:
	.db $E4,$F4,$E4,$FC,$E4,$04,$EC,$F4,$EC,$EC,$EC,$0C,$EC,$04,$EC,$04
	.db $F4,$0C,$F4,$EC,$F4,$F4,$F4,$FC,$F4,$04,$F8,$10,$F8,$08,$F8,$E8
	.db $F4,$04,$FC,$FC,$F8,$F0,$00,$E8,$00,$F0,$00,$10,$04,$FC,$04,$F4
	.db $04,$0C,$04,$04,$04,$EC,$00,$08,$04,$F4,$0C,$F4,$0C,$0C,$0C,$04
	.db $0C,$F4,$0C,$EC,$14,$F4,$14,$FC,$14,$04
MidExp_L5:
	.db $E8,$F8,$E8,$00,$EC,$EC,$EC,$F4,$F0,$08,$F0,$F8,$F0,$00,$F4,$EC
	.db $F4,$F4,$F8,$E8,$F8,$F0,$F8,$08,$F8,$10,$00,$E8,$00,$F0,$00,$08
	.db $00,$10,$04,$04,$04,$0C,$08,$F0,$08,$F8,$08,$00,$0C,$04,$0C,$0C
	.db $10,$F8,$10,$00
MidExp_L6:
	.db $E8,$F8,$E8,$00,$EC,$EC,$EC,$F4,$F0,$F8,$F0,$00,$F4,$EC,$F4,$F4
	.db $FC,$EC,$FC,$0C,$04,$04,$04,$0C,$08,$F8,$08,$00,$0C,$04,$0C,$0C
	.db $10,$F8,$10,$00
MidExp_L7:
	.db $E8,$F8,$E8,$00,$F0,$F0,$F0,$F8,$F0,$00,$08,$08,$08,$F8,$08,$00
	.db $10,$F8,$10,$00
MidExp_L8:
	.db $EC,$FC,$0C,$FC