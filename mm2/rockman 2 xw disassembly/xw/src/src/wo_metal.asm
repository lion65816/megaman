
	jsr R_CommonWeaponProc ;���ʕ��폈��
	jsr FIELD_TEST
	bne .hit
	rts
;�n�`�ɖ�������
.hit
	stx <$00
	inc <$00
	ldy #$07
	jsr R_SplitWeapon ;Obj[x]�̈ʒu��Obj[$00]�̕���y��z�u
	ldy <$00
	lda A_ObjFlag,x ;���E�H�H�e�d�H��
	and #~$02
	sta A_ObjFlag,x ;���E�H�H�e�d�H��
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


