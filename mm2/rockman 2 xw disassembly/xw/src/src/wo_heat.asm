
	lda A_ObjVal0,x ;0:マネージャ 1:飛翔中
	bne .not_manager
	lda #$00
	sta A_ObjSprTimer,x
	sta A_ObjSprNo,x
	lda <V_PadOn ; RLDUTEBA
	and #$02
	beq .suicide
	lda <V_RockmanState
	cmp #$03
	bcc .suicide
	dec A_ObjVal1,x ;炎のタイマー
	bpl .return
	lda #$02
	sta A_ObjVal1,x ;炎のタイマー
	;エネルギー
	dec <V_WeaponEnergyCounter
	bpl .not_consume
	lda A_WeaponEnergy+1-1
	beq .suicide
	dec A_WeaponEnergy+1-1
	lda #10
	sta <V_WeaponEnergyCounter
.not_consume

	;上空にいたら無効
	lda <V_RockmanYhe
	bne .ScreenOut
	;炎配置
	ldx #$02+7
.SeekEmptyObj_loop
	lda A_ObjFlag,x ;存右？？弾重特当
	bpl .SeekEmptyObj_exit
	dex
	cpx #$03
	bne .SeekEmptyObj_loop
	;※最後は強制でObj[3]に上書きされ続けるけど気にしない
.SeekEmptyObj_exit
	ldy #$01
	jsr R_CreateWeapon ;Obj[x]に武器yを作成
	inc A_ObjVal0,x
	inc A_ObjSprNo,x
.ScreenOut
	jsr R_ShotPose ;ロックマンをショット姿勢に

	lda #$36
	jsr R_SoundOn

.return
	ldx <V_ProcessingObj
	rts
.suicide
	lsr A_ObjFlag,x ;存右？？弾重特当
	rts
.not_manager
	lda A_ObjSprNo,x
	lsr a
	sta A_LObjHitSize,x
	;本当は途中で停止後に
	;拡大し消滅する予定だったがこれでいいだろう……
	jmp R_CommonWeaponProc ;共通武器処理
