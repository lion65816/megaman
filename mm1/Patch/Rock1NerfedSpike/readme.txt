====================================================================================================
���b�N�}���P�@�g�Q���_���[�W��

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
�@�p�b�`�𓖂Ă���̃o�C�i������A
A5 6A E9 04
�@�������������A�Ō�̃o�C�g��04���_���[�W�ʂł��B

���s��E�⑫�Ȃ�
�E��{�I�Ƀ��N�Ƀe�X�g���Ă��Ȃ��̂Ńo�O�邩������܂���B
�E�m�b�N�o�b�N�����́A�����Ă�������Ƌt�ł��B
�E�A�C�e���̓g�Q�ɖ��܂��Ă��܂�����A���b�N�}���̓g�Q�ɏ��`�ƂȂ��Ă��܂��B
�@���܂����A�C�e���͎��Ȃ����A�����������X�s���R�H

���X�V����
��Ver.1.00(2016�N7��3��)
�@����

���\�[�X�E���p�����Ȃ�
�@�����R�ɗ��p���Ă��������B
�@�ȉ��A�A�Z���u���\�[�X�ƂȂ��Ă��܂��B
�@���ɂ����ʗp���Ȃ��悤�ȕ\����}�N����������܂����A
�@�K���u�������Ă��ǂ݂��������B

	BANKORG_D $0ED7DE ;�g�Q�ɉ�����G�ꂽ��
	jmp SpikeDamage_H

	BANKORG_D $0ED81B ;�g�Q�ɏc�ɐG�ꂽ��
	jmp SpikeDamage_V


	BANKORG_D $0FFF00 ;�󂫗̈�𗘗p
SpikeDamage_H:
	jsr SpikeDamage_Common
	ldy #$01
	jmp $D7D9

SpikeDamage_V:
	jsr SpikeDamage_Common
	lda #$00
	jmp $D7FF

SpikeDamage_Common:
	lda <$55 ;���G����
	bne .NotDamage
	sec
	lda <$6A ;HP
	sbc #(4) ;�_���[�W��
	bpl .NotFixHP
	lda #$00
.NotFixHP
	sta <$6A ;HP
	beq .Dead
	lda $0420+0
	ora #$03
	sta $0420+0 ;�m�b�N�o�b�N��ԂɈڍs����
	lda #$6F
	sta <$55 ;���G����
.NotDamage
	rts
.Dead
	pla
	pla
	jmp $C219 ;���S���̏���

