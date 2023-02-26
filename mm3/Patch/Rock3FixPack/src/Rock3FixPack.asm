	.inesprg $10 ;�v���O�����o���N��
	.ineschr $10 ;�L�����N�^�o���N��
	.inesmir 0 ;

	.inesmap 4

	.bank 0
	.org $0000

	.incbin "rockman3.prgchr"
	.include "mylib.asm"

;�����b�V���s���o�O�̏C��
;�@�X�p�[�N�V���b�N�E�V���h�[�u���[�h�ŉE��������
;�@�����Ă��Ȃ��Ă��}������W�F�b�g��I�����Ă��܂��o�O�̏C���B
;�@02A9EA-02A9FF�𗘗p�B

	BANKORG_D $02A3CB
	jmp Fix_RushForgeryGlitch

	BANKORG_D $02A9EA
Fix_RushForgeryGlitch:
	lsr a
	bcs .NotMoveCursor
	asl a
	adc #$06+1
	tay
	lda $00A2,y ;����G�l���M�[
	bpl .NotHaveRushAdapter
	jmp $A3CF
.NotHaveRushAdapter
	;���b�V���R�C���ɍ��킹��
	lda #$01
	sta <$A1
.NotMoveCursor
	jmp $A477 ;�J�[�\���ړ������I��
	ORG_TEST $02AA00

;�����C���[�X�e�[�W�ȍ~�R���e�B�j���[���J�[�\����"CONTINUE"�ɌŒ�
;�@����ɂ��A��o�蒼��������鎖���o����B
;�@189FF4-189FFF�𗘗p�B
	BANKORG_D $1898BE
	jsr Fix_WilyContinue
	BANKORG_D $189FF4
Fix_WilyContinue:
	lda <$22
	cmp #$0C
	bcs .IsInWilyStage
	jmp $93CE
.IsInWilyStage
	jmp $93DA
	ORG_TEST $8000

;���C�G���[�f�r���̔���C��
;�@�f�r���̔��肪�����Ȃ���ԂɈړ�����d�l��ύX�B
;�@�ڋʂ̕\���̗L���ɂ�蔻�肪���܂�悤�ɂȂ�B
	BANKORG_D $12A154
	TRASH_GLOBAL_LABEL
	and #$04
	bne .Nohit
	jsr $8009
	bit $0000
	bit $0000
.Nohit
	ORG_TEST $A161

;���W���C�A���g���b�g�[���̃A�C�e���̏C��
;�@�W���C�A���g���b�g�[�����A�C�e���𗎂Ƃ�����
;�@�߂Â��ƃ��b�N�}�����ɂ����̃A�C�e���ɂȂ�s����C���B
	BANKORG_D $12B480
	TRASH_GLOBAL_LABEL
	pla
	ldy $04E0,x ;ObjHP/Blink
	beq .Hp0
	sta $0480,x ;ObjHitFlag,x
	bne $B4E2
.Hp0
	sty <$F8
	ORG_TEST $B48D

;���t���b�V���}������̘A���_���[�W�C��
;�@�h�N���t���b�V�������Ԃ��~�߂��茳�ɖ߂����肷�鎞��
;�@�m�b�N�o�b�N���Ă���Ɩ��G���Ԃ��Ȃ��A���_���[�W����炤�d�l���C���B
;�@�������A�m�b�N�o�b�N���͎����~�܂�Ȃ��Ȃ�B
;�@04A9F3-04A9FF�𗘗p�B
	BANKORG_D $04A0F0
	nop
	jsr FixFlashCombo0
	BANKORG_D $04A1DA
	nop
	jsr FixFlashCombo7

	BANKORG_D $04A9F3
FixFlashCombo0:
	ldy #$00
	beq FixFlashComb_conf
FixFlashCombo7:
	ldy #$07
FixFlashComb_conf:
	;�m�b�N�o�b�N�����������Ԃ�ύX���Ȃ�
	cmp #$06
	beq .NotStopRockman
	sty <$30 ;���b�N�}���̏��
.NotStopRockman
	rts
	ORG_TEST $04AA00
