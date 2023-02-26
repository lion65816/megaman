	; ���ꏈ�����C��
;	BANKORG_D $3FEFD0		; ���g�p�̈�𗘗p����
BANK3F_Foothold:
	cmp	#$40			; �͂���(���_)�Ȃ�ׂ������W�`�F�b�N��
	beq	.JmpF1BC		; |
	cmp	#$44			;
	bne	.JmpF1C4		;
.JmpF1BC
	jmp	$F1BC			; �͂���(���_)������̏ꍇ
.JmpF1C4
	jmp	$F1C4			; �͂���(���_)�ł�����ł��Ȃ��ꍇ
BANK3F_Foothold_End:

; �d�͉��Z�̂Ȃ����[�`���ւ̑Ή�
BANK3F_OnewayBlock:
	cmp	#$48
	beq	.JmpF0F3
	and	#$10
	bne	.JmpF0F3
	clc
	rts
.JmpF0F3
	jmp	$F0F3

; �d�͉��Z�̂��郋�[�`���ւ̑Ή�
BANK3F_OnewayBlockG:
	cmp	#$48			; ����ʍs�u���b�N�Ȃ�Ή������ւ̍��W�␳������
	beq	.JmpF225		; |
	and	#$10			; �u���b�N�����������Ă��Ȃ���΃L�����[�N���A���ă��^�[����
	beq	.JmpF22B		; |
.JmpF225
	jmp	$F225			; �������ւ̍��W�␳����
.JmpF22B
	jmp	$F22B			; �L�����[�N���A���ă��^�[��
.End

CustomBlock_Main:
	php			; �W�����v���Œׂ������������s
	ror	<$0F		; |

	.IF SW_WRAMMap
	jmp [aProcCustomBlock_Conv]
CustomBlock_Conveyor:
	.ENDIF
;	lda	<$39		; ���łɉ����ɏ���Ă����ꍇ�̓W�����v���ɋA��
;	bne	.Jmp92C8	; |
	
	lda	#$01		; Platform direction��#$01(�E)���Z�b�g
	sta	<$39		; |
.CheckCenter
	lda	<$46		; �C���f�b�N�X1��Block types in each tested position�����[�h
	cmp	#$D0		; #$D0(�R���x�A�E)�Ȃ��.SetSpeed�ɃW�����v
	beq	.SetSpeed	; |
	cmp	#$D4		; #$F0(�R���x�A��)�Ȃ��.SetDirLeft�ɃW�����v
	beq	.SetDirLeft	; |
	lda	<$45		; �C���f�b�N�X0��Block types in each tested position�����[�h
	cmp	<$46		; �C���f�b�N�X1��Block types in each tested position�Ɠ������Ȃ��Ȃ�.CheckSide�ɃW�����v
	bne	.CheckSide	; |
	lda	<$47		; �C���f�b�N�X2��Block types in each tested position�����[�h
.CheckSide
	cmp	#$D0		; #$D0�Ȃ�.SetSpeed�ɃW�����v
	beq	.SetSpeed	; |
	cmp	#$D4		; #$F0�łȂ����.Jmp92C8�ɃW�����v
	bne	.ClearDir	; |
.SetDirLeft
	inc	<$39		; Platform direction���C���N�������g(#$02=���ɂ���)
; �R���x�A�̑��x
.SetSpeed
	lda	#$80		; Platform X speed low��#$80���Z�b�g
	sta	<$3A		; |
	lda	#$00		; Platform X speed high��#$00���Z�b�g
	sta	<$3B		; |
	jmp	CustomBlock_return; .Jmp92C8

.ClearDir
	lda	#$00		; Platform direction��#$00(����)���Z�b�g
	sta	<$39		; |

	.IF SW_WRAMMap
CustomBlock_SkipConveyor:
	jmp [aProcCustomBlock_FlSn]
CustomBlock_FlowSnow:
	.ENDIF

;��E�����̂��߂̒n�`�ǂݎ��
;��:C8
;����:80 A0 C0
;�������A�������n�V�S�̒��_�̎��͏������Ȃ�
	lda <aTerrain+1
	cmp #$40
	beq .NoSnowFlow
	ldy #$10
	jsr rTerrainTestHB
	lda <$10
	bpl .NoSnowFlow
	cmp #$C8
	beq .Snow
	jmp $9319 ;���������ւȂ��ł��܂�(�����ŁA80,A0,C0�Ƃ̈�v���m�F�A��v���Ȃ����͋A�H��)
.Snow
	jmp $92F6 ;��̏���
.NoSnowFlow
.Jmp92C8
	.IF SW_WRAMMap
CustomBlock_SkipFlowSnow:
	.ENDIF
CustomBlock_return:
	jmp	$92C8		; �W�����v���֖߂�
.End
