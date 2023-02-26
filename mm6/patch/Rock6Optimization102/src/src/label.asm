;各種ラベル
Label_org:
	BANKORG Label_org


cRockSlideDx = $0E

	.IFDEF SW_MinimizeAudioQueue
;開けたゼロページメモリ
;Tmpは利用したら用途を後ろに書いておくと安全
vTmpA = $B8 ;汎用/衝突判定,マップ読み込み,地形判定,地形変化時処理
vTmpB = $B9 ;汎用/衝突判定,マップ読み込み,落下床生成時
vTmpC_00 = $BA ;00であることが保証されている
vTmpD = $BB ;汎用/地形判定,地形変化時処理,NT転送処理
;$BC
;$BD
;$BE
;$BF
	.ENDIF

	.IF SW_OptimizeTerrain ;{
aChip          = $6000;array400
aChipFlag      = $6400;array100
aChipV         = $6500;array400
aChipFlagV     = $6900;array100
aTile          = $6A00;array400
aPage          = $6E00;array800
;下位バイトが00であれば動かせます
;7600-
	.ENDIF ;}
	.IF SW_OptimizeTerrain2 ;{
aChip          = $6000;array1000
aChipGrp       = $7000;array400 ;Grpの次はFlagCの必要がある
aChipFlagC     = $7400;array100 ;
aChipFlagT     = $7500;array100
;7600-
	.ENDIF ;}
vLongCallTmp      = $7800
vPrevYhi          = $7801
vRock2TerrainTmp0 = $7802
vRock2TerrainTmp1 = $7803
vTerrain2Shutter  = $7804
vWeaponTransfer   = $7805
aWeaponGrpAddr    = $7806;array3
aProcIsFalling    = $7809;array2
vSpikeTouched     = $780B 
;$780C-$780F
aTblSpriteOrder   = $7810;array30

aTblHighNibble    = $7F00;array100

LONG_CALL .macro
	jsr Misc_LongCall
	.db HIGH((\1)-1)
	.db LOW ((\1)-1)
	.db BANK(\1)
	.endm

LONG_CALL_D .macro
	jsr Misc_LongCall
	.db HIGH((\1&$FFFF)-1)
	.db LOW ((\1&$FFFF)-1)
	.db (\1>>16)
	.endm
