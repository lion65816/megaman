;$Size 03D9
	list
	SIZE_CALCULATOR
	nolist
Weapon6_Flash:
	BANKORG_DB $1ED44C+8,$37 ;Type
	BANKORG_DB $1ED45E+8,$80 ;Flag
	BANKORG_DB $1ED470+8,$00 ;Δx
	BANKORG_DB $1ED482+8,$00 ;Vxlo
	BANKORG_DB $1ED494+8,$00 ;Vxhi
	BANKORG_DB $1ED4A6+8,$00 ;Vylo
	BANKORG_DB $1ED4B8+8,$00 ;Vyhi
	BANKORG_DB $1ED4CA+8,$01 ;サイズ

	;ボスへヒット処理
	BANKORG $17A911+6
	DB2_SEPARATED Weapon6_HitProcB,9

	;ザコへのヒット処理 1FE766
	BANKORG $1FE964+6
	DB2_SEPARATED Weapon6_HitProc,9

	;判定サイズを画面全体化
	BANKORG $1ED561
	db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
	db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
	BANKORG $1ED601
	db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
	db $C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0


	;アニメーション定義
	BANKORG $1FFC10
	DB2 $0604
	db  $33,$34,$30,$31,$32,$00,$2E

	FILL_TEST $1FFC1B

	BANKORG $148000+$30
	DB2_SEPARATED SprDfn030,$200
	DB2_SEPARATED SprDfn031,$200
	DB2_SEPARATED SprDfn032,$200
	DB2_SEPARATED SprDfn033,$200
	DB2_SEPARATED SprDfn034,$200
	DB2_SEPARATED SprDfn035,$200
	DB2_SEPARATED SprDfn036,$200
	DB2_SEPARATED SprDfn037,$200
	DB2_SEPARATED SprDfn038,$200

	BANKORG $1489F8 ;スプライト定義
SprDfn030:
	DB2 $0100 ;形状は汎用の00
	DB2 $9C01
SprDfn031:
	DB2 $0100 ;形状は汎用の00
	DB2 $9D01
SprDfn032:
	DB2 $0100 ;形状は汎用の00
	DB2 $9E01
SprDfn033:
	DB2 $05F0
	DB2 $9800
	DB2 $9840
	DB2 $9A00
	DB2 $9880
	DB2 $98C0
SprDfn034:
	DB2 $0100
	DB2 $9B00
SprDfn035:
SprDfn036:
SprDfn037:
SprDfn038:
	FILL_TEST $148AAC

	BANKORG Weapon6_Flash
WeaponHandler_8: ;F
.Suf  = 9 ;メインオブジェクト
.SufY = 8 ;変化量Y
.SufD = 7 ;Y変化方向
.SufYhi =  5
.SufXhe = 4
.SufXhi = 3
.SufS = 2 ;射出状態
	lda oHP+.SufS ;射出後処理のためスキップ
	BNEL .SkipAfterFire1
;●ロックマンの状態に依るキャンセル
	jsr Weapon8_GetRockState
	bcc .NotCancelCharging
.CancelCharging_loop
	lsr oFlag,x
	dex
	cpx #$01
	bne .CancelCharging_loop
	ldx <vProcessingObj
	clc ;要らなそう
	rts
.NotCancelCharging
;●速度低下
	lda #$03
	sta vSlowWalk
;●アニメーション固定
	lda #$00
	sta oSprOrder+.Suf
	sta oSprTimer+.Suf
;●チャージによる射程延長
	lda oHP+.Suf
	cmp #$40
	bcs .Phase1
	;clc
	adc #$08
	sta oHP+.Suf
	lda #$40
	bne .Conf
.Phase1
	cmp #$A8
	bcs .Phase2
	;clc
	adc #$02
	sta oHP+.Suf
	cmp #$A8
	bne .Phase1_end
	lda #$2D
	jsr rSound ; 音aを鳴らす
.Phase1_end
.Phase2
	lda oHP+.Suf
.Conf
	sta <$00
;a=射程/●照準横移動
	bit oFlag+.Suf
	bvs .SetPos_TowardR
;左向き
	sec
	lda oXhi+0
	sbc <$00
	sta oXhi+.Suf
	lda oXhe+0
	sbc #$00
	jmp .SetPos_conf
.SetPos_TowardR
;右向き
	sec
	lda oXhi+0
	adc <$00
	sta oXhi+.Suf
	lda oXhe+0
	adc #$00
.SetPos_conf
	bpl .SetPos_LEdge
	lda #$00
	sta oXhi+.Suf
.SetPos_LEdge
	sta oXhe+.Suf
;・はみ出たら非表示に
	jsr $EF54 ;スクロールアウト処理
	bcc .SetPos_NotScrollout
	asl oFlag+.Suf
	lda #$06
	sta oSprOrder+.Suf
.SetPos_NotScrollout
;●照準上下移動
	lda <vPadOn ; RLDUTEBA
	and #$30
	beq .SetPosY_NotMove
	ldy #$00
	and #$10
	bne .SetPosY_MoveU
	iny
.SetPosY_MoveU
	tya
	eor oHP+.SufD
	lsr a
	bcs .SetPosY_n
	;clc
	lda oHP+.SufY
	adc #$03
	cmp #$C0
	bcc .SetPosY_end
	lda #$C0
	bne .SetPosY_end
.SetPosY_n
	;sec
	lda oHP+.SufY
	sbc #$03
	bcs .SetPosY_end
	;clc
	eor #$FF
	adc #$01
	pha
	lda #$01
	eor oHP+.SufD
	sta oHP+.SufD
	pla
.SetPosY_end
	sta oHP+.SufY
.SetPosY_NotMove
.SkipAfterFire1
;●照準Y設定
	lda oYhi+0
	ldy <vRockmanYhe
	beq .SetPosY_RockInscreen
	lda #$00
.SetPosY_RockInscreen
	sta <$02 ;後で使う
	ldy oHP+.SufS ;射出後処理のためスキップ
	bne .SkipAfterFire2
	ldy oHP+.SufD
	beq .SetPosY_ReticuleUpper
	clc
	adc oHP+.SufY
	bcs .SetPosY_ReticleDown_OutofSCreen
	cmp #$F0
	bcc .SetPosY_ReticuleInScreen
.SetPosY_ReticleDown_OutofSCreen
	lda #$EF
	bne .SetPosY_ReticuleInScreen
.SetPosY_ReticuleUpper
	sec
	sbc oHP+.SufY
	bcs .SetPosY_ReticuleInScreen
	lda #$00
;	bne .SetPosY_ReticuleInScreen
.SetPosY_ReticuleInScreen
	sta oYhi+.Suf
.SkipAfterFire2
;●ロックマンの向きの固定
	lda oFlag+.Suf
	and #$40
	sta <$00
	lda oFlag+0
	and #~$40
	ora <$00
	sta oFlag+0
;●ガイド配置
;・バスターの位置に修正
	lda #$00
	sta <$01
	lda oXhi+0
	bit oFlag+.Suf
	clc
	bvs .Guide_RockTowardR
	dec <$01
	adc #$F0
	db $2C ;bit hack
.Guide_RockTowardR
	;!bit hack
	adc #$10
	;!bit hack
	sta <$00
	lda oXhe+0
	adc <$01
	sta <$01
;	lda oYhi
;	sta <$02 ;さっきセット済み
;・差分を計算
	lda #$00
	sta oXlo+.Suf
	sta oYlo+.Suf
	sta <$04 ;Δxlo
	sta <$06 ;Δylo
	sta <$10 ;Δxhe
	;Y方向
	sec
	lda oYhi+.Suf
	sbc <$02
		rol a    ;
		eor #$01 ;キャリー反転
		ror a    ;
	ror a
	ror <$06 ;Δylo
	jsr .asr
	ror <$06 ;Δylo
	jsr .asr
	ror <$06 ;Δylo
	sta <$07 ;Δyhi
	;X方向
	sec
	lda oXhi+.Suf
	sbc <$00
	pha
	lda oXhe+.Suf
	sbc <$01
		rol a    ;
		eor #$01 ;キャリー反転
		ror a    ;
	pla
	ror a
	ror <$04 ;Δxlo
	jsr .asr
	ror <$04 ;Δxlo
	jsr .asr
	ror <$04 ;Δxlo
	sta <$05 ;Δxhi
	tay
	bpl .Guide_TowardL
	dec <$10 ;Δxhe
.Guide_TowardL
;エイム情報のバックアップ
	lda <$00
	sta oHP+.SufXhi
	lda <$01
	sta oHP+.SufXhe
	lda <$02
	sta oHP+.SufYhi
