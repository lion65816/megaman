	.inesprg $10 ;�v���O�����o���N��
	.ineschr $10 ;�L�����N�^�o���N��
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman3.prgchr"

BANKORG_D .macro
	.bank (\1>>16)
	.org (\1&$FFFF)
	.endm

END_BOUNDARY_TEST	.macro
CurrentPosition\@:
	.IF ((CurrentPosition\@)&$FFFF)>((\1)&$FFFF)
	.FAIL ;END_BOUNDARY_TEST \1
	.ENDIF
	.endm


	;��~����
	BANKORG_D $1ECEFA
	jsr $D09B
	lda <$31
	pha
	jmp $CEEE

	;���n����
	BANKORG_D $1ED08F
	stx <$30
	jsr $CF55
	lda #$0D
	jsr TouchDown_Shot
	bit <$00

	;�G�A�u���[�L��Vy
	BANKORG_D $1ED006
	bmi AirBrakeVy_ResetRushFlag
	BANKORG_D $1ED00A
	bne AirBrakeVy_ResetRushFlag_End
	bit <$16
	bmi $D018
	stx $0460+0
	jsr AirBrake_Do
	nop
AirBrakeVy_ResetRushFlag:
	stx <$3A
AirBrakeVy_ResetRushFlag_End

	;�U���������
	BANKORG_D $1ED0FC
	jmp TurnProc

	;���[�V�����o�O�C��
	;�T�u��ʂ�����Ƃ���Ani�l�ύX��
	BANKORG_D $02A152
	jsr SetAniNo_ResetMotion

	;�o�ꎞ�̖_���[�v��Ani�l�ύX��
	BANKORG_D $1ECA68
	jsr SetAniNo_ResetMotion

	;�X���C�f�B���O��Ani�l�ύX��
	BANKORG_D $1ED3AF
	jsr SetAniNo_ResetMotion



	;�ȉ��͓K���ɋ󂫃X�y�[�X�Ɍ����Ă�������
	;���̏ꏊ���󂢂Ă��邩�ǂ������������Ă��܂��񂪁c�c
	BANKORG_D $1FFFCF
AirBrake_Do:
	lda #$3F
	sta $0440+0
	rts

TouchDown_Shot:
	jsr $F835 ;Obj[x]��Ani�l=a/�e�탊�Z�b�g
	inc $05A0
	rts
TurnProc:
	lda <$16 ;PadHold1P[ABETUDLR;
	and #$03
	beq .end
	sta <$31
	lsr a
	lda $0580
	and #~$40
	bcc .L
	ora #$40
.L
	sta $0580
.end
	jmp [$0000]
SetAniNo_ResetMotion:
	stx <$32 ;�p���ω��^�C�}�[
	jmp $F835 ;Obj[x]��Ani�l=a/�e�탊�Z�b�g
	END_BOUNDARY_TEST $1FFFFA

