	.IF SW_EffectEnemyEx
vEffectEnemyEx = $2C
	.ENDIF

aMap     = $6000;array1000
aChipGrp = $7000;array400
aChipHit = $7400;array100

;7500
;7600
vWaterFlag = $7600
vEnableSkull = $7601
aProcTerrainHB_Exc = $7602;array2
aProcTerrainVB_Exc = $7604;array2
aProcTerrainHB_InitExc = $7606;array2
aProcTerrainVB_InitExc = $7608;array2
aProcTerrainHB_EndExc  = $760A;array2
vForegroundFlag = $760C
vLoadMap_Step = $760D
vTransferWeapon = $760E
;760F
;7610-761F
aProcSpriteSetup_Wire = $7620
aProcSpriteSetup_Moth = $7622
aProcIce0             = $7624
aProcIce1             = $7626
aProcIce2             = $7628
aProcCustomBlock_Conv = $762A
aProcCustomBlock_FlSn = $762C ;êÖó¨Ç∆ê·
aProcCustomBlock_Sand = $762E
aProcRainbowStep      = $7630
aTerrainExists        = $7640;array40
;7700
;7800
;7900
;7A00
;7B00
;7C00
;7D00
;7E00
aFastTransferQueue = $7F00;array90
vFastTransferTrig  = $7F90

