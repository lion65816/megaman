
	BANKORG_D $0BA15B ;********************
	.IF SW_MidExp
	.include "src/MidExp_0B.asm"
	.ENDIF
	FillTest  $0BB800
	BANKORG_D $0DAA6D ;********************
	FillTest  $0DB800
	BANKORG_D $1B9979 ;********************
	FillTest  $1BA000
	BANKORG_D $20BDAC ;********************
	FillTest  $20C000
	BANKORG_D $27B800 ;********************
	FillTest  $27C000
	BANKORG_D $28BDC7 ;********************
	FillTest  $28C000
	BANKORG_D $29BE3D ;********************
	.IF SW_FastScroll
	.include "src/R5E_FastScroll_29.asm"
	.ENDIF
	FillTest  $29C000
	BANKORG_D $2DB800 ;********************
	FillTest  $2DC000
	BANKORG_D $319800 ;********************
	.IF EnableHook_StageInit
	.include "src/StageInit_31.asm"
	.ENDIF
	.IF EnableHook_Reset
	.include "src/reset_31.asm"
	.ENDIF
	.IF EnableHook_AtRoomScrolling
	.include "src/AtRoomScrolling_31.asm"
	.ENDIF
	.IF SW_WRAMMap
	.include "src/WRAMMap_31.asm"
	.ENDIF
	FillTest  $31A000
	BANKORG_D $35B934 ;********************
	FillTest  $35C000
	BANKORG_D $37B4EA ;********************
	FillTest  $37B800
	BANKORG_D $3885A9 ;********************
	.IF SW_EffectEnemyEx
	.include "src/R5E_EEE_38.asm"
	.ENDIF
	FillTest  $388800
	BANKORG_D $38BD62 ;********************
	FillTest  $38C000
;	BANKORG_D $399C65 ;********************
	BANKORG_D $399A17 ;********************デバッグモードから潰す
	FillTest  $39A000
	BANKORG_D $3BBCBC ;********************
	.IF SW_DisableCollision
	.include "src/DisableCollision_3B.asm"
	.ENDIF
	.include "src/misc_3B.asm"
	FillTest  $3BC000

	BANKORG_D $3C9F63 ;********************
	.IF SW_WRAMMap
	.include "src/WRAMMap_3C.asm"
	.ENDIF
	.IF SW_DisableCollision
	.include "src/DisableCollision_3C.asm"
	.ENDIF
	.IF EnableHook_AtCloseSubScreen
	.include "src/AtCloseSubScreen_3C.asm"
	.ENDIF
	.IF SW_Haikei
	.include "src/R5E_Haikei_3C.asm"
	.ENDIF
	.include "src/misc_3C.asm"


	.IF SW_Haikei&(!SW_WRAMMap)
	FillTest  $3C9FF0
	.ELSE
	FillTest  $3CA000
	.ENDIF
	;※3Cは大変混雑してしまい、一部3E/3Fの方に移動せざるを得ない
	BANKORG_D $3DBD9F ;********************
	.IF SW_WRAMMap
	.include "src/WRAMMap_3D.asm"
	.ENDIF
	.IF SW_DisableCollision
	.include "src/DisableCollision_3D.asm"
	.ENDIF
	.include "src/misc_3D.asm"
	FillTest  $3DC000

	BANKORG_D $3FE814 ;********************
	 ;vblank中に終わらせる処理で、タイミングがシビアなので
	 ;R5E_FastScroll_p.asmは、この場所において下さい
	.IF SW_FastScroll
	.include "src/R5E_FastScroll_p.asm"
	.ENDIF
	.IF SW_DisableCollision
	.include "src/DisableCollision_p.asm"
	.ENDIF
	.IF EnableHook_StageInit
	.include "src/StageInit_p.asm"
	.ENDIF
	.IF SW_WRAMMap
	.include "src/WRAMMap_p.asm"
	.ENDIF
	.IF EnableHook_AtRoomScrolling
	.include "src/AtRoomScrolling_p.asm"
	.ENDIF
	.IF SW_Haikei
	.include "src/R5E_Haikei_p.asm"
	.ENDIF
	.IF SW_SetupGaugeSprites
	.include "src/R5E_Gauge_p.asm"
	.ENDIF
	.iF SW_CustomBlock
	.include "src/CustomBlock_p.asm"
	.ENDIF

	.include "src/misc_p.asm"
	FillTest  $3FF000
	BANKORG_D $3FFFB3 ;********************
	FillTest  $3FFFFA

