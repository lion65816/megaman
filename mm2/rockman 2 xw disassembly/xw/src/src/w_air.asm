
C_Air_Amp      = 10
C_Air_T        = 12

; y     = - a ( x - T/4 ) ^ 2 + C_Air_Amp
; dy/dx = - 2 a ( x - T/4 )
; (d/dx)^2 y = - 2 a
; (x,y) = (0,0)  =>  a = - C_Air_Amp / ( T / 4 )^2

C_Air_a_100    = -$100*C_Air_Amp/(C_Air_T/4)/(C_Air_T/4)
C_Air_Vy0_100  = 2*C_Air_a_100*(C_Air_T/4)


;������z�u�ݒ�
	BANKORG_D $1ED44C+$2 ;�^�C�v
	BANKORG_D $1ED45E+$2 ;�t���O
	BANKORG_D $1ED470+$2 ;�z�u��x
	BANKORG_D $1ED482+$2 ;Vxlo
	.db $80
	BANKORG_D $1ED494+$2 ;Vxhi
	.db $00
	BANKORG_D $1ED4A6+$2 ;Vylo
	.db $00
	BANKORG_D $1ED4B8+$2 ;Vyhi
	.db $00
	BANKORG_D $1ED4CA+$2 ;����T�C�Y

;���_���[�W
;�E�{�X
	BANKORG_D $17A93F
	.db 10 ;4�q�[�g
	.db  3 ;2�G�A�[
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
	.db  1 ;2���C���[�}�V��
	.db  2 ;1�G�C���A��




