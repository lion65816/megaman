;���萔
C_Quick_V = $04 ;����


;������z�u�ݒ�
	BANKORG_D $1ED44C+$5 ;�^�C�v
	BANKORG_D $1ED45E+$5 ;�t���O
	BANKORG_D $1ED470+$5 ;�z�u��x
	BANKORG_D $1ED482+$5 ;Vxlo
	.db $00
	BANKORG_D $1ED494+$5 ;Vxhi
	.db C_Quick_V
	BANKORG_D $1ED4A6+$5 ;Vylo
	.db $E0 ;�����ɉ��Ɉړ����邱�ƂŁA������ۂ��߂苓���ɂȂ�
	BANKORG_D $1ED4B8+$5 ;Vyhi
	.db $FF
	BANKORG_D $1ED4CA+$5 ;����T�C�Y


;���_���[�W
;�E�{�X
	BANKORG_D $17A969
	.db  5 ;4�q�[�g
	.db  3 ;2�G�A�[
	.db  2 ;1�E�b�h
	.db  3 ;2�o�u��
	.db  4 ;3�N�C�b�N
	.db  3 ;2�t���b�V��
	.db  2 ;1���^��
	.db 10 ;3*�N���b�V��
	.db  1 ;1���J�h���S��
	.db  0 ;0�_�~�[�H
	.db  3 ;1*�K�b�c�^���N
	.db  0 ;0�_�~�[�H
	.db  3 ;2���C���[�}�V��
	.db  1 ;1�G�C���A��

