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
oFlag    = $0420 ; oFlag, ;���E�H�H�e�d����
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
olXr      = $06E0 ;��ʑ���X
ohHitSize = $06E0
;���[�`��

rSwapPrg      = $C000 ; jsr rSwapPrg ;�o���N�؂�ւ�
rSound        = $C051 ;	jsr rSound ; ��a��炷
rFieldTest    = $CB9F ;	jsr rFieldTest ;�n�`(9~8,B~A)�̑����擾
rCreateWeapon = $D3DD ;	jsr rCreateWeapon ;Obj[x]�ɕ���y���쐬
rShotPose     = $DA87 ;	jsr rShotPose ;���b�N�}�����V���b�g�p����
rSplitWeapon  = $E4FC ;	jsr rSplitWeapon ;Obj[x]�̈ʒu��Obj[$00]�̕���y��z�u
rCommonWeaponProc = $EECD ;	jsr rCommonWeaponProc ;���ʕ��폈��
rTerrainTest = $F0AD ;	jsr rTerrainTest ;Obj[x]���,�n�ʔ���(X�}$01,Y+$02)/($03,$00)�ɕԂ�



