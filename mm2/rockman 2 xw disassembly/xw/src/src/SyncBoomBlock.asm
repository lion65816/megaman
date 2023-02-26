SyncBoomBlock_Pre:

	BANKORG_D $1C8190
	jsr TimerInc_EnemyProc
	BANKORG_D $1C8242
	jsr TimerInc_EnemyProc

	BANKORG_D $1DB57C
	jsr BoonBlock_SetTimer

	BANKORG_D $1DB597+1
	.db $80
	BANKORG_D $1DB5D6+1
	.db $80


;ヒートマンステージでのテスト
	BANKORG_D $01B800+$10
	.db $30,$54,$42,$70
	BANKORG_D $01B800+$16
	.db $A0
	BANKORG_D $01B800+$18
	.db $66,$94
	BANKORG_D $01B800+$1D
	.db $A0
	BANKORG_D $01B800+$1F
	.db $73
	BANKORG_D $01B800+$20
	.db $A7
	BANKORG_D $01B800+$22
	.db $B2
	BANKORG_D $01B800+$24
	.db $70,$72,$46,$74
	.db $46,$70,$44,$72
	.db $44,$46,$60,$62
	.db $64,$66,$60,$72
	.db $64,$56,$40,$92
	.db $94,$60,$96,$70
	.db $62


	BANKORG SyncBoomBlock_Pre

BoonBlock_SetTimer:
	lda A_ObjYhi,x
	pha
	ora #$07
	sta A_ObjYhi,x
	pla
	and #$07
	tay
	lda .TimeTable,y
	sec
	sbc V_FrameCounterS
	sta $0160,x
	rts
.TimeTable
	.db $00,$20,$40,$60
	.db $80,$A0,$C0,$E0
TimerInc_EnemyProc:
	lda <$AA
	bne .SkipTimerInc
	inc V_FrameCounterS
.SkipTimerInc
	jmp $925B


