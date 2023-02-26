;$Size 0110
	list
	SIZE_CALCULATOR
	nolist
Weapon5_Quick:
	BANKORG_DB $1ED44C+5,$34 ;Type
	BANKORG_DB $1ED45E+5,$87 ;Flag
	BANKORG_DB $1ED470+5,$00 ;Δx
	BANKORG_DB $1ED482+5,$00 ;Vxlo
	BANKORG_DB $1ED494+5,$00 ;Vxhi
	BANKORG_DB $1ED4A6+5,$00 ;Vylo
	BANKORG_DB $1ED4B8+5,$00 ;Vyhi
	BANKORG_DB $1ED4CA+5,$01
	;ボスへヒット処理 17A7D1
	BANKORG $17A7D6
	bne Weapon5B_Reflected
	BANKORG $17A7DA ;ダメージ取り出し
	jsr Weapon5B_GetDamage
	BANKORG $17A7DF
	beq Weapon5B_Reflected_ ;もうHitEffectは済んでいる
	BANKORG $17A7FC
	bcs $A837 ;もうHitEffectは済んでいる

	BANKORG $17A805
Weapon5B_GetDamage:
	jsr Weapon5_HitEffect
	lda $A969,y
	jsr Weapon_ConvertDamageC
	tay ;ゼロフラグ更新
	rts
Weapon5B_Reflected:
	jsr Weapon5_HitEffect
Weapon5B_Reflected_:
	jmp $A82E
	FILL_TEST $17A82E

	;ザコへのヒット処理
	BANKORG $1FE82C ;反射属性
	bne Weapon5_Reflected
	BANKORG $1FE832 ;ダメージ取り出し
	jmp Weapon5_DamageProc
	BANKORG $1FE837 ;0ダメージ
	beq $E889 ;Weapon5_Reflectedの処理は既に済んでいる
	BANKORG $1FE844 ;多段ヒット
	bit $0000
	lda #$01
	sta $0100,x
	BANKORG $1FE857 ;倒せなかった
	bcs $E88E ;消えるなどの処理は済んでいる

	BANKORG $1FE860 ;弾かれたクイックブーメランに変化する処理を空きスペースに
Weapon5_DamageProc:
	jsr Weapon5_HitEffect
	lda $EBD2,y
	jsr Weapon_ConvertDamageC
	tay ;ゼロフラグ
	jmp $E835
Weapon5_HitEffect:
	lda oVal0,x
	lsr a
	inc oVal0,x ;分裂させるため
	bcc .NotDelete
	lsr oFlag,x
	sec
.NotDelete
	rts
Weapon5_Reflected:
	jsr Weapon5_HitEffect
	jmp $E889
	FILL_TEST $1FE889

	.include "src\w_5_damage.asm"

	;スプライト定義
	BANKORG $1FFBFE+2+3
	db $4A


	;アニメーション定義
	BANKORG $1FFBFE

	BANKORG Weapon5_Quick
WeaponHandler_5: ;Q
	lda oHP,x
	beq .Bomber
	dec oHP,x
	beq .Explode
	jmp $EECD
.Explode
	lda #$2B
	jsr rSound ; 音aを鳴らす
	ldy #$06
	lda $D44C,y
	sta oType,x
	jsr $D41F ;武器作成のルーチンの後半
	inc oSprOrder,x
	lda #$81
	sta oFlag,x ;存右？？弾重特当
	sta oVal0,x
	lda #$00
	sta oVxhi,x
	sta oVyhi,x
	jmp $EF53 ;画面外に出たら消える
.Bomber
	lda #$03
	sta oSprOrder,x
	sta oSprTimer,x
	lda oVal0,x ;分裂させるため
	bne .Split
	lda #$02
	ldy #$04
	jsr TerrainTestEx ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	bne .Split
	jmp $EECD
.Split
	lda oXhi,x
	sta <$0C
	lda oXhe,x
	sta <$0D
	lda oYhi,x
	sta <$0E
.Split_loop
	ldy #$05
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	lda <$0C
	sta oXhi,x
	lda <$0D
	sta oXhe,x
	lda <$0E
	sta oYhi,x
	lda #(7)
	sta oHP,x
	txa
	and #$03
	tay
	lda .Tbl_Vx,y
	sta oVxhi,x
	lda .Tbl_Vy,y
	sta oVyhi,x
	lda .Tbl_Flag,y
	sta oFlag,x

	dex
	cpx #$01
	beq .Split_exit
	cpx #$05
	bne .Split_loop
.Split_exit
	ldx <vProcessingObj
	inc <vProcessingObj ;オブジェクトの処理をやり直す
	jmp $EF53 ;画面外に出たら消える


.cV = $300

.Tbl_Vx
	db HIGH(.cV),HIGH(.cV) ;,0,0
	;続くテーブルの一部を利用
.Tbl_Vy
	db 0,0,HIGH(.cV),HIGH(-.cV)
.Tbl_Flag
	db $82,$C2,$C2,$82

SHOTPROC_5: ;Q
	lda <vPadPress ; RLDUTEBA
	and #$02
	bne .Fire
.NotFound
	sec
	rts
.Fire
	ldx #$09
	lda oFlag+$09
	bpl .Found
	ldx #$05
	lda oFlag+$05
	bmi .NotFound
.Found
	lda #$25
	jsr rSound ; 音aを鳴らす
;	sec
;	lda <aWeaponEnergy+1
;	sbc #$05
;	sbc #$00
;	bcs .NotFixEnergy
;	lda #$00
;.NotFixEnergy
;	sta <aWeaponEnergy+1
	dec <aWeaponEnergy+4
	ldy #$05
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	lda <vPadOn ; RLDUTEBA
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	lda .Tbl_Direction,y
	tay
	lda .Tbl_Vxlo,y
	sta oVxlo,x
	lda .Tbl_Vxhi,y
	sta oVxhi,x
	lda .Tbl_Vylo,y
	sta oVylo,x
	lda .Tbl_Vyhi,y
	sta oVyhi,x

;	jmp $DA87 ;ショットモーションにして終了
	jmp $DC4A ;投擲モーションにして終了

.Tbl_Direction
	db 2,0,4,2
	db 2,1,3,2
	db 2,1,3,2
	db 2,2,2,2

.cV  = $700
.c00 = 65536
.c45 = 46341 ; 45s*65536+0.5=;
.c90 = 0
.Tbl_Vxlo
	db LOW (.c90*.cV/65536)
	db LOW (.c45*.cV/65536)
	db LOW (.c00*.cV/65536)
	db LOW (.c45*.cV/65536)
	db LOW (.c90*.cV/65536)
.Tbl_Vxhi
	db HIGH(.c90*.cV/65536)
	db HIGH(.c45*.cV/65536)
	db HIGH(.c00*.cV/65536)
	db HIGH(.c45*.cV/65536)
	db HIGH(.c90*.cV/65536)
.Tbl_Vylo
	db LOW (.c00*.cV/65536)
	db LOW (.c45*.cV/65536)
	db LOW (.c90*.cV/65536)
	db LOW (-.c45*.cV/65536)
	db LOW (-.c00*.cV/65536)
.Tbl_Vyhi
	db HIGH(.c00*.cV/65536)
	db HIGH(.c45*.cV/65536)
	db HIGH(.c90*.cV/65536)
	db HIGH(-.c45*.cV/65536)
	db HIGH(-.c00*.cV/65536)

	list
	SIZE_CALCULATOR
	nolist

