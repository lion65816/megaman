DisableCollision_Org:

DisableCollision_Tmp .macro
	BANKORG_D ($1C86C3+\1)
	.db \2
	BANKORG_D ($1C88C3+\1)
	TRASH_GLOBAL_LABEL
	DB_ADDRLHSPLIT \3,$D0
	.endm

	DisableCollision_Tmp $00,$1D,SkipCollision;����
	DisableCollision_Tmp $01,$1D,SkipCollision;�_�~�[/����_��0/Spr12
	DisableCollision_Tmp $1E,$1D,SkipCollision;�E�F�[�u�X�e�[�W����o�C�N�I��
	DisableCollision_Tmp $6D,$1D,SkipCollision;�`���[�W�}���̉��G�t�F�N�g/�k�ʓ�
;	DisableCollision_Tmp $71,$1D,SkipCollision;�r�b�O�y�b�c�̋���(���˗p)

;	DisableCollision_Tmp $C9,$1D,SkipCollision;
;	DisableCollision_Tmp $CA,$1D,SkipCollision;
;	DisableCollision_Tmp $CB,$1D,SkipCollision;
;	DisableCollision_Tmp $CC,$1D,SkipCollision;
;	DisableCollision_Tmp $CD,$1D,SkipCollision;
;	DisableCollision_Tmp $CE,$1D,SkipCollision;
;	DisableCollision_Tmp $CF,$1D,SkipCollision;

;	DisableCollision_Tmp $43,$03,SkipCollision;(�_�~�[/����_��0/Spr12)

	;��03(�e�B�E��)
	BANKORG_D $1DB86D
	bne $B872
	jmp SkipCollision
	;��04(�`���[�W�X�e�[�W��Ԃɓ���)
	BANKORG_D $0AA676
	jsr SkipCollision_TestCollision_Rts
	bit <$00
	;��05(�E�F�[�u�X�e�[�W�p�C�v�̓����)
	BANKORG_D $0AA69F
	jsr SkipCollision_TestCollision_Rts
	bit <$00
	;��06(�d�͔��]��|�������O)/07(�d�͔��]��|���V���[�g)
	BANKORG_D $05A000
	jsr SkipCollision_TestCollision_Rts
	bit <$00
	;��08(�d�͔��]��/�������O)
	BANKORG_D $05A035
	jsr SkipCollision_TestCollision_Rts
	bit <$00
	;��09(�X�^�[�X�e�[�W�㉺����}�l�[�W��)
	BANKORG_D $05A078
	lda #$7F
	BANKORG_D $05A07D
	bit <$00
	jsr DisableCollision_SetReturnPoint
;��0A(�W���C���X�e�[�W�G���x�[�^�P)
;��0B(�W���C���X�e�[�W�G���x�[�^�Q)
	;��0C(�W���C���X�e�[�W������)
	BANKORG_D $05A1D1
	jmp DisableCollision_0C
	;��0D(�E�F�[�u�X�e�[�W���V�A)
	BANKORG_D $05A238
	lda #$3F
	BANKORG_D $05A23D
	bit <$00
	jsr DisableCollision_SetReturnPoint
	BANKORG_D $05A2A4
	lda #$AB
	BANKORG_D $05A2A9
	bit <$00
	jsr DisableCollision_SetReturnPoint
;��0E(�E�F�[�u�X�e�[�W�A�}�l�[�W��)
;��0F(�v���X�̎d�|���}�l�[�W��)
;��22(�G�f�B)
	;��23(�e�b�L���[��)
	BANKORG_D $1C9631
	jmp DisableCollision_58
	;��24(�~�U�C���̃W�F�l���[�^)
	DisableCollision_Tmp $24,$1D,DisableCollision_24
	;��2C(�^�e�p�b�J���̒e)
	DisableCollision_Tmp $2C,$1D,SkipCollision_Bullet_MoveX
	;��2E(�_�C�_�C��)
	BANKORG_D $1C9660
	lda #LOW (DisableCollision_2E)
	BANKORG_D $1C9665
	lda #HIGH(DisableCollision_2E)
;��30(�������~�T�}�l�[�W��)
	;��37(���C�_�[�W���[�̒e)
	DisableCollision_Tmp $37,$1D,SkipCollision_Bullet_MoveX
;��38(覐΃}�l�[�W��)
	;��3C(�o�E���_�[�̒e)
	DisableCollision_Tmp $3C,$1D,SkipCollision_Bullet_MoveXY
	;��3F(�g�X�}�V�[���̒e)
	BANKORG_D $1DA0B5
	jmp SkipCollision_Bullet_MoveX
;��41(�`���[�W�X�e�[�W�̃��X�^�[�}�l�[�W��)
;��42(�E�F�[�u�X�e�[�W����o�C�N��荞��)
	;��47(���C���[�J�v�Z���̗����e)
;	DisableCollision_Tmp $47,$04,DisableCollision_47
	BANKORG_D $04A540
	bcs $A54D
	BANKORG_D $04A545
	lda #$4A
	BANKORG_D $04A54A
	jmp SkipCollision_Bullet_MoveX
	jmp SkipCollision_Bullet
	;��48(�X�^�[�X�e�[�W�㉺����)
	BANKORG_D $05A525
	lda #$2C
	BANKORG_D $05A52A
	bit <$00
	jsr DisableCollision_SetReturnPoint
;��49(�u���[�X�S�̏c�X�N���[���}�l�[�W��)
;��4A(�u���[�X�R�̓�����(����))
;��4B(�u���[�X�R�̓�����(����))
;��4D(�{�X���j��e�B�E���z��)
	;��4E(�I�N�g�p�[�̒e)
	DisableCollision_Tmp $4E,$1D,DisableCollision_4E7F
	;��51(���b�g�[���}�~�[�̒e)
	DisableCollision_Tmp $51,$1D,DisableCollision_MoveXY_Stone
	;��55(�^�o��/���b�g�[��K-1000/�A�p�b�`�W���[/�g���f�I�[���̒e)
	DisableCollision_Tmp $55,$1D,DisableCollision_MoveXY_Stone
;��57(�G�f�B�̓������A�C�e��)
	;��58(�f�X�[�W�[�̒e)
	DisableCollision_Tmp $58,$1D,SkipCollision_Bullet_MoveX
	;��5B(�W�F�b�g�{���̔j��)
	DisableCollision_Tmp $5B,$1D,DisableCollision_5B
	;��5E(���b�N�X���[���̊�̔j��)
	DisableCollision_Tmp $5E,$1D,SkipCollision_SkipDamage
	;��61(�a�r�b�^�[�̒e)
	DisableCollision_Tmp $61,$1D,SkipCollision_Bullet_MoveXY
	;��6A(�X�g�[���}���̃p���[�X�g�[��)
	BANKORG_D $06A19E
	bcc DisableCollision_6A
	BANKORG_D $06A1A5
	bne $A1AA
DisableCollision_6A:
	jmp SkipCollision_Bullet
	BANKORG_D $06A1D2
	bne DisableCollision_6A
	BANKORG_D $06A1EE
	jmp DisableCollision_6A_2

	;��6C(�`���[�W�}���̏��C)
	DisableCollision_Tmp $6C,$06,DisableCollision_6C
	BANKORG_D $06A425
	lda #LOW (DisableCollision_6C_2)
	BANKORG_D $06A42A
	lda #HIGH(DisableCollision_6C_2)
	;��6F(�W���C���}���̃W���C���A�^�b�N1)
	BANKORG_D $06A5E3
	bcc DisableCollision_80
	BANKORG_D $06A5EA
	bcs DisableCollision_80
	BANKORG_D $06A61C
	jmp SkipCollision_Bullet_MoveY
;�H7A(�r�b�O�y�b�c�̓��̕�)
	;�o���Ȃ��͂Ȃ������Ȃ̂�����ς����Ȃ̂ŏȗ�
	;��7D(�T�[�N�����O�p�X�̃��t�g)
	BANKORG_D $02A542
	bcs DisableCollision_7D
	BANKORG_D $02A581
	bne DisableCollision_7D
	BANKORG_D $02A592
	beq DisableCollision_7D
	BANKORG_D $02A59E
DisableCollision_7D:
	jmp SkipCollision
	;��7E(�T�[�N�����O�p�X�̑�e)
	BANKORG_D $02A536
	jmp SkipCollision_Bullet_MoveX
	;��7F(�T�[�N�����O�p�X�̃v�`�e)
	DisableCollision_Tmp $7F,$1D,DisableCollision_4E7F
	;��80(�W���C���}���̃W���C���A�^�b�N2)
	BANKORG_D $06A629
	bcc DisableCollision_80
	BANKORG_D $06A635
	bne $A63A
DisableCollision_80:
	jmp SkipCollision_Bullet
	BANKORG_D $06A642
	bne DisableCollision_80
	BANKORG_D $06A647
	jmp SkipCollision_Bullet_MoveX
	;��82(�O���r�e�B�[�}���̒e)
	DisableCollision_Tmp $82,$07,SkipCollision_Bullet_MoveXY
	;��84(�N���X�^���}���̔��˃N���X�^��)
	DisableCollision_Tmp $84,$07,DisableCollision_84
	;��85(�N���X�^���}���̒e)
	DisableCollision_Tmp $85,$07,SkipCollision_Bullet_MoveXY
	;��87(�E�F�[�u�}���̃���)
	DisableCollision_Tmp $87,$07,SkipCollision_Bullet_MoveX
	;��8A(�i�p�[���}���̃~�T�C��)
	DisableCollision_Tmp $8A,$08,DisableCollision_8A
	;��8B(�i�p�[���}���̃i�p�[���{��)
	DisableCollision_Tmp $8B,$08,DisableCollision_8B
	;��94(�_�[�N�}���R�̒e)
	DisableCollision_Tmp $94,$09,SkipCollision_Bullet_MoveXY
	;��95(�_�[�N�}���R�̐Ή��e)
	;94/97���ړ������ċ󂢂�������q��
	BANKORG_D $09A2CE
DisableCollision_95:
	lda #HIGH(SkipCollision_Bullet-1)
	pha
	lda #LOW (SkipCollision_Bullet-1)
	pha
	DisableCollision_Tmp $95,$09,DisableCollision_95
	;��97(�_�[�N�}���P�̒e)
	DisableCollision_Tmp $97,$09,DisableCollision_MoveXY_Stone2
	;��9A(�_�[�N�}���S�̒e)
	DisableCollision_Tmp $9A,$09,SkipCollision_Bullet_MoveX
	;��9B(�c�C���L���m���̒e�P)
	DisableCollision_Tmp $9B,$1D,SkipCollision_Bullet_MoveXY
	;��9D(�_�`���[���̃��[�U�[)
	DisableCollision_Tmp $9D,$1D,SkipCollision_Bullet_MoveXY
;	;��9F(���b�g�[���X�C���̒e)
	DisableCollision_Tmp $9F,$1D,DisableCollision_MoveXY_Stone
;��A2(�U�u���[�X)
;��A3(�C�x���g�̒e)
;��A4(�u���[�X)
	;��A6(���C���[�}�V���T�z���U��)
	DisableCollision_Tmp $A6,$04,DisableCollision_A6
	;��A7(���C���[�}�V���T�o�E���h�e)
	DisableCollision_Tmp $A7,$04,DisableCollision_A7
	;��A8(���C���[�}�V���T�~�T�C��)
	DisableCollision_Tmp $A8,$04,DisableCollision_A8
;��A9(���C���[�}�V���T����ً}�E�o���郏�C���[)
	;��AB(���C���[�J�v�Z���̉�]�e)
	BANKORG_D $04A52B
	dec oVal0,x
	jmp SkipCollision_Bullet_MoveXY
;��AF(���[�v�J�v�Z��)
;��B0(�{�X���b�V���̃��C�t��)
	;��B6(�ݒu���ꂽ�A�C�e��)/��B7(�h���b�v�A�C�e��)
	BANKORG_D $1DAE42
	jmp DisableCollision_B6B7
	;��B8(�U�R���j����)
	BANKORG_D $1DAE5C
	jmp DisableCollision_B8
;��BB(���o�����H)
;�E�F�[�u�}���̃E�H�[�^�[�E�F�[�u�Ɠ������[�`���H
	;��BF(���b�g�[���X�C���̐��A)
	;����X�L�b�v�ɂ��œK���ȊO���܂�ł��邪�ׂ������Ƃ͋C�ɂ��Ȃ�
	DisableCollision_Tmp $BF,$1D,DisableCollision_BF

	BANKORG DisableCollision_Org
