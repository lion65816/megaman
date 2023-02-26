SPRITE_FIX_PRE:

	BANKORG_D $1ECCB7
	jsr SETUP_GAUGE_SPRITE_INIT
	BANKORG_D $1ECCBD
	jsr SETUP_GAUGE_SPRITE_INIT
	BANKORG_D $1ECD4B
	jsr SETUP_GAUGE_SPRITE_INIT
	BANKORG_D $1ECD51
	jsr SETUP_GAUGE_SPRITE_INIT

	BANKORG_D $1ECE28
	jmp DELETE_OBJX_CLC_RTS

	BANKORG_D $1ECF3A
	jmp DELETE_OBJX_CLC_RTS
	
	BANKORG_D $1ECE70
	jmp CANCEL_SPRITE_SETUP
	
	BANKORG_D $1ECEE8
	beq $CEF2




	BANKORG SPRITE_FIX_PRE



DELETE_OBJX_CLC_RTS:
	lsr $0420,x
	clc
	rts

CANCEL_SPRITE_SETUP:
	;�Ō�̃X�v���C�g�̃A�g���r���[�g�B
	;����ȏ�ԂȂ�F8�͖��g�p���ȊO�ɂ͂Ȃ�Ȃ�
	lda $02FE
	cmp #$F8
	bne .canceled
	lda $8400,y
	jmp $CE73
.canceled
	jmp $CEF2

SETUP_GAUGE_SPRITE_INIT:
	lda $02FE
	cmp #$F8
	beq .NormalProc
	lda <$06
	bne .NormalProc
	jmp $CFE0
.NormalProc
	jmp $CF5A
