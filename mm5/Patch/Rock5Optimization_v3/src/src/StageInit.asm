StageInit_Org:

	;�ǂ��炪�������낤���H
	;�{�X���b�V���̃J�v�Z�����[�v�ł����[�h�͕K�v���Ǝv���̂ŁA��҂ɂ��Ă���
;	BANKORG_D $1EDE45
;	jsr StageInit_Trig
;	BANKORG_D $1ED45D
;	jmp StageInit_Trig

	;���V���b�^�[����鏈���Ƃ̌��ˍ���������
	;�V���b�^�[����郋�[�`���̈ʒu�ɒu�����Ƃɂ���
	BANKORG_D $1ED3EB
	sta <$0F
	jsr StageInit_Trig


	BANKORG StageInit_Org
