SkipCollision_Bullet_MoveY:
	jsr rYpmeVy
	jmp SkipCollision_Bullet
SkipCollision_Bullet_MoveXY:
	jsr rYpmeVy
SkipCollision_Bullet_MoveX:
	jsr rXpmeVx
	;↓通過↓
SkipCollision_Bullet:
	bit vEnableEraser
	bmi SkipCollision_Rts
	;↓通過↓
SkipCollision_SkipDamage: ;このオブジェクトの被弾処理をスキップ
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
	;↓通過↓
SkipCollision:
	pla
	pla
	jmp $8039
DisableCollision_SetEraseFlag:
	ldy #$00
	lda <vCurWeapon
	and #$07
	cmp #$01 ;1:ウォーターウェーブ 9:スタークラッシュ
	bne .NotEraserable
	dey
.NotEraserable
	sty vEnableEraser
	rts

DisableCollision_0C:
	jsr DisableCollision_SetReturnPoint
	lda oXhi,x
	jmp $A1D4
;スタックを操作してでも判定を飛ばす(スタック操作自体重いが、元は取れる)
;あまり書き換えるスペースが確保できない時に利用
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
