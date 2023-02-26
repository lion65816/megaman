
	lda A_ObjVal0,x
	bmi .Moving
	dec A_ObjVal0,x
	bne .return
	lda #$80-1
	sta A_ObjVal0,x
	lda #LOW (-C_Air_Vy0_100)
	sta A_ObjVylo,x
	lda #HIGH(-C_Air_Vy0_100)
	sta A_ObjVyhi,x
.Moving
	inc A_ObjVal0,x
	lda A_ObjVal0,x
	cmp #$80+C_Air_T
	bne .Moving_noloop
	lda #$80
	sta A_ObjVal0,x
.Moving_noloop
	ldy #$00
	cmp #$80+C_Air_T/2
	bcc .Moving_an
	iny
.Moving_an
;	clc
	lda A_ObjVylo,x
	adc .table_aylo,y
	sta A_ObjVylo,x
	lda A_ObjVyhi,x
	adc .table_ayhi,y
	sta A_ObjVyhi,x

;	clc
	lda A_ObjVxlo,x
	adc #$20
	sta A_ObjVxlo,x
	lda A_ObjVxhi,x
	adc #$00
	sta A_ObjVxhi,x
.return
	jmp R_CommonWeaponProc ;ã§í ïêäÌèàóù
.table_aylo
	.db LOW (  2 * C_Air_a_100 )
	.db LOW ( -2 * C_Air_a_100 )
.table_ayhi
	.db HIGH(  2 * C_Air_a_100 )
	.db HIGH( -2 * C_Air_a_100 )
