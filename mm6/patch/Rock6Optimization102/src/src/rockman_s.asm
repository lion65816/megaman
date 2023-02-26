Rockman_S_org:
;ロックマンに関係する処理/常時割り当てバンク
	BANKORG Rockman_S_org

Rockman_FieldHitToRock:
	.db 0,1,0,0,0,1,0,1
	.db 0,1,0,1,1,1,0,1
	.db 0,1,0,1,0,1,0,1
	.db 0,1,0,1,0,1,1,1


	.IF SW_FixRockMove_Sliding ;{
Rockman_EndSlide:
	lda oVal1+0
	bne .Falling
	lda oVal0+0
	cmp #$40+1
	bcs .Falling
	lda #$00
	sta oVal0+0
.Falling
	lda oVal0+0
	rts
Rockman_Sliding_HitFoot:
	lda <$12
	beq .NotHitFoot
	lda oXhi+0
	and #$0F
	eor #$FF
	sta <$00
	inc <$00
	lda #$00
	sta <$11
	lda #$F7
	sta <$01
	jsr rTerrainHit ;$11|=チップ属性,$13=チップ番号
	clc
	lda <$00
	adc #$0F
	sta <$00
	jsr rTerrainHit ;$11|=チップ属性,$13=チップ番号
	lsr <$11
	bcc .StandUp
.NotHitFoot
	jmp $82AF
.StandUp
	lda oXhi+0
	and #$F0
	ora #$08
	sta oXhi+0
	jmp $8332

	.ENDIF ;}
	.IF SW_FixRockMove_Terrain ;{
MoveY_X00:
	clc
	jmp $E4FE
MoveX_X00:
	clc
	bcc MoveX_conf
MoveX:
	clc
	lda <vVxloW
	adc oXlo,x
	sta oXlo,x
MoveX_conf:
	lda <vVxhiW
	bpl .p
	dec oXhe,x
.p
	adc oXhi,x
	sta oXhi,x
	bcc .rts
	inc oXhe,x
.rts
	rts
	.ENDIF ;}
	.IF SW_FixRockMove_Block ;{
Rockman_SavePrevYhi: ;地形補正が入っている時は要らないが確保はする
	lda oYhi+0
	sta vPrevYhi
	jmp rMove ;Obj[CurObj]を($ED~EB,$EE~EC)移動
Rockman_PushBackByBlockObj:
	ldx #$00
	lda <vVxloW ;x押し戻し絶対値
	beq .PushBack_Side
	;1フレーム前の位置が、オブジェクトより完全に上/下なら上下に補正
	sec
	lda oYhi+0
	sbc vPrevYhi
	sta <$04
;	lda oVal0+0 ;但し既に地形に触れ着地していた時はこの補正を行わない
;	and #$01
;	bne .NotOnFloor
;;	sta <$04 ;1を書き込む
;.NotOnFloor
	clc
	lda <vVyhiW ;y押し戻し
	bpl .PushBack_Down
;上に押し戻し
	bit oVal1+0
	bmi .PushBack_Side
	adc <$04
	clc
	adc #$04
;	adc #$02
	bmi .PushBack_Side
	lda #$80 ;深くめり込まないようにしておいたほうが都合が良さそう
	sta oYlo+0
	sec
	jmp $8F9E
.PushBack_Down
;下に押し戻し
	adc <$04
	beq .PushBack_Bottom
	bpl .PushBack_Side
.PushBack_Bottom
	lda #$FF
	sta oVal1+0 ;負数を書き込んでおく
	sec
	jmp $8F9E
.PushBack_Side
	jmp $8FB5
	.ENDIF ;}
	.IF SW_FixRockMove_Collision ;{
Rockman_Collision:
	.IF SW_FixRockMove_Collision=2
	clc
	lda oYhi+0
	adc oHitSize+0
	sta <$02
	lda oYhe+0
	sta <$03
	lda oXhi+0
	sta <$00
	lda oXhe+0
	sta <$01
	.ENDIF
	ldx #$00
	jmp rCollisionW_next
	.ENDIF ;}
	.IF SW_FixRockMove_Wait ;{

Rockman_WaitWithMoveProc:
	.IF SW_FixRockMove_HoverJump ;{
	lda oVal0+0
	cmp #$41
	bcc .OnGround
	jmp $80EA
.OnGround
.SkipProc
	.ENDIF ;}
	lda #$00
	sta <vVxloW
	sta <vVxhiW
	jsr $86D5 ;地形処理を追加で行う
	jmp $8E95 ;制御を返す(ロックマン)
	.ENDIF ;}
	.IF SW_FixPowerShotGlitchAtLadder ;{
Rockman_LadderInit:
	lda <vChargeTime
	bmi .PowerRockman
	jmp $834E ;ハシゴInit
.PowerRockman
	ldy #$22
	jsr rSetAnim2
	jmp $849E
	.ENDIF ;}
	.IF SW_SwitchWeapon ;{
Rockman_SwitchWeapon:
	lda <vPadPress;ABETUDLR
	and #$30
	bne .DoProc
	rts
.DoProc
	cmp #$10
	bne .DoSwitchProc
	lda <vPadHold;ABETUDLR
	and #$30
	cmp #$30
	beq .DoSwitchProc
	jmp $9253
.DoSwitchProc
	LONG_CALL Rockman_SwitchWeapon_Body
	rts
Rockman_SwitchWeapon_Transfer:
	ldx vWeaponTransfer
	bne .DoXfer
.SkipXfer
	jmp $C79C
.DoXfer
	lda <vFrameCounter
	lsr a
	bcs .SkipXfer
	lda $2002 ;stat
	lda #$17
	sta $2006 ;addr
	lda .Tbl_DestLo-1,x
	sta $2006 ;addr

	lda <$83
	pha
	lda <$84
	pha


	lda aWeaponGrpAddr+0
	sta <$83
	lda aWeaponGrpAddr+1
	sta <$84
	lda #$06
	sta ioMMC3Cmd
	lda aWeaponGrpAddr+2
	sta ioMMC3Value
	dec vWeaponTransfer
	ldx #$08
	ldy #$00
	jsr Misc_FastTransferBody
	clc
	lda aWeaponGrpAddr+0
	adc #$80
	sta aWeaponGrpAddr+0
	bcc .NotIncAddrHi
	inc aWeaponGrpAddr+1
.NotIncAddrHi
	pla
	sta <$84
	pla
	sta <$83
	lda #$00
	sta <$89 ;転送量
	rts
.Tbl_DestLo
	db $90,$10

	.ENDIF ;}
	.IF SW_FixRockMove_HoverJump ;{
Rockman_HoverJump_Walk_Bliz:
	lda <vRasterEnabled
	beq Rockman_HoverJump_Walk
	lda oVal1+0
	jmp $80B2
Rockman_HoverJump_Walk:
	lda oVal0+0
	ora oVal1+0
	jmp $80B2
Rockman_FallInWater:
	ldy oVal0+0
	beq .rts
	ldy $064B
.rts
	jmp $86DA
Rockman_HoverJump_BLift:
	sec
	lda oYhi,x
	sbc #$13+1
	cmp oYhi+0
	bne .NotFixRockY
	inc oYhi+0
.NotFixRockY
	jmp rYieldInc ;制御を返す(無敵/画面外削除)
	.ENDIF ;}
	.IF SW_FixRockMove_FullJumpFromWater ;{
Rockman_FullJumpGlitch:
	lda oVal0+0
	ora #$0C
	sta oVal0+0
	jmp rTerrainHit ;$11|=チップ属性,$13=チップ番号

	.ENDIF ;}
	.IF SW_SmoothAirBrake ;{
Rockman_SmoothAirBrake_trig:
	LONG_CALL Rockman_SmoothAirBrake
	rts
	.ENDIF ;}
	.IF SW_FixNotJumpableFrame ;{
Rockman_FixNotJumpableFrame:
	lda <$99
	beq .toStanding
	jmp $80BB
.toStanding
	;a=0
	jsr $E101
	jmp $8062
	.ENDIF ;}
