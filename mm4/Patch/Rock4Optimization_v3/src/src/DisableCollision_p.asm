
SkipCollision_Bullet_MoveY:
	jsr rYpmeVy
	jmp SkipCollision_Bullet
SkipCollision_Bullet_MoveX:
	jsr rXpmeVx
	;���ʉ߁�
SkipCollision_Bullet:
	bit vEnableSkull
	bmi SkipCollision_Rts
	;���ʉ߁�
SkipCollision_SkipDamage: ;���̃I�u�W�F�N�g�̔�e�������X�L�b�v
	pla
	pla
	jmp $81B2 ;���b�N�}���ւ̃_���[�W����̂�
SkipCollision_Rts:
	rts
SkipCollision:
	pla
	pla
	jmp $8052
