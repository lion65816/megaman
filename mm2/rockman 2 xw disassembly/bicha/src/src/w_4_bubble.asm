;$Size 003B
	list
	SIZE_CALCULATOR
	nolist
Weapon4_Bubble:
	BANKORG_DB $1ED44C+4,$33 ;Type
	BANKORG_DB $1ED45E+4,$87 ;Flag
	BANKORG_DB $1ED482+4,$00 ;Vxlo
	BANKORG_DB $1ED494+4,$01 ;Vxhi
	BANKORG_DB $1ED4A6+4,$00 ;Vylo
	BANKORG_DB $1ED4B8+4,$02 ;Vyhi

	BANKORG $17A782
	bne Weapon4B_Reflected
	BANKORG $17A78B
	beq Weapon4B_Reflected
	BANKORG $17A7B1
Weapon4B_Reflected:
	lda #$2D
	jsr rSound
	lda oFlag,x
	eor #$41
	sta oFlag,x
	lda oVyhi,x
	bpl .NotInvVy
	eor #$FF
	sta oVyhi,x
.NotInvVy
	lsr oVxhi,x
	lda #$02
	sta <$02
	clc
	rts
	FILL_TEST $17A7D1

	BANKORG $1FE807
	lda #$2D
	jsr rSound
	lda oFlag,x
	eor #$41
	sta oFlag,x
	lda oVyhi,x
	bpl .NotInvVy
	eor #$FF
	sta oVyhi,x
.NotInvVy
	lsr oVxhi,x
	ldx <vProcessingObj
	clc
	rts
	FILL_TEST $1FE825

	;多段ヒット
	BANKORG $1FE7EB
	bit $0000
	lda #$01
	sta $0100,x

	.include "src\w_4_damage.asm"



	BANKORG Weapon4_Bubble
WeaponHandler_4: ;B
	lda oVal0,x
	bne .NotFirst
	ldy #(3*3)
	jsr MISC_LONG_CALL
.NotFirst
	lda <vFrameCounter
	and #$01
	tay
	clc
	lda oYhi,x
	adc .Tbl_Dy,y
	sta <$0A
	lda #$00
	sta <$0B
	lda oXhi,x
	sta <$08
	lda oXhe,x
	sta <$09
	jsr rFieldTest ;地形(9~8,B~A)の属性取得
	ldx <vProcessingObj
	ldy <$00
	lda $E14C,y
	bne .Delete

	jmp $EECD
.Delete
	lsr oFlag,x
	rts


.Tbl_Dy
	db 4,-2

	list
	SIZE_CALCULATOR
	nolist
