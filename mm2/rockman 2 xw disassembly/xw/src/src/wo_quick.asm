	lda A_ObjVal0,x
	bpl .Straight

	dec A_ObjVal1,x
	bpl .SkipChaseProc

	lda #8
	sta A_ObjVal1,x
	
	jsr .ChaseProc
.SkipChaseProc

;キャッチ処理
;上位バイトは無視している
	lda A_ObjXhi+0
	sbc A_ObjXhi,x
	INV_A_CC
	cmp #$10
	bcs .MoveProc_rts

	lda A_ObjYhi+0
	sbc A_ObjYhi,x
	cmp #$04
	bcc .Caught

.MoveProc_rts
	jmp R_CommonWeaponProc ;共通武器処理
.Straight
	inc A_ObjVal0,x
	lda A_ObjVal0,x
	cmp #10
	bne .MoveProc_rts
	lda #$00
	sta A_ObjVal1,x
	ldy #$83
	lda A_ObjFlag,x ;存右？？弾重特当
	and #$40
	beq .Straight_left
	ldy #$80
.Straight_left
	tya
	sta A_ObjVal0,x
	bne .MoveProc_rts
.Caught
	lda A_WeaponEnergy+5-1
	cmp #$1C
	bcs .Caught_MaxEnergy
	inc A_WeaponEnergy+5-1
.Caught_MaxEnergy
	lsr A_ObjFlag,x ;存右？？弾重特当
	rts

.ChaseProc
	sec
	lda A_ObjVal0,x
	and #$07
	sta <$01

	jsr .Aiming
	sec
	sbc <$01
	beq .Curve_0
	and #$07
	cmp #$04
	beq .curve_i
	bcs .curve_l
.curve_r
	inc <$01
	bcc .Curve_Conf
.curve_l
	dec <$01
	bcs .Curve_Conf
.curve_i
	ldy <$01
	dey
	dey
	tya
	and #$04
	bne .curve_l
	clc ;※これがないと上のルーチンで強制ジャンプがうまくいかない
	beq .curve_r
.Curve_Conf
	lda <$01
	and #$07
	ora #$80
	sta A_ObjVal0,x
.Curve_0
	lda A_ObjVal0,x
	and #$07
	tay
	lda .tmp_Vxlo,y
	sta A_ObjVxlo,x
	lda .tmp_Vxhi,y
	sta A_ObjVxhi,x
	lda .tmp_Vylo,y
	sta A_ObjVylo,x
	lda .tmp_Vyhi,y
	sta A_ObjVyhi,x
	lda A_ObjFlag,x ;存右？？弾重特当
	and #~$40
	ora .tmp_Flag,y
	sta A_ObjFlag,x ;存右？？弾重特当
	rts

;sin(22.5[deg]) = $61F8/$10000 = cos(22.5+45)
;cos(22.5[deg]) = $EC83/$10000 = sin(22.5+45)

.tmp_Vxlo
	.db LOW ( (C_Quick_V*$EC83)/$100 )
	.db LOW ( (C_Quick_V*$61F8)/$100 )
	.db LOW ( (C_Quick_V*$61F8)/$100 )
	.db LOW ( (C_Quick_V*$EC83)/$100 )
	.db LOW ( (C_Quick_V*$EC83)/$100 )
	.db LOW ( (C_Quick_V*$61F8)/$100 )
	.db LOW ( (C_Quick_V*$61F8)/$100 )
	.db LOW ( (C_Quick_V*$EC83)/$100 )
.tmp_Vxhi
	.db HIGH( (C_Quick_V*$EC83)/$100 )
	.db HIGH( (C_Quick_V*$61F8)/$100 )
	.db HIGH( (C_Quick_V*$61F8)/$100 )
	.db HIGH( (C_Quick_V*$EC83)/$100 )
	.db HIGH( (C_Quick_V*$EC83)/$100 )
	.db HIGH( (C_Quick_V*$61F8)/$100 )
	.db HIGH( (C_Quick_V*$61F8)/$100 )
	.db HIGH( (C_Quick_V*$EC83)/$100 )
.tmp_Vylo
	.db LOW (-(C_Quick_V*$61F8)/$100 )
	.db LOW (-(C_Quick_V*$EC83)/$100 )
	.db LOW (-(C_Quick_V*$EC83)/$100 )
	.db LOW (-(C_Quick_V*$61F8)/$100 )
	.db LOW ( (C_Quick_V*$61F8)/$100 )
	.db LOW ( (C_Quick_V*$EC83)/$100 )
	.db LOW ( (C_Quick_V*$EC83)/$100 )
	.db LOW ( (C_Quick_V*$61F8)/$100 )
.tmp_Vyhi
	.db HIGH(-(C_Quick_V*$61F8)/$100 )
	.db HIGH(-(C_Quick_V*$EC83)/$100 )
	.db HIGH(-(C_Quick_V*$EC83)/$100 )
	.db HIGH(-(C_Quick_V*$61F8)/$100 )
	.db HIGH( (C_Quick_V*$61F8)/$100 )
	.db HIGH( (C_Quick_V*$EC83)/$100 )
	.db HIGH( (C_Quick_V*$EC83)/$100 )
	.db HIGH( (C_Quick_V*$61F8)/$100 )
.tmp_Flag
	.db $40,$40,$00,$00,$00,$00,$40,$40



.Aiming
	ldy #$00
	sec
	lda A_ObjXhi+0
	sbc A_ObjXhi,x
	pha
	lda A_ObjXhe+0
	sbc A_ObjXhe,x
	bpl .Aiming_Dx_p
	;キャリークリア
	pla
	eor #$FF
	adc #$01
	ldy #$04
	pha
.Aiming_Dx_p
	pla
	sta <$00 ;Δx
;  |
;4 > 0
;  |
	sec
	lda A_ObjYhi+0
	sbc A_ObjYhi,x
	bpl .Aiming_Dy_p
	;キャリークリア
	eor #$FF
	adc #$01
	iny
	iny
.Aiming_Dy_p
;6 | 2
;-->--
;4 | 0
	cmp <$00 ;Δx
	bcs .Aiming_Dy_is_higher
	iny
.Aiming_Dy_is_higher
;.7|3/
;6.|/2
;-->--
;5/|.1
;/4|0.
	lda .Aiming_table,y
	rts

.Aiming_table
	.db 1,0,7,6,2,3,4,5