;flicker処理
	ldy #$03
	lda <vPadOn ; RLDUTEBA
	and #$02
	beq .NoFlicker
	lda <vFrameCounter
	and #$03
	tay
.NoFlicker
	sty <$11 ;flicker処理のフラグ
	lda <$06 ;Δylo
	sta <$0E
	lda <$07 ;Δyhi
	sta <$0F
	lda <$04 ;Δxlo
	sta <$08
	lda <$05 ;Δxhi
	sta <$09
	lda <$10 ;Δxhe
	sta <$0A
	jsr .Guide_sub
	jsr .Guide_sub
;実際に配置
	ldx #$02
.PlaceGuide_loop
	jsr Weapon6_EPlace
	clc
	lda oXlo+.Suf
	adc <$04 ;Δxlo
	sta oXlo+.Suf
	lda <$00
	sta oXhi,x
	adc <$05 ;Δxhi
	sta <$00
	lda <$01
	sta oXhe,x
	adc <$10 ;Δxhe
	sta <$01

	clc
	lda oYlo+.Suf
	adc <$06 ;Δylo
	sta oYlo+.Suf
	lda <$02
	sta oYhi,x
	adc <$07 ;Δyhi
	sta <$02


	inx
	cpx #.Suf
	bne .PlaceGuide_loop
	lda oHP+.SufS
	beq .SkipBeforeFire
;・発射後のエフェクトのための処理
	ldx #$02
.PlaceEffect_loop
	lda #$84
	sta oFlag,x
	lda #$02
	sta oSprOrder,x
	inx
	cpx #.Suf+1
	bne .PlaceEffect_loop
	inc <vProcessingObj ;オブジェクトの処理をやり直す
	jmp $EF53 ;画面外に出たら消える
.SkipBeforeFire
;●射出
	lda <vPadOn ; RLDUTEBA
	and #$02
	bne .NotFire
	jsr .Fired
.NotFire
	jsr $DA87 ;ショットモーションにして終了

;	ldx #.Suf
	;移動・スクロールアウトしない
	clc
	rts
;	jmp $EECD


.Fired
	lda #$23
	jsr rSound ; 音aを鳴らす
	jsr Weapon8_GetChargeLevel
	sty <$08
	sec
	lda <aWeaponEnergy+5
	sbc <$08
	bcs .NotFixEnergy
	lda #$00
.NotFixEnergy
	sta <aWeaponEnergy+5

	;遮蔽物のテスト
;	sta <$08 ;Xhiorg
;	sta <$09 ;Xheorg
;	sta <$0A ;Yhiorg
	ldx #$02
	stx <vProcessingObj
	lda oYhi+0
	pha
	lda oHP+.SufYhi
	sta oYhi+2
	sta oYhi+7 ;判定用
	lda oHP+.SufXhi
	sta oXhi+2
	sec
	sbc <vScrollXhi
	sta olXr+7 ;判定用
	lda oHP+.SufXhe
	sta oXhe+2
	lda oYhi+.Suf
	sta oYhi+0
	ldy #$40
	sec
	lda oXhi+.Suf
	sbc oHP+.SufXhi
	sta <$00
	lda oXhe+.Suf
	sbc oHP+.SufXhe
	lda #$00
	sta <$08 ;速さ
	lda #$04
	sta <$09 ;速さ
	jsr $F17E ;エイミングルーチンの途中
	pla
	sta oYhi+0
	;１手ずつ進めて(1)壁に当たる(2)照準より先に行く(3)画面外に出る
	;いずれかの条件を満たすまで続ける
	lda oFlag+2
	ora #$80
	and #$C0
	sta oFlag+2
.HitTest_loop
	lda oXhi+2
	sta oXhi+3
	lda oXhe+2
	sta oXhe+3
	lda oYhi+2
	sta oYhi+3
	jsr $EECD
	bcs .HitTest_end ;画面外に出た
	lda #$00
	tay
	jsr TerrainTestEx ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	bne .HitTest_end ;壁にあたった
	sec
	lda oXhi+2
	sbc oXhi+.Suf
	lda oXhe+2
	sbc oXhe+.Suf
	bit oFlag+2 ;向きにより分岐
	bvs .HitTest_TowardR
;左向き
	bcc .HitTest_end
	bcs .HitTest_loop
