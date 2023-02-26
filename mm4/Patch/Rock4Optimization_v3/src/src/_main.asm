	.IFNDEF _SW_asm_Included
	.include "src/_SW.asm"
	.ENDIF

	.include "src/mylib.asm"
	.include "src/mylib_r4.asm"
	.include "src/label.asm"

	;�I�v�V�����̃`�F�b�N
	.IF SW_WRAMMap&SW_UseTableAtTerrainProc
	.fail SW_WRAMMap��SW_UseTableAtTerrainProc�͓����Ɏg�p�ł��܂���
	.ENDIF
	.IF SW_Gauge&SW_SetupGaugeSprites
	.fail SW_Gauge��SW_SetupGaugeSprites�͓����Ɏg�p�ł��܂���
	.ENDIF
	.IF SW_OmitTerrainCollision&!SW_WRAMMap
	.fail SW_OmitTerrainCollision�ɂ�SW_WRAMMap���K�v�ł�
	.ENDIF
	.IF SW_WriteAudioReg&!SW_WRAMMap
	.fail SW_WriteAudioReg�ɂ�SW_WRAMMap���K�v�ł�
	.ENDIF
	.IF SW_FixTerrainThrough1&!SW_WRAMMap
	.fail SW_FixTerrainThrough1�ɂ�SW_WRAMMap���K�v�ł�
	.ENDIF
	.IF SW_OpenSubScreenAtSliding&!SW_ContinueGrabbingLadderEtc
	.fail SW_OpenSubScreenAtSliding�ɂ�SW_ContinueGrabbingLadderEtc���K�v�ł�
	.ENDIF
	.IF SW_SwitchWeapon&!SW_FastScroll
	.fail SW_SwitchWeapon�ɂ�SW_FastScroll���K�v�ł�
	.ENDIF
	.IF SW_AnywhereIce&!SW_WRAMMap
	.fail SW_AnywhereIce�ɂ�SW_WRAMMap���K�v�ł�
	.ENDIF
	.IF SW_RainbowStep&!SW_WRAMMap
	.fail SW_RainbowStep�ɂ�SW_WRAMMap���K�v�ł�
	.ENDIF

	.IF SW_CustomBlock
Const_16TileAttributeBits = $FC
	.ELSE
Const_16TileAttributeBits = $F0
	.ENDIF

	;����^�C�~���O�ł̏��������s���邩�ǂ���
EnableHook_StageInit              = SW_WRAMMap|SW_DisableCollision|SW_EffectEnemyEx
EnableHook_AtCloseSubScreen       = SW_DisableCollision
EnableHook_AtRoomScrolling        = SW_WRAMMap
EnableHook_Reset                  = SW_WRAMMap|SW_DisableCollision|SW_EffectEnemyEx|SW_SpriteSetup_WireMoth

	.IF FillUnusedSpace22
FillTest .macro
	SETBANK8000
	TRASH_GLOBAL_LABEL
	.IF ((\1)&$1FFF)!=$0000
	PaddingTill ((\1)&$FF1FFF)|$8000
	.ELSE
	PaddingTill ((\1)&$FF1FFF)|$A000
	.ENDIF
	.endm
	.ELSE
FillTest .macro
	SETBANK8000
	TRASH_GLOBAL_LABEL
	.IF ((\1)&$1FFF)!=$0000
	END_BOUNDARY_TEST ((\1)&$FF1FFF)|$8000
	.ELSE
	.ENDIF
	.endm
	.ENDIF

	.IF SW_WRAMMap
	.include "src/WRAMMap.asm"
	.ENDIF
	.IF SW_MidExp
	.include "src/MidExp.asm"
	.ENDIF
	.IF SW_DisableCollision
	.include "src/DisableCollision.asm"
	.ENDIF
	.IF SW_OmitTerrainCollision
	.include "src/ObjClsOmit.asm"
	.ENDIF
	.IF SW_EffectEnemyEx
	.include "src/R5E_EEE.asm"
	.ENDIF
	.IF SW_Haikei
	.include "src/R5E_Haikei.asm"
	.ENDIF
	.IF SW_FastScroll
	.include "src/R5E_FastScroll.asm"
	.ENDIF
	.IF SW_CustomBlock
	.include "src/CustomBlock.asm"
	.ENDIF



	.IF EnableHook_StageInit
	.include "src/StageInit.asm"
	.ENDIF 
	.IF EnableHook_AtCloseSubScreen
	.include "src/AtCloseSubScreen.asm"
	.ENDIF
	.IF EnableHook_AtRoomScrolling
	.include "src/AtRoomScrolling.asm"
	.ENDIF
	.IF EnableHook_Reset
	.include "src/reset.asm"
	.ENDIF

	.include "src/misc.asm" ;WRAMMap.asm�����ɂ����Ă�������
	;pool�͍Ō�ɒu������
	.include "src/pool.asm"

	;���e�X�g�p�̃}�b�v(�R�����g�A�E�g���Y��Ȃ��悤��)
;	.include "TEST_MAP.asm"
