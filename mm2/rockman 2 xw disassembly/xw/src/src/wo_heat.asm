
	lda A_ObjVal0,x ;0:�}�l�[�W�� 1:���Ē�
	bne .not_manager
	lda #$00
	sta A_ObjSprTimer,x
	sta A_ObjSprNo,x
	lda <V_PadOn ; RLDUTEBA
	and #$02
	beq .suicide
	lda <V_RockmanState
	cmp #$03
	bcc .suicide
	dec A_ObjVal1,x ;���̃^�C�}�[
	bpl .return
	lda #$02
	sta A_ObjVal1,x ;���̃^�C�}�[
	;�G�l���M�[
	dec <V_WeaponEnergyCounter
	bpl .not_consume
	lda A_WeaponEnergy+1-1
	beq .suicide
	dec A_WeaponEnergy+1-1
	lda #10
	sta <V_WeaponEnergyCounter
.not_consume

	;���ɂ����疳��
	lda <V_RockmanYhe
	bne .ScreenOut
	;���z�u
	ldx #$02+7
.SeekEmptyObj_loop
	lda A_ObjFlag,x ;���E�H�H�e�d����
	bpl .SeekEmptyObj_exit
	dex
	cpx #$03
	bne .SeekEmptyObj_loop
	;���Ō�͋�����Obj[3]�ɏ㏑�����ꑱ���邯�ǋC�ɂ��Ȃ�
.SeekEmptyObj_exit
	ldy #$01
	jsr R_CreateWeapon ;Obj[x]�ɕ���y���쐬
	inc A_ObjVal0,x
	inc A_ObjSprNo,x
.ScreenOut
	jsr R_ShotPose ;���b�N�}�����V���b�g�p����

	lda #$36
	jsr R_SoundOn

.return
	ldx <V_ProcessingObj
	rts
.suicide
	lsr A_ObjFlag,x ;���E�H�H�e�d����
	rts
.not_manager
	lda A_ObjSprNo,x
	lsr a
	sta A_LObjHitSize,x
	;�{���͓r���Œ�~���
	;�g�債���ł���\�肾����������ł������낤�c�c
	jmp R_CommonWeaponProc ;���ʕ��폈��
