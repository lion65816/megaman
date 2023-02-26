
SkipCollision_Bullet_MoveY:
	jsr rYpmeVy
	jmp SkipCollision_Bullet
SkipCollision_Bullet_MoveX:
	jsr rXpmeVx
	;↓通過↓
SkipCollision_Bullet:
	bit vEnableSkull
	bmi SkipCollision_Rts
	;↓通過↓
SkipCollision_SkipDamage: ;このオブジェクトの被弾処理をスキップ
	pla
	pla
	jmp $81B2 ;ロックマンへのダメージ判定のみ
SkipCollision_Rts:
	rts
SkipCollision:
	pla
	pla
	jmp $8052
