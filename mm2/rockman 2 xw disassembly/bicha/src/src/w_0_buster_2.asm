;$Size 0046
	list
	SIZE_CALCULATOR
	nolist
Weapon0_Buster_2:
	BANKORG Weapon0_Buster_2

SHOTPROC_0:
.cInterval = 3
.cPrevLag  = 0
.cFollLag  = 11
	lda vBusterTimer
	bne .Shooting
	lda <vPadPress ; RLDUTEBA
	and #$02
	beq .NotStartShooting
	lda #(.cFollLag+.cPrevLag+.cInterval*2)
	sta vBusterTimer
.NotStartShooting
	sec
	rts
.Shooting
	lda vBusterTimer
	dec vBusterTimer
	cmp #(.cFollLag+.cInterval*2)
	beq .DoShoot
	cmp #(.cFollLag+.cInterval*1)
	beq .DoShoot
	cmp #(.cFollLag)
	beq .DoShoot
.NotFound
	sec
	rts
.DoShoot
	ldx #(9)
.SeekLoop
	lda oFlag,x
	bpl .Found
	dex
	cpx #$01
	beq .NotFound
	bne .SeekLoop
.Found
	lda #$24
	jsr rSound ; 音aを鳴らす
	ldy #$00
	jsr rCreateWeapon ;Obj[x]に武器yを作成
	lda #(12)
	sta oHP,x
	jmp $DA87

	list
	SIZE_CALCULATOR
	nolist
