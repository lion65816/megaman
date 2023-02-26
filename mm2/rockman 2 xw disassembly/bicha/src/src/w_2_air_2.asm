;$Size 0034
	list
	SIZE_CALCULATOR
	nolist
Weapon2_Air_2:
	BANKORG Weapon2_Air_2

SHOTPROC_2: ;A 1EDAB0
	lda <vPadPress ; RLDUTEBA
	and #$02
	bne .Fire
.NotFound
	sec
	rts
.Fire
	ldx #$09
	lda oFlag,x
	bmi .NotFound
	lda #$27
	jsr rSound ; 音aを鳴らす
	sec
	lda <aWeaponEnergy+1
	sbc #$05
;	sbc #$00
	bcs .NotFixEnergy
	lda #$00
.NotFixEnergy
	sta <aWeaponEnergy+1
	ldy #$02
	jsr rCreateWeapon ;Obj[x]に武器yを作成
;	lda #$00
;	sta oHP,x
	lda #(9)
	sta oVal0,x
	lda oFlag,x
	ora #$06
	sta oFlag,x
	jmp $DA87 ;ショットモーションにして終了
;	jmp $DC4A ;投擲モーションにして終了

	list
	SIZE_CALCULATOR
	nolist
