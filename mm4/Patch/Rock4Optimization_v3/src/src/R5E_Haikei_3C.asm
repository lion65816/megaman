;by rock4_haikei/Rock5easily
R5E_Haikei_main:
	;SW_WRAMMap������΁A�t���O���Q�Ƃ���悤�ɕύX
	.IF !SW_WRAMMap
	ldy	<$22		; Current level�����[�h
	lda	R5E_Haikei_TblPerStage,y		; $95F0�̒l�����[�h
	beq	R5E_Haikei_Return		; 0�Ȃ��Return�ɃW�����v
	.ELSE
	lda vForegroundFlag
	beq R5E_Haikei_Return
	.ENDIF

	lda	<$95		; Synchronous frame counter�����[�h
	lsr	a		; 2bit�E�V�t�g
	lsr	a		; |
	bcs	R5E_Haikei_Return		; �L�����[��1�Ȃ�Return�ɃW�����v

	lda	$0528		; ���b�N�}����display flags�����[�h
	and	#$DF		; 5bit��(�w�i�ɉB���)���N���A
	sta	$0528		; |
	ldy	#$40		; ���E�����̃`�b�v�����`�F�b�N
	jsr	$D428		; |
	lda	<$41		; Largest block type found�����[�h
	cmp	#$E0		; #$E0(�w�i�̗��ɉB���)�Ȃ�SetSprieFlag�ɃW�����v
	beq	R5E_Haikei_SetSprieFlag	; |
	ldy	#$41		; ���E�����̃`�b�v�����`�F�b�N
	jsr	$D428		; |
	lda	<$41		; Largest block type found�����[�h
	cmp	#$E0		; #$E0(�w�i�̗��ɉB���)�łȂ����Return�ɃW�����v
	bne	R5E_Haikei_Return		; |

R5E_Haikei_SetSprieFlag:
	lda	$0528		; ���b�N�}����display flags��5bit��(�w�i�ɉB���)��1�ɃZ�b�g
	ora	#$20		; |
	sta	$0528		; |

R5E_Haikei_Return:
	plp			; �X�e�[�^�X���W�X�^�Ƀ|�b�v
	rts			; ���^�[��
