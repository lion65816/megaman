;$Size 0107
	list
	SIZE_CALCULATOR
	nolist
Weapon8_Clash:
	BANKORG_DB $1ED44C+6,$35 ;Type
	BANKORG_DB $1ED45E+6,$87 ;Flag
	BANKORG_DB $1ED482+6,$00 ;Vxlo
	BANKORG_DB $1ED494+6,$02 ;Vxhi
	BANKORG_DB $1ED4A6+6,$00 ;Vylo
	BANKORG_DB $1ED4B8+6,$FE ;Vyhi
	BANKORG_DB $1ED4CA+6,$02 ;HitSize

;アニメーション定義書き換え
	BANKORG $1FFC04
	db $05,$02
	DB4 $2A393A3B
	DB2 $3C00

	BANKORG $1FE8A0
	bne Weapon8_Reflected
	BANKORG $1FE8AB
	beq Weapon8_Reflected
;命中/倒せなかった時
	BANKORG $1FE8CB
	bcs WeaponClash_Exp2

;命中/倒した時
	BANKORG $1FE8D2
	beq WeaponClash_Exp

;弾かれたり命中したが倒せなかった時
	BANKORG $1FE8D4
Weapon8_Reflected:
	cpx #$07
	bne $E8F9
	inc oHP,x
	bne $E8F9
WeaponClash_Exp2:
	lda #$01
	sta oHP,y
	bne $E88E
WeaponClash_Exp:
	lda #$01
	sta oHP,y
	sec
	rts
	FILL_TEST $1FE8F9

;●ボスの命中処理
	BANKORG $17A847 ;状態での反射
	bne Weapon8B_Reflected
	BANKORG $17A850 ;ダメージ量での反射
	beq Weapon8B_Reflected
	BANKORG $17A86D ;倒せなかった
	bcs WeaponClash_BossExp2
	BANKORG $17A874 ;倒せた
	beq WeaponClash_BossExp

	BANKORG $17A876
;反射された
Weapon8B_Reflected:
	cpx #$07
	bne $A89F ;爆風ならスルー
	inc oHP,x ;起爆
	bne $A89F ;スルーに繋ぐ
WeaponClash_BossExp2:
	inc oHP,x
	bne $A837
WeaponClash_BossExp:
	inc oHP,x
	sec
	rts

	FILL_TEST $17A89F

	include "src/w_8_damage.asm"

	BANKORG Weapon8_Clash
WeaponHandler_6: ;C
	lda #$00
	sta oSprTimer,x
	lda oHP,x
	bne .Exp
	lda oVyhi,x
	sta <$10
	lda #$06
	sta <$01
	sta <$02
	jsr rTerrainTest ;Obj[x]を壁,地面判定(X±$01,Y+$02)/($03,$00)に返す
	ldy oVal0,x
	bne .OnGround
	lda <$00
	beq .NotTouchDown
	lda <$10
	bpl .Exp
	inc oVal0,x
.NotTouchDown
	jmp $EECD
.OnGround
	lda <vFrameCounter
	lsr a
	bcs .NoSE
	and #$03
	beq .NoSE
	adc #$35-1
	jsr rSound ; 音aを鳴らす
.NoSE
	lda #$02
	sta oVxhi,x
	lda <$03
	beq .NotTouchOnWall
	lda #$08
	ldy #-$16
	jsr TerrainTestEx ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	beq .StepUp1
	sec
	lda <$0A
	sbc #$10
	sta <$0A
	jsr TerrainTestEx_sub
	bne .Exp
	ldy #$01
	db $2C ;bit hack
.StepUp1
	;ここにコードを書いてはならない
	ldy #$00
	lda .Tbl_Vy+0,y
	sta oVyhi,x
	lda .Tbl_Vy+2,y
	sta oVylo,x
	lda #$01
	sta oVxhi,x
	dec oVal0,x
.NotTouchOnWall
	jmp $EECD
.Exp
	ldx #$06
.PlaceExp_loop
	ldy #$06
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	inc oSprOrder,x
	lda #$81
	sta oFlag,x ;存右？？弾重特当
	lda #$00
	sta oVxhi,x
	sta oVyhi,x
	lda oXhe+7
	sta oXhe,x
	lda .Tbl_ExpDx-2,x
	bpl .PlaceExp_Dx_p
	dec oXhe,x
.PlaceExp_Dx_p
	clc
	adc oXhi+7
	sta oXhi,x
	bcc .PlaceExp_Dx_nc
	inc oXhe,x
.PlaceExp_Dx_nc
	lda oYhi+7
	clc
	adc .Tbl_ExpDy-2,x
	sta oYhi,x
	dex
	cpx #$01
	bne .PlaceExp_loop
	ldx #$07
	lda #$2B
	jsr rSound ; 音aを鳴らす

	lsr oFlag,x
	rts

.Tbl_Vy
	db $03,$04
	db $20,$80


.cExpD = 13
.cCos1 = 62328 ; (90-72)o*65536+0.5=;
.cCos2 = 38521 ; (90-144)o*65536+0.5=;
.cSin1 = 20252 ; (90-72)s*65536+0.5=;
.cSin2 = 53019 ;負数 (90-144)s*65536+0.5=;

.Tbl_ExpDx
	db 0
	db (.cCos1*.cExpD/65536)
	db (.cCos2*.cExpD/65536)
	db -(.cCos2*.cExpD/65536)
	db -(.cCos1*.cExpD/65536)
.Tbl_ExpDy
	db -.cExpD
	db (-.cSin1*.cExpD/65536)
	db (.cSin2*.cExpD/65536)
	db (.cSin2*.cExpD/65536)
	db (-.cSin1*.cExpD/65536)



.Tbl_Dy
	db 4,-2

.Vxlo
	db LOW ($0300),LOW ($0400),LOW ($0100),LOW ($0200)
.Vxhi
	db HIGH($0300),HIGH($0400),HIGH($0100),HIGH($0200)
.Vylo
	db LOW ($0240),LOW ($01C0),LOW ($0180),LOW ($0200)
.Vyhi
	db HIGH($0240),HIGH($01C0),HIGH($0180),HIGH($0200)

SHOTPROC_8: ;C
	lda <vPadPress ; RLDUTEBA
	and #$02
	bne .Fire
.NotFire
	sec
	rts
.Fire
	ldx #$07
	lda oFlag+$07
	bmi .NotFire
	sec
	lda <aWeaponEnergy+7
	beq .NotFire
	sbc #$02
	bcs .NotFixEnergy
	lda #$00
.NotFixEnergy
	sta <aWeaponEnergy+7

.Found
	lda #$29
	jsr rSound ; 音aを鳴らす
	ldy #$06
	jsr rCreateWeapon ;Obj[x]に武器yを作成
;	jmp $DA87 ;ショットモーションにして終了
	jmp $DC4A ;投擲モーションにして終了

	list
	SIZE_CALCULATOR
	nolist



