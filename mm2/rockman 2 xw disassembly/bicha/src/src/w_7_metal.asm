;$Size 023F
	list
	SIZE_CALCULATOR
	nolist
Weapon7_Metal:
	BANKORG_DB $1ED44C+7,$36 ;Type
	BANKORG_DB $1ED45E+7,$82 ;Flag
	BANKORG_DB $1ED470+7,$00 ;Δx
	BANKORG_DB $1ED482+7,$00 ;Vxlo
	BANKORG_DB $1ED494+7,$00 ;Vxhi
	BANKORG_DB $1ED4A6+7,$00 ;Vylo
	BANKORG_DB $1ED4B8+7,$00 ;Vyhi
	BANKORG_DB $1ED4CA+7,$02 ;サイズ

	;ボスへヒット処理
	BANKORG $17A8A6
	bne Weapon7B_Reflected
	BANKORG $17A8AA
	jsr Weapon7B_GetDamage
	BANKORG $17A8AF
	beq Weapon7B_Reflected
	BANKORG $17A8CC ;倒せなかった時
	bcs Weapon7B_NotBeat

	BANKORG $17A8D5
Weapon7B_GetDamage:
	cpx #$08
	bcs .RollerBody
	;泡
	lda $A923,y ;バスターダメージ
	rts
.RollerBody
	lda oVal0+9
	cmp #$06 ;歩行
	lda $A985,y ;メタルブレードダメージ
	jsr Weapon_ConvertDamageC
	ora #$00
	rts
Weapon7B_Reflected:
	lda #$02
	sta <$02
Weapon7B_NotBeat:
	jsr Weapon7_Reflected
	clc
	rts
	FILL_TEST $17A8FC

	;ザコへのヒット処理 1FE8FD
	BANKORG $1FE904
	bne Weapon7_Reflected
	BANKORG $1FE90A
	jsr Weapon7_Hit
	BANKORG $1FE90F
	beq Weapon7_Reflected
	BANKORG $1FE91F ;前フレームにもヒットしていたとき
	bne Weapon7_NotBeat
	BANKORG $1FE92F ;倒せなかった時
	bcs Weapon7_NotBeat

	BANKORG $1FE938
Weapon7_NotBeat:
	TYAX
Weapon7_Reflected:
	cpx #$08
	bcs .RollerBody
	lsr oFlag,x ;泡なら消す
	bpl $E954
.RollerBody ;ローラー本体+ダミー判定なら消えない/ノックバック
	lda oFlag+0
	and #$40
	eor #$40
	sta <$AF
	lda #$02
	sta oHP+8
	bne $E954
	FILL_TEST $1FE954

	;アニメーション定義
	.include "src\w_7_damage.asm"

	BANKORG Weapon7_Metal
WeaponHandler_7: ;M
	jsr Weapon7_GetRockState
	BCSL .Delete
	ldy oVal0,x
	lda .TblProc+1,y
	pha
	lda .TblProc+0,y
	pha
	rts

.Proc00 ;Init
	ldy #$00
	jsr .SetMotion
	inc oHP,x
	lda oHP,x
	cmp #$08
	bne .Proc00_NotSW
	lda #$02
	sta oVal0,x
	lda #$01
	sta oHP,x
	lda #$3B
	jsr rSound
	jsr .HitOn
.Proc00_NotSW
	jmp .Common_RollerProc

.Proc02
	ldy oHP,x
	cpy #$04
	beq .Proc04_init
	jsr .SetMotion
	inc oHP,x
	jmp .Common_RollerProc
.Proc04_init
	ldy #$03
	jsr .SetMotion ;※向きを整えるため
	ldx #$02
.Proc04_PlaceWater_loop
	ldy #$04
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	lda .Proc04_Tbl_Vxhi-2,x
	sta oVxhi,x
	lda .Proc04_Tbl_Vyhi-2,x
	sta oVyhi,x
	inx
	cpx #$05
	bne .Proc04_PlaceWater_loop
	ldx vProcessingObj
	jsr .HitOff
	lda #(6)
	sta oHP,x
	lda #$04
	sta oVal0,x
.Proc04
	ldy #$03
	jsr .SetMotion
	dec oHP,x
	beq .Proc06_init
	jmp .Common_RollerProc

.Proc06_init
	ldy #$04
	jsr .SetMotion
	jsr .HitOn
	lda #$06
	sta oVal0,x
.Proc06
	lda oFlag+0
	and #$40
	ora #$83
	sta oFlag,x

	lda <vPadOn ; RLDUTEBA
	and #$02
	beq .Proc08_init
	ldy #$05
	jsr .SetMotion_Walk
	lda #$01
	sta <vRockPosing
	stx <vRockPosingTimer

	lda oSprTimer,x
	bne .Proc06_NoSe
	lda #$31
	jsr rSound
.Proc06_NoSe

	jsr .HitOn
	ldy <vRockmanState
	cpy #$05 ;歩行中
	beq .Proc06_AnimOn
	lda #$00
	sta oSprTimer,x
	jsr .HitOff
