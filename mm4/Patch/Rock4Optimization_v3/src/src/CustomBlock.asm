CustomBlock:
;-------------------------------------------------
; ������W�����v���ď��鑫�ꏈ��
;-------------------------------------------------
;	; ����(�E)�A����(��)�̏������s��Ȃ��悤�ɂ���p�b�`
;	BANKORG_D $3C9319
;	lda	<$10			; �`�b�v�������[�h
;	jmp	$9329			; ����(��)�̃`�F�b�N�����փW�����v

	; ���ꏈ���֔�΂����߂̃p�b�`
	BANKORG_D $3FF1B8
BANK3F_JmpFoothold:
	jmp	BANK3F_Foothold		; ����`�F�b�N�����փW�����v
	nop

;-------------------------------------------------
; �ォ�牺�ւ̈���ʍs�u���b�N����
;-------------------------------------------------
	BANKORG_D $3FF0EF
BANK3F_JmpOnewayBlock:
	jmp	BANK3F_OnewayBlock
	nop

	BANKORG_D $3FF221
BANK3F_JmpOnewayBlockG:
	jmp	BANK3F_OnewayBlockG
	nop


	;�J�X�^���u���b�N���󂯕t���邽�߂̃t�b�N
	BANKORG_D $3C82F0
	jsr CustomBlock_Main
	BANKORG_D $3C8358
	jsr CustomBlock_Main

	;�X�e�[�W�ɂ���ʂ��폜����
	;SW_EffectEnemyEx������Ƃ��͂�����ŏ�������
	.IF !SW_EffectEnemyEx
	BANKORG_D $3C92D3
	bit <$00
	BANKORG_D $3C92DD
	bcs $933E
	.ENDIF

	;������C4�ɕύX
	BANKORG_D $3FF1CE
	.IF SW_WRAMMap
	jmp [aProcCustomBlock_Sand]
	.ELSE
	jmp $F1D4
	.ENDIF
	BANKORG_D $3FF1D4
CustomBlock_Sand:
	BANKORG_D $3FF1D6
	cmp #$C4
	BANKORG_D $3FF22B
CustomBlock_SkipSand:

	.IF SW_CustomBlock_OrgHack
	BANKORG_D $21A400+$00 ;�g�[�h�}���X�e�[�W/�Ȃ����󔒂ɖ��g�p�r�b�g���t�^����Ă���
	.db $01
	BANKORG_D $23A400+$18 ;�t�@���I�}���X�e�[�W/������04��t�^
	DB4 $C5C5C5C5
	BANKORG_D $28A400+$04 ;�R�T�b�N�P/���08��t�^
	DB3 $CACACA
	.ENDIF

	BANKORG CustomBlock
