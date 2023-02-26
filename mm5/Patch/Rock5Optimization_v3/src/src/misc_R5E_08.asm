;by Rock5easily

	.IF Enable_WeaponSelect
	;��DisableCollision�ׂ̈ɂ�����Ə��������܂�Ă��܂�
	;���O���r�e�B�[�z�[���h���ɕύX�������̑Ή���ǉ����Ă��܂�

Misc_WeaponSelect_Main:
	beq	Misc_WeaponSelect_CHANGE_WEAPON	; �X�^�[�g�{�^���������Ă��Ȃ���Ε���`�F���W������

	ldx	#$00		;
	lda	<$16		; �Z���N�g�{�^���������Ȃ���Ȃ�Ε���`�F���W������(���b�N�o�X�^�[�ɕύX)
	and	#$20		; |
	bne	Misc_WeaponSelect_CHANGE_WEAPON	; |
	
	lda	#$29		; #$29�Ԃ̌��ʉ�(���탁�j���[�\��)��炷
	jsr	$EC5D		; |
	jmp	$8000		; �ʏ�̕��탁�j���[�����փW�����v

Misc_WeaponSelect_CHANGE_WEAPON:			; ��������Z���N�g�{�^������

	; �������畐��I�u�W�F�N�g������
	ldy	#$04		; Y���W�X�^��#$04�����[�h
.LOOP
	jsr	$F2FE		; �I�u�W�F�N�gy���Ń��[�`��
	dey			; Y���W�X�^���f�N�������g
	bne	.LOOP		; 0�ɂȂ�Ȃ����$807A�ɃW�����v

	lda	<$14		; SELECT + START �Ȃ�Ε�������b�N�o�X�^�[�ɕύX
	and	#$10		; |
	bne	Misc_WeaponSelect_SETTING		; |

	ldx	<$32		; Current weapon�����[�h
	lda	<$16		; ���{�^�����ꏏ�ɉ����Ă��鎞�͋t���`�F���W
	and	#$04		; |
	bne	Misc_WeaponSelect_REV_CHANGE	; |

Misc_WeaponSelect_NORMAL_CHANGE:
.LOOP
	inx			;
	cpx	#$0D		;
	bcc	.L		;
	ldx	#$00		;
.L
	lda	<$B0,x		;
	bpl	.LOOP		;
	bmi	Misc_WeaponSelect_SETTING		;
	
Misc_WeaponSelect_REV_CHANGE:
.LOOP
	dex			;
	bpl	.L		;
	ldx	#$0C		;
.L
	lda	<$B0,x		;
	bpl	.LOOP		;

Misc_WeaponSelect_SETTING:
	stx	<$32		;
	ldy	Misc_WeaponSelect_WeaponTable,x	; CurrentWeapon -> Weapon selection in menu order
	sty	<$50		;

	txa			;
	beq	.L		;
	ora	#$80		; #$80��ORA
.L
	sta	<$2E		; Weapon bar select�Ɋi�[; Current weapon �� Weapon selection in menu order�ւ̕ϊ��e�[�u��
	lda	$85F1,y		; $(#$85F1 + Y)�̒l�����[�h
	sta	<$ED		; �C���f�b�N�X1��Sprite CHR banks�Ɋi�[

	; ��������p���b�g�Z�b�g
	lda	<$50		; Weapon selection in menu order�����[�h
	asl	a		; A���W�X�^�����V�t�g
	asl	a		; A���W�X�^�����V�t�g
	tay			; A���W�X�^�̒l��Y���W�X�^�ɃR�s�[
	ldx	#$00		; X���W�X�^�̒l��#$00�����[�h
.LOOP
	lda	$854B,y		; ���했�̃p���b�g���Z�b�g
	sta	$0611,x		; |
	sta	$0631,x		; |
	iny			; |
	inx			; |
	cpx	#$03		; |
	bne	.LOOP		; |

	;���ǉ���/���ߐF����������/���ł�DisableCollision�̂��߂̏������Ăяo��
	lda aPrePal+$00
	sta aCurPal+$10
	.IF Enable_Disable_Collision
	jsr DisableCollision_SetEraseFlag
	.ENDIF

	lda	#$FF		; Palette changed��#$FF���Z�b�g
	sta	<$18		; |

	lda	#$27		; #$29�Ԃ̌��ʉ�(�J�[�\���ړ���)��炷(�`���[�W���ɕ���`�F���W�����Ƃ��̃`���[�W����������������)
	jsr	$EC5D		; |
	
	ldx	#$00		;
	jmp	$821C		;


Misc_WeaponSelect_WeaponTable:
	.db	$00, $01, $02, $03, $04, $05, $08, $09
	.db	$0A, $0B, $0C, $0D, $06

	.ENDIF
