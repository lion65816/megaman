;$Size 001E
	list
	SIZE_CALCULATOR
	nolist

SHOTPROC_4: ;B
	lda <vPadPress ; RLDUTEBA
	and #$02
	bne .Fire
.NotFound
	sec
	rts
.Fire
	ldx #$05
	lda oFlag+$05
;	bpl .Found
;	ldx #$06
;	lda oFlag+$06
	bmi .NotFound
.Found
	lda #$3B
;	lda #$3D
	jsr rSound ; 音aを鳴らす
;	sec
;	lda <aWeaponEnergy+3
;	sbc #$02
;	sta <aWeaponEnergy+3
	dec <aWeaponEnergy+3
	ldy #$04
	jsr rCreateWeapon ;Obj[x]に武器yを作成
;	jmp $DA87 ;ショットモーションにして終了
	jmp $DC4A ;投擲モーションにして終了

	list
	SIZE_CALCULATOR
	nolist
