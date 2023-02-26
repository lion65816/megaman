;by rock5_lite/Rock5easily

Misc_R5E_org:
;{���œK��


	.IF Enable_JoypadOmission
;------------------------------------------------
; �p�b�h���͓ǂݎ�菈���y�ʉ�(2P�𖳎�����)
;------------------------------------------------
	BANKORG_D $1EC2E5
ReadPad:
	ldx	#$01
	stx	$4016
	dex
	stx	$4016

	ldx	#$04
.LOOP
	lda	$4016
	lsr	a
	rol	<$14
	lsr	a
	rol	<$00
	lda	$4016
	lsr	a
	rol	<$14
	lsr	a
	rol	<$00
	dex
	bne	.LOOP

	lda	<$00
	ora	<$14
	sta	<$14

	tay
	eor	<$16
	and	<$14
	sta	<$14
	sty	<$16
CheckCrossKey1
	lda	<$14
	and	#$0C
	cmp	#$0C
	beq	.ClearCrossKey
	lda	<$14
	and	#$03
	cmp	#$03
	bne	CheckCrossKey2
.ClearCrossKey
	lda	<$14
	and	#$F0
	sta	<$14
CheckCrossKey2
	lda	<$16
	and	#$0C
	cmp	#$0C
	beq	.ClearCrossKey
	lda	<$16
	and	#$03
	cmp	#$03
	bne	.Return
.ClearCrossKey
	lda	<$16
	and	#$F0
	sta	<$16
.Return
	rts
ReadPadEnd:
	.ENDIF

	.IF Enable_DebugModeOmission
;------------------------------------------------
; �f�o�b�O���[�h�m�F�����X�L�b�v
;------------------------------------------------
	.IF !Enable_WRAMMap ;��WRAMMap�ƏՓ˂��܂�
	BANKORG_D $1EC4A4
	jmp	$C4AD

	BANKORG_D $1EC5AD
	jmp	$C5B6
	.ENDIF


	BANKORG_D $1EDE73
	jmp	$DE7F

	BANKORG_D $1EDF2A
	jmp	$DF47
	.ENDIF

	.IF Enable_UpdateOAMPointer
;------------------------------------------------
; OAM�e�[�u���|�C���^�X�V�����y�ʉ�
;------------------------------------------------
	BANKORG_D $1FE1F3
UpdateOAMOffset:
	inx
	inx
	inx
	inx
	beq	.R
.Next
	dec	<$04
	bpl	$E19F
.R
	stx	<$9F
	rts
	; E200
	iny
	lda	#$F8
	sta	$200,x
	bne	.Next
	.ENDIF


	.IF Enable_ObjMoveLR
;------------------------------------------------
; �I�u�W�F�N�g�̉E�ړ������y�ʉ�
;------------------------------------------------
	BANKORG_D $1FE8E6
Move_Right:
	lda	$318,x
	clc
	adc	$3A8,x
	sta	$318,x
	lda	$330,x
	adc	$3C0,x
	sta	$330,x
	bcc	.R
	inc	$348,x
.R
	rts

;------------------------------------------------
; �I�u�W�F�N�g�̍��ړ������y�ʉ�
;------------------------------------------------
	BANKORG_D $1FE90C
Move_Left:
	lda	$318,x
	sec
	sbc	$3A8,x
	sta	$318,x
	lda	$330,x
	sbc	$3C0,x
	sta	$330,x
	bcs	.R
	dec	$0348,x
.R
	rts
	.ENDIF

	.IF Enable_Rock2ObjCollision
;------------------------------------------------
; ���b�N�}���ƃI�u�W�F�N�g�̐ڐG���菈���y�ʉ�
;------------------------------------------------
	BANKORG_D $1FEF87
Collision_Check:
	sec
	lda	$0528
	bpl	.R
	lda	$390
	ora	$390,x
	bne	.R
	lda	$0528,x
	bpl	.R
	and	#$04
	bne	.R
	lda	$408,x
	and	#$3F
	tay
	lda	$330
	; sec			; �K��C=1�Ȃ̂ŏȗ�
	sbc	$330,x
	pha
	lda	$348
	sbc	$348,x
	sta	<$00
	pla
	bcs	.Check_X
.Calc_Abs
	eor	#$FF
	adc	#$01
	pha
	lda	<$00
	eor	#$FF
	adc	#$00
	sta	<$00
	pla
.Check_X
	cmp	$F0F1,y
	bcs	.R
	sec
	lda	<$00
	bne	.R

	lda	$F0B1,y
	sta	<$00
	lda	$0558
	cmp	#$14
	beq	.Fix_val
	lda	<$30
	cmp	#$02
	bne	.Check_Y
.Fix_val
	lda	<$00
	;sec			; �K��C=1�Ȃ̂ŏȗ�
	sbc	#$07
	sta	<$00
.Check_Y
	lda	$378
	sec
	sbc	$378,x
	bcs	.Compare_val
	eor	#$FF
	adc	#$01
.Compare_val
	cmp	<$00
.R
	rts
	.ENDIF

	.IF Enable_BankSwitch
;------------------------------------------------
; PRG�o���N�؂�ւ������y�ʉ�
;------------------------------------------------
	BANKORG_D $1FFF43
Switch_Bank:
	inc	<$F7		; In PRG change���C���N�������g
	lda	#$06		; Last MMC3 command��#$06���Z�b�g
	sta	<$F2		; |
	sta	$8000		;MMC3 Selector/Command Set
	lda	<$F5		;
	;sta	<$F3		; �Q�[�������[�h����邱�Ƃ��Ȃ��̂ŃR�����g�A�E�g
	sta	$8001		;MMC3 SetPageNumber
	lda	#$07		;
	sta	<$F2		;
	sta	$8000		;MMC3 Selector/Command Set
	lda	<$F6		;
	;sta	<$F4		; �Q�[�������[�h����邱�Ƃ��Ȃ��̂ŃR�����g�A�E�g
	sta	$8001		;MMC3 SetPageNumber
	dec	<$F7		; In PRG change���f�N�������g
	lda	<$F8		; Postponed PRG change�����[�h
	bne	$FF68		; 0�łȂ����$FF68�ɃW�����v
	rts
	.ENDIF

;}���œK��
;{���@�\���P
	.IF Enable_WeaponSelect
	BANKORG_D $1EDE95+1
	.db $30

	BANKORG_D $1EDEA4
	nop			;
	lda	<$14		; �X�^�[�g�{�^���������Ă���Ȃ��Z=0
	and	#$10		; |
	jsr	Misc_WeaponSelect_Main		; ���̏������Ăяo��

	.ENDIF

	.IF Enable_BossRoomJump ;{
	BANKORG_D $1B8759
BossRoomJump_CMove_0F_Main:
	ldy	#$00		; Y���W�X�^��#$00�����[�h
	jsr	$E7B7		; Y������(�u���b�N�ɂ߂荞�܂Ȃ��悤��)�ړ�(�d�͉��Z�L��H)�A�㉺�̃u���b�N�ɂԂ�������L�����[1�H
	bcc	BossRoomJump_cm0F_L1		; �߂荞��ł��Ȃ����$8794�ɃW�����v
	
	lda	#$04		;
BossRoomJump_cm0F_L8:
	cmp	$0558		;
	beq	BossRoomJump_cm0F_L6		;
	jsr	$EA98		;
	
BossRoomJump_cm0F_L6:
	lda	#BANK(BossRoomJump_cm0F_L7)		;
	sta	<$F6		;
	jsr	$FF43		;
	jmp	BossRoomJump_cm0F_L7		;
BossRoomJump_cm0F_R1:
	rts			;
BossRoomJump_cm0F_L1:
	lda	#$07		;
	ldy	$0468		;
	;cpy	#$80		;
	beq	BossRoomJump_cm0F_L8		;
	
	lda	$03F0		; ���b�N�}����Y�������x(high)�����[�h
	bpl	BossRoomJump_cm0F_R1		; �񕉂Ȃ�΃��^�[��
	lda	#$78		; #$78 �� ���b�N�}����Y���W(low) �Ȃ�΃��^�[��
	cmp	$0378		; |
	bcs	BossRoomJump_cm0F_R1		; |
	sta	$0378		; ���b�N�}����Y���W(low)��#$78���Z�b�g
	lda	$0498		; ���b�N�}���̕ϐ�A�����[�h
	bne	BossRoomJump_JumpToL4	; 0�łȂ����$8801�ɃW�����v
	lda	$0480		; ���b�N�}���̕ϐ�B�����[�h
	cmp	#$80		; #$80�łȂ����$87B6�ɃW�����v
	bne	BossRoomJump_JumpToL5	; |
	inc	<$30		;
	jmp	$EA1E		; x��Y�������x��FF.00�ɃZ�b�g����

BossRoomJump_JumpToL4:
	jmp	BossRoomJump_cm0F_L4		;
BossRoomJump_JumpToL5:
	jmp	BossRoomJump_cm0F_L5		;


	BANKORG_D $1B87B6
BossRoomJump_cm0F_L5:

	BANKORG_D $1B8801
BossRoomJump_cm0F_L4:

	BANKORG_DB $1B87FA,$98
	BANKORG_DB $1B8802,$98

	.ENDIF ;}

	.IF Enable_6BitAttribute ;{
	.IF !Enable_WRAMMap ;{
	BANKORG_DB $1EC551+1,$FC
	BANKORG_DB $1EC659+1,$FC
	BANKORG_DB $1EC770+1,$FC
	.ENDIF ;}
	
; ���ׂ鏰�p
	BANKORG_D $1B81DB
	jsr	SixBitAttr_Slip1	; ���s�E��~��
	
	BANKORG_D $1B827B
	jsr	SixBitAttr_Slip2	; ���n��

	BANKORG_D $1B82E5
	jsr	SixBitAttr_Slip3	; �X���C�f�B���O��
	
	BANKORG_D $1B8498
	jsr	SixBitAttr_Slip4_R	; �ジ���蒆

	BANKORG_D $1B849F
	jsr	SixBitAttr_Slip4_L	; �ジ���蒆

	BANKORG_D $1B964C
SixBitAttr_Main:
	php			; �X�e�[�^�X���W�X�^���X�^�b�N�Ƀv�b�V��
	lda	<$49		; �C���f�b�N�X1��Block types in each tested position�����[�h
	pha			; �X�^�b�N�Ƀv�b�V��
	lda	<$11		; $11�̒l���X�^�b�N�Ƀv�b�V��
	pha			; |

	lda	#$00		;
	sta	$122		;

	lda	<$39		; Platform direction�����[�h
	bne	$9684		; 0�łȂ����$9684�ɃW�����v
	bcs	.L		; �L�����[��1(�n�ʂɑ������Ă���)�Ȃ�$965C�ɃW�����v
	jmp	$96E5		; $96E5�ɃW�����v

.L
	jmp	SixBitAttr_Main2

;	BANKORG_D $1B9664
SixBitAttr_ConveyorSpeedTable:
	.dw	$0080
	.dw	$0100
	.dw	$0180
	.dw	$0200

; ������W�����v���ď���u���b�N
	BANKORG_D $1FE822
	jmp	SixBitAttr_AttributeC0Chk1
	
	BANKORG_D $1FE8C2
	jmp	SixBitAttr_AttributeC0Chk2
	
	BANKORG_D $1FE777
	jmp	SixBitAttr_AttributeC0Chk3

	; �������̓X���[
	;BANKORG_D $1FE7AE
	;jmp	AttributeC0Chk4

	.ENDIF ;}

	.IF Enable_SpriteAutoCoordination ;{
	; ��������v���O����
	BANKORG_D $1FE17B
	; beq	$E182			; ���̏���
	; rts				;
	jmp	SprAutCd_BANK1F_SpritePatternEx
	.ENDIF ;}

;}���@�\���P
	BANKORG Misc_R5E_org
