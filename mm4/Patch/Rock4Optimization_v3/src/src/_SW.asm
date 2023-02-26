;アセンブルオプション
;
;1:有効 / 0:無効     他の値は指定しないで下さい。（※一部例外あり）

;●最適化(by ぷれさべー)
SW_WRAMMap                    = 1 ;SW_UseTableAtTerrainProcと同時に利用不可
SW_WRAMMap_OrgHack            = 1 ;
SW_WRAMMap_DrillLeverEx       = 1 ;
SW_MidExp                     = 1 ;
SW_DisableCollision           = 1 ;
SW_OmitTerrainCollision       = 1 ;SW_WRAMMapが必要
SW_WriteAudioReg              = 1 ;SW_WRAMMapが必要
SW_NMIExit                    = 1 ;
SW_Gauge                      = 0 ;SW_SetupGaugeSpritesと同時に利用不可
SW_ClearDMASrc                = 1 ;
SW_StampRockman               = 1 ;
SW_RockBubble                 = 1 ;
SW_MainLoopExit               = 1 ;
SW_SpriteSetup_WireMoth       = 1 ;
SW_DisableCapsuleForeground   = 1 ;
SW_DisableCpslFrgnd_OrgHack   = 1 ;SW_Haikeiが実質必要
SW_RainbowStep                = 1 ;SW_WRAMMapが必要
SW_EliminateJSRAtMainLoop     = 1 ;
SW_AudioDriverModPointer      = 1

;●最適化(by Rock5easily)
SW_UseTableAtTerrainProc      = 0 ;SW_WRAMMapと同時に利用不可
SW_UnrollingPalTransfer       = 1 ;
SW_SetupGaugeSprites          = 1 ;SW_Gaugeと同時に利用不可
SW_UnrollingSearchSlot        = 1 ;
SW_UpdateObjectPointer        = 1 ;
SW_JoypadOmission             = 1 ;
SW_UpdateOAMPointer           = 1 ;
SW_ObjMoveLR                  = 1 ;
SW_BankSwitch                 = 1 ;

;●機能拡張等(by ぷれさべー)
SW_FixTerrainThrough1         = 1 ;SW_WRAMMapが必要
SW_FixTerrainThrough2         = 1
SW_ThroughInvincibleBoss      = 0
SW_SlidingJumpInWaterEtc      = 1
SW_QuickRecover               = 1
SW_QuickFade                  = 2 ;0で無効 それ以外だとフレーム数(1だと早い)  -1で更に早い
SW_ContinueGrabbingLadderEtc  = 1
SW_OpenSubScreenAtSliding     = 1 ;SW_ContinueGrabbingLadderEtcが必要
SW_SwitchWeapon               = 1 ;SW_FastScrollが必要
SW_SparkPosition              = 0
SW_FixChargeShotColorGlitch   = 1
SW_FixSquareMachineGlitch     = 1
SW_FixRushJumpLadderGlitch    = 1
SW_Fix8BossCenterGlitch       = 1
SW_ExPortGlitchAtWeaponGetScr = 1
SW_AnywhereIce                = 1 ;SW_WRAMMapが必要
SW_FixRockWeaponsCollision    = 1
SW_FixKickBuster              = 1
SW_FixObjLeakOverScreen       = 1
SW_RainFlushMisfire           = 1
SW_FixWireGlitch              = 1
SW_FixBalloonStampGlitch      = 1
SW_SpikeCollisionByPlatform   = 0
SW_FixMarineStampGlitch       = 1
SW_EscarooGlitch              = 1
SW_SlidingFlashStopperGlitch  = 1
SW_KnockbackFlashStopperGlitch= 1
SW_NerfedSpike                = 0 ;0で無効 それ以外だと、ダメージ指定

;　メモ：その他バグ色々
;タコトラッシュと逃げるワイリーのダメージ設定
;ワイリーマシン第二形態が出るときのゲージ上昇
;ワイヤー中に足元のトゲに当たらない
;ファラオマンの表示バグ
;中ボスでフリーズバグ
;水面が上下する場所でマリンが浮くバグ



;●機能拡張等(by Rock5easily)
SW_EffectEnemyEx              = 1
SW_Haikei                     = 1 ;SW_WRAMMapがあると強化
SW_FastScroll                 = 1
SW_FastScroll_OrgHack         = 1
SW_DeleteTriWaveFromRefillSound = 1
SW_BossGaugeSpeed             = 2 ;0で無効 1-9で大きいほど遅い。原作は4。1だと音が聞こえなくなる。
SW_ETankSpeed                 = 4 ;0で無効。大きいほど遅くなる
SW_CustomBlock                = 1 ;SW_WRAMMapがあると強化
SW_CustomBlock_OrgHack        = 1 ;

;●その他
FillUnusedSpace22             = 1 ; 非ゼロだと未使用領域を22(非公開命令KIL/プロセッサ停止)で埋める






_SW_asm_Included = 0 ;このファイルがinclude済みか（値を変更する必要なし）
;公開用プリセット３種類をアセンブルしやすいための工夫です
