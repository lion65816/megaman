;by rock4_fastscroll/Rock5easily
R5E_FastScroll_PPUTransfer:
	ldx	#$00		; 
	stx	<$19		;
	
	lda	vFastTransferTrig		;
	bne	.L		;

	jmp	$C334		;
	
.L
	stx	vFastTransferTrig		;
	
	lda	aFastTransferQueue		;
	bmi	.R2		;
	sta	$2006		;
	lda	aFastTransferQueue+1		;
	sta	$2006		;
	
	ldy	aFastTransferQueue+2		;
	stx	aFastTransferQueue+2		;
	clc			;
	
.AddrTest0
.LOOP
	; 16�o�C�g�]��
	lda	aFastTransferQueue+$3,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$4,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$5,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$6,x		;
	sta	$2007		;

	lda	aFastTransferQueue+$7,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$8,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$9,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$A,x		;
	sta	$2007		;

	lda	aFastTransferQueue+$B,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$C,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$D,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$E,x		;
	sta	$2007		;

	lda	aFastTransferQueue+$F,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$10,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$11,x		;
	sta	$2007		;
	lda	aFastTransferQueue+$12,x		;
	sta	$2007		;
	
	txa			;
	;clc			;
	adc	#$10		;
	tax			;
	dey			;
	bne	.LOOP		;
.AddrTest1

.R2
	rts			;

	.IF HIGH(.AddrTest0)!=HIGH(.AddrTest1)
	.FAIL �����]�����x���Ȃ�v���O�����z�u�ł�
	.ENDIF


R5E_FastScroll_STD___:
.rts
	rts
.Entry
	lda	<$19		; Draw horizontal data�����[�h
	ora	<$1A		; Draw vertical data��ORA
	ora	vFastTransferTrig		;

	bne	.rts		; �ǂꂩ��ł�0�łȂ���΃��^�[��
	lda	<$55		;
	bne	.MapGraphicBank	;
	lda	#$29		;
	sta	<$F6		;
	jsr	$FF37		; PRG BANK�؂�ւ�
	ldy	<$51		;
	lda	[$52],y		;
	bmi	.rts		; �ŏ��bit��1�Ȃ�΃��^�[��

	; �V�������������f�[�^�ǂݏo��
.ReadNewData
	sta	<$54		;
	iny			;
	lda	[$52],y		;
	sta	<$55		;
	iny			;
	lda	#$00		;
	sta	<$56		;
	sta	<$58		;

	sta	$7F02		;
	
	lda	[$52],y		;
	sta	<$57		;
	iny			;
	lda	[$52],y		;
	sta	<$59		;
	iny			;
	sty	<$51		;

.MapGraphicBank
	lda	<$59		;
	sta	$7F00		;
	lda	<$58		;
	sta	$7F01		;
	lda	<$54		;
	sta	<$F5		;
	sta	<$F6		;
	inc	<$F6		;
	jsr	$FF37		;

	ldy	#$00
	; �f�[�^�W�J���[�v
.LOOP
	; 1�x��16��t�F�b�`���邱�ƂŃ��[�v�`�F�b�N�񐔂����炷
	; 0�`7
	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;
	
	; 8�`15
	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;

	lda	[$56],y		;
	sta	$7F03,y		;
	iny			;
	
	inc	$7F02		;
	dec	<$55		;
	
	beq	.SetWriteAddress;
	cpy	#$80		; Y���W�X�^�̒l��#$80(�^�C��8��)�Ɣ�r
	bne	.LOOP		; ��v���Ȃ���΃��[�v

.SetWriteAddress
	lda	#$FF		;
	sta	$7F03,y		;
	tya			;
	clc			;
	adc	<$56		;
	sta	<$56		;
	lda	<$57		;
	adc	#$00		;
	sta	<$57		;
	tya			;
	clc			;
	adc	<$58		;
	sta	<$58		;
	lda	<$59		;
	adc	#$00		;
	sta	<$59		;
	dey			;
	sty	<$19
	sty	vFastTransferTrig		;
.R1
	rts			;

	GLOBALIZE .Entry,R5E_FastScroll_SetupTransferData
