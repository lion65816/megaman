;�œK��{
	.IF SW_ClearDMASrc
Misc_ClearDMASrc:
	sec
	ldx #$C0
.loop
	lda #$F8
	sta aDMASrc+$4*$00+0,x
	sta aDMASrc+$4*$01+0,x
	sta aDMASrc+$4*$02+0,x
	sta aDMASrc+$4*$03+0,x
	sta aDMASrc+$4*$04+0,x
	sta aDMASrc+$4*$05+0,x
	sta aDMASrc+$4*$06+0,x
	sta aDMASrc+$4*$07+0,x
	sta aDMASrc+$4*$08+0,x
	sta aDMASrc+$4*$09+0,x
	sta aDMASrc+$4*$0A+0,x
	sta aDMASrc+$4*$0B+0,x
	sta aDMASrc+$4*$0C+0,x
	sta aDMASrc+$4*$0D+0,x
	sta aDMASrc+$4*$0E+0,x
	sta aDMASrc+$4*$0F+0,x
	txa
	beq .exit
	sbc #$40
	tax
	bcs .loop
.exit
	jmp $C7BB
	.ENDIF

	.IF SW_StampRockman
RockWallDeath:
	lda <$F0
	cmp #$04
	beq .ForceProc
	lda <vFrameCounterS
	and #$0F
	bne .NotProc
.ForceProc
	jsr $D428
	jmp $808D
.NotProc
	;�ړ�����ɂ��g�Q�Փ˂�L���ɂ���ꍇ�́A
	;�������̕ύX�ɂ��A�����ɔ�΂��Ȃ���΂Ȃ�Ȃ�
	.IF SW_SpikeCollisionByPlatform
	jmp $8003
	.ELSE
	rts ;jmp����K�v����Ȃ�
	.ENDIF
	.ENDIF

	.IF SW_SpriteSetup_WireMoth
SpriteSetup_WireMoth:
	ora #$00 ;�t���O�e�X�g
	bmi .moth
	;���C���[�p����
	lda oVal0,x
	sta <$00
	lda #LOW (SpriteSetup_WireSpr)
	sta aProcSpriteSetup_Wire+0
	lda #HIGH(SpriteSetup_WireSpr)
	sta aProcSpriteSetup_Wire+1
	bne .return
.moth
	;���X���[���p����
	lda #LOW (SpriteSetup_MothSpr)
	sta aProcSpriteSetup_Moth+0
	lda #HIGH(SpriteSetup_MothSpr)
	sta aProcSpriteSetup_Moth+1
.return
	jmp $DD9C
	;�Ō�̂P���̏����ɂȂ�����|�C���^��߂��Ȃ���΂Ȃ�Ȃ�
	;�Ō�̂P���Ƃ�������̂��߂ɁA
	;�X�v���C�g�c�薇���ƁADMASrc�̃|�C���^���݂�B
	;�܂����̔��肪�Ȃ��ꂽ���́A�����I�Ɏc�薇�����O���Ƃ������Ƃɂ���B
SpriteSetup_WireSpr:
	lda <$04 ;�X�v���C�g�c�薇��
	beq .Last1
	cpx #$FC
	bne .continue
.Last1
	lda #$00
	sta <$04 ;�X�v���C�g�c�薇��
	lda #LOW ($DDE9)
	sta aProcSpriteSetup_Wire+0
	lda #HIGH($DDE9)
	sta aProcSpriteSetup_Wire+1
.continue
	jmp $DDCD

SpriteSetup_MothSpr:
	lda <$04 ;�X�v���C�g�c�薇��
	beq .Last1
	cpx #$FC
	bne .continue
.Last1
	lda #$00
	sta <$04 ;�X�v���C�g�c�薇��
	lda #LOW ($DE0C)
	sta aProcSpriteSetup_Moth+0
	lda #HIGH($DE0C)
	sta aProcSpriteSetup_Moth+1
.continue
	jmp $DE01

	.ENDIF

	.IF SW_RainbowStep
RainbowStep_Setup16x16Transfer:
	lda #HIGH($C779-1)
	jmp RainbowStep_Setup16x16Transfer_
	.ENDIF

	.IF SW_EliminateJSRAtMainLoop
	;�u�����`������+1���P�`���Ă���킯�����A�e�ʂ̂ق����厖�̂悤�ȋC������
EliminateJSRAtMainLoop:
	lda <vTransfer32Tile
	bmi .DoTransfer32x32Tile
.RtsTransfer32x32Tile
	lda $0135
	bne .DoBrightenDarken
.RtsBrightenDarken
	lda <vDrillStep
	bne .DoDrillStepProc
.RtsDrillStepProc
	lda $0140
	bne .DoDustWallProc
.RtsDustWallProc
	jmp $C788

.DoTransfer32x32Tile
	jsr $E262
	jmp .RtsTransfer32x32Tile
.DoBrightenDarken
	jsr $E429
	jmp .RtsBrightenDarken
.DoDrillStepProc
	jsr $E49C
	jmp .RtsDrillStepProc
.DoDustWallProc
	jsr $E4DD
	jmp .RtsDustWallProc
	.ENDIF

;�œK��}
;�œK��(by Rock5easily){
	.IF SW_UseTableAtTerrainProc
UseTableAtTerrainProc_Tbl:
	.db $00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0
	.db $00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0
	.db $A9,$A9,$A9,$A9,$AA,$AA,$AA,$AA,$AB,$AB,$AB,$AB,$AC,$AC,$AC,$AC
	.db $AD,$AD,$AD,$AD,$AE,$AE,$AE,$AE,$AF,$AF,$AF,$AF,$B0,$B0,$B0,$B0
	.ENDIF
	.IF SW_UnrollingPalTransfer
UnrollingPalTransfer:
	ldy	#$04
	clc
.LOOP
	lda	$600,x
	sta	$2007
	lda	$601,x
	sta	$2007
	lda	$602,x
	sta	$2007
	lda	$603,x
	sta	$2007
	lda	$604,x
	sta	$2007
	lda	$605,x
	sta	$2007
	lda	$606,x
	sta	$2007
	lda	$607,x
	sta	$2007
	txa
	adc	#$08
	tax
	dey
	bne	.LOOP
	jmp	$C0A9
	.ENDIF
	.IF SW_UnrollingSearchSlot
UnrollingSearchSlot:
.LOOP
	lda	$300,y
	beq	.Found
	dey
	lda	$300,y
	beq	.Found
	dey
	lda	$300,y
	beq	.Found
	dey
	lda	$300,y
	beq	.Found
	dey
	cpy	#$07
	bne	.LOOP
.NotFound
	; sec			; ���cpy�ŃL�����[1�ƂȂ�̂ŏȗ�
	rts
.Found
	clc
	rts
	.ENDIF
	.IF SW_JoypadOmission
JoypadOmission_rem:
	lda	<$16
	and	#$F0
	sta	<$16
	rts
	.ENDIF
;�œK��}
;�g���@�\��{
	.IF SW_FixTerrainThrough2
FixTerrainTrhough2_Trig:
	lda oAniOrder+0
	eor oAniTimer+0
	lsr a
	bcs .NotMove
	bit oFlag+0
	jmp $8604
.NotMove
	jmp $8616
	.ENDIF

	.IF SW_ThroughInvincibleBoss
ThroughInvincibleBoss_proc:
	lda aGauge+2 ;�{�X�Q�[�W
	bpl .DoHitProc
	cpx vBossIndex
	bne .DoHitProc
	;�{�X�Ƀq�b�g
	lda oBlink,x
	bmi .DoHitProc
	beq .DoHitProc
	;�{�X�Q�[�W���o�Ă���
	;�����������肪�{�X�����̃I�u�W�F�N�g��
	;�_�ł��Ă���Ƃ��͏������s��Ȃ�
	rts
.DoHitProc
	jmp $82A4
	.ENDIF

	.IF SW_SwitchWeapon
SwitchWeapon_cont:
	txa
	beq .NoGauge
	ora #$80
.NoGauge
	sta aGauge+1
	txa
	asl a
	asl a
	tay
	ldx #$00
.Color_loop
	lda $9B04,y
	sta aCurPal+$11,x
	sta aPrePal+$11,x
	iny
	inx
	cpx #$03
	bne .Color_loop
	stx <vPalTrig

	jsr rDeleteRockWeapon

	lda #$00
	sta oVal4+0
	lda #$02
	sta vTransferWeapon

	lda #$2E
	jsr rSE
	.IF SW_DisableCollision
	;�e���������̐ݒ�
	jsr DisableCollision_SetSkullFlag
	.ENDIF
	;���b�V���}�����ɏ�荞��ł�����A�R���؂�̃��[�`���ɔ�΂��B
	;���Ȃ�s���悭�A�Ăяo���Ă����Ȃ��`�ɂȂ��Ă���悤���B
	lda <vRockmanState
	cmp #$04
	bne .NotInRushMarine
	lda #$3C
	sta <vNewPrg8
	jsr rPrgBankSwap
	ldx #$00
	jsr $852B
.NotInRushMarine
	rts

SwitchWeapon_TileTransfer:
	jsr $DB3A
	lda vTransferWeapon
	beq .NoTransfer
	lda <vVRAMTrig1
	ora <vVRAMTrig32
	bne .NoTransfer
	lda vTransferWeapon
	lsr a
	ror a
	sta <$00
	sta aFastTransferQueue+1
	ldx <vCurWeapon
	lda .Tbl_WeaponTileBank,x
	sta <vNewPrgA
	jsr rPrgBankSwap
	lda .Tbl_WeaponTileAddr,x
	sta <$01

	ldy #$7F
.SetupQueue_loop
	lda [$00],y
	sta aFastTransferQueue+3,y
	dey
	lda [$00],y
	sta aFastTransferQueue+3,y
	dey
	lda [$00],y
	sta aFastTransferQueue+3,y
	dey
	lda [$00],y
	sta aFastTransferQueue+3,y
	dey
	bpl .SetupQueue_loop
	sty aFastTransferQueue+3+$80
	lda #$19
	sta aFastTransferQueue+0
	lda #$08
	sta aFastTransferQueue+2
	sta <vVRAMTrig1
	sta vFastTransferTrig
	dec vTransferWeapon
.NoTransfer
	jmp $C7BE
.Tbl_WeaponTileBank
	.db 4,0,0,0
	.db 3,3,3,3
	.db 3,3,3,3
	.db 4,3
.Tbl_WeaponTileAddr
	.db $B3,$A9,$AA,$AB
	.db $A9,$B0,$B1,$AE
	.db $AC,$AA,$AD,$AB
	.db $B3,$AF

	.ENDIF

	.IF SW_SparkPosition
SparkPosition:
	ldx #$00
	jsr rPlaceObjYAtX
	ldx <$0F
	rts
	.ENDIF

	.IF SW_Fix8BossCenterGlitch ;�z�u�̓o���N3C�̕����ǂ��Ƃ͎v��
Fix8BossCenterGlitch_DecCnt:
	dec vSceneTimer
	beq .Timer0
.rts
	rts
.Timer0
	lda <vCurStage
	cmp #$08
	bcs .rts
	jmp $87EC
	.ENDIF

	.IF SW_FixObjLeakOverScreen
FixObjLeakOverScreen:
	cmp #$FF
	bcc .Delete
	jmp $DC45 ;�A�j���[�V���������̂ݍs���A�Z�b�g�A�b�v�͂��Ȃ�
.Delete
	jmp $DC00 ;�폜

FixObjLeakOverScreen_2:
	ldy oAniOrder,x
	iny
	iny
	lda [$00],y
	beq .delete
	rts
.delete
	jmp $DC00
;;	lda #$00
;	jmp $DD3D
	.ENDIF

	.IF SW_FixWireGlitch
FixWireGlitch_2:
	lda #$05
	bit oFlag+0 ; <����D��O���u��>
	bvc .FacingLeft
	lda #-$05
.FacingLeft
	clc
	adc oXhi+0
	cmp oXhi+4
	bne .EndWireProc
	lda oAniNo+4
	rts
.EndWireProc
	pla
	pla
	jmp $85D3
	.ENDIF

	.IF SW_SpikeCollisionByPlatform
SpikeCollisionByPlatform:
	bne .rts
	.IF SW_NerfedSpike ;{
	jmp NerfedSpike
	.ELSE
	jmp $8243
	.ENDIF ;}
.rts
	rts
	.ENDIF

	.IF SW_EscarooGlitch|SW_SlidingFlashStopperGlitch|SW_KnockbackFlashStopperGlitch
EscarooGlitch:
SlidingFlashStopperGlitch:
KnockbackFlashStopperGlicth:
	jsr $F0F8
	lda $013C
	ora $013D
	bne .DecTimer
	rts
.DecTimer
	php
	jsr $9195 ;3C�}�b�v�ς�
	plp
	rts

	.ENDIF

	.IF SW_NerfedSpike ;{
NerfedSpike:
	sec
	lda <aWeaponEnergy+0
	and #$1F
	sbc #SW_NerfedSpike
	jmp $81E7
	.ENDIF ;}


;�g���@�\��}
