	.inesprg $08 ;�v���O�����o���N��
	.ineschr $00 ;�L�����N�^�o���N��
	.inesmir 1 ;

	.inesmap 2

	.bank 0
	.org $0000

	.incbin "rockman1.prg"
	.include "mylib.asm"


;�����j
;�i�P�j�q�b�g�t���O�́A�q�b�g���ɉ��낷�悤�ɂ���B
;�@�@�@�f�t�H���g�ł́A�Q�t���[���ɂP�񉺂낳��Ă���
;�i�Q�j���G���Ԃ𓱓�����B
;�@�@�@�q�b�g�t���O���󗝂��ꂽ�Ƃ��ɖ��G�����B
;�@�@�@���G���Ԓ��́A�q�b�g���̂𖳌��ɂ��A������X���[����
;�i�R�j���G���Ԃ́A���i�̓q�b�g�t���O�����낵�Ă��镔���Ńf�N�������g�B


;�q�b�g���Ă��Ȃ��Ƃ��̂Ƃѐ�����X�C��
	BANKORG_D $0BBE56
	beq $BE5E

;�q�b�g���ɖ����t���O�����낷
	BANKORG_D $0BBEC2
	asl $0420,x ;�t���O
	lsr $0420,x ;�t���O

;���G���Ԃ̃Z�b�g
;�{����0��1���Ƃ��������ł��邱�Ƃɗ��ӂ��邱��
;�傫�Ȓl�ɂ��Ă��A����Ȃ�ɂ͂܂Ƃ��ɓ��삷��B
;�i�c�c�N�������Ȃ��ł����j
	BANKORG_D $0BBEE6+1
	.db 2

;�����r�b�g��OFF�ɂ��鏈���̑����
;���G���ԃf�N�������g
	BANKORG_D $0BA261
	TRASH_GLOBAL_LABEL
	ldx #$1F
.DecThroughTime_loop
	lda $0580,x ;���G����
	beq .DecThroughTime_next
	dec $0580,x ;���G����
.DecThroughTime_next
	dex
	cpx #$0F
	bne .DecThroughTime_loop
	beq $A277
;	Addr <=0BA277

;���G�X���[
	BANKORG_D $0EC9A1
	jmp MUTEKI_THROUGH

;���g�p�̈悾�ƐM���ė��p
	BANKORG_D $0FFF00
MUTEKI_THROUGH:
	lda $0580,x ;���G����
	bne .through
	asl $0420,x ;�t���O
	sec
	ror $0420,x ;�t���O
	jmp $C9A9
.through
	rts
