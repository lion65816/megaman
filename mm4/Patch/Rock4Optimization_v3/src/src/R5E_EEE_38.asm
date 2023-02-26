;by rock4_effectenemyex/Rock5easily
R5E_EEE_ChkEffectEnemyID:
	cmp	#$F0		; ID��F0�ȏ�Ȃ�g��������
	bcs	R5E_EEE_EffectEnemyEx	; |
	
	and	#$3F		; �W�����v���Œׂ����������s��
	tay			; |
	jmp	$808C		; ID:C0�`EF�͒ʏ�̏����֖߂�
	
R5E_EEE_EffectEnemyEx:
	and	#$0F		; ����4bit���o��
	tay			;
	lda	R5E_EEE_ProcAddrLow,y	;
	sta	<$06		;
	lda	R5E_EEE_ProcAddrHigh,y	;
	sta	<$07		;
	ldy	<$04		;
	lda	$B200,y		; �I�u�W�F�N�g��Y���W�����[�h
	jmp	[$0006]		;
	
R5E_EEE_ProcAddrLow:
	.db	low(R5E_EEE_ProcF0), low(R5E_EEE_ProcF1), low(R5E_EEE_ProcF2), low(R5E_EEE_ProcF3)
	.db	low(R5E_EEE_ProcF4), low(R5E_EEE_ProcF5), low(R5E_EEE_ProcF6), low(R5E_EEE_ProcF7)
	.db	low(R5E_EEE_ProcF8), low(R5E_EEE_ProcF9), low(R5E_EEE_ProcFA), low(R5E_EEE_ProcFB)
	.db	low(R5E_EEE_ProcFC), low(R5E_EEE_ProcFD), low(R5E_EEE_ProcFE), low(R5E_EEE_ProcFF)
R5E_EEE_ProcAddrHigh:
	.db	high(R5E_EEE_ProcF0), high(R5E_EEE_ProcF1), high(R5E_EEE_ProcF2), high(R5E_EEE_ProcF3)
	.db	high(R5E_EEE_ProcF4), high(R5E_EEE_ProcF5), high(R5E_EEE_ProcF6), high(R5E_EEE_ProcF7)
	.db	high(R5E_EEE_ProcF8), high(R5E_EEE_ProcF9), high(R5E_EEE_ProcFA), high(R5E_EEE_ProcFB)
	.db	high(R5E_EEE_ProcFC), high(R5E_EEE_ProcFD), high(R5E_EEE_ProcFE), high(R5E_EEE_ProcFF)

; ��������ID:F0�̏���(�ݒuY���W��艺�̃X�v���C�g��w�i�ɉB��)
R5E_EEE_ProcF0:
;	lda	$B200,y		; �I�u�W�F�N�g��Y���W�����[�h
	sta	<$EF		; $EF�Ɋi�[(�w����W��艺�̃X�v���C�g��w�i�ɉB��)
	rts			; ���^�[��
	
	
; ��������ID:F1�̏���(BGM��ݒuY���W�Ŏw�肵���g���b�N�ɕύX)
R5E_EEE_ProcF1:
;	lda	$B200,y		; �I�u�W�F�N�g��Y���W�����[�h
	cmp	<$D9		; ���݂̃g���b�N�ԍ��Ɣ�r
	beq	.R0		; ��v����΃��^�[��
	jmp	$F6BC		; ���y��炷
.R0
	rts			;
	
; ��������ID:F2�̏���(�d�͒l��ݒuY���W�Ŏw�肵���l�ɕύX(�f�t�H���g=$40))
R5E_EEE_ProcF2:
;	lda	$B200,y		; �I�u�W�F�N�g��Y���W�����[�h
	sta	<$99		;
	rts			;

; ��������ID:F3�̏���(Y���W��00�ȊO�ɂ��ăZ�b�g -> �����X�N���[���J�n, Y���W��00�ɂ��ăZ�b�g -> �����X�N���[������)
R5E_EEE_ProcF3:
;	lda	$B200,y		; �I�u�W�F�N�g��Y���W�����[�h
	beq	.L0		;
	lda	#$80		;
.L0
	sta	<$06		; 
	lda	<$2C		;
	and	#$7F		; �ŏ��bit���N���A
	ora	<$06		; �����X�N���[���L���Ȃ�ŏ��bit��1�ƂȂ�
	sta	<$2C		;
	rts			; ���^�[��

; ��������ID:F4�̏���(���̐ݒ�B Y���W = 00 -> ����, 01 -> �E, 02 -> ��)
R5E_EEE_ProcF4:
;	lda	$B200,y		; �I�u�W�F�N�g��Y���W�����[�h
	and	#$03		; ����2bit���o��
	sta	<$06		;
	lda	<$2C		;
	and	#$FC		; ����2bit���N���A
	ora	<$06		;
	sta	<$2C		;
	rts			; ���^�[��

; ��������ID:F5�̏���(BG�p���b�g�t�F�[�h�C���E�t�F�[�h�A�E�g�̐ݒ�BY���W = 00 -> �t�F�[�h�C��, 01 -> �t�F�[�h�A�E�g)
R5E_EEE_ProcF5:
;	lda	$B200,y		; �I�u�W�F�N�g��Y���W�����[�h
	and	#$01		;
	beq	.FadeIn	;
.FadeOut
	; BG�p���b�g�t�F�[�h�A�E�g
	lda	$0135		;
	and	#$7F		;
	bne	.R0		; 0�ɂȂ�Ȃ���΃��^�[��
	sta	$0136		;
	lda	#$10		;
	sta	$0137		;
	lda	#$01		;
	sta	$0135		;
	lda	#$58		;
	sta	$0143		;
	lda	#$02		;
	sta	$0144		;
.R0
	rts			; ���^�[��
.FadeIn
	lda	$0135		; $135�̒l�����[�h
	beq	.R0		; 0�Ȃ�΃��^�[��
	bmi	.R0		; �ŏ��bit��1�Ȃ�΃��^�[��
	lda	#$00		; 
	sta	$0136		;
	lda	#$30		;
	sta	$0137		;
	lda	#$80		;
	sta	$0135		;
	rts			; ���^�[��

; ���������͂܂������Ȃ�
R5E_EEE_ProcF6:
R5E_EEE_ProcF7:
R5E_EEE_ProcF8:
R5E_EEE_ProcF9:
R5E_EEE_ProcFA:
R5E_EEE_ProcFB:
R5E_EEE_ProcFC:
R5E_EEE_ProcFD:
R5E_EEE_ProcFE:
R5E_EEE_ProcFF:
	rts			; ���^�[��

