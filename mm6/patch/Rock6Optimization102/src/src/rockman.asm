Rockman_org:
;ロックマンに関係する処理
	.IF SW_FixRockMove_Sliding ;{

	BANKORG_D $389119+$08 ;スライディングの地形判定
	.db cRockSlideDx, cRockSlideDx,-cRockSlideDx,-cRockSlideDx
	.db cRockSlideDx,-cRockSlideDx,-          $07,           $07

	BANKORG_D $38912D+$08
	DB4 $FD0AFD0A
	DB4 $0C0CFDFD

	;リフトの上でスライディングをAで止めた時に、
	;Vyが00.00ではないことにより「空中」状態に移行してしまうため、
	;リフト上でスライディングジャンプが出来ない問題に対応するために工夫。
	;この処理は、壁と床の間に１マス空間があった時に、Vyが00.00で無くなる問題にも対応可能。
	BANKORG $388343
	jsr Rockman_EndSlide
	;スライディング後に歩行に繋ぐ
	BANKORG_D $38834B
	jmp $8096

	;スプライトの位置調整
	BANKORG_D $2088E6+2*0
	.db $F6
	BANKORG_D $2088E6+2*1
	.db $F6
	BANKORG_D $2088E6+2*2
	.db $FE
	BANKORG_D $2088E6+2*3
	.db $FE
	BANKORG_D $2088E6+2*4
	.db $FE
	BANKORG_D $2088E6+2*5
	.db $FE
	BANKORG_D $2088E6+2*6
	.db $FF
	BANKORG_D $2088E6+2*7
	.db $06
	BANKORG_D $2088E6+2*8
	.db $06
	BANKORG_D $2088E6+2*9
	.db $06
	BANKORG_D $2088E6+2*10
	.db $06

	;スライディング開始時に目の前が空いているかどうかをテストする
	BANKORG $3880D4
	jmp Rockman_38_IsSlidable

	;足先をぶつけた時にのみ、一歩前に立ち上がる事が出来る
	BANKORG $388316
	bne $832F
	BANKORG $38832F
	jmp Rockman_Sliding_HitFoot

	.ENDIF ;}
	.IF SW_FixRockMove_Terrain ;{
	BANKORG $388718
	;移動前に各種値を初期化等
	;a=00
	sta <$12
	lda oFlag+0
	and #~$20
	sta oFlag+0
	lda $064B ;足元判定
	sta $067C ;1f前の足元判定
	.IF SW_FixRockMove_Block ;{
	lda oYhi+0
	sta vPrevYhi
	.ENDIF ;}
	;Y移動 {
	;・Y方向に移動
	jsr rMoveY_
	;・判定位置を計算/スライディング中上には動かないので、Vyの値のみをみる
	lda #$0C
	ldy <vVyhiW
	bpl .Y_MoveDown
	lda #$F7
.Y_MoveDown
	sta <$01
	sta vRock2TerrainTmp0
	;・判定処理
	lda #$00
	sta <$00
	jsr .TestTerrain_ex
	sta $064B ;足元判定
	beq .Y_Hit_NotUpdateA7
	sta <$A7 ;ロックマンの足元の判定
.Y_Hit_NotUpdateA7
	jsr $887E ;ロックマンの上下地形からの押し返し等処理/a=地形判定
	lda <$AD ;ロックマン移動処理後Yに1を足すか→押し戻されたか
	bne .Y_End

	lda #-$07
	.IF SW_FixRockMove_Sliding
	ldy <$A3 ;ロックマンの地形判定番号(0or8(スライディング))
	beq .Y_NotSliding
	lda #-cRockSlideDx
.Y_NotSliding
	.ENDIF
	sta vRock2TerrainTmp1
.Y_Again
	sta <$00
	lda vRock2TerrainTmp0
	sta <$01
	jsr .TestTerrain_ex
	beq .Y_NotHit2
	jsr $887E ;ロックマンの上下地形からの押し返し等処理/a=地形判定
.Y_NotHit2
	lda vRock2TerrainTmp1
	bpl .Y_End
	eor #$FF
	clc
	adc #$01
	sta vRock2TerrainTmp1
	bne .Y_Again
.Y_End
	;・押し戻しフラグがOnなら押し戻す
	lda <$AD ;ロックマン移動処理後Yに1を足すか→押し戻されたか
	beq .NotPushBackY
	ldx #$00
	jsr $DB75 ;縦押し戻し距離の計算の途中
	jsr MoveY_X00
	inc oYhi+0
.NotPushBackY
	;Y移動 }
	;X移動 {
	;・X方向に移動
	jsr MoveX
	;・判定位置を計算
	;●テーブルを利用すれば軽くなるかも
	lda #$07
	.IF SW_FixRockMove_Sliding
	ldy <$A3 ;ロックマンの地形判定番号(0or8(スライディング))
	beq .X_NotSliding
	lda #cRockSlideDx
.X_NotSliding
	.ENDIF
	ldy vVxhiW
	bpl .X_MoveTowardR
	eor #$FF
	clc
	adc #$01
.X_MoveTowardR
	sta <$00
	lda #$00
	sta <$01
	sta <$AD ;ロックマン移動処理後にYに1を足すか→押し戻されたか
	;・判定処理
	jsr .TestTerrain_ex
	pha
	lda #$F7
	ldy <$A3 ;ロックマンの地形判定番号(0or8(スライディング))
	beq .X_NotSliding2
	lda #$FD
.X_NotSliding2
	sta <$01
	jsr .TestTerrain_ex
	pha
	lda #$0A
	sta <$01
	jsr .TestTerrain_ex
	;・判定結果により押し返し処理を呼び出し
	beq .X_Hit_NoHit0
	jsr $8A96 ;ロックマンの左右地形からの押し返し等処理？a=地形判定
.X_Hit_NoHit0
	pla
	beq .X_Hit_NoHit1
	jsr $8A96 ;ロックマンの左右地形からの押し返し等処理？a=地形判定
.X_Hit_NoHit1
	pla
	beq .X_Hit_NoHit2
	jsr $8A96 ;ロックマンの左右地形からの押し返し等処理？a=地形判定
.X_Hit_NoHit2

	;・押し戻しフラグがOnなら押し戻す
	lda <$AD ;ロックマン移動処理後Yに1を足すか→押し戻されたか
	beq .NotPushBackX
	jsr $DB57 ;横押し戻し距離の計算の途中
	jsr MoveX_X00
.NotPushBackX
	;X移動 }
	jmp $8805
.TestTerrain_ex
	lda #$00
	sta <$11
	jsr $D9D1 ;Obj[CurObj]の地形とのヒット処理($11|=チップ属性,$13=チップ番号)
	lda <$11
	rts
	FILL_TEST $388805

	BANKORG $388A26 ;落下床からの押し戻しのため。これ元からまずいんじゃないか……？
	sta <vTmpB
	BANKORG $388A45
	lda <vTmpB

	BANKORG $388A74
	ldy vRock2TerrainTmp0 ;判定Δy
	BANKORG $388A7F
	inc <$AD ;ロックマン移動処理後にYに1を足すか→押し戻されたか
	rts
	BANKORG $388AF7
	inc <$AD ;ロックマン移動処理後にYに1を足すか→押し戻されたか
	rts

	.ENDIF ;}
	.IF SW_FixRockMove_Block ;{
	.IF SW_FixRockMove_Terrain=0 ;{
	BANKORG $388734 ;地形補正も入っている時はそちらで補正する
	jsr Rockman_SavePrevYhi
	.ENDIF ;}
	
	BANKORG $388F46+$2
	db LOW(Rockman_PushBackByBlockObj)
	BANKORG $388F46+$5
	db LOW(Rockman_PushBackByBlockObj)
	BANKORG $388F46+$9
	db LOW(Rockman_PushBackByBlockObj)
	BANKORG $388F56+$2
	db HIGH(Rockman_PushBackByBlockObj)
	BANKORG $388F56+$5
	db HIGH(Rockman_PushBackByBlockObj)
	BANKORG $388F56+$9
	db HIGH(Rockman_PushBackByBlockObj)

	BANKORG $3087A4 ;カウントボムのハンドラを調整
	jmp $87A7

	.ENDIF ;}
	.IF SW_FixRockMove_Collision ;{
	BANKORG $388EDF
	jsr Rockman_Collision
	.ENDIF ;}
	.IF SW_FixRockMove_Wait ;{
	BANKORG $388087 ;歩き出し
	jsr Rockman_WaitWithMoveProc
	BANKORG $38816A ;ジェット・パワー着地時
	jsr Rockman_WaitWithMoveProc
	.ENDIF ;}
	.IF SW_FixRockMove_HoverJump ;{
	BANKORG $3880AF ;歩行
;	jmp Rockman_HoverJump_Walk
	jmp [aProcIsFalling] ;※飛び先でステージ判定するよりコストが少し安い(が、煩雑)
;スライディングで１フレーム浮くのもどうにかしようとした形跡
;	BANKORG $3882DC ;スライディング
;	beq $82E3
;	bit <$00
	BANKORG $3886D7
	jmp Rockman_FallInWater
	BANKORG $298BCE
	jsr Rockman_HoverJump_BLift
	BANKORG $298C36
	jsr Rockman_HoverJump_BLift
;潜水艦不具合をどうにかしようとした形跡
;	BANKORG $3ED4F8
;	lda <vRockAppState ;ロックマンの見かけ状態([止動歩ス梯端Je空)
;	and #$04
;	beq $D503
;	bne $D50D
;	BANKORG $3ED506
;	sec
;	BANKORG $3ED50A
;	jsr Rockman_HoverJump_Submarine
	
	.ENDIF ;}
	.IF SW_FixRockMove_FullJumpFromWater ;{
	BANKORG $388992
	jsr Rockman_FullJumpGlitch
	.ENDIF ;}
	.IF SW_FixPowerShotGlitchAtLadder ;{
	BANKORG $38887A
	jmp Rockman_LadderInit
	.ENDIF ;}
	.IF SW_SwitchWeapon ;{
	BANKORG $388E95
	jsr Rockman_SwitchWeapon
	.ENDIF ;}
	.IF SW_SmoothAirBrake ;{
	BANKORG $38813E
	bit <$00
	jsr Rockman_SmoothAirBrake_trig
	ORG_TEST $388143
	.ENDIF ;}
	.IF SW_FixNotJumpableFrame ;{
	BANKORG $3880B7
	jmp Rockman_FixNotJumpableFrame
	nop
	BANKORG $3880BB
	.ENDIF ;}

	BANKORG Rockman_org
	.IF SW_SwitchWeapon ;{
Rockman_SwitchWeapon_Body:
	lda vCurWeapon
	sta <$01 ;PrevWeapon

	lda <vPadHold;ABETUDLR
	and #$30
	cmp #$30
	bne .SwitchWeapon_NotSelSta
	;セレクトスタート同時押し
	ldy #$00
	lda <vPadHold;ABETUDLR
	and #$0C
	beq .SelSta_ToNormal
	and #$08
	bne .SelSta_ToJet
;パワーへ切り替え
	iny
.SelSta_ToJet
	iny
.SelSta_ToNormal
	cpy <vRush ;0N/1J/2P
	bne .SwitchRushForm
	tya
	bne .rts2
	lda #$00
	sta vCurWeapon
	beq .Decided
.SwitchRushForm
	jmp .SwitchRushForm_body
.SwitchWeapon_NotSelSta
	lda <vRush ;0N/1J/2P
	bne .rts2

	lda #$1B
	sta aWeaponEnergy_dummy

	ldy #$01
	lda <vPadHold;ABETUDLR
	and #$04
	beq .NotReverseScan
	ldy #$FF
.NotReverseScan
	sty <$00
.ScanAgain
	clc
	lda vCurWeapon
	adc <$00
	bpl .Scan_NotNLoop
	lda #$09
.Scan_NotNLoop
	cmp #$0A
	bcc .Scan_NotPLoop
	lda #$00
.Scan_NotPLoop
	sta vCurWeapon
	ldy vCurWeapon
	lda aWeaponEnergy_dummy,y
	cmp #$80
	beq .ScanAgain
.Decided
	lda vCurWeapon
	cmp <$01 ;PrevWeapon
	bne .DoSwitching
.rts2
	rts
.DoSwitching
	;a利用
	;サブ画面のカーソルの位置
	ldy #$00
	cmp #$05
	bcc .SubCursorX
	sec
	sbc #$05
	iny
.SubCursorX
	sty vSubCursorX
	sta vSubCursorY
	ldy #$01
	ora vSubCursorX
	bne .DS_NotRockBuster
	dey
.DS_NotRockBuster
	sty vSubCursorA

	;音
	lda #$32
	sta <vAudio

	;3895E7あたりを参考
	ldx #$05
	LONG_CALL_D $389624 ;Obj[5->1]削除
	LONG_CALL_D $389617 ;各設定
	;画像転送
	ldy vCurWeapon
	lda .Tbl_WeaponGrpAddr_lo,y
	sta aWeaponGrpAddr+0
	lda .Tbl_WeaponGrpAddr_hi,y
	sta aWeaponGrpAddr+1
	lda .Tbl_WeaponGrpAddr_bank,y
	sta aWeaponGrpAddr+2
	lda #$02
	sta vWeaponTransfer

	lda #$09
	ldy vCurWeapon
	beq .Color_09
	cpy #$09
	beq .Color_09
	dey
	tya
	ora #$B0
.Color_09
	sta <vCurWeaponColor
	jsr rTransferPalette
.rts
	rts

.Tbl_WeaponGrpAddr_bank
	db $00,$03,$03,$03,$03
	db $03,$03,$03,$00,$02
.Tbl_WeaponGrpAddr_hi
	db $87,$83,$8B,$83,$83
	db $87,$87,$87,$87,$9B
.Tbl_WeaponGrpAddr_lo
	db $10,$10,$10,$10,$10
	db $10,$10,$10,$10,$10

.SwitchRushForm_body

	lda <vRockAppState ;ロックマンの見かけ状態([止動歩ス梯端Je空)
	cmp #$03
	beq .SRF_rts
	tya
	beq .SRF_DoSwitch
	.IF SW_DebugAlwaysHaveAdaptor
	bne .SRF_DoSwitch
	.ENDIF
	cpy #$01
	bne .SRF_EquipableTestPower
	lda aClearFlag+3
	and #$01
	bne .SRF_DoSwitch
.SRF_rts
	rts
.SRF_EquipableTestPower
	lda aClearFlag+2
	and #$01
	beq .SRF_rts
.SRF_DoSwitch

	sty <vRush ;0N/1J/2P

	lda #$00
	sta vCurWeapon
	sta vWeaponTransfer

	;サブ画面のカーソルの位置
	sty vSubCursorX
	sta vSubCursorY
	sta vSubCursorA

	lda .SRF_ChargeTimer,y
	sta vFullChargeTime

	;画像転送
	lda #$00
	sta <vPPUCnt1
	ldy <vRush ;0N/1J/2P
	lda .SRF_TestRenderCode,y
	jsr rReserveTransfer2 ;VRAM転送aを実行/状況によりキューが開くのを待つ
	lda #$1E
	sta <vPPUCnt1

	ldy <vRush ;0N/1J/2P
	lda .SRF_ColorCode,y
	sta <vCurWeaponColor
	jsr rTransferPalette

	;3895E7あたりを参考
	ldx #$05
	LONG_CALL_D $389624 ;Obj[5->1]削除
	LONG_CALL_D $389617 ;各設定

	lda <vRockAppState ;ロックマンの見かけ状態([止動歩ス梯端Je空)
	jsr $E101

	lda #$2A
	sta <vAudio
	rts
.SRF_TestRenderCode
	.db $00,$02,$03
.SRF_ChargeTimer
	.db $5A,$3C,$3C
.SRF_ColorCode
	.db $09,$0A,$0A

	.ENDIF ;}

	.IF SW_SmoothAirBrake ;{
Rockman_SmoothAirBrake:
	;この段階でVyが正数出ないことが確定している。
	;設定によっては、負数でも値により処理を行わない。
	.IF SW_SmoothAirBrake >= 2
	lda oVal1+0
	cmp #$101-SW_SmoothAirBrake
	bcs .NoBrake
	.ENDIF
	;Y速度の小数部を0Cに設定。
	lda oVal0+0
	and #$0F
;	cmp #$01 ;上昇気流に吹き上げられているときは、処理を行わない。
;	beq .NoBrake
	sta oVal0+0
	lda #LOW($101-SW_SmoothAirBrake)
	sta oVal1+0
.NoBrake
	rts
	.ENDIF ;}
