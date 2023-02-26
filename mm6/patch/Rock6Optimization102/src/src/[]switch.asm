;アセンブルスイッチ
;説明がなければ0か1を指定します。0が無効で、1が有効です。

                                ;vこの値は、サンプルの設定値です
;●最適化
SW_OptimizeTerrain          = 0 ;0 ;＼この２つは
SW_OptimizeTerrain2         = 1 ;1 ;／どちらか一方しか有効に出来ない
SW_OptimizeCollision        = 1 ;1
SW_OptimizeObjectSpriteProc = 1 ;1
SW_OptimizeSoundProcess     = 2 ;2 ;0:無効 1-3:有効,大きいほど消費容量と効果が上がる
SW_OptimizeGamepad          = 1 ;1

;●中途半端
SW_FixSpriteGlitch_LEdge    = 1 ;1 ;＼
SW_SynchronizeAnimation     = 1 ;1 ;　|この３つはまとめて0/1にしないとダメ
SW_OptimizeDMASrcFilling    = 1 ;1 ;／

;●機能追加
;・バグやぎこちない動きの変更
SW_FixRockMove_Sliding      = 1 ;1
SW_FixRockMove_Terrain      = 1 ;1
SW_FixRockMove_Block        = 1 ;1
SW_FixRockMove_Collision    = 2 ;2 ;0:無効 1:バグ修正 2:位置ずれ対応
SW_FixRockMove_Wait         = 1 ;1
SW_FixRockMove_HoverJump    = 1 ;1
SW_FixRockMove_FullJumpFromWater = 1 ;1
SW_FixPowerShotGlitchAtLadder = 1 ;1
SW_FixSpriteGlitch_Gauge    = 1 ;1
SW_FixNotJumpableFrame      = 1 ;1
;・機能追加・変更
SW_SwitchWeapon             = 1 ;1
SW_DisableChargeCancel      = 1 ;1
SW_FastScrolling            = 1 ;1
SW_QuickFading              = 2 ;2 ;0:無効 他:速さ
SW_OmitRushAdaptor          = 2 ;2 ;0:無効 1:完全除去 2:簡略化
SW_QuickRecovering          = 1 ;1
SW_NerfedSpike              = 0 ;0 ;0:無効 他:ダメージ値
SW_SmoothAirBrake           = 1 ;1 ;0:無効 1:4,5作目程度 2:2作目程度 3-:さらにふんわり
;・その他
SW_FixChargeBusterSE        = 1 ;1
SW_ModifyFallingBlockSize   = 1 ;1

;●最適化のテスト用のスイッチ
SW_DebugAlwaysHaveAdaptor    = 0 ;0
SW_Debug00FillAtLoadingStage = 0 ;0
SW_DebugTestMap              = 0 ;0
SW_DebugWarnSlowTransfer     = 0 ;0

	.include "src/[]switch2.asm"
