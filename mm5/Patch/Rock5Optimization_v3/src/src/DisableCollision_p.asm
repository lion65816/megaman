SkipCollision_Bullet_MoveY:
	jsr rYpmeVy
	jmp SkipCollision_Bullet
SkipCollision_Bullet_MoveXY:
	jsr rYpmeVy
SkipCollision_Bullet_MoveX:
	jsr rXpmeVx
	;���ʉ߁�
SkipCollision_Bullet:
	bit vEnableEraser
	bmi SkipCollision_Rts
	;���ʉ߁�
SkipCollision_SkipDamage: ;���̃I�u�W�F�N�g�̔�e�������X�L�b�v
	pla
	pla
	jmp $8082
SkipCollision_Rts:
	rts
SkipCollision_TestCollision_Rts:
	jsr rCollision2Rock
	bcc SkipCollision_Rts
	pla
	pla
	;���ʉ߁�
SkipCollision:
	pla
	pla
	jmp $8039
DisableCollision_SetEraseFlag:
	ldy #$00
	lda <vCurWeapon
	and #$07
	cmp #$01 ;1:�E�H�[�^�[�E�F�[�u 9:�X�^�[�N���b�V��
	bne .NotEraserable
	dey
.NotEraserable
	sty vEnableEraser
	rts

DisableCollision_0C:
	jsr DisableCollision_SetReturnPoint
	lda oXhi,x
	jmp $A1D4
;�X�^�b�N�𑀍삵�Ăł�������΂�(�X�^�b�N���쎩�̏d�����A���͎���)
;���܂菑��������X�y�[�X���m�ۂł��Ȃ����ɗ��p
DisableCollision_SetReturnPoint:
	pla
	sta <vThreadWorking0
	pla
	sta <vThreadWorking1
	pla
	pla
	lda #HIGH($8039-1)
	pha
	lda #LOW ($8039-1)
	pha
	lda <vThreadWorking1
	pha
	lda <vThreadWorking0
	pha
	rts
