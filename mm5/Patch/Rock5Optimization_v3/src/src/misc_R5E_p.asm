;by Rock5easily

	.IF Enable_6BitAttribute ;{

; ������W�����v���ď���u���b�N
SixBitAttr_AttributeC0Chk1:
	lda	<$42		;
	and	#$70		;
	cmp	#$40		;
	jmp	$E826
SixBitAttr_AttributeC0Chk2:
	lda	<$42		;
	and	#$70		;
	cmp	#$40		;
	jmp	$E8C6

SixBitAttr_AttributeC0Chk3:		; �������ړ�
	and	#$10		;
	bne	SixBitAttr_AC0_R1		;
	lda	<$42		;
	
	cmp	#$C0		;
	beq	SixBitAttr_AC0_R1		;
	clc
	rts			;
SixBitAttr_AC0_R1:
	jmp	$E77B		;

;SixBitAttr_AttributeC0Chk4:		; ������ړ�
;	and	#$10		;
;	bne	AC0_R2		;
;	lda	<$42		;
;	cmp	#$C0		;
;	beq	AC0_R2		;
;	clc
;	rts			;
;SixBitAttr_AC0_R2:
;	jmp	$E7B2		;

SixBitAttr_Main2:
; �x���g�R���x�A����
	lda	#$01		; Platform direction��#$01(�E)���Z�b�g
	sta	<$39		; |
	lda	<$49		; �C���f�b�N�X1��Block types in each tested position�����[�h
	tay			; A -> Y
	and	#$F0		; ���4bit���o��

	cmp	#$50		; #$50(�R���x�A�E)�Ȃ��$967C�ɃW�����v
	beq	SixBitAttr_SetConveyorSpeed		; |
	cmp	#$70		; #$70(�R���x�A��)�Ȃ��$967A�ɃW�����v
	beq	SixBitAttr_L1		; |
	cmp	#$90		; #$90(���ׂ鏰)�Ȃ��
	beq	SixBitAttr_SlipBlock_Main	; |
	
	lda	<$48		; �C���f�b�N�X0��Block types in each tested position�����[�h
	cmp	<$49		; �C���f�b�N�X1��Block types in each tested position�Ɠ������Ȃ��Ȃ�$9672�ɃW�����v
	bne	SixBitAttr_L2		; |
	lda	<$4A		; �C���f�b�N�X2��Block types in each tested position�����[�h
SixBitAttr_L2:
	tay			; A -> Y
	and	#$F0		; ���4bit���o��
	
	cmp	#$50		; #$50�Ȃ�$967C�ɃW�����v
	beq	SixBitAttr_SetConveyorSpeed		; |
	cmp	#$70		; #$70�łȂ����$96C0�ɃW�����v
	beq	SixBitAttr_L1		; |
	cmp	#$90		; #$90(���ׂ鏰)�Ȃ��
	beq	SixBitAttr_SlipBlock_Main	; |
	
	lda	#$00		;
	sta	<$5C		;
SixBitAttr_JumpTo96C0:
	jmp	$96C0		;
SixBitAttr_L1:
	inc	<$39		; Platform direction���C���N�������g(#$02=���ɂ���)

; �x���g�R���x�A�̑��x
SixBitAttr_SetConveyorSpeed:
	tya			; Y -> A
	lsr	a		;
	and	#$06		;
	tay			;
	lda	SixBitAttr_ConveyorSpeedTable,y
	sta	<$3A		; |
	lda	(SixBitAttr_ConveyorSpeedTable+1),y
	sta	<$3B		; |
	jmp	$9684		;

; ���ׂ鏰�̏���
; $5C -> ����(01 -> �E, 02 -> ��)
; $122 -> ���ׂ������t���O
; $120-121 -> ���x

SixBitAttr_SlipBlock_Main:
	lda	<$30		; �n�ʒ��n���łȂ���Ζ���
	bne	SixBitAttr_JumpTo96C0	; |

	lda	<$5C		; ���ׂ�Ȃ�.L1�ɃW�����v
	bne	.L1		; |
	
	lda	$0558		; ���b�N�}����Animation��#$04,05�łȂ���΃��^�[��
	cmp	#$04		; |
	beq	.L3		; |
	cmp	#$05		; |
	bne	SixBitAttr_JumpTo96C0	; |
.L3
	lda	<$31		; ���ׂ�����Z�b�g
	sta	<$5C		; |

.L1
	lda	<$16		; �L�[���͕��� <> ���ׂ���� �Ȃ炷�ׂ�
	and	#$03		; |
	cmp	<$5C		; |
	bne	.L4		; |

	lda	#$4C		; ���ׂ鑬�x�Z�b�g
	sta	$120		; |
	lda	#$01		; |
	sta	$121		; |
	jmp	$96C0		;
.L4
	lda	$120		; [$120-121] := [$120-121] - #$0003
	sec			; |
	sbc	#$02		; |
	sta	$120		; |
	lda	$121		; |
	sbc	#$00		; |
	sta	$121		; |

	bcs	.L2		;
	lda	#$00		;
	sta	<$5C		;
	sta	$120		;
	sta	$121		;
	beq	SixBitAttr_JumpTo96C0	;
.L2
	inc	$122		;
	
	lda	<$5C		;
	sta	<$39		;
	lda	$120		;
	sta	<$3A		;
	lda	$121		;
	sta	<$3B		;
	jmp	$9684		;



SixBitAttr_Slip1:
	;lda	<$31		;
	lda	$122		; ���ׂ������t���O
	beq	.L1		; ���ׂ��ĂȂ���Ε��ʂ�X�����ړ�
	jmp	$EC30		; �O���t�B�b�N�̌���������f�[�^�ɍ��킹��
.L1
	jmp	$EA3F		; X�����ړ�

SixBitAttr_Slip2:
	ldy	#$00		; ���n���ɂ��ׂ�����N���A
	sty	<$5C		; |
	jmp	$EA98		; �A�j���[�V�����ԍ��Z�b�g

SixBitAttr_Slip3:
	lda	<$5C		; ���鏰�Ŋ����Ă��邩
	beq	.L		; �����Ă��Ȃ���Ε��ʂ�X�����ړ�
	lda	<$31		; ���鏰�Ŋ���������X���C�f�B���O�����ɍ��킹��
	sta	<$5C		; |
.L
	jmp	$EA3F		; X�����ړ�

SixBitAttr_Slip4_R:		; �ジ���蒆
	lda	<$5C		;
	beq	.L		;
	lda	#$01		;
	sta	<$5C		;
.L
	jmp	$E6C7		;
SixBitAttr_Slip4_L:		; �ジ���蒆
	lda	<$5C		;
	beq	.L		;
	lda	#$02		;
	sta	<$5C		;
.L
	jmp	$E708		;

	.ENDIF ;}
	
	.IF Enable_SpriteAutoCoordination ;{
	; �X�v���C�g�p�^�[���W�J�̎�������
SprAutCd_BANK1F_SpritePatternEx:
	bne	.CheckBank
	jmp	$E182			; �W�����v���Œׂ������������s
.CheckBank
	txa				; ���������BANK��I��
	eor	#$01			; |
	tax				; |
	lda	<$EC,x			; ���������BANK���g�p�ς݂Ȃ珈���I��
	bmi	.Main			; |
	cmp	[$02],y			; |
	bne	.R			; |
.Main
	lda	[$02],y
	sta	<$EC,x
	ldy	#$01
	lda	[$02],y
	sta	<$04
	iny
	lda	[$02],y
	tax
	lda	$8400,x
	sec
	sbc	#$03
	sta	<$05
	lda	$8500,x
	sbc	#$00
	sta	<$06
	ldx	<$9F
	bne	.Loop
.R
	rts
.Loop
	iny
	lda	[$02],y			; �X�v���C�g�p�^�[���ԍ����v�Z
	eor	#$40			; |
	sta	$0201,x
	lda	[$05],y
	sta	<$07
	lda	<$10
	bpl	.CalcY
	lda	#$F8
	sec
	sbc	<$07
	sta	<$07
.CalcY
	lda	<$12
	clc
	adc	<$07
	sta	$0200,x
	lda	<$07
	bmi	.L1
	bcc	.L2
	bcs	.NotDrawn1
.L1
	bcc	.NotDrawn1
.L2
	iny
	lda	[$02],y
	eor	<$10
	ora	<$11
	sta	$0202,x
	lda	[$05],y
	sta	<$07
	lda	<$10
	and	#$40
	beq	.CalcX
	lda	#$F8
	sec
	sbc	<$07
	sta	<$07
.CalcX
	lda	<$13
	clc
	adc	<$07
	sta	$0203,x
	lda	<$07
	bmi	.L3
	bcc	.L4
	bcs	.NotDrawn2
.L3
	bcc	.NotDrawn2
.L4
	inx
	inx
	inx
	inx
	stx	<$9F
	beq	.R
.Next
	dec	<$04
	bpl	.Loop
	rts

.NotDrawn1
	iny
.NotDrawn2
	lda	#$F8
	sta	$0200,x
	bne	.Next
	.ENDIF ;}
