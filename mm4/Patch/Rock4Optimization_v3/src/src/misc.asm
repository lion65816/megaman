Misc_org:

;�œK��(by �Ղꂳ�ׁ[){

	;�I�[�f�B�I�����̃��W�X�^��@�������̍œK��
	;�e�[�u�����m�ۂ���ʒu�̓s����AWRAMMap�ƃZ�b�g�ōs����B
	.IF SW_WriteAudioReg&SW_WRAMMap
	BANKORG_D $1E80EC
	sta <$C4
	tya
	ora MISC_TblAudioRegOffset,x
	tay
	lda <$C4
	sta $4000,y
	rts
	.ENDIF

	;NMI�������E�o
	.IF SW_NMIExit
	BANKORG_D $3EC10B
	cli ;�I�[�f�B�I�������̃��X�^�[���荞�݂̂��߃N���A���Ă���
	jmp $C13F
	BANKORG_D $3EC148
	rti
	.ENDIF

	;�X�v���C�g�Z�b�g�A�b�v�����̍œK��
	;�Q�[�W�̕����̍œK�����s��
	.IF SW_Gauge
	BANKORG_D $3EDB44
	jsr Misc_SetupGauge

	BANKORG_D $3EDB6E
	jmp Misc_SetupGauge

	;�L�����[�t���O�̕ϓ���}���邱�Ƃ�
	;�Q�[�W�Z�b�g�A�b�v�̍ŏ���sec���邾���ŗǂ��Ȃ��Ă���
	BANKORG_D $3EDEE2
Misc_SetupGauge:
	sec
	ldx #$02
	jsr $DF00
	ldx #$01
	jsr $DF00
	ldx #$00
	jmp $DF00
	PaddingTill $3EDF00-1

	BANKORG_D $3EDF03
	bpl Misc_SetupGauge_Rts

	BANKORG_D $3EDF0B
	ora #$80
	BANKORG_D $3EDF30
	ldy #$84
	lda <$00
	sbc #$04
	bmi .GaugeProc_4Gauge
	ldy <$00
	lda #$80
.GaugeProc_4Gauge
	sta <$00
	tya
	sta aDMASrc+1,x
	inx
	inx
	inx
	inx
	beq $DF56
	lda <$03
	sbc #$08
	sta <$03
	cmp #$10
	bne $DF21
	stx <$97
Misc_SetupGauge_Rts:
	rts
	.ENDIF


	;DMA�]�����̃N���A���[�`�����A�����[�����O
	.IF SW_ClearDMASrc
	BANKORG_D $3EC7B8
	jmp Misc_ClearDMASrc
	.ENDIF
	
	;���b�N�}���̈��������̊Ԉ���
	.IF SW_StampRockman
	BANKORG_D $3A808A
	jmp RockWallDeath
	.ENDIF

	;���b�N�}���̐��A����
	.IF SW_RockBubble
	BANKORG_D $3C9497
	jmp $949C
	BANKORG_D $3C949C
	lda <$44
	.ENDIF

	;���C�����[�v�𔲂��锻��̍œK��
	.IF SW_MainLoopExit
	BANKORG_D $3EC7CF
	bcc $C7F3 ;0-6�͑����[�v
	cmp #$09
	bcc $C7DD ;7,8�����������
	.ENDIF
	
	;���C���[�E���X���[���̔��̕\�����ق�̋͂��ɍ��
	;�i�t�ɂ������\�����鎞�͂��Ȃ�d���Ȃ�j
	.IF SW_SpriteSetup_WireMoth
	BANKORG_D $3EDD91 ;���̏�����+2clock/�I�u�W�F�N�g
	TRASH_GLOBAL_LABEL
	cmp #$0B ;���C���[
	beq .Exception
	cmp #$88 ;���X���[���̔�
	bne .NoException
.Exception
	jmp SpriteSetup_WireMoth
.NoException
	BANKORG_D $3EDDC9
	jmp [aProcSpriteSetup_Wire] ;-1clock/�X�v���C�g1��
	BANKORG_D $3EDDFB
	jmp [aProcSpriteSetup_Moth] ;-3clock/�X�v���C�g1��

	.ENDIF

	.IF SW_DisableCapsuleForeground
	BANKORG_D $3C8032
	bit $0000
	.ENDIF

	.IF SW_DisableCpslFrgnd_OrgHack
	BANKORG_D $2EA414
	DB2 $E2E2
	BANKORG_D $2EA41A
	DB2 $E2E2
	.ENDIF

	.IF SW_RainbowStep
	BANKORG_D $3EC776
	jmp [aProcRainbowStep]
	BANKORG_D $3FE0FA
RainbowStep_Setup16x16Transfer_:
	pha
	lda #LOW ($C779-1)
	pha
	lda <vCurStage
	ORG_TEST $E100
	.ENDIF

	.IF SW_EliminateJSRAtMainLoop
	BANKORG_D $3EC779
	TRASH_GLOBAL_LABEL
	lda <vTransferBackNT
	bne .DoBackNTTransfer
.RtsBackNTTransfer
	jmp EliminateJSRAtMainLoop
.DoBackNTTransfer
	jsr $E35C
	jmp .RtsBackNTTransfer
	END_BOUNDARY_TEST $3EC788
	.ENDIF

	.IF SW_AudioDriverModPointer
	BANKORG_D $1E868A
	asl a
	asl a
	rol <$C3
	asl a
	rol <$C3
	adc #$D1
	sta <$C5
	lda <$C3
	adc #$8A
	sta <$C6
	rts
	.ENDIF
;�œK��}
;�œK��(by Rock5easily){
	.IF SW_UseTableAtTerrainProc
	BANKORG_D $3ED2DA
	tay
	lda UseTableAtTerrainProc_Tbl,y
	sta <$20
	lda UseTableAtTerrainProc_Tbl+$20,y
	sta <$21
	rts
	.ENDIF
	.IF SW_UnrollingPalTransfer
	BANKORG_D $3EC09D
	jmp UnrollingPalTransfer
	.ENDIF
	.IF SW_UnrollingSearchSlot
	BANKORG_D $3FFB6C
	ldy #$17
	jmp UnrollingSearchSlot
	.ENDIF
	.IF SW_UpdateObjectPointer
	BANKORG_D $3A8052
	inx
	stx <vProcessingObj
	cpx #$18
	bne $8018
	nop
	ORG_TEST $805A
	
	;�o�O��x�ɃI�u�W�F�N�g�ԍ��������ꂸ�ɕ��A���Ă���
	;�K�`���b�|��
	BANKORG_D $3BB578
	bit <$00
	.ENDIF
	.IF SW_JoypadOmission
	BANKORG_D $3EC37D
JoypadOmission_ReadPad:
	ldx	#$01
	stx	$4016
;	dex       ;���T�Ƃ̂�����Ƃ������[�`���̈Ⴂ�ɂ��
;	stx	$4016 ;�e�ʂ�����Ȃ��̂Ŗ�������P�o���܂��B
	sta	$4016 ;�Ăяo������a��00�ł��B

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
JoypadOmission_CheckCrossKey1:
	lda	<$14
	and	#$0C
	cmp	#$0C
	beq	.ClearCrossKey
	lda	<$14
	and	#$03
	cmp	#$03
	bne	JoypadOmission_CheckCrossKey2
.ClearCrossKey
	lda	<$14
	and	#$F0
	sta	<$14
JoypadOmission_CheckCrossKey2:
	lda	<$16
	and	#$0C
	cmp	#$0C
	beq	.ClearCrossKey
	lda	<$16
	and	#$03
	cmp	#$03
	bne	.Return
.ClearCrossKey
	;�������肪���Ȃ����ȏꍇ�A���[�`�����΂��ĂR�o�C�g�m��
	jmp JoypadOmission_rem
;	lda	<$16
;	and	#$F0
;	sta	<$16
.Return
	rts
	END_BOUNDARY_TEST $3EC3D5
	.ENDIF
	.IF SW_UpdateOAMPointer
	BANKORG_D $3EDE39
	TRASH_GLOBAL_LABEL
	beq UpdateOAMPointer_WritePtr_rts
UpdateOAMPointer_Next:
	dec <$04
	bpl $DDC3
UpdateOAMPointer_WritePtr_rts:
	stx <vDMASrcPointer
	rts
	ORG_TEST $DE42
	BANKORG_D $3EDE48
	bne UpdateOAMPointer_Next
	.ENDIF

	.IF SW_ObjMoveLR
	;�E
	BANKORG_D $3FF240
	TRASH_GLOBAL_LABEL
	bcc .rts
	inc oXhe,x
.rts
	rts
	;��
	BANKORG_D $3FF25E
	TRASH_GLOBAL_LABEL
	bcs .rts
	dec oXhe,x
.rts
	rts
	.ENDIF

	.IF SW_BankSwitch
	BANKORG_D $3FFF3B
	sta $8000
	lda <vNewPrg8
	sta $8001
	lda #$07
	sta $8000
	lda <vNewPrgA
	sta $8001
	dec <vMMCSemaphore
	lda <vDelayedAudioProc
	bne $FF5C
	rts
	.ENDIF
;�œK��}
;�g���@�\��(by �Ղꂳ�ׁ[){

	.IF SW_FixTerrainThrough2
	BANKORG_D $3C85EA+1
	.db $00
	BANKORG_D $3C85EF+1
	.db $01

	BANKORG_D $3C85FF
	jmp FixTerrainTrhough2_Trig
	BANKORG_D $3C8604
	bvs $860F
	.ENDIF
	
	.IF SW_ThroughInvincibleBoss
	BANKORG_D $3A815C
	jsr ThroughInvincibleBoss_proc
	.ENDIF
	
	.IF SW_SlidingJumpInWaterEtc
	BANKORG_D $3C836A
	bpl $839D
	ldy #$03

	BANKORG_D $3C8374
	jsr $D2FC
	lda <$10
	and #$10
	.ENDIF
	
	.IF SW_QuickFade
	.IF SW_QuickFade>0
	BANKORG_D $3EC45E+1
	.db SW_QuickFade
	.ELSE
	BANKORG_D $3EC451+1
	.db $20
	BANKORG_D $3EC453+1
	.db $E0
	BANKORG_D $3EC457+1
	.db $20
	BANKORG_D $3EC45E+1
	.db 1
	.ENDIF
	.ENDIF
	
	.IF SW_QuickRecover
	BANKORG_D $3BBC32
	bit $0000
	BANKORG_D $3BBC3C
	bit $0000
	.ENDIF

	;�T�u��ʊJ�Ńn�V�S������������A�Ȃ�
	.IF SW_ContinueGrabbingLadderEtc
	BANKORG_D $3C973A
	jsr ContinueGrabbingLadderEtc
	nop
	.ENDIF

	;�X���C�f�B���O���ł��T�u��ʂ��J����
	.IF SW_OpenSubScreenAtSliding
	BANKORG_D $3EC715
	jmp $C719
	.ENDIF

	;����؂�ւ�
	.IF SW_SwitchWeapon
	BANKORG_D $3EC299 ;�X�N�G�A�}�V���̕s��H�d�l�H�C��
	sta $2005
	nop
	ORG_TEST $3EC29D
	BANKORG_D $3EC70F
	and #$30 ;�X�^�[�g�Z���N�g���󂯕t��
	BANKORG_D $3EC73D
	jsr SwitchWeapon
	BANKORG_D $3EC7BB
	jmp SwitchWeapon_TileTransfer
	.ENDIF

	;��e�X�p�[�N�̏o��ʒu�̒���
	;(���ꂾ���̏����̂��߂ɁA�M�d�ȃo���N3E,3F�𗘗p���Ă������̂��c�c)
	.IF SW_SparkPosition
	BANKORG_D $3A8236
	jsr SparkPosition
	.ENDIF

	;�`���[�W�V���b�g�ˏo���ɁA�H�ɐF�����������Ȃ�s����Ƃ肠�����ׂ�
	.IF SW_FixChargeShotColorGlitch
	BANKORG_D $3C8D16
	bit $0000
	bit $0000
	.ENDIF

	;�X�N�G�A�}�V���̉��̕ǂɋ��܂�Ă��_���[�W���󂯂Ȃ��o�O
	.IF SW_FixSquareMachineGlitch
	BANKORG_D $3DBD40
	jsr FixSquareMachineGlitch
	.ENDIF

	;���b�V���W�����v��ɒ�q��͂݁A�o�肫��ƁA���̃W�����v�ōő�W�����v���Ă��܂��o�O
	.IF SW_FixRushJumpLadderGlitch
	BANKORG_D $3C84A1
	TRASH_GLOBAL_LABEL
	bit oFlag+0
	bvs .TowardL
	dec vLastInputLR ;���e�ʒ����̂��ߔ�[���y�[�W
.TowardL
	stx oVal2+0
	ORG_TEST $84AC
	.ENDIF
	
	;�W�{�X��|�������A�����ɂ���Ə��X�������Ȍ��ۂ��N����o�O
	.IF SW_Fix8BossCenterGlitch
	;�����n�߂鎞�ɒ����ɂ���ƃ��[�v����o�O
	BANKORG_D $3C87CA
	jmp Fix8BossCenterGlitch_DecCnt
;	BANKORG_D $3C87CA
;	bne Fix8BossCenterGlitch_sub
;	BANKORG_D $3C8808
;	lda #$08
;	jmp rSetVyA00
;Fix8BossCenterGlitch_sub:
;	dec vSceneTimer
;	beq $87EC
;	ORG_TEST $8812
	
	;���y����n�߂鎞��Y���܂ߒ����ɂ���ƕ���z�����n�܂�o�O
	BANKORG_D $35B055
	beq Fix8BossCenterGlitch_Wait

	BANKORG_D $35B082
	TRASH_GLOBAL_LABEL
	ldy #$01
	lda oXhi+0
	bpl .TowardR
	iny
.TowardR
	sty oDirection+0
	nop
Fix8BossCenterGlitch_Wait:
	lda vSceneTimer
	bne $B0F3
	ORG_TEST $B093

	.ENDIF

	;���b�V���A�_�v�^���莞�A�g���[�q���͂Ńo�O
	.IF SW_ExPortGlitchAtWeaponGetScr
	BANKORG_D $398E3E
	lda #$00
	.ENDIF

	.IF SW_AnywhereIce
	BANKORG_D $3C82CF
	jmp [aProcIce0]
	.db $22,$22,$22
AnywhereIce_Proc0:
	php
	ORG_TEST $82D6
	BANKORG_D $3C82F0
AnywhereIce_SkipProc0:

	BANKORG_D $3C938F
	jmp [aProcIce1]
	.db $22,$22,$22
AnywhereIce_Proc1:
	ORG_TEST $9395
	BANKORG_D $3C93D9
AnywhereIce_SkipProc1:

	BANKORG_D $3C93DB
	jmp [aProcIce2]
	.db $22,$22,$22
AnywhereIce_Proc2:
	ORG_TEST $93E1
	.ENDIF
	BANKORG_D $3C93C9
AnywhereIce_SkipProc2:

	.IF SW_FixRockWeaponsCollision
	BANKORG_D $3C9022
	jmp $9027
	.ENDIF

	.IF SW_FixKickBuster
	BANKORG_D $3C8DA0
	lda <vRockmanState
	cmp #$04
	.ENDIF
	
	.IF SW_FixObjLeakOverScreen
	BANKORG_D $3EDBD0
	ora #$00
	bpl $DBDA ;��ʉ��͍폜
	jmp FixObjLeakOverScreen ;�����Č���

	BANKORG_D $3EDCE5
	bpl FixObjLeakOverScreen_Hook
	;�󂫗e�ʂ̖�����ȔP�o
	BANKORG_D $3EDD52
	bne $DD59
FixObjLeakOverScreen_Hook:
	jmp FixObjLeakOverScreen_2
	.ENDIF

	.IF SW_RainFlushMisfire
	BANKORG_D $3A8BCE
	lda #$FF
	BANKORG_D $3A8BD6
	lda #$04
	.ENDIF

	.IF SW_FixWireGlitch
	BANKORG_D $3A8EE0
	jsr FixWireGlitch
	
	BANKORG_D $3C858D
	jsr FixWireGlitch_2

	;�Ȃ񂩗v��Ȃ�����������̂ő���ɏ��ɏo�����̏���
	BANKORG_D $3C8F05
	TRASH_GLOBAL_LABEL
	lda oYhe+4
	beq .SkipFixProc
	stx oYhe+4
	stx oYhi+4
.SkipFixProc
	stx oHitFlag+4
	ORG_TEST $8F13

	.ENDIF
	
	.IF SW_FixBalloonStampGlitch
	BANKORG_D $3ED734+1
	.db $FA
	.ENDIF
	
	.IF SW_SpikeCollisionByPlatform ;{
	BANKORG_D $3A8005
	beq SpikeCollisionByPlatform_Rts
	BANKORG_D $3A800B
	bcs SpikeCollisionByPlatform_Rts
	BANKORG_D $3A800F
	jmp SpikeCollisionByPlatform
SpikeCollisionByPlatform_Rts:
	rts
	END_BOUNDARY_TEST $3A8014

	BANKORG_D $3A805C
	bne $8003
	BANKORG_D $3A8062
SpikeCollisionByPlatform_LengCS:
	bcs $8003
	BANKORG_D $3A8068
SpikeCollisionByPlatform_LengEQ:
	beq $8003
	BANKORG_D $3A8088
	bcs SpikeCollisionByPlatform_LengCS
	BANKORG_D $3A8091
	beq SpikeCollisionByPlatform_LengEQ
	BANKORG_D $3A8093
	jmp $8243

	BANKORG_D $3EC757
	jsr $8014
	.ENDIF ;}
	
	.IF SW_FixMarineStampGlitch
	BANKORG_D $3ED922+2
	DB2 $FC0F
	BANKORG_D $3ED926+2
	DB2 $FC0F
	.ENDIF

	.IF SW_EscarooGlitch
	BANKORG_D $3C86AF
	jsr EscarooGlitch
	.ENDIF

	.IF SW_SlidingFlashStopperGlitch
	BANKORG_D $3C8355
	jsr SlidingFlashStopperGlitch
	.ENDIF

	.IF SW_KnockbackFlashStopperGlitch
	BANKORG_D $3C85E7
	jsr KnockbackFlashStopperGlicth
	.ENDIF
	
	.IF SW_NerfedSpike ;{
	;�ړ��������C��������Ƃ��͂�����Ŕ�ѐ�C��
	.IF !SW_SpikeCollisionByPlatform
	BANKORG_D $3A8011
	jsr NerfedSpike
	.ENDIF
	.ENDIF ;}

;�g���@�\��}
;�g���@�\��(by Rock5easily){
	;�񕜌��ʉ�����O�p�g�i�����j���폜���A�Ȃ��O�p�g�̂ݗ����悤��
	.IF SW_DeleteTriWaveFromRefillSound
	BANKORG_D $1D8F5A;1DAF5A
	.db $03
	BANKORG_D $1D8F65;1DAF65
	.db $01,$02,$CF,$57
	BANKORG_D $1D8F6A;1DAF6A
	.db $00,$FF,$FF,$FF,$FF,$FF
	.ENDIF

	;�{�X�Q�[�W�̏㏸���x
	.IF SW_BossGaugeSpeed
SW_BossGaugeSpeed_tmp = ($FF>>(9-SW_BossGaugeSpeed))
	BANKORG_D $35A0B6+1
	.db SW_BossGaugeSpeed_tmp
	BANKORG_D $35A4FD+1
	.db SW_BossGaugeSpeed_tmp
	BANKORG_D $35A85D+1
	.db SW_BossGaugeSpeed_tmp
	BANKORG_D $35AADA+1
	.db SW_BossGaugeSpeed_tmp
	BANKORG_D $35ACE5+1
	.db SW_BossGaugeSpeed_tmp
	BANKORG_D $35B509+1
	.db SW_BossGaugeSpeed_tmp
	BANKORG_D $38B861+1
	.db SW_BossGaugeSpeed_tmp
	BANKORG_D $3DB1F9+1
	.db SW_BossGaugeSpeed_tmp
	BANKORG_D $3DB6E3+1
	.db SW_BossGaugeSpeed_tmp
	BANKORG_D $3DBAE5+1
	.db SW_BossGaugeSpeed_tmp
	.ENDIF
	
	;E�ʗ��p���x
	.IF SW_ETankSpeed
	BANKORG_D $3C9704+1
	.db SW_ETankSpeed
	.ENDIF
	
	;6bit�����̎���
	.IF SW_CustomBlock&!SW_WRAMMap
	;SW_WRAMMap�����鎞�͂�����ŃZ�b�g�����
	BANKORG_D $3ED395+1
	.db Const_16TileAttributeBits
	BANKORG_D $3ED4C0+1
	.db Const_16TileAttributeBits
	.ENDIF


;�g���@�\��(by Rock5easily)}



	BANKORG Misc_org
