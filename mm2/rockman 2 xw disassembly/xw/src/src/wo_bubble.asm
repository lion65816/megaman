
	lda A_ObjVal0,x
	bpl .Targetting

	and #$7F
	tay
	jsr .IsEnableTarget
	bcc .Targetting_init
.Homing
	dec A_ObjHP,x
	bpl .Homing_SkipProc
	lda #$08
	sta A_ObjHP,x
	jmp .Homing_main
.Targetting_init
	lda #$00
.Targetting
	clc
	adc #$01
	and #$07
	ora #$10
	sta A_ObjVal0,x
	tay
	jsr .IsEnableTarget
	bcs .Targetting_Completed
	tya
	ora #$08
	tay
	jsr .IsEnableTarget
	bcs .Targetting_Completed
	ldy #$01
	jsr .IsEnableTarget
	bcs .Targetting_Completed

;横に加速する
	;clc
	lda A_ObjVxlo,x
	adc #LOW ($0180/8)
	sta A_ObjVxlo,x
	lda A_ObjVxhi,x
	adc #HIGH($0180/8)
	sta A_ObjVxhi,x
.Homing_SkipProc
	jmp R_CommonWeaponProc ;共通武器処理
.Targetting_Completed
	tya
	ora #$80
	sta A_ObjVal0,x
	lda #$00
	sta A_ObjHP,x
	jmp .Homing

.IsEnableTarget
	lda A_ObjFlag,y ;存右？？弾重特当
	bpl .clcrts
	and #$02
	beq .clcrts

	cpy #$10
	bcc .IsEnableTarget_boss

	sty <$00
	lda A_ObjType,y
	tay
	lda $EB5A,y
	pha
	ldy <$00
	pla
	sec
	bne .rts
.clcrts
	clc
.rts
	rts
.IsEnableTarget_boss
	lda <$B3 ;ボスの種類
	cmp #$04
	bne .clcrts
	sec
	rts


.Homing_main
	;美しくないコーディングになってしまった
	lda A_ObjVyhi,x
	pha
	lda A_ObjVylo,x
	pha
	lda A_ObjVxhi,x
	pha
	lda A_ObjVxlo,x
	pha
	lda A_ObjFlag,x ;存右？？弾重特当
	pha

	lda #$80
	sta <$08
	lda #$02
	sta <$09
	lda A_ObjYhi+0
	pha
	lda A_ObjYhi,y
	sta A_ObjYhi+0

	;sec
	lda A_ObjXhi,y
	sbc A_ObjXhi,x
	sta <$00
	lda A_ObjXhe,y
	ldy #$40
	sbc A_ObjXhe,x
	jsr $F17E

	pla
	sta A_ObjYhi+0


	pla
	sta <$00
	eor A_ObjFlag,x ;存右？？弾重特当
	and #$40
	beq .Homing_X_not_reversed

	sec
	pla
	sbc A_ObjVxlo,x
	sta A_ObjVxlo,x
	pla
	sbc A_ObjVxhi,x
	sta A_ObjVxhi,x
	bpl .Homing_x_brake
	lda #$00
	sta A_ObjVxlo,x
	sta A_ObjVxhi,x
	beq .Homing_X_turn_conf
.Homing_x_brake
	lda <$00
	sta A_ObjFlag,x ;存右？？弾重特当
	bne .Homing_X_turn_conf
.Homing_X_not_reversed
	clc
	pla
	adc A_ObjVxlo,x
	sta A_ObjVxlo,x
	pla
	adc A_ObjVxhi,x
	sta A_ObjVxhi,x
.Homing_X_turn_conf


	lda #$04
	cmp A_ObjVxhi,x
	bcs .Homing_X_limit
	sta A_ObjVxhi,x
.Homing_X_limit

	clc
	pla
	adc A_ObjVylo,x
	sta A_ObjVylo,x
	pla
	adc A_ObjVyhi,x
	bmi .Homing_Y_limit_n
;+
	cmp #$04
	bcc .Homing_Y_limit_end
	lda #$04
	bne .Homing_Y_limit_end
.Homing_Y_limit_n
;-
	cmp #$FC
	bcs .Homing_Y_limit_end
	lda #$FC
;	bne .Homing_Y_limit_end
.Homing_Y_limit_end
	sta A_ObjVyhi,x
	jmp R_CommonWeaponProc ;共通武器処理

;.Table_Homing_Vylo
;	.db $40,$C0
;.Table_Homing_Vyhi
;	.db $00,$FF
;.Table_Homing_Vxlo
;	.db $40,$C0
;	.db $C0,$40
;.Table_Homing_Vxhi
;	.db $00,$FF
;	.db $FF,$00

