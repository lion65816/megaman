	inc A_ObjVal0,x
	lda A_ObjVal0,x
	cmp #10
	bne .NotSplit

	lda A_ObjFlag+2 ;存右？？弾重？当
	and #~$02
	pha
;	sta A_ObjFlag+2 ;存右？？弾重？当

	lda #$02
	sta <$00
	ldy #$0C
	jsr R_SplitWeapon ;Obj[x]の位置にObj[$00]の武器yを配置
	inc <$00
	jsr R_SplitWeapon ;Obj[x]の位置にObj[$00]の武器yを配置
	inc <$00
	jsr R_SplitWeapon ;Obj[x]の位置にObj[$00]の武器yを配置
	lda #$03
	sta A_ObjVyhi+3
	lda #$FD
	sta A_ObjVyhi+4

	pla
	sta A_ObjFlag+2 ;存右？？弾重？当
	sta A_ObjFlag+3 ;存右？？弾重？当
	sta A_ObjFlag+4 ;存右？？弾重？当

.NotSplit
	jmp R_CommonWeaponProc ;共通武器処理


