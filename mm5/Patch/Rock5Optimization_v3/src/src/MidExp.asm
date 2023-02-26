MidExp_Org:

MidExp_Sub .macro
	BANKORG_D \1
	TRASH_GLOBAL_LABEL
	DB_ADDRLHSPLIT \2,\3
	.endm

;※一部の位置定義を別の定義の一部にくっつけることで
;　アニメーション定義に空きを作る
	BANKORG_D $1687A9
MidExp_LocDef_03_Rep:
	BANKORG_D $1688A0
MidExp_LocDef_04_Rep:
	MidExp_Sub $168400+$03,MidExp_LocDef_03_Rep,$100 ;アニメーション定義２つ分(5C 5D)
;	MidExp_Sub $168400+$04,MidExp_LocDef_04_Rep,$100
;※もっと必要ならこれ↑を利用すれば明けることが可能です。

	;スプライト定義
	MidExp_Sub $168000+$1FF,MidExp_NA0,$200
	MidExp_Sub $168000+$1FE,MidExp_NA1,$200
	MidExp_Sub $168000+$1FD,MidExp_NA2,$200
	MidExp_Sub $168000+$1FC,MidExp_NA3,$200
	MidExp_Sub $168000+$1FB,MidExp_NA4,$200
	MidExp_Sub $168000+$1FA,MidExp_NA5,$200
	MidExp_Sub $168000+$1F9,MidExp_NA6,$200
	MidExp_Sub $168000+$1F8,MidExp_NA7,$200
	MidExp_Sub $168000+$1F7,MidExp_NA8,$200
	;位置定義
	MidExp_Sub $168400+$FF,MidExp_L0,$100
	MidExp_Sub $168400+$FE,MidExp_L1,$100
	MidExp_Sub $168400+$FD,MidExp_L2,$100
	MidExp_Sub $168400+$FC,MidExp_L3,$100
	MidExp_Sub $168400+$FB,MidExp_L4,$100
	MidExp_Sub $168400+$FA,MidExp_L5,$100
	MidExp_Sub $168400+$F9,MidExp_L6,$100
	MidExp_Sub $168400+$F8,MidExp_L7,$100
	MidExp_Sub $168400+$E7,MidExp_L8,$100
	;アニメーション定義

	MidExp_Sub $168600+$5C,MidExp_Ani,$100


	MidExp_Sub $1C88C3+$C2,MidExpC2_EntryPoint,$D0


	BANKORG_D $1C906B
MidExp_EntryPoint:
	lda #$00
	sta oFlag,x ; <画UD右裏広見ブ乗>
	lda oType,x
	and #$0F
	cmp #$0C
	beq MidExp_Routine_Damage
MidExp_Routine_Wait:
	OBJX_SET_ROUTINE .Wait
.Wait
	pla
	pla
	jmp $8039
MidExp_Routine_Damage:
	OBJX_SET_ROUTINE .Wait2
.Wait2
	pla
	pla
	jmp $8082
MidExpC2_EntryPoint:
	jsr rNewObjY
	bcs MidExp_Routine_Wait
	lda #$5C
	jsr rPlaceObjYOnX
	lda #$00
	sta oHitFlag,y
	lda #$2F
	sta oType,y
	bne MidExp_Routine_Wait


	END_BOUNDARY_TEST $1C90BA

;2F
	BANKORG_DB $03A2A3+1,$5C
	BANKORG_DB $04A275+1,$5C
	BANKORG_DB $0AA588+1,$5C
	BANKORG_DB $1B8D2A+1,$5C
	BANKORG_DB $1C90E7+1,$5C
	BANKORG_DB $1DA574+1,$5C
;8C
	BANKORG_DB $08A1A5+1,$5C
	BANKORG_DB $1DA955+1,$5C
;BC
	BANKORG_DB $08A1C8+1,$5C
;C2
;	BANKORG_DB $1C8210+1,$5C
;	BANKORG_DB $1DB3A5+1,$5C


	;スプライト定義のあるバンクを調整
	BANKORG_DB $1FE33B+$2F,BANK(MidExp_Ani)
	BANKORG_DB $1FE33B+$8C,BANK(MidExp_Ani)
	BANKORG_DB $1FE33B+$BC,BANK(MidExp_Ani)
;	BANKORG_DB $1FE33B+$C2,BANK(MidExp_Ani)

	BANKORG MidExp_Org
