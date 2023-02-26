;$Size 009E
	list
	SIZE_CALCULATOR
	nolist
Weapon3_Wood:
	BANKORG_DB $1ED44C+3,$32 ;Type
	BANKORG_DB $1ED45E+3,$87 ;Flag
	BANKORG_DB $1ED470+3,$10 ;Δx
	BANKORG_DB $1ED482+3,$00 ;Vxlo
	BANKORG_DB $1ED494+3,$07 ;Vxhi
	BANKORG_DB $1ED4A6+3,$C0 ;Vylo
	BANKORG_DB $1ED4B8+3,$01 ;Vyhi
	BANKORG_DB $1ED4CA+3,$01 ;サイズ

	;ボスへヒット処理
	BANKORG $17A721
	bne Weapon3B_Reflected
	BANKORG $17A72A
	beq Weapon3B_Reflected
	BANKORG $17A747 ;倒せなかった時
	;特に変更なし
	BANKORG $17A750
Weapon3B_Reflected:
	lda #$2D
	jsr rSound
	lda #$02
	sta <$02
	lda oFlag,x
	and #~$03
	eor #$40
	sta oFlag,x
	clc
	rts

	;ザコへのヒット処理 1FE766
	BANKORG $1FE7A6 ;弾かれた時
	lda oFlag,x
	eor #$40
	and #$FC
	sta oFlag,x
	jmp $E7C1
	

	.include "src\w_3_damage.asm"

	;アニメーション定義
	BANKORG $1FFBF0+1
	db $FF ;アニメーションを凄く遅くする

	BANKORG Weapon3_Wood
WeaponHandler_3: ;W
	lda oVal0,x
	bne .Charger
	lda #$00
	sta oSprOrder,x
	sta oSprTimer,x
	lda #$00
	tay
	jsr TerrainTestEx ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	beq .NotHitIntoWall
	jmp $EF6A
.NotHitIntoWall
	jmp $EECD
.Charger
	inc oHP,x
	lda oHP,x
	cmp #(75)
	bcc .NotFullCharge
	bne .Charge_NoSE
	lda #$2D
	jsr rSound ; 音aを鳴らす
.Charge_NoSE
	and #$0F
	ora #$C0
	sta oHP,x
.NotFullCharge
	lda oHP,x
	cmp #(75)
	bcs .AnimTime0
	cmp #(75*3/4)
	bcs .AnimTime1
	cmp #(75*2/4)
	bcs .AnimTime2
	cmp #(75*1/4)
	bcs .AnimTime3
	lsr a
	asl <$00
.AnimTime3
	lsr a
	asl <$00
.AnimTime2
	lsr a
	asl <$00
.AnimTime1
	lsr a
	asl <$00
.AnimTime0
	and #$03
	clc
	adc #$01
	cmp oSprOrder,x
	beq .NotUpdateOrder
	sta oSprOrder,x
	lda oHP,x
	lsr a
	bcs .NoChargedSE
;	lda #$29
	lda #$31
	jsr rSound ; 音aを鳴らす
.NoChargedSE
.NotUpdateOrder
	lda #$00
	sta oSprTimer,x
	jsr Weapon3_Snap
	lda #$01
	sta vSlowWalk
	lda <vPadOn ; RLDUTEBA
	and #$02
	beq .Fire_Delete
	clc
	rts
.Fire_Delete
	;x1.5
	lda oHP,x
	sta <$00
	lsr a
	clc
	adc <$00
	bcs .Fire_Max
;	adc #(32)
	adc #(8) ;ゲタ
	bcs .Fire_Max
	cmp #(144-24) ;-24はボーナス
	bcc .Fire_NotMax
.Fire_Max
	lda #(144)
.Fire_NotMax
	sta vBusterTimer
	;最初の１発はかならず消費
	lda #$00
	sta <vWeaponEnergyCounter
	jmp $EF6A

	list
	SIZE_CALCULATOR
	nolist
