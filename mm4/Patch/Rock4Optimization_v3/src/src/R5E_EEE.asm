;by rock4_effectenemyex/Rock5easily
R5E_EffectEnemyEx:
	BANKORG_D $388089
	jmp	R5E_EEE_ChkEffectEnemyID

	BANKORG_D $3C92CF
R5E_EEE_Wind:
	lda	<$2C		; $2C�̒l�̉���2bit���o��
	and	#$03		; |
	beq	.L0		; 0�Ȃ�Ε���������
	
	asl	<$0F		; $0F�̍ŏ��bit���L�����[�t���O�ɉ����o��
	bcs	$933E		; �n�ʂɑ������Ă���Ȃ��$933E�ɃW�����v
	bcc	$9343		; �����łȂ����$9343�ɃW�����v
	
.L0
	.IF SW_CustomBlock ;�J�X�^���u���b�N�����鎞�́A������Ɏc��̏�����C����
	jmp $933E
	.ELSE
	lda	<$22		; 
	cmp	#$01		; �g�[�h�}���X�e�[�W�Ȃ��$9314�ɃW�����v
	beq	$9314		; |
	cmp	#$08		; �R�T�b�N�X�e�[�W1�łȂ����$933E�ɃW�����v
	bne	$933E		; |
	lda	#$00		; �p�f�B���O�p�̃_�~�[����
; 92E7:
	.ENDIF

	BANKORG_D $3EC981
R5E_EEE_AutoScroll:
	lda	<$2C		; $2C�̒l�̍ŏ��bit��0�Ȃ狭���X�N���[������
	bpl	$C9D3		; |
	lda	#$00		; �p�f�B���O�p�̃_�~�[�̖���
	lda	<$2E		;
	bne	$C98F		;
	lda	<$FC		;
	beq	$C9D3		;
; C98F:

	BANKORG R5E_EffectEnemyEx
