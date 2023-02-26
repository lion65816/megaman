;$Size 0005
	list
	SIZE_CALCULATOR
	nolist
Weapon2_Air:
	BANKORG_DB $1ED44C+2,$31 ;Type
	BANKORG_DB $1ED45E+2,$81 ;Flag 親は87/子オブジェクトの設定を優先
	BANKORG_DB $1ED470+2,$10 ;Δx
	BANKORG_DB $1ED482+2,$00 ;Vxlo
	BANKORG_DB $1ED494+2,$06 ;Vxhi
	BANKORG_DB $1ED4A6+2,$00 ;Vylo
	BANKORG_DB $1ED4B8+2,$00 ;Vyhi
	;ボスへヒット処理
	BANKORG $17A6C6
Weapon2B_NotBeated:

	BANKORG $17A6CD
	bne Weapon2B_Reflected
	BANKORG $17A6D6
	beq Weapon2B_Reflected
	BANKORG $17A6F3
	bcs Weapon2B_NotBeated
	BANKORG $17A6FC
Weapon2B_Reflected:
	lda #$2D
	jsr rSound
	lda #$02
	sta <$02
	clc
	rts

	;ザコへのヒット処理
	BANKORG $1FE73F ;あたっても消えない
	bcs $E709
	BANKORG $1FE74D ;弾かれても消えない
	jmp $E762
	FILL_TEST $1FE762

	.include "src\w_2_damage.asm"

	BANKORG Weapon2_Air
WeaponHandler_2: ;A
	ldy #(1*3)
	jmp MISC_LONG_CALL

	list
	SIZE_CALCULATOR
	nolist
