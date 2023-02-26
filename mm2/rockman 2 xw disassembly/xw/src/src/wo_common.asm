FIELD_TEST:
	lda A_ObjXhi,x
	sta <$08
	lda A_ObjXhe,x
	sta <$09
	lda A_ObjYhi,x
	sta <$0A
	lda #$00
	sta <$0B
	jsr R_FieldTest ;地形(9~8,B~A)の属性取得
	ldx <V_ProcessingObj
	ldy <$00
;クラッシュボムの判定テーブルを参照にする
	lda $E14C,y
	rts



