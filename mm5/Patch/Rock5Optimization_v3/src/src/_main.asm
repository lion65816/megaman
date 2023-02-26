	.include "src/mylib.asm"
	.include "src/mylib_r5.asm"
	.include "src/label.asm"

	.IFNDEF _SW_asm_Included
	.include "src/_SW.asm"
	.ENDIF

	;�I�v�V�����̃`�F�b�N
	.IF Enable_Misc_Gauge&Enable_SetupGaugeSprites
	.fail Enable_Misc_Gauge��Enable_SetupGaugeSprites�͓����Ɏg�p�ł��܂���
	.ENDIF
	.IF Enable_WRAMMap&Enable_UseTableAtTerrainProc
	.fail Enable_WRAMMap��Enable_UseTableAtTerrainProc�͓����Ɏg�p�ł��܂���
	.ENDIF
	.IF Enable_WRAMMap&Enable_ForegroundOmission
	.fail Enable_WRAMMap��Enable_ForegroundOmission�͓����Ɏg�p�ł��܂���
	.ENDIF
	.IF Enable_FixArrowZipping&!Enable_WRAMMap
	.fail Enable_FixArrowZipping�ɂ�Enable_WRAMMap���K�v�ł�
	.ENDIF

	;����^�C�~���O�ł̏��������s���邩�ǂ���
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
	;pool�͍Ō�ɒu������
	.include "src/pool.asm"

	;���e�X�g�p�̃}�b�v(�R�����g�A�E�g���Y��Ȃ��悤��)
;	.include "TEST_MAP.asm"
