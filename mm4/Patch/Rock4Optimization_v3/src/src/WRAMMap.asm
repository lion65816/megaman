WRAMMap_Org:
	;���ɓ��鏈��
	BANKORG_D $3FF0FC
	jmp RockIntoWater

	;�I�u�W�F�N�g�ɂ�郍�b�N�}���̋����ړ������̃o���N�ޔ��𖳌���
	;����ɁASW_FixTerrainThrough�ɑΉ�
	.IF SW_FixTerrainThrough1
	BANKORG_D $3FF398
	TRASH_GLOBAL_LABEL
	ldy #$00
	lda <vRockmanState
	cmp #$02
	beq .SlidingProc
	cmp #$06
	bne .Conf
	lda oVal0+0
	cmp #$02
	bne .Conf
.SlidingProc
	ldy #$04
	bne .Conf
.Conf
	ldx #$00
	jsr rXpmeVxT
	bit <$00
	ORG_TEST $F3B6
	.ELSE
	BANKORG_D $3FF3A2
	ldx #$00
	jsr rXpmeVxT
	jmp $F3B6
	
	.ENDIF



	;�����_
	BANKORG_D $3ED2FF
	jmp [aProcTerrainHB_InitExc]
WRAMMAP_HB_Init_NoExc:

	lda WRAMMap_HB_Data_Offset,y
	tay
	lda WRAMMap_HB_Data_Base,y
	sta <$06 ;�������
	iny
	;������ł�16bit�̍��W���ӎ����Ă���悤�ɂ������Ă��Ă��Ȃ��B
	;�@�Ȃ̂ł΂����菈�����J�b�g�By>=F0�̏����������B
	clc
	lda WRAMMap_HB_Data_Base,y
	bmi .Dy_n
	;Dy>=0
	adc oYhi,x
	bcc .Y_InScreen
.Y_OutOfScreen
	lda #$00
	ldy <$06 ;�������
.Y_OutOfScreen_loop
	sta $0045,y
	dey
	bpl .Y_OutOfScreen_loop
	jmp WRAMMap_HBar_Exit2
.Dy_n
	adc oYhi,x
	bcc .Y_OutOfScreen
.Y_InScreen
	sta <$11
	lda oYhe,x
	bne .Y_OutOfScreen
;	lda #$00
	sta <$02 ;����ڂ̔��肩
	sta <$04
	iny
	sty <$40
	lda WRAMMap_HB_Data_Base,y
	bpl .Dx_p
	dec <$04
.Dx_p
	clc
	adc oXhi,x
	sta <$12
	lda oXhe,x
	adc <$04
;	sta <$13

;	lda <$13
	and #$0F
	ora #HIGH(aMap)
	sta <$01
	lda <$11
	lsr a
	lsr a
	lsr a
	lsr a
	sta <$00
.Next
	lda <$12
	and #$F0
	tay
	lda [$00],y
	tay
	lda aChipHit,y
	and #Const_16TileAttributeBits
	;��O�����������Ȃ炱���ɏ���
	jmp [aProcTerrainHB_Exc]
.GlobalLabel
	;����
	cpx #$00
	bne .NotRockSpike
	cmp #$30
	bne .NotRockSpike
	sta <$3D
.NotRockSpike
	ldy <$02
	sta $0045,y
	cmp <$41
	bcc .NotSignificantValue
	sta <$41
.NotSignificantValue
	ora <$10
	sta <$10
	lda <$02
	cmp <$06
	beq WRAMMap_HBar_Exit1
	inc <$02
	inc <$40
	ldy <$40

	lda <$12
	clc
	adc WRAMMap_HB_Data_Base,y
	sta <$12
	bcc .Next
	clc
	lda <$01
	adc #$01
	and #$6F
	sta <$01
	bne .Next
	
	GLOBALIZE .GlobalLabel,WRAMMap_HB_NoExc
WRAMMap_HBar_Exit1:
	jmp [aProcTerrainHB_EndExc]
WRAMMap_HBar_Exit2:
	lda <$42
	sta oYhi,x
	rts
WRAMMap_HB_DiveExc:
	ldy <$11
	cpy $013E
	bcs WRAMMap_HB_NoExc
	lda #$00
	beq WRAMMap_HB_NoExc
WRAMMap_HB_DrillExc:
	;������Xhe�͕ێ����Ă��܂���
	cmp #$70
	bne WRAMMap_HB_NoExc
	lda <$01
	and #$0F
	tay
	lda $0680,y
	and #$F0
	jmp WRAMMap_HB_NoExc


	END_BOUNDARY_TEST $3ED3FD
	BANKORG_D $3ED425
	jmp WRAMMap_HBar_Exit2

	;���c�_
	BANKORG_D $3ED42B
	jmp [aProcTerrainVB_InitExc]
