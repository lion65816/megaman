;$Size 00DE
	list
	SIZE_CALCULATOR
	nolist
MISC2_ORG:
	BANKORG MISC2_ORG
MISC_InitDMASrc:
	lda #$F8
	sta aDMASrc+4*$00
	sta aDMASrc+4*$01
	sta aDMASrc+4*$02
	sta aDMASrc+4*$03
	sta aDMASrc+4*$04
	sta aDMASrc+4*$05
	sta aDMASrc+4*$06
	sta aDMASrc+4*$07
	sta aDMASrc+4*$08
	sta aDMASrc+4*$09
	sta aDMASrc+4*$0A
	sta aDMASrc+4*$0B
	sta aDMASrc+4*$0C
	sta aDMASrc+4*$0D
	sta aDMASrc+4*$0E
	sta aDMASrc+4*$0F
	sta aDMASrc+4*$10
	sta aDMASrc+4*$11
	sta aDMASrc+4*$12
	sta aDMASrc+4*$13
	sta aDMASrc+4*$14
	sta aDMASrc+4*$15
	sta aDMASrc+4*$16
	sta aDMASrc+4*$17
	sta aDMASrc+4*$18
	sta aDMASrc+4*$19
	sta aDMASrc+4*$1A
	sta aDMASrc+4*$1B
	sta aDMASrc+4*$1C
	sta aDMASrc+4*$1D
	sta aDMASrc+4*$1E
	sta aDMASrc+4*$1F
	sta aDMASrc+4*$20
	sta aDMASrc+4*$21
	sta aDMASrc+4*$22
	sta aDMASrc+4*$23
	sta aDMASrc+4*$24
	sta aDMASrc+4*$25
	sta aDMASrc+4*$26
	sta aDMASrc+4*$27
	sta aDMASrc+4*$28
	sta aDMASrc+4*$29
	sta aDMASrc+4*$2A
	sta aDMASrc+4*$2B
	sta aDMASrc+4*$2C
	sta aDMASrc+4*$2D
	sta aDMASrc+4*$2E
	sta aDMASrc+4*$2F
	sta aDMASrc+4*$30
	sta aDMASrc+4*$31
	sta aDMASrc+4*$32
	sta aDMASrc+4*$33
	sta aDMASrc+4*$34
	sta aDMASrc+4*$35
	sta aDMASrc+4*$36
	sta aDMASrc+4*$37
	sta aDMASrc+4*$38
	sta aDMASrc+4*$39
	sta aDMASrc+4*$3A
	sta aDMASrc+4*$3B
	sta aDMASrc+4*$3C
	sta aDMASrc+4*$3D
	sta aDMASrc+4*$3E
	sta aDMASrc+4*$3F
	sta aDMASrc+$FE ;※必要です
	rts

MISC_AtEnteringStage:
	jsr rSound
	lda #$00
	sta vBusterTimer
	lda <vCurStage
	cmp #$0D
	bne .NotRecoverEnergy
	lda #$1C
	ldx #$07
.RecoverEnergy_loop
	sta <aWeaponEnergy,x
	dex
	bpl .RecoverEnergy_loop
.NotRecoverEnergy
	rts




	list
	SIZE_CALCULATOR
	nolist
