	.include "mylib.asm"
	

vFrameCounter = $1C
vScrollXhi    = $1F
vScrollXhe    = $20

vPadOn      = $23 ; vPadOn ; RLDUTEBA
vPadPress    = $27 ; vPadPress ; RLDUTEBA

vCurStage          = $2A
vProcessingObj     = $2B
vRockmanState      = $2C
vRockPosingTimer   = $36
vRockPosing        = $3D
vInvincibleTime    = $4B

vCurPrgBank = $69
aWeaponEnergy = $9C

vCurWeapon    = $A9
vWeaponEnergyCounter = $AC

vRockmanYhe = $F9

aDMASrc  = $0200

oType    = $0400
oFlag    = $0420 ; oFlag, ;存右？？弾重特当
oXhe     = $0440
oXhi     = $0460
oXlo     = $0480
oYhi     = $04A0
oYlo     = $04C0
oVal0    = $04E0

olHitSize = $0590

oVal1    = $05A0
oVal2    = $05C0
oVal3    = $05E0
oVxhi    = $0600
oVxlo    = $0620
oVyhi    = $0640
oVylo    = $0660
oSprTimer = $0680
oSprOrder = $06A0
oHP      = $06C0
olXr      = $06E0 ;画面相対X
ohHitSize = $06E0
;ルーチン

rSwapPrg      = $C000 ; jsr rSwapPrg ;バンク切り替え
rSound        = $C051 ;	jsr rSound ; 音aを鳴らす
rFieldTest    = $CB9F ;	jsr rFieldTest ;地形(9~8,B~A)の属性取得
rCreateWeapon = $D3DD ;	jsr rCreateWeapon ;Obj[x]に武器yを作成
rShotPose     = $DA87 ;	jsr rShotPose ;ロックマンをショット姿勢に
rSplitWeapon  = $E4FC ;	jsr rSplitWeapon ;Obj[x]の位置にObj[$00]の武器yを配置
rCommonWeaponProc = $EECD ;	jsr rCommonWeaponProc ;共通武器処理
rTerrainTest = $F0AD ;	jsr rTerrainTest ;Obj[x]を壁,地面判定(X±$01,Y+$02)/($03,$00)に返す



