���b�N�}���Q���i�q�b�g�p�b�`
�E�z�z���E�F�u�T�C�g
�@�@�@�@�@http://borokobo.web.fc2.com/
�@�@�@�@�@�iNeo�ڂ낭���H�[�j
�@�@�@�@�@http://www4.atpages.jp/borokobo/
�@�@�@�@�@�iNeo�ڂ낭���H�[�ʊفj

���T�v
�@���b�N�}���Q�́A���b�N�}���P�Ƃ͈�]�A
�@�|���Ȃ��Ă�������ђʂ���悤�ȕ���͏��Ȃ��ł��B
�@�ł����A�����ʂ蔲���Ă���Ԃ�
�@�P��̂݃_���[�W��^����i���߂Ǝv����悤�ȁj�����͑��݂��Ă��܂��B
�i�قڑS����Ɍʂɏ����Ă���܂����A�d�l���Ǝv���܂����j

�@�X�i�C�p�[�A�[�}�[�ɃG�A�[�V���[�^�[�𖧒����ē��Ă��
�@���̏������������߁A
�@�P�Z�b�g�̃G�A�[�V���[�^�[�œ|���Ȃ����Ƃ͗ǂ����邱�Ƃł��B
�@�܂��A�N���b�V���{�����v���悤�ɑ���Ƀ_���[�W��^�����Ȃ����Ƃ�����܂��B

�@�Ƃ������ƂŁA�O�t���[���ɍU�����q�b�g���Ă��Ă�
�@���킪������΃_���[�W������悤�Ƀp�b�`������Ă݂܂����B

���g�p�@
�@�K���ȃp�b�`�\�t�g�Ń��b�N�}���Q�̂q�n�l�C���[�W��
�@���ĂĂ��������B

���s��E�⑫�Ȃ�
�E��{�I�Ƀ��N�Ƀe�X�g���Ă��Ȃ��̂Ńo�O�邩������܂���
�E�����G�A�[�V���[�^�[�͂�����ƃC���`�L�L���ł��B
�@�V���b�g�}����W���[���u�E�ł��܂����c�c
�E�N���b�V���{���͂���ɃC���`�L�L���C�����܂��B
�i���������t���[���q�b�g����̂ŁA
�@�P�_���[�W�ł��^�����鑊��͑����ɓ|����j

�@�����o�O������A�E�F�u�T�C�g�̂ق���
�@�񍐂��Ă���������ƑΏ��ł��邩������܂���B

������
�EVer1(2010�N5��23��)
�@����
�EVer2(2011�N1��30��)
�@�E�U�R����e���_�ł��Ă��Ȃ������s�
�@�E�u���b�L�[�����􂵂Ȃ��s�
�@�����Ԃ�C��

���ӎ�
�@�����X��13��735�l
�@�@�s����w�E���Ă����������肪�Ƃ��������܂��B

���\�[�X
BANKORG_D .macro
	.bank (\1>>16)
	.org (\1&$FFFF)
	.endm

A_1ObjBlink = $100

;���b�N�o�X�^�[
	BANKORG_D $1FE66D
	lda #$01
	sta A_1ObjBlink,x
	jmp $E675
;�A�g�~�b�N�t�@�C�A�[
	BANKORG_D $1FE6DD
	lda #$01
	sta A_1ObjBlink,x
	jmp $E6E5
;�G�A�[�V���[�^�[
	BANKORG_D $1FE72C
	lda #$01
	sta A_1ObjBlink,x
	jmp $E734
;���[�t�V�[���h
	BANKORG_D $1FE785
	lda #$01
	sta A_1ObjBlink,x
	jmp $E78D
;�o�u�����[�h
	BANKORG_D $1FE7EB
	lda #$01
	sta A_1ObjBlink,x
	jmp $E7F3
;�N�C�b�N�u�[������
	BANKORG_D $1FE844
	lda #$01
	sta A_1ObjBlink,x
	jmp $E84C
;�N���b�V���{��
	BANKORG_D $1FE8B8
	lda #$01
	sta A_1ObjBlink,x
	jmp $E8C0
;���^���u���[�h
	BANKORG_D $1FE91C
	lda #$01
	sta A_1ObjBlink,x
	jmp $E924
