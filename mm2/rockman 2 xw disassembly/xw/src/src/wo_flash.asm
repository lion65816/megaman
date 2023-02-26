	jsr R_CommonWeaponProc ;���ʕ��폈��
	jsr FIELD_TEST
	bne .hit
	sta A_ObjSprTimer,x
	lda #$03
	sta A_ObjSprNo,x
	rts
;�n�`�ɖ�������
.hit
WEAPON_FLASH_SPLITTING:
	lda A_ObjFlag+2 ;���E�H�H�e�d�H��
	and #~$02
	eor #$40
	sta <$01
	lsr A_ObjFlag+2 ;���E�H�H�e�d�H��

	ldx #$03
.Split_loop
	ldy #$08
	stx <$00
	ldx #$02
	jsr R_SplitWeapon ;Obj[x]�̈ʒu��Obj[$00]�̕���y��z�u
	ldx <$00
	lda .Table_Vxlo-3,x
	sta A_ObjVxlo,x
	lda .Table_Vxhi-3,x
	sta A_ObjVxhi,x
	lda .Table_Vylo-3,x
	sta A_ObjVylo,x
	lda .Table_Vyhi-3,x
	sta A_ObjVyhi,x

	lda <$01
	sta A_ObjFlag,x ;���E�H�H�e�d�H��
	inx
	cpx #$08
	bne .Split_loop

	rts

;cos(45[deg])   = $B504/$10000 = sin(45)
;sin(22.5[deg]) = $61F8/$10000 = cos(22.5+45)
;cos(22.5[deg]) = $EC83/$10000 = sin(22.5+45)

.Table_Vxlo
	.db LOW ( 8* $B504/$100)
	.db LOW ( 8* $EC83/$100)
	.db LOW ( 8*$10000/$100)
	.db LOW ( 8* $EC83/$100)
	.db LOW ( 8* $B504/$100)
.Table_Vxhi
	.db HIGH( 8* $B504/$100)
	.db HIGH( 8* $EC83/$100)
	.db HIGH( 8*$10000/$100)
	.db HIGH( 8* $EC83/$100)
	.db HIGH( 8* $B504/$100)
.Table_Vylo
	.db LOW (-8* $B504/$100)
	.db LOW (-8* $61F8/$100)
	.db LOW ( 8* $0000/$100)
	.db LOW ( 8* $61F8/$100)
	.db LOW ( 8* $B504/$100)
.Table_Vyhi
	.db HIGH(-8* $B504/$100)
	.db HIGH(-8* $61F8/$100)
	.db HIGH( 8* $0000/$100)
	.db HIGH( 8* $61F8/$100)
	.db HIGH( 8* $B504/$100)

