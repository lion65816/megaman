	inc A_ObjVal0,x
	lda A_ObjVal0,x
	cmp #10
	bne .NotSplit

	lda A_ObjFlag+2 ;���E�H�H�e�d�H��
	and #~$02
	pha
;	sta A_ObjFlag+2 ;���E�H�H�e�d�H��

	lda #$02
	sta <$00
	ldy #$0C
	jsr R_SplitWeapon ;Obj[x]�̈ʒu��Obj[$00]�̕���y��z�u
	inc <$00
	jsr R_SplitWeapon ;Obj[x]�̈ʒu��Obj[$00]�̕���y��z�u
	inc <$00
	jsr R_SplitWeapon ;Obj[x]�̈ʒu��Obj[$00]�̕���y��z�u
	lda #$03
	sta A_ObjVyhi+3
	lda #$FD
	sta A_ObjVyhi+4

	pla
	sta A_ObjFlag+2 ;���E�H�H�e�d�H��
	sta A_ObjFlag+3 ;���E�H�H�e�d�H��
	sta A_ObjFlag+4 ;���E�H�H�e�d�H��

.NotSplit
	jmp R_CommonWeaponProc ;���ʕ��폈��


