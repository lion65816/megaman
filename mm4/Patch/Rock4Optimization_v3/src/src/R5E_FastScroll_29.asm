;by rock4_fastscroll/Rock5easily
	.IF SW_FastScroll_OrgHack
R5E_FastScroll_OnT50:
	DB4 $0F0F3727
	DB4 $0F371016
	DB4 $1830AC0B
	DB4 $24809800
	.db $FF

	.ENDIF