.HitTest_TowardR
;右向き
	bcc .HitTest_loop
;	bcs .HitTest_end
.HitTest_end
	lda oXhi+3
	sta oXhi+.Suf
	lda oXhe+3
	sta oXhe+.Suf
	lda oYhi+3
	sta oYhi+.Suf


;X=2
;	ldx #$02
	jsr Weapon6_EPlace_2
	inx
	jsr Weapon6_EPlace_2
.Fire_Delete_loop
	inx
	lsr oFlag,x
	cpx #.Suf-1
	bne .Fire_Delete_loop
	inx
	stx <vProcessingObj
	;・非表示
	lda #$06
	sta oSprOrder+.Suf
	;・状態変更
	inc oHP+.SufS
;	;・一瞬無敵になる
;	lda #(1)
;	sta <vInvincibleTime

;判定用
	lda oYhi+.Suf
	sta oYhi+8
	sec
	lda oXhi+.Suf
	sbc <vScrollXhi
	sta olXr+8
	cmp olXr+7
	bcs .Fire_NotSwapHitObj
	pha
	lda olXr+7
	sta olXr+8
	pla
	sta olXr+7
	lda oYhi+7
	pha
	lda oYhi+8
	sta oYhi+7
	pla
	sta oYhi+8
.Fire_NotSwapHitObj
	rts



.asr
	asl a
	php
	ror a
	plp
	ror a
	rts

.Guide_sub
	;y
	lda <$0F
	jsr .asr
	sta <$0F
	ror <$0E
	;x
	lda <$0A
	jsr .asr
	sta <$0A
	ror <$09
	ror <$08

	lsr <$11 ;flicker処理のフラグ
	bcc .GuideFlicker_NotAddH
	clc
	lda oYlo+.Suf
	adc <$0E
	sta oYlo+.Suf
	lda <$02
	adc <$0F
	sta <$02

	clc
	lda oXlo+.Suf
	adc <$08
	sta oXlo+.Suf
	lda <$00
	adc <$09
	sta <$00
	lda <$01
	adc <$0A
	sta <$01
.GuideFlicker_NotAddH
	rts

Weapon6_EPlace_2:
	jsr Weapon6_EPlace
	lda #$04
	sta olHitSize,x
	lda #$81
	sta oFlag,x
	lda #$06
	sta oSprOrder,x
	clc
	lda <vScrollXhi
	adc #$80
	sta oXhi,x
	lda <vScrollXhe
	adc #$00
	sta oXhe,x
	lda #$80
	sta oYhi,x
	rts
Weapon6_EPlace:
	lda #$84
	sta oFlag,x
	lda #$00
	sta oVxlo,x
	sta oVxhi,x
	sta oVylo,x
	sta oVyhi,x
	sta oSprTimer,x
	lda #$37
	sta oType,x
	lda #$01
	sta oSprOrder,x
	rts

SHOTPROC_6: ;F 1EDC2E
	jsr Weapon8_GetRockState
	bcs .NotFire
	lda <vPadOn ; RLDUTEBA
	and #$02
	bne .Fire
.NotFound
.NotFire
	sec
	rts
.Fire
	ldx #$09
	lda oFlag+$09
	bmi .NotFound
	ldy #$08
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	lda oFlag,x
	ora #$02
	sta oFlag,x
	lda #$00
	sta oHP+8
	sta oHP+7
	sta oHP+2
	clc
	rts

;	jmp $DA87 ;ショットモーションにして終了
;	jmp $DC4A ;投擲モーションにして終了

Weapon6_HitProc:
	ldy #(0*3)
	jmp MISC_LONG_CALL

Weapon6_HitProcB:
	ldy #(4*3)
	jmp MISC_LONG_CALL

Weapon8_GetChargeLevel:
	ldy #$00
	lda oHP+9
	cmp #$40
	bcc .NoCharged
	iny
	cmp #$A8
	bcc .MiddleCharged
	iny
.MiddleCharged
.NoCharged
	rts

Weapon7_GetRockState:
Weapon8_GetRockState:
	lda <vRockmanState
	cmp #$03
	bcc .CancelCharging
	cmp #$09
	bcc .NotCancelCharging
.CancelCharging
	sec
.NotCancelCharging
	rts

	list
	SIZE_CALCULATOR
	nolist
