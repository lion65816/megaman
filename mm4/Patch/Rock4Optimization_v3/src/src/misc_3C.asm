;最適化{
;最適化}
;拡張機能等{
	.IF SW_ContinueGrabbingLadderEtc
ContinueGrabbingLadderEtc:
	lda <vRockmanState
	cmp #$04
	bne .rts
	lda #$00
	sta <vRockmanState
.rts
	rts
	.ENDIF


	.IF SW_SwitchWeapon
SwitchWeapon:
	lda <vPadHold ; ABETUDLR
	and #$30
	cmp #$30
	beq .EquipRockBuster
	cmp #$20
	bcs .SwitchWeapon_select
	jmp $9600 ;サブ画面へ
.EquipRockBuster
	;空振りの可能性があるので、効果音を消す
	lda #$F1
	jsr rSE
	lda <vCurWeapon
	beq .rts
	lda #$00
	beq .Conf_RockBuster
.SwitchWeapon_select
	ldy #$01
	lda <vPadHold ; ABETUDLR
	and #$04
	beq .Rotate_p
	ldy #$FF
.Rotate_p
	sty <$00
	lda <vCurWeapon
.Rotate_again
	clc
	lda vSubCursor
	adc <$00
	and #$0F
	sta vSubCursor
.Conf_RockBuster
	sta vSubCursor
	tay
	ldx $9B71,y ;サブ画面のカーソル位置→武器番号
	bmi .Rotate_again
	lda <aWeaponEnergy,x
	bpl .Rotate_again
	stx <vCurWeapon
	jmp SwitchWeapon_cont
.rts
	rts
	.ENDIF

;拡張機能等}

	;※いっぱいいっぱいです
