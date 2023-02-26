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
vRockAppState  = $94 ;<vRockAppState ;ロックマンの見かけ状態([止動歩ス梯端Je空)
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


rStartCertainThread = $C5C7 ;rStartCertainThread ;xの値に応じて一定のスレッドを開始
rStopThread         = $C5F0 ;rStopThread ;スレッドyを停止
rWaitThreadA        = $C5F6 ;rWaitThreadA ;aフレーム処理を待つ
rWaitThread         = $C62B ;rWaitThread ;1フレーム処理を待つ
rRandomize          = $C88D ;乱数内部変数を更新する
rAudio              = $C8B2 ;rAudio ;オーディオキューに追加
rTransferPalette    = $C9EF ;rTransferPalette ;パレット番号aを転送
rReserveTransfer2   = $CAA4
rReserveTransfer    = $CAAA ;rReserveTransfer ;VRAM転送aを実行/状況によりキューが開くのを待つ
rRoutineCall        = $CB28 ;rRoutineCall ;次に続く1バイトに対応するルーチンを呼ぶ
rBankCngAX_p        = $CB91 ;rBankCngAX_p ;現在のバンクをスタックに積み、(a,*)にバンク切り替え
rBankCngYYp1        = $CBC0 ;rBankCngYYp1 ;(y,y+1)にバンク切り替え
rBankCngXA          = $CBDA ;rBankCngXA ;(*,a)にバンク切り替え
rResumeBank         = $CBE9 ;rResumeBank ;スタックに詰まれたバンクを復元する
rDivision16         = $CC70 ;rDivision16 ;$5~$4=$1.$0/$3.$2_x維持

rPadHack            = $D42E ;rPadHack ; パッドをa(左右のみ)に上書き
rPadHack_B          = $D434 ;rPadHack_B ; パッドをa(左右のみ)に上書き(Bのみ維持)
rTerrainHit         = $D9D1 ;rTerrainHit ;$11|=チップ属性,$13=チップ番号
rTerrainHitX        = $D9D3 ;rTerrainHitX ;$11|=チップ属性,$13=チップ番号
rPushBackH          = $DB53 ;rPushBackH ;Obj[x]を水平方向に押し戻す計算(最後に判定したX座標を利用)
rPushBackV          = $DB71 ;rPushBackV ;Obj[x]を垂直方向に押し戻す計算(最後に判定したY座標を利用)
dBitTable           = $DFB5

dDirPerPad          = $E1D1

rSetupSprite_Obj    = $E1E1
rYieldDelete        = $E45A ;rYieldDelete ;制御を返す/現在オブジェクトを削除
rYield              = $E46C ;rYield ;制御を返す
rYieldNotUpdatePtr  = $E47B ;rYieldNotUpdatePtr ;制御を返す/jmpで呼ぶ事/処理位置更新なし
rIsInScreen         = $E489 ;rIsInScreen ;画面内かどうか(内clc外sec)
rIsInScreenX        = $E495 ;rIsInScreenX ;X座標が画面内かどうか(内clc外sec)
rMoveInt            = $E4CF ;rMoveInt ;Obj[CurObj]を($ED,$EE)移動
rMove               = $E4D5 ;rMove ;Obj[CurObj]を($ED~EB,$EE~EC)移動
rMove_              = $E4D7 ;rMove_ ;Obj[x]を($ED~EB,$EE~EC)移動
rMoveY_             = $E4F5 ;rMoveY_ ;Obj[x]を(0,$EE~EC)移動
rSetAnim            = $E526 ;rSetAnim ;obj[x]の見かけをyに/x維持/y破壊
rSetAnim2           = $E561
rNewObjP            = $E594 ;rNewObjP ;x=newObj(PlacementID=y)/既に存在・キャラクタオーバーでsec
rNewObjSeek         = $E59F ;rNewObjSeek ;x=空きオブジェクト
rNewObj             = $E5AF ;rNewObj ;x=newObj(Type=y)
rNewObj_            = $E5B4 ;rNewObj_ ;xにオブジェクトを作成(Type=y)
rGetDirH            = $E5BA ;rGetDirH ; $11=4,C(ロックマンの向き)
rFaceDir            = $E5E3
rPolarMove          = $E612 ;rPolarMove ;Obj[x]をyで示される速さで、現在の向きに移動
rPolarMoveF         = $E618
rSetupPolerV        = $E61E
rPlaceDelta2        = $E8C0 ;rPlaceDelta2 ;Obj[x]をObj[y]から少しずらした場所に配置(向き考慮)
rPlaceDelta3        = $E8D0 ;rPlaceDelta3 ;Obj[x]をObj[y]から少しずらした場所に配置(向き考慮2)
rPlaceDelta         = $E901 ;rPlaceDelta ;Obj[x]をObj[y]から少しずらした場所に配置
rYieldEnemy         = $E9D7 ;rYieldEnemy ;制御を返す(ザコ)
rYieldEnemy_        = $E9E1 ;rYieldEnemy_ ;制御を返す(ザコ)/Obj[x]/点滅フラグをクリアしない
rYieldMidExp        = $EA20 ;rYieldMidExp ;制御を返す(ザコ・ミドル爆発)
rYieldInc           = $EA6E ;rYieldInc ;制御を返す(無敵/画面外削除)
rYieldInc_          = $EA80 ;rYieldInc_ ;制御を返す(無敵/画面外削除/上空で消えない)
rSetupObj           = $EBD5 ;rSetupObj ;[-1]上属性/下Dmg[-2]HP[-3]判定No[-4]転送絵[-5]Pal[-6]AniNo
rMoveFG40           = $EC0A ;
rMoveFG2A           = $EC0E ;
rMoveFGxx           = $EC10
rMoveF              = $EC15 ;
rMoveF_             = $EC18 ;
rMoveF__            = $EC81 ;rMoveF__ ;ルーチンの途中(EC81)
rVyG                = $ECA8 ;rVyG ;重力($00)加算(Vy:Val2,3)/速度セットアップ
rVyG_               = $ECAD
rCollisionW         = $ECC8 ;rCollisionW ;xと他Objの衝突判定/ヒットでcs,yに返す
rCollisionW_        = $ECCD ;rCollisionW_ ;xと他Objの衝突判定/y座標を指定/ヒットでcs,yに返す
rCollisionW_next    = $ECF9 ;
rSlowAim            = $ED05
rPlaceTiwnBGMOffSE  = $ED42 ;BGMをオフにし、効果音を鳴らしつつ16ティウン配置
rCollision0         = $EDAC 
rCollisionY         = $EDAE 
rVxAcc              = $EE1D ;rVxAcc ;Vx(Val0,1)セット/y指定の速度加算/終端速度a/x維持
rVxAccI             = $EE6D ;rVxAccI ;Vx(Val0,1)セット/y指定の速度減算/終端速度a/x維持
rVyAcc              = $EE9E ;rVyAcc ;Vy(Val4,5)セット/y指定重力加算/x維持
rVyAccI             = $EECD ;rVyAccI ;Vy(Val4,5)セット/y指定重力減算/x維持
rFaceRock           = $EF10
rDirMirror          = $EF1C
rFaceMirror         = $EF24

rCollisionXY        = $F716 ;rCollisionXY ;Obj(x⇔y)の衝突判定(判定サイズ$8,$A)
rCollisionAnyY      = $F72A ;rCollisionAnyY ;Obj(y⇔(1~0,3~2))の衝突判定(判定サイズ$8,$A)
rAtan16             = $F8B2 ;rAtan16 ;atan(Obj(x→y))/$11とaに返す
dBitTable_r         = $FF58
