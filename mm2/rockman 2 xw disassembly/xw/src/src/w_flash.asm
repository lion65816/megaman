;������z�u�ݒ�
	BANKORG_D $1ED44C+$8 ;�^�C�v
	BANKORG_D $1ED45E+$8 ;�t���O
	.db $81
	BANKORG_D $1ED470+$8 ;�z�u��x
	.db $10-$09 ;���P�t���[���ڂɑ��镪
	BANKORG_D $1ED482+$8 ;Vxlo
	.db $00
	BANKORG_D $1ED494+$8 ;Vxhi
	.db $09
	BANKORG_D $1ED4A6+$8 ;Vylo
	BANKORG_D $1ED4B8+$8 ;Vyhi
	BANKORG_D $1ED4CA+$8 ;����T�C�Y

;���U�R�ւ̃_���[�W����
;�A�g�~�b�N�t�@�C���[�ɑ��荞�݂܂�
	BANKORG_D $1FE964+6
	.db LOW ($E6A4)
	BANKORG_D $1FE96D+6
	.db HIGH($E6A4)

;������ƃR�[�f�B���O
	BANKORG_D $1FE6C0
	TRASH_GLOBAL_LABEL
	lda TABLE_DAMAGE_TO_1X_FLASH,y
	pha
	cpx #$02
	bne .no_splitting
	jsr WEAPON_FLASH_SPLITTING
.no_splitting
	pla
	beq $E6CE
;	jmp $E6CE
;	Addr<=1FE6CE


;�N�C�b�N�}���X�e�[�W�̃��[�U�[���������Ȃ����ȁ[���@�Ƃ������Ă݂��炵��
;	BANKORG_D $1C9CFE
;	.db $E3,$A3,$E3,$A3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3
;	.db $A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3
;	.db $A3,$E3,$A3,$A3,$A3,$A3,$E3,$E3,$A3,$A3,$A3,$A3,$A3,$A3,$A3,$E3
;	.db $A3,$A3,$E3,$A3

;���{�X�ւ̃_���[�W����
	BANKORG_D $17A911+6
	.db LOW (WEAPON_FLASH_DAMAGE_0X)
	BANKORG_D $17A91A+6
	.db HIGH(WEAPON_FLASH_DAMAGE_0X)

	BANKORG_D $17A66F
TABLE_DAMAGE_TO_0X_FLASH:
	.db  6 ;4�q�[�g
	.db  3 ;2�G�A�[
	.db  2 ;1�E�b�h
	.db  3 ;2�o�u��
	.db  4 ;3�N�C�b�N
	.db  3 ;2�t���b�V��
	.db  8 ;1���^��
	.db  4 ;3�N���b�V��
	.db  2 ;1���J�h���S��
	.db  0 ;0�_�~�[�H
	.db  2 ;1�K�b�c�^���N
	.db  0 ;0�_�~�[�H
	.db  5 ;2���C���[�}�V��
	.db  2 ;1�G�C���A��
WEAPON_FLASH_DAMAGE_0X:
	lda A_ObjFlag+1 ;���E�H�H�e�d����
	and #$08
	bne $A6B2
	ldy <$B3 ;�{�X�̎��
	lda TABLE_DAMAGE_TO_0X_FLASH,y
	nop
;	jmp $A68A

;	Addr<=17A68A

;���u�X�N���[�����ɏ����Ȃ��v�𖳌���
	BANKORG_D $1C9224+1
	.db $FF

;���A�j���[�V������`
	BANKORG_D $1FFC10
	.db 2,2
	.db $30,$31,$32,$33 ;���P������`���Ă���

;���X�v���C�gNo/Attr��`
	BANKORG_D $1489F8
SPRITE_NA_30:
	.db $01,$5B
	.db $9C,$01
SPRITE_NA_31:
	.db $01,$5B
	.db $9D,$01
SPRITE_NA_32:
	.db $01,$5B
	.db $9E,$01
SPRITE_NA_33:
	.db $01,$5B
	.db $9A,$01

;���X�v���C�g���ʒu��`
	BANKORG_D $15B470+2
SPRITE_POS_5B:
	.db $FC,$FC

;��`�����X�v���C�g���̃A�h���X�w��

	BANKORG_D $148000+$30
	.db LOW (SPRITE_NA_30)
	BANKORG_D $148200+$30
	.db HIGH(SPRITE_NA_30)
	BANKORG_D $148000+$31
	.db LOW (SPRITE_NA_31)
	BANKORG_D $148200+$31
	.db HIGH(SPRITE_NA_31)
	BANKORG_D $148000+$32
	.db LOW (SPRITE_NA_32)
	BANKORG_D $148200+$32
	.db HIGH(SPRITE_NA_32)
	BANKORG_D $148000+$33
	.db LOW (SPRITE_NA_33)
	BANKORG_D $148200+$33
	.db HIGH(SPRITE_NA_33)
	BANKORG_D $148400+ $5B
	.db LOW (SPRITE_POS_5B-2)
	BANKORG_D $148500+ $5B
	.db HIGH(SPRITE_POS_5B-2)
