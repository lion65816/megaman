	.inesprg $10 ;�v���O�����o���N��
	.ineschr $20 ;�L�����N�^�o���N��
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman5.prgchr"
	.include "mylib.asm"



	BANKORG_D $03A60A ;�I�N�g�p�[
	jmp BOSS_THROUGH_PROC

	BANKORG_D $04A166 ;���C���[�}�V���@���������������ǂ���������Ȃ����c�c
	jmp BOSS_THROUGH_PROC

;	BANKORG_D $0AA557 ;���[�����O�h�����@�X���[�����̕����ǂ����낤
;	jsr BOSS_THROUGH_PROC

	BANKORG_D $1C807F ;�u���̑��v
	jsr BOSS_THROUGH_PROC

	BANKORG_D $1C8AF0 ;�v�J�v�[�J�[�̃{�f�B
	jsr BOSS_THROUGH_PROC

	BANKORG_D $1C9525 ;�_�`���[��
	jmp BOSS_THROUGH_PROC

;	BANKORG_D $1DA4F5 ;�W�F�b�g�{���@�����炭�s�v
;	jsr BOSS_THROUGH_PROC

	BANKORG_D $1DA645 ;�R�b�R
	jsr BOSS_THROUGH_PROC

;	BANKORG_D $1DA7ED ;�����N���X�^���@�����炭�s�v
;	jsr BOSS_THROUGH_PROC

	BANKORG_D $1DAA11 ;���[�h�[��
	jmp BOSS_THROUGH_PROC





	;��~���̃��[�v�ʒu��������ƒ���
	BANKORG_D $1EDE86
	jmp $DE7F

	;���C�����[�`���̃��[�v�ʒu��������ƒ���
	BANKORG_D $1EDF4C
	jmp $DE7F

	;���Ȃ苷�����c�c�Q�R���f�o�b�O�̒�~��ׂ�
	BANKORG_D $1EDE73
	bne $DE7F
BOSS_THROUGH_PROC:
	lda $05b8,x ;Obj���G
	bne .rts
	jmp $809D
.rts
	rts
;	Addr<=1EDE7F
