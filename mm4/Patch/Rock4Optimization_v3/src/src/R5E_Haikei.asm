;by rock4_haikei/Rock5easily
R5E_Haikei:
	;�O�i�����̂��߂Ƀt�b�N
	BANKORG_D $3C932B
	bne $933E
	BANKORG_D $3C933E
	jmp R5E_Haikei_main
	BANKORG_D $3C938D
	beq $933E

	;SW_WRAMMap�Ɠ����Ɏw�肳��Ă��Ȃ�������
	;�X�e�[�W���̏����L��/�������X�g��p��
	.IF !SW_WRAMMap
	BANKORG_D $3C9FF0
R5E_Haikei_TblPerStage:
	.db $01,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$01
	.ENDIF

	;�_��`��ǉ����邽�߂ɂ��ɂ傲�ɂ傷��
	;�c�_��`�A�h���Xhi�̃A�h���X��+2
	BANKORG_D $3E9434;3EB434
	.db $4A
	;�c�_��`[00](lo)�̃A�h���X
	BANKORG_D $3E9808;3EB808
	.db LOW(R5E_Haikei_VBar00)
	;�c�_��`[40][41](lo)[00](hi)�̃A�h���X
	BANKORG_D $3E9848;3EB848
	.db LOW(R5E_Haikei_VBar40),LOW(R5E_Haikei_VBar41),HIGH(R5E_Haikei_VBar00)
	;����
	BANKORG_D $3E9866;3EB866
	.db $D8,$D8
	;�c�_��`[3E][3F][40][41]�̃A�h���X
	BANKORG_D $3E9888;3EB888
	.db $D9,$D9,HIGH(R5E_Haikei_VBar40),HIGH(R5E_Haikei_VBar41)

	BANKORG R5E_Haikei
