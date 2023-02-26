Misc_org:
;{���œK��

	;�I�[�f�B�I�����̃��W�X�^��@�������̍œK��
	;�e�[�u�����m�ۂ���ʒu�̓s����AWRAMMap�ƃZ�b�g�ōs����B
	BANKORG_D $1880EC
	.IF Enable_Misc_WriteAudioReg&Enable_WRAMMap
	sta <$C4
	tya
	ora MISC_TblAudioRegOffset,x
	tay
	lda <$C4
	sta $4000,y
	rts
	.ENDIF

	.IF Enable_Misc_NMIExit
	;NMI�������E�o
	BANKORG_D $1EC12B
	cli ;�I�[�f�B�I�������̃��X�^�[���荞�݂̂��߃N���A���Ă���
	jmp $C15F
	BANKORG_D $1EC168
	rti
	.ENDIF

	.IF Enable_Misc_Gauge
	;�Q�[�W�̃X�v���C�g�Z�b�g�A�b�v�̍œK��
	BANKORG_D $1EDF78
	jsr Misc_SetupGauges
	BANKORG_D $1EDF9B
	jsr Misc_SetupGauges
	BANKORG_D $1EDFB5
	jsr Misc_SetupGauges
;
	;�L�����[�t���O�̕ϓ���}���邱�Ƃ�
	;�Q�[�W�Z�b�g�A�b�v�̍ŏ���sec���邾���ŗǂ��Ȃ��Ă���
	BANKORG_D $1FE260
Misc_SetupGauges:
	sec
	ldx #$02
	jsr Misc_SetupAGauge_Boss
	ldx #$01
	jsr Misc_SetupAGauge
	ldx #$00
	jmp Misc_SetupAGauge

	ORG_DELTA $10
Misc_SetupAGauge_Boss:
	ldy <aGauge+2
	bpl Misc_SetupAGauge_rts
	ldy <vBossObj
	lda oHP,y
	ora #$80
	jmp Misc_SetupAGauge_ConfFromBoss
Misc_SetupAGauge:
	ldy <aGauge,x
	bpl Misc_SetupAGauge_rts
	lda aWeaponEnergy-$80,y
Misc_SetupAGauge_ConfFromBoss:
	ORG_TEST $E295

	BANKORG_D $1FE2B8
	ldy #$64
	lda <$00
	sbc #$04
	bmi .GaugeProc_4Gauge
	sbc #$1C
	tay
	lda #$80
.GaugeProc_4Gauge
	sta <$00
	tya
	sta aDMASrc+1,x
	inx
	inx
	inx
	inx
	beq Misc_SetupAGauge_rts
	lda <$03
	sbc #$08
	sta <$03
	cmp #$10
	bne $E2A9
	stx <vDMASrcPtr
Misc_SetupAGauge_rts:
	rts
	END_BOUNDARY_TEST $1FE2E1

	.ENDIF

	.IF Enable_Misc_ClearDMASrc
	;DMA�]�����̃N���A���[�`�����A�����[�����O
	BANKORG_D $1EDF1E
	jmp Misc_ClearDMASrc
	.ENDIF

	;���b�N�}���̕���ƃ��b�N�}���Ƃ̔�����X�L�b�v
	.IF Enable_Misc_DisCollRW
	BANKORG_D $1C805D
	bcc $8039
	.ENDIF

;}���œK��
;{���@�\���P

	.IF Enable_SlidingCharge
	BANKORG_D $1B832D
	TRASH_GLOBAL_LABEL
	;�`���[�W������(�o�X�^�[�ȊO�̕����)�Ƃ��I��
	lda <$38
	beq .return
	;�a��������Ă���΃`���[�W����������
	bit <$16
	bvs .BHolded
	;�`���[�W���Ԃ�20h���Z���Ƃ��I��
	cmp #$20
	bcc .return
.BHolded
	jmp $913D
.return
	;�`���[�W���Ԃ�0�ɂ��郋�[�`���ɔ�΂�
	jmp $9236
;���̏ꏊ�ɔ�э��ޏ���������
	rts
	END_BOUNDARY_TEST $1B8340
	.ENDIF

	.IF Enable_InvincibleTimeType=1
	BANKORG_D $1C817A
	jmp Misc_InvTime1
	.ENDIF
	.IF Enable_InvincibleTimeType=2 | Enable_InvincibleTimeType=3
	BANKORG_D $03A60A ;�I�N�g�p�[
	jmp Misc_InvTime23
	BANKORG_D $04A166 ;���C���[�}�V���@���������������ǂ���������Ȃ����c�c
	jmp Misc_InvTime23
	BANKORG_D $1C807F ;�u���̑��v
	jsr Misc_InvTime23
	BANKORG_D $1C8AF0 ;�v�J�v�[�J�[�̃{�f�B
	jsr Misc_InvTime23
	BANKORG_D $1C9525 ;�_�`���[��
	jmp Misc_InvTime23
	BANKORG_D $1DA645 ;�R�b�R
	jsr Misc_InvTime23
	BANKORG_D $1DAA11 ;���[�h�[��
	jmp Misc_InvTime23
	.ENDIF

	.IF Enable_GoodDog
	BANKORG_D $1DB1A4
	cmp #$01
	bne $B187
	jsr $EC94 ;��x
	cmp #$10
	bcs $B187
	lda $03F0 ;Vyhi
	bpl $B187
	jsr $EC76 ;��y
	bcs $B187
	cmp #$10
	bcs $B187
	bit $0000
	nop
	.ENDIF

	.IF Enable_SlidingJumpInWaterEtc
	BANKORG_D $1B82B9
	and #$10
	bne $82C8
	lda #$4C
	jsr $8455
	bit $0000
	.ENDIF

	.IF Enable_DisableChargeCancel
	BANKORG_D $1C82FF
	bit <$38
	.ENDIF

	.IF Enable_QuickRecover
	BANKORG_D $1DAEEF
	jmp $AEF7
	.ENDIF

	.IF Enable_QuickFade
	BANKORG_D $1EC3FA+1
	.db $01
	.ENDIF

	.IF Enable_FixEnemyOffsetAtWarp
	BANKORG_D $1ED042
	jsr Misc_FixEnemyOffsetAtWarp
	.ENDIF

	.IF Enable_FixLadderAtAntigravity
	;���_��`�̗e�ʂ��m�ۂ��邽�߂Ɋ���f�[�^�����ւ���
	;01<=>26
	BANKORG_DB $1EC807+$01,FixLadderAtAntigravity_New01-$C837
	BANKORG_DB $1EC807+$26,FixLadderAtAntigravity_New26-$C837
	BANKORG_DB $1EC807+$27,FixLadderAtAntigravity_New27-$C837
	BANKORG_DB $1EC807+$28,FixLadderAtAntigravity_New28-$C837


	BANKORG_D $1EC83C ;��01
FixLadderAtAntigravity_New26:
	.db $01,$05,$F9,$0E
	BANKORG_D $1EC8D8 ;��26
FixLadderAtAntigravity_New01:
	.db $02,$F6,$F9,$07,$07
FixLadderAtAntigravity_New27:
	.db $00,$0C;,$00 ;����00�𗘗p���ďȗ�
FixLadderAtAntigravity_New28:
	.db $00,$F4,$00
	ORG_TEST $1EC8E2
	.ENDIF
	
	.IF Enable_NerfedSpike ;{
	BANKORG_D $1C82A5
	lda <$36
	lsr a
	lsr a
	and #$03
	tay
	lda <aWeaponEnergy+0
	sec
	jmp NerfedSpike
	ORG_TEST $1C82B2
	BANKORG_D $1C82B2
NerfedSpike_Tbl_Damage:
	db 28,7,4,1
	.ENDIF ;}


;}���@�\���P
	BANKORG Misc_org
