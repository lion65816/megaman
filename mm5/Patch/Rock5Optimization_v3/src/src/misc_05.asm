;�ƂĂ������̂Ń��C���o���N�Ɉړ����邱�Ƃ��l����K�v�����邾�낤


	.IF Enable_FixPWCSkip ;{
FixPWCSkip_org:

	BANKORG_DB $1C88C3+$42,LOW(FixPWCSkip_org)
	BANKORG_DB $1C8993+$42,HIGH(FixPWCSkip_org)
	BANKORG_DB $1C86C3+$42,BANK(FixPWCSkip_org)

	BANKORG FixPWCSkip_org
;�X���C�f�B���O���Ԃ�1��(�X���C�f�B���O���łȂ��Ă����Ȃ�)
	lda #$01
	sta <vRockmanSlideTimer
	jmp $A4AC

	.ENDIF ;}
