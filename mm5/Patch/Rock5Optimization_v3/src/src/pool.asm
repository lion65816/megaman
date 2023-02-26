	BANKORG_D $0083A1
	FillTest $008800
	;01
	;02
	BANKORG_D $03A656
	FillTest $03A800
	BANKORG_D $04A665
	.IF Enable_Disable_Collision
	.include "src/DisableCollision_04.asm"
	.ENDIF
	FillTest $04A800
	;05
	BANKORG_D $05A7E5
	.include "src/misc_05.asm"
	FillTest  $05A800
	BANKORG_D $06A64A
	.IF Enable_Disable_Collision
	.include "src/DisableCollision_06.asm"
	.ENDIF
	FillTest $06A800
	BANKORG_D $07A60B
	.IF Enable_Disable_Collision
	.include "src/DisableCollision_07.asm"
	.ENDIF
	FillTest $07A800
	BANKORG_D $08A4E8
	.IF Enable_Disable_Collision
	.include "src/DisableCollision_08.asm"
	.ENDIF
	.include "src/misc_R5E_08.asm"
	FillTest $08A800
	BANKORG_D $09A672
	.IF Enable_Disable_Collision
	.include "src/DisableCollision_09.asm"
	.ENDIF
	FillTest $09A800
	BANKORG_D $0AA6D2
	FillTest $0AA800
	BANKORG_D $0B839D
	FillTest $0B8800
	;0C
	BANKORG_D $0DA26F
	FillTest $0DA800
	;0E
	;0F
	BANKORG_D $108000
	FillTest $108800
	BANKORG_D $118000
	.include "src/reset_11.asm"
	.IF Enable_AtRoomScrolling
	.include "src/AtRoomScrolling_11.asm"
	.ENDIF
	.IF Enable_StageInit
	.include "src/StageInit_11.asm"
	.ENDIF
	.IF Enable_WRAMMap
	.include "src/WRAMMap_11.asm"
	.ENDIF
	.include "src/misc_R5E_11.asm"
	SETBANK8000
	FillTest $118800
	;12/–³‚µ
	BANKORG_D $13BF41
	FillTest $13C000
	;14/–³‚µ
	BANKORG_D $15BF84
	FillTest $15C000
	BANKORG_D $16917E
	.IF Enable_MidExp
	.include "src/MidExp_16.asm"
	.ENDIF
	FillTest $16A000
	;17
	;18,19,1A ‰¹Šy
	BANKORG_D $1B9E70
	.IF Enable_ForegroundOmission
	.include "src/ForegroundOmission_1B.asm"
	.ENDIF
	.include "src/misc_R5E_1B.asm"
	.include "src/misc_1B.asm"
	SETBANK8000
	FillTest $1BA000
	BANKORG_D $1C9F0B
	.include "src/misc_1C.asm"
	FillTest $1CA000

	BANKORG_D $1DBB4F
	.IF Enable_Disable_Collision
	.include "src/DisableCollision_1D.asm"
	.ENDIF
	FillTest $1DC000

	BANKORG_D $1FE43B
	FillTest $1FE6C7
	BANKORG_D $1FF53E
	.IF Enable_StageInit
	.include "src/StageInit_p.asm"
	.ENDIF
	.IF Enable_AtRoomScrolling
	.include "src/AtRoomScrolling_p.asm"
	.ENDIF
	.IF Enable_WRAMMap
	.include "src/WRAMMap_p.asm"
	.ENDIF
	.IF Enable_UnrollingSwChrBank
	.include "src/UnrollingSwChrBank_p.asm"
	.ENDIF
	.IF Enable_UnrollingPalTransfer
	.include "src/UnrollingPalTrans_p.asm"
	.ENDIF
	.IF Enable_SetupGaugeSprites
	.include "src/SetupGaugeSprites_p.asm"
	.ENDIF
	.IF Enable_UnrollingSearchSlot
	.include "src/UnrollingSearchSlot_p.asm"
	.ENDIF
	.IF Enable_UseTableAtTerrainProc
	.include "src/UseTableAtTerrainProc_p.asm"
	.ENDIF
	.IF Enable_Disable_Collision
	.include "src/DisableCollision_p.asm"
	.ENDIF
	.IF Enable_AtCloseSubScreen
	.include "src/AtCloseSubScreen_p.asm"
	.ENDIF
	.include "src/misc_R5E_p.asm"
	.include "src/misc_p.asm"
	FillTest $1FFE00

