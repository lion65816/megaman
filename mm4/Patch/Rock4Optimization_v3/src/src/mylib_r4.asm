vPadPush  = $14 ;vPadPush ; ABETUDLR
vPadPush2 = $15
vPadHold  = $16 ;vPadHold ; ABETUDLR
vPadHold2 = $17
vPalTrig  = $18
vVRAMTrig1 = $19
vVRAMTrig32 = $1A
vTransferBackNT = $1B
vTransfer32Tile = $1D
vDrillStep = $1E
vCurStage = $22
vLastNTDrawDirection = $23
vNTDrawlo = $24
vNTDrawhi = $2A
vRoomFlag = $2B
vPagesOfRoom = $2D
vPageInRoom  = $2E
vRockmanState = $30
vLastInputLR  = $31
vSignificantTerrain = $41
aTerrain     = $45
vCurRaster   = $5D
vFrameCounterP = $92
vFrameCounterS = $95
vDMASrcPointer = $97
vCurWeapon = $A0
vClearedCapsule = $AC
aWeaponEnergy  = $B0
vProcessingObj = $EB
vNewRaster   = $F0
	.IF !SW_BankSwitch ;SW_BankSwitch定義時は利用不可能にする
vCurPrg8  = $F3
vCurPrgA  = $F4
	.ENDIF
vNewPrg8  = $F5
vNewPrgA  = $F6
vMMCSemaphore = $F7
vDelayedAudioProc = $F8
vScrollXhi = $F9
vScrollY   = $FA
vScrollX   = $FC
aGauge     = $0130
vSubCursor = $0138
vBossIndex = $0146
vSceneTimer = $0148
aDMASrc = $0200;array100
oType = $0300;array18
oXlo = $0318;array18
oXhi = $0330;array18
oXhe = $0348;array18
oYlo = $0360;array18
oYhi = $0378;array18
oYhe = $0390;array18
oVxlo = $03a8;array18
oVxhi = $03C0;array18
oVylo = $03d8;array18
oVyhi = $03f0;array18
oHitFlag = $0408;array18
;oHitFlag, ; <体弾[判定サイズ]>
oDirection = $0420 ;array18
;oDirection, ; <????上下左右>
oPlacementID = $0438;array18
oHP = $0450;array18
oVal0 = $0468;array18
oVal1 = $0480;array18
oVal2 = $0498;array18
oVal3 = $04b0;array18
oVal4 = $04C8;array18
oVal5 = $04E0;array18
oVal6 = $04F8;array18
oVal7 = $0510;array18
oFlag = $0528;array18
;oFlag, ; <画向優補外見ブ乗>
oAniOrder = $0540;array18
oAniNo = $0558;array18
oAniTimer = $0570;array18
oProcessPtrlo = $0588;array18
oProcessPtrhi = $05a0;array18
oBlink = $05B8;array18
aCurPal = $0600;array20
aPrePal = $0620;array20
aNTColor   = $0640;array40
aVRAMQueue = $0780;array40

OBJX_SET_ROUTINE	.macro
	lda #LOW (\1)
	sta oProcessPtrlo,x
	lda #HIGH(\1)
	sta oProcessPtrhi,x
	.endm
OBJY_SET_ROUTINE	.macro
	lda #LOW (\1)
	sta oProcessPtrlo,y
	lda #HIGH(\1)
	sta oProcessPtrhi,y
	.endm


rScreenOn       = $C373
rFadeIn         = $C451
rGetTileAddr    = $D2A2
rGetPageAddr_bs = $D2CE
rGetPageAddr    = $D2D7
rTerrainTestHB  = $D2FC
rDeleteObjX     = $DC00
rYmoveG         = $F2A7 ;重力加算しつつY移動
rSetVyA00       = $F31B
rXpmeVxT        = $F3ED ;X+-=Vx(地形判定有り)
rXpmeVx         = $F413 ;X+-=Vx
rYpmeVy         = $F434 ;Y+-=Vy
rSetAnim        = $F446
rPlaceObjYAtX   = $F452 ;Obj[X]の位置にObj[Y](AniNo=a)を配置
rBGM            = $F6BC
rSE             = $F6BE
rHitTestToRock  = $F95D
rDeleteRockWeapon = $FDDE

rPrgBankSwap    = $FF37
