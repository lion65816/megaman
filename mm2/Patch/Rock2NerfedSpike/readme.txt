====================================================================================================
���b�N�}���Q�@�g�Q���_���[�W��

�E�E�F�u�T�C�g
�@�@�@�@�@http://borokobo.web.fc2.com/
�@�@�@�@�@�iNeo�ڂ낭���H�[�j
�@�@�@�@�@http://www.geocities.jp/borokobo/
�@�@�@�@�@�iNeo�ڂ낭���H�[�ʊفj

====================================================================================================
����������
�@�{�p�b�`���c�k���Ă��������A���肪�Ƃ��������܂��B

���Ɛ�
�@�g�p�͎��ȐӔC�ł��肢�v���܂��B

���T�v
�@�����̃g�Q���_���[�W(�f�t�H���g��4�_���[�W)�ɕύX���܂��B

���_���[�W�������@
�@�p�b�`�𓖂Ă���̃o�C�i������
AD C0 06 E9 04
�@�������������A�Ō�̃o�C�g��04���_���[�W�ʂł��B

���s��E�⑫�Ȃ�
�E��{�I�Ƀ��N�Ƀe�X�g���Ă��Ȃ��̂Ńo�O�邩������܂���B
�E�m�b�N�o�b�N�����́A�����Ă�������Ƌt�ł��B

���X�V����
��Ver.1.00(2016�N7��3��)
�@����

���\�[�X�E���p�����Ȃ�
�@�����R�ɗ��p���Ă��������B
�@�ȉ��A�A�Z���u���\�[�X�ƂȂ��Ă��܂��B
�@���ɂ����ʗp���Ȃ��悤�ȕ\����}�N����������܂����A
�@�K���u�������Ă��ǂ݂��������B

	BANKORG_D $1C8A5E ;�g�Q�ɉ�����G�ꂽ��
	jsr NerfedSpike_H
	lda #$03
	nop
	nop

	BANKORG_D $1C8CC2 ;�g�Q�ɏc�ɐG�ꂽ��
	jsr NerfedSpike_V
	ldx #$00
	nop
	nop

	BANKORG_D $1FF2A2 ;�󂫗̈�𗘗p
NerfedSpike_V:
	;�g�Q�̏�ɒ��n����Ƃ��́A���������Ńm�b�N�o�b�N�������Ă��܂��B
	;���̂��߁A������Y���W�𒲐����A�c�����ɂ͕ǂɐG��Ă��Ȃ����Ƃɂ���
	lda <$2C
	cmp #$06 ;�u�󒆁v���
	bne .NotFixCollisionState
	lda $0640 ;���Ɉړ����Ă���
	bpl .NotFixCollisionState
	;�g�Q�ɂ�鎩�@�̉����߂�
	lda <$0A
	and #$0F
	sta <$32
	sec
	lda $04A0
	sbc <$32
	sta $04A0
	;�ǂɂ͐G��Ă��Ȃ��Ƃ��������ɂ���
	lda #$00
	sta <$32
	sta <$33
.NotFixCollisionState
NerfedSpike_H:
	sec
	lda $06C0 ;HP
	sbc #(4) ;�_���[�W��
	bpl .NotFixHP
	lda #$00
.NotFixHP
	sta $06C0 ;HP
	beq .Dead
	jmp $D32F ;�m�b�N�o�b�N
.Dead
	sta <$2C ;���b�N�}���̏��
	pla
	pla
	jmp $C10B

