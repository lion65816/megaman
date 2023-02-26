
	jsr R_CommonWeaponProc ;共通武器処理
	jsr FIELD_TEST
	bne .hit
	rts
;地形に命中した
.hit
	stx <$00
	inc <$00
	ldy #$07
	jsr R_SplitWeapon ;Obj[x]の位置にObj[$00]の武器yを配置
	ldy <$00
	lda A_ObjFlag,x ;存右？？弾重？当
	and #~$02
	sta A_ObjFlag,x ;存右？？弾重？当
	lda #$00
;	sta A_ObjVxlo+2
;	sta A_ObjVxlo+3
	sta A_ObjVxhi,x
	sta A_ObjVxhi,y
	lda #$FB
	sta A_ObjVyhi,x
	lda #$05
	sta A_ObjVyhi,y
	rts


