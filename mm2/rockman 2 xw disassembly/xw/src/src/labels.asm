
V_FrameCounter = $1C

V_PadOn      = $23 ; V_PadOn ; RLDUTEBA
V_PadPush    = $27 ; V_PadPush ; RLDUTEBA

V_ProcessingObj = $2B
V_RockmanState = $2C

V_CurPrgBank = $69
A_WeaponEnergy = $9C

V_CurWeapon    = $A9
V_WeaponEnergyCounter = $AC

V_RockmanYhe = $F9

V_FrameCounterS = $0180 ;�X�^�b�N���n���P�o�C�g�q��

A_ObjType    = $0400
A_ObjFlag    = $0420 ; A_ObjFlag, ;���E�H�H�e�d����
A_ObjXhe     = $0440
A_ObjXhi     = $0460
A_ObjXlo     = $0480
A_ObjYhi     = $04A0
A_ObjYlo     = $04C0
A_ObjVal0    = $04E0

A_LObjHitSize = $0590

A_ObjVal1    = $05A0
A_ObjVal2    = $05C0
A_ObjVal3    = $05E0
A_ObjVxhi    = $0600
A_ObjVxlo    = $0620
A_ObjVyhi    = $0640
A_ObjVylo    = $0660
A_ObjSprTimer = $0680
A_ObjSprNo    = $06A0
A_ObjHP      = $06C0







;���[�`��


R_SoundOn      = $C051 ;	jsr R_SoundOn ; ��a��炷
R_FieldTest    = $CB9F ;	jsr R_FieldTest ;�n�`(9~8,B~A)�̑����擾
R_CreateWeapon = $D3DD ;	jsr R_CreateWeapon ;Obj[x]�ɕ���y���쐬
R_ShotPose     = $DA87 ;	jsr R_ShotPose ;���b�N�}�����V���b�g�p����
R_SplitWeapon  = $E4FC ;	jsr R_SplitWeapon ;Obj[x]�̈ʒu��Obj[$00]�̕���y��z�u
R_CommonWeaponProc = $EECD ;	jsr R_CommonWeaponProc ;���ʕ��폈��




