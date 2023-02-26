;$Size 006F
	list
	SIZE_CALCULATOR
	nolist
WEAPON:
	BANKORG $1087D0
	incbin "src/weapon_font.bin"

WSt__ = $40
WSt_A = $41
WSt_B = $42
WSt_C = $43
WSt_D = $44
WSt_E = $45
WSt_F = $46
WSt_G = $47
WSt_H = $48
WSt_I = $49
WSt_J = $4A
WSt_K = $4B
WSt_L = $4C
WSt_M = $4D
WSt_N = $4E
WSt_O = $4F
WSt_P = $50
WSt_Q = $51
WSt_R = $52
WSt_S = $53
WSt_T = $54
WSt_U = $55
WSt_V = $56
WSt_W = $57
WSt_X = $58
WSt_Y = $59
WSt_Z = $5A
WSt_rd = $5B
WSt_do = $5C
WSt_co = $5D
WSt_ap = $5E
WSt_ex = $5F
WStK     = WSt__
WStKA    = $60
WStKI    = $61
WStKU    = $62
WStKE    = $63
WStKO    = $64
WStKKA   = $65
WStKKI   = $66
WStKKU   = $67
WStKKE   = $68
WStKKO   = $69
WStKSA   = $6A
WStKSI   = $6B
WStKSU   = $6C
WStKSE   = $6D
WStKSO   = $6E
WStKTA   = $6F
WStKTI   = $70
WStKTU   = $71
WStKTE   = $72
WStKTO   = $73
WStKNA   = $74
WStKNI   = $75
WStKNU   = $76
WStKNE   = $77
WStKNO   = $78
WStKHA   = $79
WStKHI   = $7A
WStKHU   = $7B
WStKHE   = $7C
WStKHO   = $7D
WStKMA   = $7E
WStKMI   = $7F
WStKMU   = $80
WStKME   = $81
WStKMO   = $82
WStKYA   = $83
WStKYU   = $84
WStKYO   = $85
WStKRA   = $86
WStKRI   = $87
WStKRU   = $88
WStKRE   = $89
WStKRO   = $8A
WStKWA   = $8B
WStKWO   = $8C
WStKNN   = $8D
WStKLTU  = $8E
WStKLYA  = $8F
WStKLYU  = $90
WStKLYO  = $91
WStKDAKU = $92
WStKHAND = $93
WStKBAR  = $94
WStKLA   = $95

	BANKORG $1BBCF3+2+12*0 ;ヒート
	db WStKNO
	db WStKU
	db WStKDAKU
	db WStKLA
	db WStKHU
	db WStKDAKU
	db WStKRA
	db WStKSU
	db WStKTA
	db WStKBAR
	BANKORG $1BBCF3+2+12*1 ;エアー
	db WStKSU
	db WStKBAR
	db WStKHA
	db WStKHAND
	db WStKBAR
	db WStKSI
	db WStKLYO
	db WStKLTU
	db WStKTO
	db WStK
	BANKORG $1BBCF3+2+12*2 ;ウッド
	db WStKHA
	db WStKDAKU
	db WStKRE
	db WStKRU
	db WStKSU
	db WStKHI
	db WStKHAND
	db WStKNA
	db WStKBAR
	db WStK
	BANKORG $1BBCF3+2+12*3 ;バブル
	db $9E
	db WStKKE
	db WStKLTU
	db WStKTO
	db WStKSU
	db WStKRO
	db WStKLTU
	db WStKSI
	db WStKLYA
	db WStKBAR
	BANKORG $1BBCF3+2+12*4 ;クイック
	db WStKKU
	db WStKI
	db WStKLTU
	db WStKKU
	db WStKHO
	db WStKDAKU
	db WStKMU
	db WStK
	db WStK
	db WStK
	BANKORG $1BBCF3+2+12*5 ;フラッシュ
	db WStKRI
	db WStKLTU
	db WStKTA
	db WStKBAR
	db $9D
	db WSt_K
	db WStK
	db WStK
	db WStK
	db WStK
	BANKORG $1BBCF3+2+12*6 ;メタル
	db WStKSU
	db WStKHU
	db WStKHAND
	db WStKRA
	db WStKRO
	db WStKBAR
	db WStKRA
	db WStKBAR
	db WStK
	db WStK
	BANKORG $1BBCF3+2+12*7 ;クラッシュ
	db WStKTI
	db $9F
	db WStKI
	db WStKSU
	db WStKHO
	db WStKDAKU
	db WStKMU
	db WStK
	db WStK
	db WStK


	BANKORG $169A1D+1 ;ワイリーマシンカバー脱落前に弾く武器１
	db $3
	BANKORG $169A21+1 ;ワイリーマシンカバー脱落前に弾く武器２
	db $4
	BANKORG $169A29+1 ;ワイリーマシンカバー脱落後に弾く武器
	db $7

	BANKORG $1C87A5 ;Bを押していなくても射出処理を呼ぶ
	bit <$00

	BANKORG $1C8818
	jmp Weapon_SlowWalk

	BANKORG $1EDCB5
	DB2_SEPARATED SHOTPROC_0,$C
	DB2_SEPARATED SHOTPROC_1,$C
	DB2_SEPARATED SHOTPROC_2,$C
	DB2_SEPARATED SHOTPROC_3,$C
	DB2_SEPARATED SHOTPROC_4,$C
	DB2_SEPARATED SHOTPROC_5,$C
	DB2_SEPARATED SHOTPROC_6,$C
	DB2_SEPARATED SHOTPROC_7,$C
	DB2_SEPARATED SHOTPROC_8,$C

	BANKORG $1EDD11
	DB2_SEPARATED WeaponHandler_0,$10
	DB2_SEPARATED WeaponHandler_1,$10
	DB2_SEPARATED WeaponHandler_2,$10
	DB2_SEPARATED WeaponHandler_3,$10
	DB2_SEPARATED WeaponHandler_4,$10
	DB2_SEPARATED WeaponHandler_5,$10
	DB2_SEPARATED WeaponHandler_6,$10
	DB2_SEPARATED WeaponHandler_7,$10
	DB2_SEPARATED WeaponHandler_8,$10
	ORG_D 1
	ORG_D 1
	ORG_D 1
	DB2_SEPARATED WeaponHandler_C,$10
	DB2_SEPARATED WeaponHandler_D,$10
	DB2_SEPARATED WeaponHandler_E,$10
	DB2_SEPARATED WeaponHandler_F,$10

	BANKORG WEAPON


TerrainTestEx: ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	sta <$08
	lda #$00
	sta <$0B
	clc
	tya
	adc oYhi,x
	sta <$0A
	lda oFlag,x
	asl a
	bmi .TowardRight
	;必ずcs
	lda oXhi,x
	sbc <$08
	sta <$08
	lda oXhe,x
	sbc #$00
	jmp .ConfRL
.TowardRight
	clc
	lda <$08
	adc oXhi,x
	sta <$08
	lda oXhe,x
	adc #$00
.ConfRL
	sta <$09
TerrainTestEx_sub:
	jsr rFieldTest ;地形(9~8,B~A)の属性取得
	ldx <vProcessingObj
	ldy <$00
	lda $E14C,y
	rts

TerrainTestEx_Ex:
	lda <vCurPrgBank
	pha
	jsr TerrainTestEx
	sta vTmpLongCallA
	pla
	jsr rSwapPrg
	lda vTmpLongCallA
	rts


Weapon_ConvertDamageC:
	bcs Weapon_ConvertDamageL
Weapon_ConvertDamageH:
	lsr a
	lsr a
	lsr a
	lsr a
	db $2C ;bit hack
Weapon_ConvertDamageL:
	;bit hackによりここにコードは書けない
	and #$0F
.ConvertDamageHigh_conf
	cmp #$0F
	bne .ConvertDamageLow_rts
	lda #(20)
.ConvertDamageLow_rts
	rts

Weapon_SlowWalk:
.Again
	lsr vSlowWalk
	bcc .NotSlowWalk
	lsr oVxhi+0
	ror a
	jmp .Again
.NotSlowWalk
	sta oVxlo+0
	jmp $881B


WeaponHandler_0: ;?
WeaponHandler_C:
WeaponHandler_D:
WeaponHandler_F:
	list
	SIZE_CALCULATOR
	nolist
