;アセンブルスイッチ（サブ）/メインのスイッチのテストや、それに依存するもの

	.IF SW_FastScrolling | SW_SwitchWeapon | SW_OmitRushAdaptor=2 ;高速転送を利用するか{
SW_FastTransfer = 1
	.ENDIF ;}
	.IF SW_OptimizeCollision | SW_OptimizeTerrain2 | SW_FixRockMove_Terrain ;サウンドのキューを小さくして変数を確保するか{
SW_MinimizeAudioQueue = 1
	.ENDIF ;}

	.IF SW_OptimizeTerrain & SW_OptimizeTerrain2
	.FAIL SW_OptimizeTerrainとSW_OptimizeTerrain2は同時に設定できません
	.ENDIF ;}

	.IF SW_FixRockMove_Block & !SW_FixRockMove_Wait
	.FAIL SW_FixRockMove_BlockにはSW_FixRockMove_Waitが必要です
	.ENDIF ;}
	.IF SW_FixSpriteGlitch_LEdge | SW_SynchronizeAnimation | SW_OptimizeDMASrcFilling ;{
	.IF !SW_FixSpriteGlitch_LEdge | !SW_SynchronizeAnimation | !SW_OptimizeDMASrcFilling
	.FAIL SW_FixSpriteGlitch_LEdge/SW_SynchronizeAnimation/SW_OptimizeDMASrcFillingは3つ対で設定が必要です
	.ENDIF
	.ENDIF ;}