.Proc06_AnimOn
	jmp .Common_RollerProc

.Proc08_init
	jsr .HitOff
	lda #$05
	sta oHP,x
	lda #$08
	sta oVal0,x
.Proc08
	dec oHP,x
	beq .Proc0A_init
	ldy oHP,x
	jsr .SetMotion
	jmp .Common_RollerProc
.Proc0A_init
	lda #$04
	sta oHP,x
	lda #$0A
	sta oVal0,x
.Proc0A
	dec oHP,x
	beq .Delete
	ldy #$00
	jsr .SetMotion
	jmp .Common_RollerProc
.Delete
	lsr oFlag,x
	lsr oFlag+8
	lda #$00
	sta <vRockPosingTimer
	sta <vRockPosing
	jsr $D3A5
	ldx <vProcessingObj
	rts

.Common_RollerProc
	lda oSprOrder,x
	and #$01
	sta oSprOrder,x
	;ノックバック
	lda oHP+8
	beq .Common_NoKnockback
	asl a
	sta <$4F
	sta <$50
	dec oHP+8
	lda #$01
	sta <$40
.Common_NoKnockback
	jsr $EECD
	lda oFlag,x
	bpl .Common_OutOfScreen
	and #$81
	sta oFlag+8
	lda oXhi,x
	sta oXhi+8
	sec
	sbc <vScrollXhi
	sta olXr,x
	sta olXr+8
	lda oXhe,x
	sta oXhe+8
	lda oYhi,x
	sta oYhi+8
	lda #$03
	sta oSprOrder+8
	lda #$00
	sta oSprTimer+8
	rts
.Common_OutOfScreen
	asl oFlag,x
	lda #$03
	sta oSprOrder,x
	jsr .HitOff
	lsr oFlag+8
	rts

.TblProc
	dw (.Proc00-1)
	dw (.Proc02-1)
	dw (.Proc04-1)
	dw (.Proc06-1)
	dw (.Proc08-1)
	dw (.Proc0A-1)

.Proc04_Tbl_Vxhi
	db 0,1,2
.Proc04_Tbl_Vyhi
	db 3,2,1

.HitOn
	;判定有効
	lda oFlag,x
	ora #$01
	sta oFlag,x
	rts

.HitOff
	;判定無効
	lda oFlag,x
	and #~$01
	sta oFlag,x
	rts


.SetMotion
	lda #$03
	sta vSlowWalk
	lda #$02
	sta <vRockPosingTimer

	lda oFlag,x
	and #$40
	sta <$00
	lda oFlag+0
	and #~$40
	ora <$00
	sta oFlag+0
.SetMotion_Walk

	lda #$00
	sta <$00
	clc
	lda .Tbl_Motion_Dx,y
	bit oFlag+0
	bvs .SetMotion_TowardR
	eor #$FF
	clc
	adc #$01
.SetMotion_TowardR
	ora #$00
	bpl .SetMotion_Dxp
	dec <$00
.SetMotion_Dxp
	adc oXhi+0
	sta oXhi,x
	lda <$00
	adc oXhe+0
	sta oXhe,x

	lda <vRockmanYhe
	bne .SetMotion_Y00
	clc
	lda oYhi+0
	adc .Tbl_Motion_Dy,y
	cmp #$F0
	bcc .SetMotion_NotY00
.SetMotion_Y00
	lda #$00
.SetMotion_NotY00
	sta oYhi,x
	lda .Tbl_Motion,y
	bmi .SetMotion_NotSwSpr
	jsr $D3B2
.SetMotion_NotSwSpr
	ldx vProcessingObj
	rts

.Tbl_Motion_Dx
	db $04,$10,$14,$0E,$14,$14
.Tbl_Motion_Dy
	db $EE,$F4,$00,$0A,$05,$05
.Tbl_Motion
	db $1B,$0C,$01,$03,$01,$FF


SHOTPROC_7: ;M 1EDB9C
	jsr Weapon7_GetRockState
	bcs .NotFire
	lda <vPadPress ; RLDUTEBA
	and #$02
	bne .Fire
.NotFire
	sec
	rts
.Fire
	ldx #$09
	lda oFlag+$09
	bmi .NotFire
	dec <aWeaponEnergy+6
	dec <aWeaponEnergy+6
	bpl .Fire_Enegy_p
	inc <aWeaponEnergy+6
.Fire_Enegy_p
	ldy #$07
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	;処理の都合上[8]にも一旦作成して消す
	dex
	ldy #$07
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	lsr oFlag+8
	clc
	rts

;	jmp $DA87 ;ショットモーションにして終了
;	jmp $DC4A ;投擲モーションにして終了

Weapon7_Hit:
	cpx #$08
	bcs .RollerBody
	;泡
	lda $E976,y ;バスターダメージ
	rts
.RollerBody
	lda oVal0+9
	cmp #$06 ;歩行
	lda $ECC2,y ;メタルブレードダメージ
	jsr Weapon_ConvertDamageC
	ora #$00
	rts


	list
	SIZE_CALCULATOR
	nolist