WRAMMAP_VB_Init_NoExc:
	lda $D808,y
	sta <$5A
	lda $D848,y
	sta <$5B
	ldy #$00
	sty <$02 ;����ڂ̔��肩
	sty <$04 ;16bit���Zhi
	sty <$05 ;��ʊO
	lda [$5A],y
	sta <$06 ;�����
	iny
	lda [$5A],y
	bpl .Dx_p
	dec <$04
.Dx_p
	clc
	adc oXhi,x
	sta <$12 ;����Xhi���o�͗p�ɕK�v�ł�
	and #$F0
	sta <$00 ;�Ǐolo
	lda oXhe,x
	adc <$04 ;16bit���Zhi
	and #$0F
;	sta <$13 ;����Xhe
	ora #HIGH(aMap)
	sta <$01 ;�Ǐohi
	iny
	sty <$40 ;����ʒu�e�[�u���I�t�Z�b�g
	lda oYhe,x
	bmi .ScreenOut_U
	bne .ScreenOut_D
	clc
	lda oYhi,x
	adc [$5A],y
	sta <$11 ;����Y
	lda [$5A],y
	bpl .Dy_p
	;Dy<0
	bcc .ScreenOut_U
	bcs .NotScreenOut
.Dy_p
	;Dy>=0
	bcs .ScreenOut_D
	;��y>=F0�̊m�F���ȗ�
	bcc  .NotScreenOut
.ScreenOut_D
	lda #$EF
	.db $2C ;Bit $****
.ScreenOut_U
	lda #$00
	sta <$11 ;����Y
	sty <$05 ;��ʊO
.NotScreenOut
.Loop
	lda <$11
	lsr a
	lsr a
	lsr a
	lsr a
	tay
	lda [$00],y
	tay
	lda aChipHit,y
	and #Const_16TileAttributeBits
	cmp #$40
	bne .NotLadderTop
	lda #$20
.NotLadderTop
	;��O�����������Ȃ炱���ɏ���
	jmp [aProcTerrainVB_Exc]
.GlobalLabel
	;����
	cpx #$00
	bne .NotRockSpike
	cmp #$30
	bne .NotRockSpike
	sta <$3D
.NotRockSpike
	ldy <$02 ;����ڂ̔��肩
	sta $0045,y
	cmp <$41
	bcc .NotSignificantValue
	sta <$41
.NotSignificantValue
	ora <$10
	sta <$10
	cpy <$06 ;�����
	beq .ExitProc
	inc <$02 ;����ڂ̔��肩
	inc <$40 ;����ʒu�e�[�u���I�t�Z�b�g
	lda <$05 ;��ʊO
	bne .Loop
	ldy <$40 ;����ʒu�e�[�u���I�t�Z�b�g
	lda <$11 ;����Y
	clc
	adc [$5A],y
	sta <$11 ;����Y
	bcc .Loop
	lda #$FF
	sta <$11 ;����Y
	bne .Loop
.ExitProc
;	jmp $D58D
	lda <$42
	sta oYhi,x
	rts
	GLOBALIZE .GlobalLabel,WRAMMap_VB_NoExc
WRAMMap_VB_DiveExc:
	ldy <$11
	cpy $013E
	bcs WRAMMap_VB_NoExc
	lda #$00
	beq WRAMMap_VB_NoExc
WRAMMap_VB_DrillExc:
	;������Xhe�͕ێ����Ă��܂���
	cmp #$70
	bne WRAMMap_VB_NoExc
	lda <$01
	and #$0F
	tay
	lda $0680,y
	and #$F0
	jmp WRAMMap_VB_NoExc
WRAMMAP_VB_DustInitExc:
	lda #HIGH($D42E-1)
	pha
	jmp WRAMMap_VB_DustConf
WRAMMap_Whopper:
	lda <vScrollXhi
	cmp #$0A
	bne .EndProc
	lda #$00
	ldx #.Tbl_end-.Tbl-1
.loop
	ldy .Tbl,x
	sta aMap+$A00,y
	dex
	bpl .loop
	ldx <vProcessingObj
.EndProc
	jmp rDeleteObjX
.Tbl
	.db $3A,$4A,$5A,$6A
	.db $3B,$4B,$5B,$6B
	.db     $4C,$5C
	.db     $4D,$5D
	.db     $4E,$5E
	.db     $4F,$5F
.Tbl_end
	END_BOUNDARY_TEST $3ED53A
	;�n�`����O�̃o���N�؂�ւ�������
	BANKORG_D $3ED540
	lda oYhi,x
	sta <$42
	rts

	;�_�X�g�v���X�̏���
	BANKORG_D $3ED552
WRAMMAP_HB_DustInitExc:
	lda #HIGH($D302-1)
	pha
	lda #LOW ($D302-1)
	pha
	BANKORG_D $3ED55D
	bne $D56C
	BANKORG_D $3ED566
	beq $D56C
	nop
WRAMMap_VB_DustConf:
	lda #LOW ($D42E-1)
	pha
	ORG_TEST $3ED56C

	BANKORG_D $3ED55D
;	bit <$00
	BANKORG_D $3ED564
;	bit <$00
;	BANKORG_D $3ED56C

	;�����ɒn�`�ω��p�̃��[�`��������
	BANKORG_D $3ED58D

	END_BOUNDARY_TEST $3ED69E

	;���_����f�[�^�̐ݒ�
	BANKORG_D $3ED69E
WRAMMap_HB_Data_Offset:
	.db $16,$1B,$1F,$22,$27,$2C,$31,$36,$3B,$36,$40,$36,$45,$4A,$4F,$53
	.db $57,$1F,$1F,$5A,$5F,$62,$67,$6B,$6F,$74,$79,$7E,$83,$87,$8B,$8F
	.db $93,$97,$9C,$1F,$A1,$A4,$A8,$AD,$B2,$B6,$BA,$BE,$C2,$C6,$C9,$CF
	.db $D5,$DA,$DF,$E4,$E9,$EC,$EF,$F2,$F5,$F8,$FD
	.db $00 ;3B �\��
	.db $00 ;3C �\��
	.db $00 ;3D �\��
	.db $00 ;3E �\��
	.db $00 ;3F �\��
	.db $00 ;40 �\��
	.db $00 ;41 �\��
	.db $00 ;42 �\��
	.db $00 ;43 �\��
	.db $00 ;44 �\��
	.db $00 ;45 �\��
	.db $00 ;46 �\��
	.db $00 ;47 �\��
	.db $00 ;48 �\��
	.db $00 ;49 �\��
	.db $00 ;4A �\��
	.db $00 ;4B �\��
	.db $00 ;4C �\��
	.db $00 ;4D �\��
	.db $00 ;4E �\��
	.db $00 ;4F �\��
	.db $00 ;50 �\��
	.db $00 ;51 �\��
	.db $00 ;52 �\��
	.db $00 ;53 �\��
	.db $00 ;54 �\��
	.db $00 ;55 �\��
	.db $00 ;56 �\��
	.db $00 ;57 �\��
	.db $00 ;58 �\��
	.db $00 ;59 �\��
	.db $00 ;5A �\��
	.db $00 ;5B �\��
	.db $00 ;5C �\��
	.db $00 ;5D �\��
	.db $00 ;5E �\��
	.db $00 ;5F �\��
	BANKORG_D $3ED708
WRAMMap_HB_Data_Base:

	;�I�u�W�F�N�g�̒n�`������ȗ������Ă����ꍇ�̃f�[�^�������Őݒ�
	BANKORG WRAMMap_HB_Data_Offset+$3B
	.db $5F ;$3B ���΂̏�ړ��̂���
	.db $5F ;$3C
	.db $3B ;$3D
	.db WRAMMap_HB_Data_3E-WRAMMap_HB_Data_Base ;$3E
	BANKORG WRAMMap_HB_Data_Base
WRAMMap_HB_Data_3E:
	.db $01,$F0,$F5,$16 ;�Q�_
	END_BOUNDARY_TEST $3ED71E



;���ω�����n�`�ւ̑Ή�
	;�_�X�g�}���X�e�[�W�̉󂹂��
	BANKORG_D $3A886F
	lda <$01
	sta $140
	lda <$00
	sta $141
	lda oXhi,x
	sta $142
	ORG_TEST $3A887F

	BANKORG_D $3FE4E2
	lda <vVRAMTrig1
	ora <vVRAMTrig32
	bne $E4DC
	lda $0140
	sta <$01
	lda $0142
	and #$F0
	ora $0141
	sta <$00
	lda #$00
	sta aVRAMQueue+$0
	tay
	sta [$00],y
	sta <$01
;	lda <$00 ;XXXX yyyy
;	lda <$01 ;0110 PPPP
;	lda #0142;XXXX xxxxx

;0010 00YY YY0X XXX0
	lda <$00
	lsr a    ;0XXX Xyyy  ... y
	ror a    ;y0XX XXyy  ... y
	ror a    ;yy0X XXXy  ... y
	rol <$01 ;yy0X XXXy  0000 000y
	lsr a    ;0yy0 XXXX  ...y
	rol <$01 ;0yy0 XXXX  0000 00yy
	asl a    ;yy0X XXX0  0000 00yy
	sta aVRAMQueue+$1
	ora #$20
	sta aVRAMQueue+$6
	lda <$01
	eor #$03
	ora #$20
	sta aVRAMQueue+$0
	sta aVRAMQueue+$5
	ldy #$01
	sty aVRAMQueue+$2
	sty aVRAMQueue+$7
	dey
	sty aVRAMQueue+$3
	sty aVRAMQueue+$4
	sty aVRAMQueue+$8
	sty aVRAMQueue+$9
	sty $0140
	dey
	sty aVRAMQueue+$A
	sty <vVRAMTrig1
	rts
	END_BOUNDARY_TEST $3FE578

	;������i����ԁj
	BANKORG_D $3DA112
	TRASH_GLOBAL_LABEL
	jsr WRAMMap_RainbowStep
	;clc
	and #$0F
	ora #HIGH(aMap)
	sta <$01
	lda oXhi,x
	and #$F0
	tay

	lda oVal2,x
	adc #$12

	sta [$00],y
	ORG_TEST $3DA128

	;������i�����E�����O�j
	BANKORG_D $3DA1EB
	jsr WRAMMap_RainbowStep
	and #$0F
	ora #HIGH(aMap)
	sta <$01
	lda oXhi,x
	and #$F0
	tay
	lda #$00
	lda oVal2,x
	sta [$00],y
	ORG_TEST $3DA201
	
	;�h�����}���X�e�[�W�̏o����
	BANKORG_D $3DAE14
	jsr WRAMMap_DrillFloor

	;���X���[���̏��j��
	BANKORG_D $3DB494
	jsr WRAMMap_Moth
	stx <vVRAMTrig1

	BANKORG_D $3DA22E
WRAMMap_RainbowStep:
	lda oYhi,x
	lsr a
	lsr a
	lsr a
	lsr a
	sta <$00
	lda oXhe,x
	clc ;���������ɗe�ʂ�����Ȃ��Ȃ����̂ł�����clc
	rts
	END_BOUNDARY_TEST $3DA241
	
	BANKORG_D $3DA89A
	jsr WRAMMap_Whopper

;��3ED4C8:2099D5 jsr $3ED599 ;�����O�}���X�e�[�W�A�����ꔻ��;
;��3ED4CB:20DAD5 jsr $3ED5DA ;�R�T�b�N�P��O(���X���[��);
;������3ED4CE:20E6D5 jsr $3ED5E6 ;���X�^�[5(�_�C�uS���ʕϓ�)/�h�����}���o����/�����O�}�����b�p�[;
;��3ED4D1:2024D6 jsr $3ED624 ;���X�^�[4�ɂ�90�̏����i�_�X�g�}���ǁj;
;��3ED4D4:2061D6 jsr $3ED661 ;���C���[�R���C���[�}�V���ւ̃J�v�Z��;


;3EC5AA:20B1CF jsr $3ECFB1 ;PPU�������݃L���[�ɒǉ�:�X�N���[���ɂ��l�[���e�[�u���`��;
;3ECAC9:20B1CF jsr $3ECFB1 ;PPU�������݃L���[�ɒǉ�:�X�N���[���ɂ��l�[���e�[�u���`��;
;3ECBB5:20B1CF jsr $3ECFB1 ;PPU�������݃L���[�ɒǉ�:�X�N���[���ɂ��l�[���e�[�u���`��;
;3FE61B:20B1CF jsr $3ECFB1 ;PPU�������݃L���[�ɒǉ�:�X�N���[���ɂ��l�[���e�[�u���`��;
;	BANKORG_D $3EC5AA
;	jsr WRAMMap_SetupNTTransfer
	BANKORG_D $3ECAC9
	jsr WRAMMap_SetupNTTransfer
;	BANKORG_D $3ECBB5
;	jsr WRAMMap_SetupNTTransfer
;	BANKORG_D $3FE61B
;	jsr WRAMMap_SetupNTTransfer

	.IF SW_WRAMMap_OrgHack
	;�����O�}���X�e�[�W�̓��E�����O�ɂ�萶�����
	BANKORG_D $24A000+$1B
	.db $00
	BANKORG_D $24A100+$1B
	.db $00
	BANKORG_D $24A200+$1B
	.db $00
	BANKORG_D $24A300+$1B
	.db $00
	BANKORG_D $24A400+$1B
	.db $02
	BANKORG_D $24A000+$9E
	.db $00
	BANKORG_D $24A100+$9E
	.db $00
	BANKORG_D $24A200+$9E
	.db $00
	BANKORG_D $24A300+$9E
	.db $00
	BANKORG_D $24A400+$9E
	.db $01
	.ENDIF


	BANKORG WRAMMap_Org
