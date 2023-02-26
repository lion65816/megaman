Misc_org:
;{●最適化

	;オーディオ処理のレジスタを叩く処理の最適化
	;テーブルを確保する位置の都合上、WRAMMapとセットで行われる。
	BANKORG_D $1880EC
	.IF Enable_Misc_WriteAudioReg&Enable_WRAMMap
	sta <$C4
	tya
	ora MISC_TblAudioRegOffset,x
	tay
	lda <$C4
	sta $4000,y
	rts
	.ENDIF

	.IF Enable_Misc_NMIExit
	;NMIを強制脱出
	BANKORG_D $1EC12B
	cli ;オーディオ処理中のラスター割り込みのためクリアしておく
	jmp $C15F
	BANKORG_D $1EC168
	rti
	.ENDIF

	.IF Enable_Misc_Gauge
	;ゲージのスプライトセットアップの最適化
	BANKORG_D $1EDF78
	jsr Misc_SetupGauges
	BANKORG_D $1EDF9B
	jsr Misc_SetupGauges
	BANKORG_D $1EDFB5
	jsr Misc_SetupGauges
;
	;キャリーフラグの変動を抑えることで
	;ゲージセットアップの最初にsecするだけで良くなっている
	BANKORG_D $1FE260
Misc_SetupGauges:
	sec
	ldx #$02
	jsr Misc_SetupAGauge_Boss
	ldx #$01
	jsr Misc_SetupAGauge
	ldx #$00
	jmp Misc_SetupAGauge

	ORG_DELTA $10
Misc_SetupAGauge_Boss:
	ldy <aGauge+2
	bpl Misc_SetupAGauge_rts
	ldy <vBossObj
	lda oHP,y
	ora #$80
	jmp Misc_SetupAGauge_ConfFromBoss
Misc_SetupAGauge:
	ldy <aGauge,x
	bpl Misc_SetupAGauge_rts
	lda aWeaponEnergy-$80,y
Misc_SetupAGauge_ConfFromBoss:
	ORG_TEST $E295

	BANKORG_D $1FE2B8
	ldy #$64
	lda <$00
	sbc #$04
	bmi .GaugeProc_4Gauge
	sbc #$1C
	tay
	lda #$80
.GaugeProc_4Gauge
	sta <$00
	tya
	sta aDMASrc+1,x
	inx
	inx
	inx
	inx
	beq Misc_SetupAGauge_rts
	lda <$03
	sbc #$08
	sta <$03
	cmp #$10
	bne $E2A9
	stx <vDMASrcPtr
Misc_SetupAGauge_rts:
	rts
	END_BOUNDARY_TEST $1FE2E1

	.ENDIF

	.IF Enable_Misc_ClearDMASrc
	;DMA転送元のクリアルーチンをアンローリング
	BANKORG_D $1EDF1E
	jmp Misc_ClearDMASrc
	.ENDIF

	;ロックマンの武器とロックマンとの判定をスキップ
	.IF Enable_Misc_DisCollRW
	BANKORG_D $1C805D
	bcc $8039
	.ENDIF

;}●最適化
;{●機能改善

	.IF Enable_SlidingCharge
	BANKORG_D $1B832D
	TRASH_GLOBAL_LABEL
	;チャージが無い(バスター以外の武器も)とき終了
	lda <$38
	beq .return
	;Ｂが押されていればチャージ処理をする
	bit <$16
	bvs .BHolded
	;チャージ時間が20hより短いとき終了
	cmp #$20
	bcc .return
.BHolded
	jmp $913D
.return
	;チャージ時間を0にするルーチンに飛ばす
	jmp $9236
;この場所に飛び込む処理がある
	rts
	END_BOUNDARY_TEST $1B8340
	.ENDIF

	.IF Enable_InvincibleTimeType=1
	BANKORG_D $1C817A
	jmp Misc_InvTime1
	.ENDIF
	.IF Enable_InvincibleTimeType=2 | Enable_InvincibleTimeType=3
	BANKORG_D $03A60A ;オクトパー
	jmp Misc_InvTime23
	BANKORG_D $04A166 ;ワイリーマシン　無効化した方が良いかもしれないが……
	jmp Misc_InvTime23
	BANKORG_D $1C807F ;「その他」
	jsr Misc_InvTime23
	BANKORG_D $1C8AF0 ;プカプーカーのボディ
	jsr Misc_InvTime23
	BANKORG_D $1C9525 ;ダチョーン
	jmp Misc_InvTime23
	BANKORG_D $1DA645 ;コッコ
	jsr Misc_InvTime23
	BANKORG_D $1DAA11 ;ユードーン
	jmp Misc_InvTime23
	.ENDIF

	.IF Enable_GoodDog
	BANKORG_D $1DB1A4
	cmp #$01
	bne $B187
	jsr $EC94 ;Δx
	cmp #$10
	bcs $B187
	lda $03F0 ;Vyhi
	bpl $B187
	jsr $EC76 ;Δy
	bcs $B187
	cmp #$10
	bcs $B187
	bit $0000
	nop
	.ENDIF

	.IF Enable_SlidingJumpInWaterEtc
	BANKORG_D $1B82B9
	and #$10
	bne $82C8
	lda #$4C
	jsr $8455
	bit $0000
	.ENDIF

	.IF Enable_DisableChargeCancel
	BANKORG_D $1C82FF
	bit <$38
	.ENDIF

	.IF Enable_QuickRecover
	BANKORG_D $1DAEEF
	jmp $AEF7
	.ENDIF

	.IF Enable_QuickFade
	BANKORG_D $1EC3FA+1
	.db $01
	.ENDIF

	.IF Enable_FixEnemyOffsetAtWarp
	BANKORG_D $1ED042
	jsr Misc_FixEnemyOffsetAtWarp
	.ENDIF

	.IF Enable_FixLadderAtAntigravity
	;横棒定義の容量を確保するために幾つかデータを入れ替える
	;01<=>26
	BANKORG_DB $1EC807+$01,FixLadderAtAntigravity_New01-$C837
	BANKORG_DB $1EC807+$26,FixLadderAtAntigravity_New26-$C837
	BANKORG_DB $1EC807+$27,FixLadderAtAntigravity_New27-$C837
	BANKORG_DB $1EC807+$28,FixLadderAtAntigravity_New28-$C837


	BANKORG_D $1EC83C ;元01
FixLadderAtAntigravity_New26:
	.db $01,$05,$F9,$0E
	BANKORG_D $1EC8D8 ;元26
FixLadderAtAntigravity_New01:
	.db $02,$F6,$F9,$07,$07
FixLadderAtAntigravity_New27:
	.db $00,$0C;,$00 ;次の00を利用して省略
FixLadderAtAntigravity_New28:
	.db $00,$F4,$00
	ORG_TEST $1EC8E2
	.ENDIF
	
	.IF Enable_NerfedSpike ;{
	BANKORG_D $1C82A5
	lda <$36
	lsr a
	lsr a
	and #$03
	tay
	lda <aWeaponEnergy+0
	sec
	jmp NerfedSpike
	ORG_TEST $1C82B2
	BANKORG_D $1C82B2
NerfedSpike_Tbl_Damage:
	db 28,7,4,1
	.ENDIF ;}


;}●機能改善
	BANKORG Misc_org
