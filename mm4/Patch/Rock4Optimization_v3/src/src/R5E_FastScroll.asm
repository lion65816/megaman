;by rock4_fastscroll/Rock5easily
R5E_FastScroll:

	;NMI���̓]��
	BANKORG_D $3EC06C
	jsr R5E_FastScroll_PPUTransfer

	;�X�N���[�����x�ƃ��b�N�}���̈ʒu����
	;�E
	BANKORG_D $3E8B72;3EAB72
	.db $04
	BANKORG_D $3E8B7C;3EAB7C
	.db $30
	BANKORG_D $3E8B80;3EAB80
	.db $01
	BANKORG_D $3E8B82;3EAB82
	.db $30
	BANKORG_D $3E8B85;3EAB85
	.db $48
	BANKORG_D $3E8B8A;3EAB8A
	.db $48
	BANKORG_D $3E8B8C;3EAB8C
	.db $4C,$94,$CB,$EA,$EA,$EA,$EA,$EA
	;�㉺
	BANKORG_D $3E8DF8;3EADF8
	.db $04
	BANKORG_D $3E8E08;3EAE08
	.db $80
	BANKORG_D $3E8E10;3EAE10
	.db $03
	BANKORG_D $3E8E22;3EAE22
	.db $04
	BANKORG_D $3E8E30;3EAE30
	.db $80
	BANKORG_D $3E8E38;3EAE38
	.db $03

	;�X�N���[�����̃L�����N�^�]���Z�b�g�A�b�v
	BANKORG_D $3ECBB8
	jsr R5E_FastScroll_SetupTransferData
	BANKORG_D $3ECE48
	jsr R5E_FastScroll_SetupTransferData

	;��������̏C��
	.IF SW_FastScroll_OrgHack
	;�p���b�g�A�j���[�V�����f�[�^/�����O�}���X�e�[�W�̐F�t�F�[�h�𑬂�
	BANKORG_D $209B89;20BB89
	.db $10
	;On�]����`[00]�̃A�h���Xlo
	BANKORG_D $29B800
	.db low(R5E_FastScroll_OnT00)
	;On�]����`[50]�̃A�h���Xlo
	BANKORG_D $29B850
	.db low(R5E_FastScroll_OnT50)
	;On�]����`[00]�̑��/���̃f�[�^��������������΂����̂ŁA�A�h���Xhi�̕�����]�p
	BANKORG_D $29B860
R5E_FastScroll_OnT00:
	;On�]����`[50]�̃A�h���Xhi
	BANKORG_D $29B8B0
	.db high(R5E_FastScroll_OnT50)
	;On�]����`[26]
	BANKORG_D $29BB3D
	.db $FF
	DB4 $02208B1A
	DB4 $02108F1C
	DB4 $0230A01D
	.db $FF

	;�R�T�b�N�S�̉��On��`�ԍ�
	BANKORG_D $2B9569;2BB569
	.db $26,$50

	.ENDIF


	BANKORG R5E_FastScroll
