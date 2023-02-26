;$Size 006F
	list
	SIZE_CALCULATOR
	nolist
Weapon1_Heat:
	BANKORG_DB $1ED44C+1,$30 ;Type
	BANKORG_DB $1ED470+1,$10 ;Δx
	BANKORG_DB $1ED45E+1,$83 ;Flag
	BANKORG_DB $1ED482+1,$00 ;Vxlo
	BANKORG_DB $1ED494+1,$04 ;Vxhi
	BANKORG_DB $1ED4A6+1,$00 ;Vylo
	BANKORG_DB $1ED4B8+1,$00 ;Vyhi

	;ボスへヒット処理
	BANKORG $17A657
	ldy <$B3 ;ボスの種類
	lda $A931,y
	BMIL $A903
	lda oFlag+1
	and #$08
	bne Weapon1B_Reflected
	lda oSprOrder,x
	cmp #$08
	lda $A931,y
	php
	jsr Weapon_ConvertDamageC
	sta <$00
	plp
	bcs .SmallBullet
	ora #$00
	beq .NoSE
	lda #$22
	jsr rSound ; 音aを鳴らす
	lda <$00
.NoSE
.SmallBullet
	tay
	jmp $A68C
	FILL_TEST $17A68C
	BANKORG $17A6B2
Weapon1B_Reflected:

	;ザコへのヒット処理
	BANKORG $1FE6AD
	lda oType,y
	tay
	lda oSprOrder,x
	cmp #$08
	lda $E9F2,y ;ダメージテーブル
	php
	jsr Weapon_ConvertDamageC
	sta <$00
	plp
	bcs .SmallBullet
	tay
	beq .NoSE
	lda #$22
	jsr rSound ; 音aを鳴らす
.NoSE
.SmallBullet
	bit <$00
	lda <$00
	ORG_TEST $1FE6CE
;	FILL_TEST $1FE6CE

	;多段ヒット
	BANKORG $1FE6DD
	lda #$01
	sta oFlag,y ;消える
	sta $0100,x

	
	;アニメーション定義
	BANKORG $1FFBDF
	DB2 $0906 ;分裂後消えるまでの時間を設定
	db $50,$50
	db $4E,$4D,$50,$4F,$52,$51
	db $4D,$00

	.include "src\w_1_damage.asm"

	BANKORG Weapon1_Heat
WeaponHandler_1: ;H
	lda #$00
	sta oSprTimer,x
	lda oVal0,x
	bne .Proc01
	lda #$00
	tay
	jsr TerrainTestEx ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	bne .Delete

	dec oHP,x
	bne .NotExplode
	inc oVal0,x
	lda #$02
	sta oSprOrder,x
	lsr oFlag,x ;当たらなくする
	asl oFlag,x
.NotExplode
	jmp $EECD
.Proc01
	inc oSprOrder,x
	lda oSprOrder,x
	cmp #$08
	bne .NotSplit
	ldy #(2*3)
	jsr MISC_LONG_CALL
.NotSplit
	jmp $EF53 ;画面外に出たら消える
.Delete
	lsr oFlag,x
	rts

SHOTPROC_1: ;H 1EDA9C
	lda <vPadPress ; RLDUTEBA
	and #$02
	bne .Fire
.NotFound
	sec
	rts
.Fire
	ldx #$01
.Seek_loop
	inx
	lda oFlag,x
	bmi .NotFound
	cpx #$09
	bne .Seek_loop
;x=#$09
	lda #$38
	jsr rSound ; 音aを鳴らす
	sec
	lda <aWeaponEnergy+0
	sbc #$03
	bcs .NotFixEnergy
	lda #$00
.NotFixEnergy
	sta <aWeaponEnergy+0
	ldy #$01
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	lda #(8)
	sta oHP,x
	jmp $DA87 ;ショットモーションにして終了
;	jmp $DC4A ;投擲モーションにして終了

	list
	SIZE_CALCULATOR
	nolist
