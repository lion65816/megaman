VITAL_GAUGE_ADDR_PRE:
	;�\��
	BANKORG_D $1ECFA1
	jmp VITAL_GAUGE_EX
	;�{�X�̗͔{��
	BANKORG_D $168117+1
	.db 28*2
	;�Q�[�W���x�t�o
	BANKORG_D $168131+1
	.db 1
	;�񕜎��ɏ������ޒl
	BANKORG_D $17A903+1
	.db 28*2

	;�g�o�{��
	BANKORG_D $169029+1
	.db 28*2
	BANKORG_D $169232+1
;	.db 28*2 ;�s�R�s�R
	BANKORG_D $169682+1
;	.db 28*2 ;�u�[�r�[��
	BANKORG_D $16977A+1
	.db 28*2
	BANKORG_D $16996A+1
	.db 28*2
	BANKORG_D $169BF3+1
	.db 28*2

	BANKORG_D $17A11A+1
	.db 1
	BANKORG_D $17A121+1
	.db 28*2

	BANKORG VITAL_GAUGE_ADDR_PRE
VITAL_GAUGE_EX:
;	ldy #$28
;	lda <$00
;	cmp #29
;	bcc .NormalPosition
;	ldy #$28+8
;	;sec
;	sbc #28
;	sta <$00
;.NormalPosition
;	sty <$01
;	jmp $CFA1

	lda <$00
	cmp #29
	bcc .Normal
	;sec
	sbc #28
	sta <$00
	lda #$48
	sta $0200,x
	lda #$6A
	sta $0201,x
	lda #$01
	sta $0202,x
	lda #$30
	sta $0203,x
	inx
	inx
	inx
	inx
	stx <$06
	beq .SpriteOver
.Normal
	jmp $CFA5
.SpriteOver
	rts

