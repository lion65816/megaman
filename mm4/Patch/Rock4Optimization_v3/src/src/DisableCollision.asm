DisableCollision_Org:

DisableCollision_Tmp .macro
	BANKORG_D ($3A8683+\1-$D0)
	.db \2
	BANKORG_D ($3A8683+\1)
	TRASH_GLOBAL_LABEL
	DB_ADDRLHSPLIT \3,$D0
	.endm




	;��00(����)��
	DisableCollision_Tmp $00,$3B,SkipCollision;����
	DisableCollision_Tmp $01,$3B,SkipCollision;�C���C����������Obj
	DisableCollision_Tmp $60,$3B,SkipCollision;�u���C�g�}���r�Èłł������鏰/�u�[���u���b�N
	DisableCollision_Tmp $80,$3B,SkipCollision;�G�t�F�N�g�S��
;	DisableCollision_Tmp $81,$3B,SkipCollision;�X�J���}���̃X�J���o���A/�C�x���g�V�[���_�~�[
	DisableCollision_Tmp $CC,$38,SkipCollision;�h�����}���̐��s���̉�
	;��26�J�o�g���L���[�̑����
	DisableCollision_Tmp $26,$3B,SkipCollision;�J�o�g���L���[����P����
;	DisableCollision_Tmp $28,$3B,SkipCollision;�h�����{���ŉ󂹂��
;	DisableCollision_Tmp $67,$3B,SkipCollision;���b�g�[���_�f�B�̈ꕔ�H
	DisableCollision_Tmp $99,$3D,SkipCollision;�X�N�G�A�}�V���̕�
;	DisableCollision_Tmp $AC,$3B,SkipCollision;�^�R�g���b�V���̈ꕔ
;	DisableCollision_Tmp $BB,$3B,SkipCollision;���C���[�}�V���̈ꕔ
;	DisableCollision_Tmp $CD,$3B,SkipCollision;�G�X�J���[�̈ꕔ
	;12(�z�o�[)
	;��39(�z�o�[�̒e)
	DisableCollision_Tmp $39,BANK(SkipCollision_Bullet_MoveX),SkipCollision_Bullet_MoveX
	;��15(�T�\���[�k�W�F�l���[�^)
	BANKORG_D $3A93BC
	TRASH_GLOBAL_LABEL
	lda oVal0,x
	bne .NotDecTimerhi
	dec oVal1,x
.NotDecTimerhi
	dec oVal0,x
	lda oVal1,x
	beq $93CF
	jmp SkipCollision
	END_BOUNDARY_TEST $3A93CF
	;16(�o�b�^��)
	;��1B(�E�H�[���u���X�^�[�̒e)
	BANKORG_D $3A9925
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;��1E(�P�O�O���b�g���e)
	BANKORG_D $3A9A70
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;32(���b�p�[���􂵂���)
	;��34(�n�G�n�G�[�̒e)
	DisableCollision_Tmp $34,$3B,SkipCollision_Bullet_MoveY
	;C8(�h���p���̉ԉ΃W�F�l���[�^�[)
	;38(�h���p���̉ԉ�)
	;40(���΃W�F�l���[�^)
	;42(�G�f�B)
	;43(���̏�G�f�B)
	;44(�G�f�B�̃A�C�e��)
	;��4F(�g�[�e���|�[�����̒e)
	DisableCollision_Tmp $4F,$3B,SkipCollision_Bullet_MoveX
	;��51(���b�g�[���̒e) ���_���[�W�ݒ��X�J���o���A�[�ŏ����܂���
	BANKORG_D $3BA6CD
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;��66(���b�g�[���X�C���̐��A)
	DisableCollision_Tmp $66,$3B,DisableCollision_66
	;��63(�X�P���g���W���[�̓����鍜)
	BANKORG_D $3BABCF
	jsr rYmoveG
	jmp SkipCollision_Bullet_MoveX
	;��6A(�X�J�����b�g�̒e)
	BANKORG_D $3BAD6A
	jsr rYmoveG
	jmp SkipCollision_Bullet_MoveX
	;��6E(�w���|���̒e)
	DisableCollision_Tmp $6E,$3B,SkipCollision_Bullet_MoveX
	;��9B(�}�~�[���̓�������)
	BANKORG_D $3BB29D
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;��A8(�K�`���b�|���̒��i�e)
	DisableCollision_Tmp $A8,$3B,SkipCollision_Bullet_MoveX
	;��A9(�K�`���b�|���̕����e)
	BANKORG_D $3BB592
	jsr rYmoveG
	jmp SkipCollision_Bullet_MoveX
	;��B1(�p�J�b�g24�̒e)
	DisableCollision_Tmp $B1,$3B,SkipCollision_Bullet_MoveX
	;B4(�A�b�v���_�E���̃W�F�l���[�^)
	;BD(�g�Q�w���W�F�l���[�^(�E�[�ɔz�u))
	;CE(�g�Q�w���W�F�l���[�^(���[�ɔz�u))
	;��B5(�j�u���b�N)
	BANKORG_D $3BB9EC
	jmp DisableCollision_B5
	;��9D(���j�������A�C�e��)
	BANKORG_D $3BBBE5
	jmp DisableCollision_9D
	;��C2(���C���[/�o���[��)C1(�u���Ă���A�C�e��)
	BANKORG_D $3BBC54
	jmp DisableCollision_C1
	;C6(��������A�C�e��?)�i�����Ԃ񖢎g�p�j
	;���^�C�v20(�����OS������1)�~4
	BANKORG_D $3DA01B
	jmp DisableCollision_20_1
	BANKORG_D $3DA0C0+1
	.db LOW (DisableCollision_20_2)
	BANKORG_D $3DA0C5+1
	.db HIGH(DisableCollision_20_2)
	BANKORG_D $3DA167+1
	.db LOW (DisableCollision_20_3)
	BANKORG_D $3DA16C+1
	.db HIGH(DisableCollision_20_3)
	
	;90(���r�[�̎n���W)
	;2D(�G�X�J���[���j����)
	;3A(���b�p�[���j����)
	;��2E(�e�B�E��)
	BANKORG_D $3DA904
	TRASH_GLOBAL_LABEL
	bne .Delete
	jmp SkipCollision
.Delete
	jmp rDeleteObjX
	END_BOUNDARY_TEST $3DA90D
	;2F(�u���C�gS�̃��t�g(�Г�))
	;C9(�u���C�gS�̃��t�g(����))
	;4B(�J�o�g���L���[�̎n���W)
	;4C(�P�O�O���b�g�����j��)
	;57(�h����S�̃��o�[���g�p�d�|��1)�~�S
	;5B(�h����S�̃��o�[)
	;5E(�_�X�gS�v���X�}�l�[�W��)
	;6B(�_�C�uS���ʃ}�l�[�W��1)
	;6C(�_�C�uS���ʃ}�l�[�W��2)
	;��CF(�_�C�uS���ʕϓ��n�т̃g�Q)
	BANKORG_D $3DAFAC
	jmp DisableCollision_CF
	;��6F(���b�N�}�������ɔ�э��񂾂Ƃ��̐����Ԃ�)
	BANKORG_D $3DAFB3
	jmp DisableCollision_6F
	;73(�_�X�gS�g�݂����鑫��)
	;��74(�_�X�gS�g�݂����鑫��̒f��)
	BANKORG_D $3DB033
	jmp DisableCollision_74
	BANKORG_D $3DB084+1
	.db LOW (DisableCollision_74_2)
	BANKORG_D $3DB089+1
	.db HIGH(DisableCollision_74_2)
	BANKORG_D $3DB0C0+1
	.db LOW (DisableCollision_74_3)
	BANKORG_D $3DB0C5+1
	.db HIGH(DisableCollision_74_3)
	;��8A(���X���[���̒e)
	BANKORG_D $3DB5C8
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;��88(���X���[���̈ꕔ)
	DisableCollision_Tmp $88,$3D,SkipCollision_SkipDamage
	;��89(���X���[���̈ꕔ)
	DisableCollision_Tmp $89,$3D,SkipCollision_SkipDamage
	;��93(�R�T�b�N�L���b�`���[�̃A�[��)
	DisableCollision_Tmp $93,$3D,SkipCollision
	;��94(�R�T�b�N�L���b�`���[�̒e)97(�X�N�G�A�}�V���̒e)
	BANKORG_D $3DBA90
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;96(�X�N�G�A�}�V���̃��t�g)
	BANKORG_D $3DBD7A+1
	.db LOW (DisableCollision_96)
	BANKORG_D $3DBD7F+1
	.db HIGH(DisableCollision_96)

	;AE(�^�R�g���b�V���̉�)
	;AF(�^�R�g���b�V���̃��t�g)
	;B3(���[�v�J�v�Z��)
	;29(���X���[��/�X�N�G�A�}�V��/���b�g�[���_�f�B/�^�R�g���b�V�����j����)
	;BF(���C���[�}�V���̖C��)
	;2A(�W�{�X���j��̃e�B�E���z��)4D(���C���[�J�v�Z���̎����e)
	;49(�R�b�N���[�`�c�C���P�C�ڂ̎n���W)
	;4A(�R�b�N���[�`�c�C���Q�C�ڂ̎n���W)
	;45(�R�b�N���[�`�c�C���̑���)
	;5D(�R�T�b�N3�̏o����)
	;C3(�u�[���u���b�N�}�l�[�W��)
	;C5(�����e�̎���)
	;��72(�X�J���}���̒e)
	BANKORG_D $38AA64
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;76(�����O�}���̃����O�u�[������)
	;7A(�_�X�g�}���̃_�X�g�N���b�V���[�����O)
	;7B(�_�X�g�}���̃_�X�g�N���b�V���[�����)
	;82(�h�����}���̉��}�l�[�W��)
	;��85(�t�@���I�E�F�[�u)
	DisableCollision_Tmp $85,$3B,SkipCollision_Bullet_MoveX
	;��86(�t�@���I�V���b�g) ���㉺�ɂ͂ݏo���������鏈�����Ȃ��Ȃ��Ă��邯�Ǖʂɖ��͂Ȃ����낤
	BANKORG_D $38B52E
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;��8C(�u���C�g�}���̒e)
	BANKORG_D $38B718
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;��9F(�R�b�N���[�`�c�C���Q�̑�e)A0(�R�b�N���[�`�c�C���P�E�Q�̒e)
	BANKORG_D $38BC62
	TRASH_GLOBAL_LABEL
	lda oYhe,x
	beq .NotSuicide
	jmp rDeleteObjX
.NotSuicide
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	END_BOUNDARY_TEST $38BC71

	BANKORG DisableCollision_Org
