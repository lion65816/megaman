;$Size 000F
	list
	SIZE_CALCULATOR
	nolist
Weapon0_Buster:
	BANKORG_DB $1ED44C+0,$3D ;Type
	BANKORG_DB $1ED45E+0,$87 ;Flag
	BANKORG_DB $1ED482+0,$00 ;Vxlo
	BANKORG_DB $1ED494+0,$06 ;Vxhi
	BANKORG_DB $1ED4A6+0,$00 ;Vylo
	BANKORG_DB $1ED4B8+0,$01 ;Vyhi

	BANKORG $1FF900+$3D
	DB2_SEPARATED $1FFBC3,$100

	include "src/w_0_damage.asm"


	BANKORG Weapon0_Buster
WeaponHandler_E: ;リールガンとして利用
;	dec oHP,x
;	bne .NotStartDropping
;	dec oVxhi,x
;	lda oFlag,x
;	ora #$04
;	sta oFlag,x
;.NotStartDropping
	lda #$00
	tay
	jsr TerrainTestEx ;Obj[x]から(a,y)ずれた地形をテスト/壁なら非ゼロを返す
	bne .HitIntoWall
	jmp $EECD
.HitIntoWall
	lsr oFlag,x
	rts

	list
	SIZE_CALCULATOR
	nolist
