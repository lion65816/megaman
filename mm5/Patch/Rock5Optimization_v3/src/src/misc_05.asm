;とても狭いのでメインバンクに移動することも考える必要があるだろう


	.IF Enable_FixPWCSkip ;{
FixPWCSkip_org:

	BANKORG_DB $1C88C3+$42,LOW(FixPWCSkip_org)
	BANKORG_DB $1C8993+$42,HIGH(FixPWCSkip_org)
	BANKORG_DB $1C86C3+$42,BANK(FixPWCSkip_org)

	BANKORG FixPWCSkip_org
;スライディング時間を1に(スライディング中でなくても問題なし)
	lda #$01
	sta <vRockmanSlideTimer
	jmp $A4AC

	.ENDIF ;}
