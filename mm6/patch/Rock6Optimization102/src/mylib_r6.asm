	.include "mylib.asm"


ioMMC3Cmd     = $8000
ioMMC3Value   = $8001


vPadHold       = $40 ;<vPadHold;ABETUDLR
vPadPress      = $42 ;<vPadPress;ABETUDLR
vPrePadXOR     = $44 ;<vPrePadXOR;ABETUDLR
vColorTrig     = $46
aAddrPage      = $52;array2
vScreenXhi     = $56
vScreenXhe     = $57
vCurBnk8       = $4A
vCurBnkA       = $4B
vMMC3Cmd       = $4C
vCurStage      = $51
vTrigNTXfer    = $60
vAddrChipHi    = $63
vAddrTileHi    = $67
vMapBank8      = $6E
vMapBankA      = $6F
vLastScrollDirection = $70
vVRAMXferSize  = $87
vProcessingObj = $8F
vRockAppState  = $94 ;<vRockAppState ;���b�N�}���̌��������([�~�����X��[Je��)
vRush          = $9B
vChargeTime    = $9E
vCurWeaponColor = $AE
vAudio         = $DC
vVxloW         = $EB
vVyloW         = $EC
vVxhiW         = $ED
vVyhiW         = $EE
vFrameCounter  = $F3
vRasterEnabled = $F4
vScreenX       = $F7
vScreenNT      = $F8
vNTMirroring   = $FB
vPPUCnt0       = $FC
vPPUCnt1       = $FD



aSprDMASrc     = $0200;array100
aNTColor       = $0300;array40
aChipVaried    = $0340;array20
aColor         = $0360
aPreColor      = $0380

oType         = $03A0
oFlag         = $03B7
oDir          = $03CE
oHP           = $03E5
oPlacementID  = $03FC
oHandlerhi    = $0413
oHandlerlo    = $042A
oHandlerbank  = $0441
oSprBank      = $0458
oXhe          = $046F
oXhi          = $0486
oXlo          = $049D
oYhe          = $04B4
oYhi          = $04CB
oYlo          = $04E2
oAnimLoop     = $04F9
oAnimOrder    = $0510
oSprAddrhi    = $0527
oSprAddrlo    = $053E
oAnimTimer    = $0555

oHitFlag      = $056C
oHitDamage    = $0583
oHitSize      = $059A

vCheckPointPage  = $0684

aWeaponEnergy_dummy = $0688
aWeaponEnergy    = $0689
aClearFlag       = $0692

vForceMoveRocklo = $069A
vForceMoveRockhi = $069B

vSubCursorX      = $06A2
vSubCursorY      = $06A3
vSubCursorA      = $06A4
vFullChargeTime  = $06AB

oVal0      = $05B1
oVal1      = $05C8
oVal2      = $05DF
oVal3      = $05F6
oVal4      = $060D
oVal5      = $0624

vCurRaster = $0676
vNewRaster = $0677
vCurWeapon = $0699

aNTXfer = $07B0;array20


rStartCertainThread = $C5C7 ;rStartCertainThread ;x�̒l�ɉ����Ĉ��̃X���b�h���J�n
rStopThread         = $C5F0 ;rStopThread ;�X���b�hy���~
rWaitThreadA        = $C5F6 ;rWaitThreadA ;a�t���[��������҂�
rWaitThread         = $C62B ;rWaitThread ;1�t���[��������҂�
rRandomize          = $C88D ;���������ϐ����X�V����
rAudio              = $C8B2 ;rAudio ;�I�[�f�B�I�L���[�ɒǉ�
rTransferPalette    = $C9EF ;rTransferPalette ;�p���b�g�ԍ�a��]��
rReserveTransfer2   = $CAA4
rReserveTransfer    = $CAAA ;rReserveTransfer ;VRAM�]��a�����s/�󋵂ɂ��L���[���J���̂�҂�
rRoutineCall        = $CB28 ;rRoutineCall ;���ɑ���1�o�C�g�ɑΉ����郋�[�`�����Ă�
rBankCngAX_p        = $CB91 ;rBankCngAX_p ;���݂̃o���N���X�^�b�N�ɐς݁A(a,*)�Ƀo���N�؂�ւ�
rBankCngYYp1        = $CBC0 ;rBankCngYYp1 ;(y,y+1)�Ƀo���N�؂�ւ�
rBankCngXA          = $CBDA ;rBankCngXA ;(*,a)�Ƀo���N�؂�ւ�
rResumeBank         = $CBE9 ;rResumeBank ;�X�^�b�N�ɋl�܂ꂽ�o���N�𕜌�����
rDivision16         = $CC70 ;rDivision16 ;$5~$4=$1.$0/$3.$2_x�ێ�

rPadHack            = $D42E ;rPadHack ; �p�b�h��a(���E�̂�)�ɏ㏑��
rPadHack_B          = $D434 ;rPadHack_B ; �p�b�h��a(���E�̂�)�ɏ㏑��(B�݈̂ێ�)
rTerrainHit         = $D9D1 ;rTerrainHit ;$11|=�`�b�v����,$13=�`�b�v�ԍ�
rTerrainHitX        = $D9D3 ;rTerrainHitX ;$11|=�`�b�v����,$13=�`�b�v�ԍ�
rPushBackH          = $DB53 ;rPushBackH ;Obj[x]�𐅕������ɉ����߂��v�Z(�Ō�ɔ��肵��X���W�𗘗p)
rPushBackV          = $DB71 ;rPushBackV ;Obj[x]�𐂒������ɉ����߂��v�Z(�Ō�ɔ��肵��Y���W�𗘗p)
dBitTable           = $DFB5

dDirPerPad          = $E1D1

rSetupSprite_Obj    = $E1E1
rYieldDelete        = $E45A ;rYieldDelete ;�����Ԃ�/���݃I�u�W�F�N�g���폜
rYield              = $E46C ;rYield ;�����Ԃ�
rYieldNotUpdatePtr  = $E47B ;rYieldNotUpdatePtr ;�����Ԃ�/jmp�ŌĂԎ�/�����ʒu�X�V�Ȃ�
rIsInScreen         = $E489 ;rIsInScreen ;��ʓ����ǂ���(��clc�Osec)
rIsInScreenX        = $E495 ;rIsInScreenX ;X���W����ʓ����ǂ���(��clc�Osec)
rMoveInt            = $E4CF ;rMoveInt ;Obj[CurObj]��($ED,$EE)�ړ�
rMove               = $E4D5 ;rMove ;Obj[CurObj]��($ED~EB,$EE~EC)�ړ�
rMove_              = $E4D7 ;rMove_ ;Obj[x]��($ED~EB,$EE~EC)�ړ�
rMoveY_             = $E4F5 ;rMoveY_ ;Obj[x]��(0,$EE~EC)�ړ�
rSetAnim            = $E526 ;rSetAnim ;obj[x]�̌�������y��/x�ێ�/y�j��
rSetAnim2           = $E561
rNewObjP            = $E594 ;rNewObjP ;x=newObj(PlacementID=y)/���ɑ��݁E�L�����N�^�I�[�o�[��sec
rNewObjSeek         = $E59F ;rNewObjSeek ;x=�󂫃I�u�W�F�N�g
rNewObj             = $E5AF ;rNewObj ;x=newObj(Type=y)
rNewObj_            = $E5B4 ;rNewObj_ ;x�ɃI�u�W�F�N�g���쐬(Type=y)
rGetDirH            = $E5BA ;rGetDirH ; $11=4,C(���b�N�}���̌���)
rFaceDir            = $E5E3
rPolarMove          = $E612 ;rPolarMove ;Obj[x]��y�Ŏ�����鑬���ŁA���݂̌����Ɉړ�
rPolarMoveF         = $E618
rSetupPolerV        = $E61E
rPlaceDelta2        = $E8C0 ;rPlaceDelta2 ;Obj[x]��Obj[y]���班�����炵���ꏊ�ɔz�u(�����l��)
rPlaceDelta3        = $E8D0 ;rPlaceDelta3 ;Obj[x]��Obj[y]���班�����炵���ꏊ�ɔz�u(�����l��2)
rPlaceDelta         = $E901 ;rPlaceDelta ;Obj[x]��Obj[y]���班�����炵���ꏊ�ɔz�u
rYieldEnemy         = $E9D7 ;rYieldEnemy ;�����Ԃ�(�U�R)
rYieldEnemy_        = $E9E1 ;rYieldEnemy_ ;�����Ԃ�(�U�R)/Obj[x]/�_�Ńt���O���N���A���Ȃ�
rYieldMidExp        = $EA20 ;rYieldMidExp ;�����Ԃ�(�U�R�E�~�h������)
rYieldInc           = $EA6E ;rYieldInc ;�����Ԃ�(���G/��ʊO�폜)
rYieldInc_          = $EA80 ;rYieldInc_ ;�����Ԃ�(���G/��ʊO�폜/���ŏ����Ȃ�)
rSetupObj           = $EBD5 ;rSetupObj ;[-1]�㑮��/��Dmg[-2]HP[-3]����No[-4]�]���G[-5]Pal[-6]AniNo
rMoveFG40           = $EC0A ;
rMoveFG2A           = $EC0E ;
rMoveFGxx           = $EC10
rMoveF              = $EC15 ;
rMoveF_             = $EC18 ;
rMoveF__            = $EC81 ;rMoveF__ ;���[�`���̓r��(EC81)
rVyG                = $ECA8 ;rVyG ;�d��($00)���Z(Vy:Val2,3)/���x�Z�b�g�A�b�v
rVyG_               = $ECAD
rCollisionW         = $ECC8 ;rCollisionW ;x�Ƒ�Obj�̏Փ˔���/�q�b�g��cs,y�ɕԂ�
rCollisionW_        = $ECCD ;rCollisionW_ ;x�Ƒ�Obj�̏Փ˔���/y���W���w��/�q�b�g��cs,y�ɕԂ�
rCollisionW_next    = $ECF9 ;
rSlowAim            = $ED05
rPlaceTiwnBGMOffSE  = $ED42 ;BGM���I�t�ɂ��A���ʉ���炵��16�e�B�E���z�u
rCollision0         = $EDAC 
rCollisionY         = $EDAE 
rVxAcc              = $EE1D ;rVxAcc ;Vx(Val0,1)�Z�b�g/y�w��̑��x���Z/�I�[���xa/x�ێ�
rVxAccI             = $EE6D ;rVxAccI ;Vx(Val0,1)�Z�b�g/y�w��̑��x���Z/�I�[���xa/x�ێ�
rVyAcc              = $EE9E ;rVyAcc ;Vy(Val4,5)�Z�b�g/y�w��d�͉��Z/x�ێ�
rVyAccI             = $EECD ;rVyAccI ;Vy(Val4,5)�Z�b�g/y�w��d�͌��Z/x�ێ�
rFaceRock           = $EF10
rDirMirror          = $EF1C
rFaceMirror         = $EF24

rCollisionXY        = $F716 ;rCollisionXY ;Obj(x��y)�̏Փ˔���(����T�C�Y$8,$A)
rCollisionAnyY      = $F72A ;rCollisionAnyY ;Obj(y��(1~0,3~2))�̏Փ˔���(����T�C�Y$8,$A)
rAtan16             = $F8B2 ;rAtan16 ;atan(Obj(x��y))/$11��a�ɕԂ�
dBitTable_r         = $FF58
