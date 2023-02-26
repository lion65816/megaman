	.IF Enable_Misc_ClearDMASrc
Misc_ClearDMASrc:
	sec
	ldx #$C0
.loop
	lda #$F9
	sta aDMASrc+$4*$00+0,x
	sta aDMASrc+$4*$01+0,x
	sta aDMASrc+$4*$02+0,x
	sta aDMASrc+$4*$03+0,x
	sta aDMASrc+$4*$04+0,x
	sta aDMASrc+$4*$05+0,x
	sta aDMASrc+$4*$06+0,x
	sta aDMASrc+$4*$07+0,x
	sta aDMASrc+$4*$08+0,x
	sta aDMASrc+$4*$09+0,x
	sta aDMASrc+$4*$0A+0,x
	sta aDMASrc+$4*$0B+0,x
	sta aDMASrc+$4*$0C+0,x
	sta aDMASrc+$4*$0D+0,x
	sta aDMASrc+$4*$0E+0,x
	sta aDMASrc+$4*$0F+0,x
	txa
	beq .exit
	sbc #$40
	tax
	bcs .loop
.exit
	jmp $DF21
	.ENDIF

	.IF Enable_FixEnemyOffsetAtWarp
Misc_FixEnemyOffsetAtWarp:
	jsr rSetNTMirroring
	ldy oXhe+0
	lda <vLastScrollDirection
	lsr a
	bcs .ForwardScrolling
	iny
.ForwardScrolling
	lda $AC00,y
	sta <vObjIDR
	sta <vObjIDL
	rts
	.ENDIF

	.IF Enable_FixArrowZipping ;{
FixArrowZipping_org:
	BANKORG_D $1FE7E3
	jsr FixArrowZipping_Trig


	BANKORG FixArrowZipping_org
FixArrowZipping_Trig:
	php
	cpy #$04
	bne .NotSliding
	lda <vRockmanSlideTimer
	cmp #$1A-4
	bcs .Exception
.NotSliding
	plp
	jmp $E814
.Exception
;���_�p�^�[����04,05����00,01�ɓǂݑւ���
;�������A�p�^�[��00,01�ƃ�y�̒l���قȂ�B�i�X���C�f�B���O���l������}2�̒l�ɂȂ��Ă���j
;���b�N�}���̕��̍��W���ꎞ�I�ɕύX���邱�Ƃ�
;���̖��ɖ������Ή�����B
	ldy #$00
	plp
	bcc .TowardDown
	beq .TowardDown
;��Ɉړ�
	iny
	jsr .Yp
	jsr rHBarTest
	jsr .Yn
	jmp $E7AB
.TowardDown ;���Ɉړ�
	jsr rVypeAy
	jsr .Yn
	jsr rHBarTest
	jsr .Yp
	jmp $E822
.Yp
	clc
	lda oYhi+0
	adc #$02
	cmp #$F0
	bcc .Yp_starts
	;cs
	adc #$0F
	inc oYhe+0
.Yp_starts
	sta oYhi+0
	rts
.Yn
	sec
	lda oYhi+0
	sbc #$02
	bcs .Yp_starts
	;cc
	sbc #$0F
	dec oYhe+0
	jmp .Yp_starts

	.ENDIF ;}
