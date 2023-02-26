;アセンブルオプション
;
;1:有効 / 0:無効     他の値は指定しないで下さい。（※一部例外あり）
;オプション同士が衝突する場合は、一応エラーを出すようにしてありますが
;見落としがあるかもしれません

;●最適化(by ぷれさべー)
Enable_WRAMMap                = 1 ;
Enable_MidExp                 = 1 ;
Enable_Misc_WriteAudioReg     = 1 ;Enable_WRAMMapが必要
Enable_Misc_NMIExit           = 1 ;
Enable_Misc_Gauge             = 0 ;Enable_SetupGaugeSpritesと同時に不可
Enable_Misc_ClearDMASrc       = 1 ;
Enable_Disable_Collision      = 1 ;
Enable_Misc_DisCollRW         = 1 ;

;●最適化(by Rock5easily)
Enable_UseTableAtTerrainProc  = 0 ;Enable_WRAMMapと同時に不可
Enable_UnrollingSwChrBank     = 1 ;
Enable_UnrollingPalTransfer   = 1 ;
Enable_SetupGaugeSprites      = 1 ;
Enable_UnrollingSearchSlot    = 1 ;
Enable_UpdateObjectPointer    = 1 ;
Enable_ForegroundOmission     = 0 ;Enable_WRAMMapと同時に不可
Enable_JoypadOmission         = 1 ;
Enable_DebugModeOmission      = 1 ;
Enable_UpdateOAMPointer       = 1 ;
Enable_ObjMoveLR              = 1 ;
Enable_Rock2ObjCollision      = 1 ;
Enable_BankSwitch             = 1 ;

;●機能拡張等(by ぷれさべー)
Enable_SlidingCharge          = 1 ;
Enable_InvincibleTimeType     = 3 ;※0:無効 1:ザコ無敵無効 2:ザコ無敵スルー 3:ザコボス無敵スルー
Enable_GoodDog                = 1 ;
Enable_SlidingJumpInWaterEtc  = 1 ;
Enable_DisableChargeCancel    = 1 ;
Enable_QuickRecover           = 1 ;
Enable_QuickFade              = 1 ;
Enable_FixEnemyOffsetAtWarp   = 1 ;
Enable_FixPukaPukaWarp        = 1 ;
Enable_FixDownScrollingGlitch = 1 ;
Enable_FixArrowZipping        = 1 ;Enable_WRAMMapが必要
Enable_FixPWCSkip             = 1 ;
Enable_FixLadderAtAntigravity = 1 ;
Enable_FixAwkwardMoveAfterSlide = 1 ;
Enable_NerfedSpike            = 1

;●機能拡張等(by Rock5easily)
Enable_WeaponSelect           = 1 ;
Enable_BossRoomJump           = 1 ;
Enable_6BitAttribute          = 1 ;
Enable_SpriteAutoCoordination = 1 ;

;●その他
FillUnusedSpace22             = 1 ; 非ゼロだと未使用領域を22(非公開命令KIL/プロセッサ停止)で埋める
WRAMMap_ModifyMap             = 1 ; Enable_WRAMMapと共に非ゼロだと、マップデータの一部を書き換える






_SW_asm_Included = 0 ;このファイルがinclude済みか（値を変更する必要なし）
;公開用プリセット３種類をアセンブルしやすいための工夫です
