;������z�u�ݒ�
	BANKORG_D $1ED44C+$1 ;�^�C�v
	BANKORG_D $1ED45E+$1 ;�t���O
	BANKORG_D $1ED470+$1 ;�z�u��x
	.db $10
	BANKORG_D $1ED482+$1 ;Vxlo
	.db $00
	BANKORG_D $1ED494+$1 ;Vxhi
	.db $08
	BANKORG_D $1ED4A6+$1 ;Vylo
	BANKORG_D $1ED4B8+$1 ;Vyhi
	BANKORG_D $1ED4CA+$1 ;����T�C�Y


;���U�R�ւ̃_���[�W����
;�^�C���X�g�b�p�[�Ƌ��ʂɂ��܂�
	BANKORG_D $1FE6B1
	lda <V_CurWeapon
	lsr a
	;H:1 F:6
	bcs $E6BA
	bcc $E6C0
;	;�����t���b�V�����i�q�b�g�̂��߂ɖ��G�����𖳌���
;	BANKORG_D $1FE6DD
;	bne $E6E5
;	beq $E6E5

;���{�X�ւ̃_���[�W����
;�^�C���X�g�b�p�[�H�̂��߂Ƀ`�}�`�}�������C��
	;��ʂ̃_���[�W�̂ݎQ�Ƃ���
	BANKORG_D $17A66C
	jmp $A68A

;���u�X�N���[�����ɏ����Ȃ��v�𖳌���
	BANKORG_D $1C9228+1
	.db $FF

;���X�v���C�g�A�j���[�V����
	BANKORG_D $1FFBDF+1
	.db 0
	.db $2F,$4E,$4D,$50,$4F,$52,$51,$00

;���_���[�W
;�Z�̐��������܂�ɕς���Ă��邽�߁A�S�̓I�ɏC��
;�E�{�X
	BANKORG_D $17A931
	.db $FF;4�q�[�g
	.db  3 ;2�G�A�[
	.db  2 ;1�E�b�h
	.db  3 ;2�o�u��
	.db  4 ;3�N�C�b�N
	.db  8 ;2*�t���b�V��
	.db  2 ;1���^��
	.db  4 ;3�N���b�V��
	.db  1 ;1���J�h���S��
	.db  0 ;0�_�~�[�H
	.db  1 ;1�K�b�c�^���N
	.db  0 ;0�_�~�[�H
	.db  3 ;2*���C���[�}�V��
	.db  0 ;1�G�C���A��
;�E�U�R
	BANKORG_D $1FE9F2
	.db 20 ;00�V�������N
	.db 20 ;�V�������N�H
	.db  0 ;
	.db  0 ;
	.db 20 ;M-445
	.db  0 ;
	.db 20 ;���j����(�Ȃ����_���[�W�w�肪����)
	.db  0 ;

	.db 20 ;�N���E
	.db  0 ;
	.db  5 ;�^�j�b�V�[
	.db 10 ;�^�j�b�V�[�̊k
	.db  3 ;�P���b�O
	.db 20 ;�q�P���b�O
	.db  0 ;
	.db  2 ;�A���R

	.db  0 ;10
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db 10 ;�o�b�g��
	.db  5 ;���r�b�g

	.db  0 ;
	.db  1 ;�t�����_�[
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  7 ;�����L���O
	.db  0 ;
	.db 10 ;�N�b�N

	.db  0 ;20
	.db  0 ;
	.db 20 ;�e���[
	.db  0 ;�`�����L�[���[�J�[
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;
	.db  5 ;�s�G���{�b�g�̃M�A
	.db 20 ;�s�G���{�b�g�̖{��
	.db  0 ;
	.db  7 ;�t���C�{�[�C
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;30�v���X
	.db 10 ;�u���b�L�[
	.db  0 ;
	.db  0 ;
	.db 20 ;���b�g�[��
	.db  0 ;
	.db  5 ;�}�^�T�u���E
	.db  0 ;

	.db 20 ;�s�s
	.db  0 ;
	.db 20 ;�s�s�̃^�}�S
	.db 20 ;�s�s�̗��̊k(�Ȃ����_���[�W�w�肪����)
	.db 20 ;�q�s�s
	.db  5 ;�J�~�i���S���[(�{��)
	.db  0 ;
	.db  0 ;

	.db  0 ;40
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db 20 ;�v�`�S�u����
	.db  1 ;�X�v�����K�[
	.db  0 ;

	.db  7 ;���[��
	.db  7 ;���[��
	.db  0 ;
	.db  5 ;�V���b�g�}��
	.db  5 ;�V���b�g�}��
	.db  0 ;
	.db  1 ;�X�i�C�p�[�A�[�}�[
	.db  2 ;�X�i�C�p�[�W���[

	.db  5 ;50�X�N���[���̃W�F�l���[�^
	.db 10 ;�X�N���[��
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;60
	.db  0 ;���[�t�V�[���h
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;
	.db  0 ;
	.db  2 ;�s�R�s�R
	.db  0 ;
	.db  0 ;
	.db  1 ;�u�[�r�[��
	.db  0 ;
	.db  0 ;

	.db  0 ;70
	.db  1 ;�r�b�O�t�B�b�V��
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
