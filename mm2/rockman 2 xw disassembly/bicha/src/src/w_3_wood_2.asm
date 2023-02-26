;$Size 0068
	list
	SIZE_CALCULATOR
	nolist
SHOTPROC_3: ;W 1EDAE3
	lda vBusterTimer
	beq .NotCharged
	dec vBusterTimer
	lsr a
	bcs .NotFire
	lsr a
	bcs .NotFire
	and #$07
	clc
	adc #$02
	tax
	lda #$23
	jsr rSound ; 音aを鳴らす

	dec <vWeaponEnergyCounter
	bpl .NotConsumeEnergy
	lda #(12)
	sta <vWeaponEnergyCounter
	dec <aWeaponEnergy+2
	bpl .NotShortEnergy
	inc <aWeaponEnergy+2
.NotShortEnergy
.NotConsumeEnergy
	ldy #$03
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	jmp $DA87 ;ショットモーションにして終了
.NotFire
	clc
	rts
.NotCharged
	lda <vPadOn ; RLDUTEBA
	and #$02
	bne .Fire
.NotFound
	sec
	rts
.Fire
	ldx #$09
	lda oFlag+$09
	bmi .NotFound
	ldy #$03
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	inc oVal0,x
	lda #$82
	sta oFlag,x
	clc
	rts

;	jmp $DA87 ;ショットモーションにして終了
;	jmp $DC4A ;投擲モーションにして終了


Weapon3_Snap:
	lda oXhi+0
	sta oXhi,x
	lda oYhi+0
	ldy <vRockmanYhe
	beq .YheEQ00
	lda #$00
.YheEQ00
	sta oYhi,x
	lda oXhe+0
	sta oXhe,x
	rts

	list
	SIZE_CALCULATOR
	nolist
