	.include "src/mylib.asm"
	.include "src/mylib_r5.asm"
	.include "src/label.asm"

	.IFNDEF _SW_asm_Included
	.include "src/_SW.asm"
	.ENDIF

	;オプションのチェック
	.IF Enable_Misc_Gauge&Enable_SetupGaugeSprites
	.fail Enable_Misc_GaugeとEnable_SetupGaugeSpritesは同時に使用できません
	.ENDIF
	.IF Enable_WRAMMap&Enable_UseTableAtTerrainProc
	.fail Enable_WRAMMapとEnable_UseTableAtTerrainProcは同時に使用できません
	.ENDIF
	.IF Enable_WRAMMap&Enable_ForegroundOmission
	.fail Enable_WRAMMapとEnable_ForegroundOmissionは同時に使用できません
	.ENDIF
	.IF Enable_FixArrowZipping&!Enable_WRAMMap
	.fail Enable_FixArrowZippingにはEnable_WRAMMapが必要です
	.ENDIF

	;特定タイミングでの処理を実行するかどうか
Enable_StageInit              = Enable_WRAMMap|Enable_Disable_Collision
Enable_AtCloseSubScreen       = Enable_WRAMMap|Enable_Disable_Collision
Enable_AtRoomScrolling        = Enable_WRAMMap

	.IF FillUnusedSpace22
FillTest .macro
	TRASH_GLOBAL_LABEL
	PaddingTill \1
	.endm
	.ELSE
FillTest .macro
	END_BOUNDARY_TEST \1
	.endm
	.ENDIF
	
	.IF Enable_6BitAttribute
Const_16TileAttributeBits = $FC
	.ELSE
Const_16TileAttributeBits = $F0
	.ENDIF

	.IF Enable_WRAMMap
	.include "src/WRAMMap.asm"
	.ENDIF
	.IF Enable_MidExp
	.include "src/MidExp.asm"
	.ENDIF
	.IF Enable_UpdateObjectPointer
	.include "src/UpdateObjectPointer.asm"
	.ENDIF
	.IF Enable_Disable_Collision
	.include "src/DisableCollision.asm"
	.ENDIF
	.IF Enable_AtCloseSubScreen
	.include "src/AtCloseSubScreen.asm"
	.ENDIF
	.IF Enable_StageInit
	.include "src/StageInit.asm"
	.ENDIF
	.IF Enable_AtRoomScrolling
	.include "src/AtRoomScrolling.asm"
	.ENDIF


	.include "src/reset.asm"
	.include "src/misc.asm"
	.include "src/misc_R5E.asm"
	;poolは最後に置くこと
	.include "src/pool.asm"

	;※テスト用のマップ(コメントアウトし忘れないように)
;	.include "TEST_MAP.asm"
