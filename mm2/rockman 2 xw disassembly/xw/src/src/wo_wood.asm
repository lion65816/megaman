
	jsr R_CommonWeaponProc ;共通武器処理
	jsr FIELD_TEST
	bne .Hit_Wall

	clc
	lda <$0A
	adc #$0C
	sta <$0A
	jsr R_FieldTest ;地形(9~8,B~A)の属性取得
	ldx <V_ProcessingObj
	ldy <$00
	lda $E14C,y ;暫定・クラッシュボムのテーブル
	beq .return
;床に命中した
	lda #$00
	sta A_ObjVylo,x
	sta A_ObjVyhi,x
	lda <$0A
	and #$F0
	sec
	sbc #$0C
	sta A_ObjYhi,x
.return
	rts
;壁に命中した
.Hit_Wall
	lda A_ObjFlag,x ;存右？？弾重特当
	eor #$40
	sta A_ObjFlag,x ;存右？？弾重特当
	lda A_ObjVal0,x
	bmi .suicide
	dec A_ObjVal0,x
	rts
.suicide
	lsr A_ObjFlag,x ;存右？？弾重特当
	rts
