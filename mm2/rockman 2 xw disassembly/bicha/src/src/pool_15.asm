;特定バンクの空き容量に固定配置するデータ

Weapon6_CollisionProc: ;リッター3Kの当たり判定の実体
	jsr Weapon6_CollisionBody
	bcs .Hit
	rts
.Hit
	ldx <vProcessingObj
	lda oFlag,x
	and #$08
	bne .Reflected
	jsr Weapon8_GetChargeLevel
	sty <$08
	tya
	bne .UseStdTable
	ldy oType,x
	lda $E976,y ;バスターのダメージ
	jmp .Conf_BusterTable
.UseStdTable
	lsr a
	ldy oType,x
	lda .Tbl_Damage,y
	jsr Weapon_ConvertDamageC
.Conf_BusterTable
	sta <$00
	tay
	beq .Reflected
	ldy <$08
	lda Weapon6_Tbl_SE,y
	jsr rSound ; 音aを鳴らす
	lda #$01
	sta $0100,x
	sec
	lda oHP,x
	sbc <$00
	sta oHP,x
	beq .Defeated
	bcs .NotDefeated
	lda #$00
.Defeated
	sta oHP,x
	sec
	rts
.Reflected
	lda #$2D
	jsr rSound ; 音aを鳴らす
.NotDefeated
	clc
	rts

.Tbl_Damage
	.include "src\w_6_damage1.asm"

Weapon6_Tbl_SE:
	db $2B,$21,$22

Weapon6_CollisionProcB: ;リッター3Kの当たり判定の実体(ボス用)
	sec
	lda oXhi+1
	sbc <vScrollXhi
	sta <$2E
	lda oYhi+1
	sta <$00
	jsr Weapon6_CollisionBody
	bcs .Hit
	rts
.Hit
	ldx <vProcessingObj
	lda oFlag,x
	and #$08
	bne .Reflected
	jsr Weapon8_GetChargeLevel
	sty <$02
	tya
	bne .UseStdTable
	ldy <$B3
	lda .Tbl_Damage+$E,y
	jmp .Conf_BusterTable
.UseStdTable
	lsr a
	ldy <$B3
	lda .Tbl_Damage,y
	jsr Weapon_ConvertDamageC
.Conf_BusterTable
	tay
	beq .Reflected
	cmp #(20)
	bne .Not20Dmg
	lda #(28)
.Not20Dmg
	sta <$00
	ldy <$02
	lda Weapon6_Tbl_SE,y
	jsr rSound ; 音aを鳴らす
	lda #$01
	sta <$02
	lda #$01
	sta $0100,x
	sec
	lda oHP,x
	sbc <$00
	sta oHP,x
	beq .Defeated
	bcs .NotDefeated
	lda #$00
.Defeated
	sta oHP,x
	sec
	rts
.Reflected
	lda #$02
	sta <$02
	lda #$2D
	jsr rSound ; 音aを鳴らす
.NotDefeated
	clc
	rts

.Tbl_Damage
	.include "src\w_6_damage2.asm"

Weapon6_CollisionBody:
	;実際の判定を行う
	ldx <vProcessingObj
	ldy ohHitSize,x
	lda $D501,y ;Δx(バスターとの接触サイズ)
	sta <$08
	lda $D5A1,y ;Δy(バスターとの接触サイズ)
	sta <$09
;00(=Yhi) 08 09
;$2E = Xr
;	lda #$00
;	sta oXlo+4
;	sta oYlo+4
	lda oYhi+7
	sta oYhi+5
	lda oYhi+8
	sta oYhi+6
	lda olXr+8
	sta olXr+6
	cmp <$2E
	bcs .HitProc_NotOutR
	sta olXr+5
	lda oYhi+6
	sta oYhi+5
	jmp .HitProc_start
.HitProc_NotOutR
	lda olXr+7
	sta olXr+5
	cmp <$2E
	bcc .HitProc_start
	sta olXr+6
	lda oYhi+5
	sta oYhi+6
.HitProc_start
.HitProc_next
	;Y
	asl oYlo+4
	lda oYhi+5
	adc oYhi+6
	ror a
	ror oYlo+4
	sta oYhi+4
	;X
	asl oXlo+4
	lda olXr+5
	adc olXr+6
	ror a
	ror oXlo+4
	sta olXr+4
	ldy #$00
	cmp <$2E
	bcc .HitProc_ObjL
	iny
.HitProc_ObjL
	sta olXr+5,y
	lda oYhi+4
	sta oYhi+5,y
	;判定位置ここで決定

	sec
	lda <$2E
	sbc olXr+4
	INV_A_CC
	cmp <$08
	bcs .NoHit
	sec
	lda <$00
	sbc oYhi+4
	INV_A_CC
	cmp <$09
	bcc .Hit
.NoHit
	sec
	lda olXr+5
	sbc olXr+6
	INV_A_CC
	cmp #$04
	bcs .HitProc_next
;	clc
	rts
.Hit
	sec
	rts


Weapon2_ObjHandler:
	;時間経過に依るHPの変化
	dec oVal0,x
	bpl .Proc_p
	inc oVal0,x
	lda #$FC
	db $2C ;bit hack
.Proc_p
	;bit hackによりコード追加禁止
	lda #$10
	;bit hackここまで
	clc
	adc oHP,x
	sta oHP,x
	cmp #$F0
	bcs .Delete
	;速度設定/移動
	lda #-$04
	sta oVyhi,x
	sta oVylo,x
	jsr $EECD ;※消えることがある
	bcs .WallProc_end
	;地形ヒットに依る座標とHPの変化
.WallProc_loop
	lda #$00
	tay
	jsr TerrainTestEx_Ex ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	beq .NotHitIntoWall
	sec
	lda oHP,x
	sbc #$10
	sta oHP,x
	bcc .Delete
	sec
	lda oYhi,x
	sbc #$10
	sta oYhi,x
	bcs .WallProc_loop
.Delete
	lsr oFlag,x
	bpl .GenObj_Org
.NotHitIntoWall
	;足元
	lda #$00
	ldy #$08
	jsr TerrainTestEx_Ex ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	beq .OnGround
	jsr $F083 ;上に押し返す処理
.OnGround
.WallProc_end
;※この段階でこのオブジェクトが消滅済みのことがある
	;タワー作成
	lda oHP,x
	sta <$10

.GenObj_Org
	ldx #$08
.GenObj_Loop
	lda oFlag+9
	bpl .GenObj_NotExists
	sec
	lda <$10
	sbc #$10
	bcs .GenObj_Exists
.GenObj_NotExists
	lsr oFlag,x
	bpl .GenObj_Next
.GenObj_Exists
	sta <$10
	ldy #$02
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	lda oXhi+9
	sta oXhi,x
	lda oXhe+9
	sta oXhe,x
	lda oSprOrder+9
	sta oSprOrder,x
	lda #$00
	sta oVxhi,x
	sec
	lda oYhi+1,x
	sbc #$10
	bcc .GenObj_NotExists
	sta oYhi,x ;存在しない時は書き込まないことで上の方を維持できる
	lda #$00
	tay
	stx <vProcessingObj
	jsr TerrainTestEx_Ex ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	beq .GenObj_NotGeneratedInWall
	sec
	lda oHP+9
	sbc <$10
	bcs .GenObj_NotHP0
	lda #$00
.GenObj_NotHP0
	sta oHP+9
	lda #$00
	sta <$10
	beq .GenObj_NotExists
.GenObj_NotGeneratedInWall
.GenObj_Next
	dex
	cpx #$01
	bne .GenObj_Loop
	ldx #$09
	stx <vProcessingObj
	lda oFlag,x
	eor #$80
	asl a
	rts

Weapon1_Split:
	lda oXhi+9
	sta <$0C
	lda oXhe+9
	sta <$0D
	lda oYhi+9
	sta <$0E

;	lda #$2E
	lda #$39
	jsr rSound ; 音aを鳴らす
	ldx #$02-1
.Split_loop
	inx
	ldy #$01
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	lda <$0C
	sta oXhi,x
	lda <$0D
	sta oXhe,x
	lda <$0E
	sta oYhi,x
	lda #$08
	sta oSprOrder,x
	lda #$81
	sta oFlag,x
	lda .Tbl_Vylo-2,x
	sta oVylo,x
	lda .Tbl_Vyhi-2,x
	sta oVyhi,x
	lda .Tbl_Vxlo-2,x
	sta oVxlo,x
	lda .Tbl_Vxhi-2,x
	sta oVxhi,x
	bpl .SplitTowardR
	eor #$FF
	sta oVxhi,x
	lda oVxlo,x
	eor #$FF
	sta oVxlo,x
	;誤差1は気にしない
	lda #$C1
	sta oFlag,x
.SplitTowardR
	cpx #$09
	bne .Split_loop

	inc <vProcessingObj ;オブジェクトの処理をやり直す
	rts

.cV = $600
.c00 = 65536
.c45 = 46341 ;45o*65536+0.5=;
.c90 = 0

.Tbl_Vylo
	db LOW(.cV*.c90/65536)
	db LOW(.cV*.c45/65536)
	;↓に続く
.Tbl_Vxlo
	db LOW(.cV*.c00/65536)
	db LOW(.cV*.c45/65536)
	db LOW(.cV*.c90/65536)
	db LOW(-.cV*.c45/65536)
	db LOW(-.cV*.c00/65536)
	db LOW(-.cV*.c45/65536)
	db LOW(.cV*.c90/65536)
	db LOW(.cV*.c45/65536)

.Tbl_Vyhi
	db HIGH(.cV*.c90/65536)
	db HIGH(.cV*.c45/65536)
	;↓に続く
.Tbl_Vxhi
	db HIGH(.cV*.c00/65536)
	db HIGH(.cV*.c45/65536)
	db HIGH(.cV*.c90/65536)
	db HIGH(-.cV*.c45/65536)
	db HIGH(-.cV*.c00/65536)
	db HIGH(-.cV*.c45/65536)
	db HIGH(.cV*.c90/65536)
	db HIGH(.cV*.c45/65536)

Weapon4_Split:
	inc oVal0,x
	txa
	and #$03
	pha
	cmp #$01
	bne .NotPlace
	dex
.PlaceLoop
	ldy #$04
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	dex
	cpx #$01
	bne .PlaceLoop
.NotPlace
	pla
	tay
	ldx <vProcessingObj
	lda .Vxlo,y
	sta oVxlo,x
	lda .Vxhi,y
	sta oVxhi,x
	lda .Vylo,y
	sta oVylo,x
	lda .Vyhi,y
	sta oVyhi,x
	rts

.Vxlo
	db LOW ($0300),LOW ($0400),LOW ($0100),LOW ($0200)
.Vxhi
	db HIGH($0300),HIGH($0400),HIGH($0100),HIGH($0200)
.Vylo
	db LOW ($0240),LOW ($01C0),LOW ($0180),LOW ($0200)
.Vyhi
	db HIGH($0240),HIGH($01C0),HIGH($0180),HIGH($0200)
