;������z�u�ݒ�
	BANKORG_D $1ED44C+$6 ;�^�C�v
	BANKORG_D $1ED45E+$6 ;�t���O
	.db $81
	BANKORG_D $1ED470+$6 ;�z�u��x
	BANKORG_D $1ED482+$6 ;Vxlo
	.db $00
	BANKORG_D $1ED494+$6 ;Vxhi
	.db $04
	BANKORG_D $1ED4A6+$6 ;Vylo
	.db $00
	BANKORG_D $1ED4B8+$6 ;Vyhi
	.db $00
	BANKORG_D $1ED4CA+$6 ;����T�C�Y

;����
	BANKORG_D $1ED44C+$C ;�^�C�v
	BANKORG_D $1ED45E+$C ;�t���O
	BANKORG_D $1ED470+$C ;�z�u��x
	BANKORG_D $1ED482+$C ;Vxlo
	.db $00
	BANKORG_D $1ED494+$C ;Vxhi
	.db $04
	BANKORG_D $1ED4A6+$C ;Vylo
	.db $00
	BANKORG_D $1ED4B8+$C ;Vyhi
	.db $00
	BANKORG_D $1ED4CA+$C ;����T�C�Y
;���{�X�ւ̃_���[�W����
	;�������Ă����ł��邾��
	BANKORG_D $17A847
	bne $A893
	BANKORG_D $17A850
	beq $A893
	BANKORG_D $17A876
	.db 0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0
	BANKORG_D $17A893
	lsr A_ObjFlag,x ;���E�H�H�e�d����
;���U�R�ւ̃_���[�W����
	BANKORG_D $1FE8A0
	bne $E8F1
	BANKORG_D $1FE8AB
	beq $E8F1
	BANKORG_D $1FE8D4
	.db 0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0
	BANKORG_D $1FE8F1
	lsr A_ObjFlag,x ;���E�H�H�e�d����

;���_���[�W
;�E�{�X
	BANKORG_D $17A977
	.db  5 ;4�q�[�g
	.db  7 ;2*�G�A�[
	.db  2 ;1�E�b�h
	.db  3 ;2�o�u��
	.db  4 ;3�N�C�b�N
	.db  3 ;2�t���b�V��
	.db  2 ;1���^��
	.db  4 ;3�N���b�V��
	.db  1 ;1���J�h���S��
	.db  0 ;0�_�~�[�H
	.db  1 ;1�K�b�c�^���N
	.db  0 ;0�_�~�[�H
	.db  6 ;2*���C���[�}�V��
	.db  1 ;1�G�C���A��
;���C���[�}�V���̃J�o�[�E���O�͒e��
	BANKORG_D $169A1D+1
	.db 8
	BANKORG_D $169A21+1
	.db $FF ;���łɒe���Q��ނ̂�����𖳌���
;�E�U�R
	BANKORG_D $1FEC4A+$6D
	.db  0 ;�u�[�r�[��

;���X�v���C�g�A�j���[�V����
	BANKORG_D $1FFBD8+0
	.db 3
	.db 1


