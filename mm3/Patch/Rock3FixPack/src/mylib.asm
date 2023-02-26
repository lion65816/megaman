;●ロングブランチ

BEQ_L .macro
	bne .tmp_\@
	jmp \1
.tmp_\@
	.endm

BNE_L .macro
	beq .tmp_\@
	jmp \1
.tmp_\@
	.endm

BCS_L .macro
	bcc .tmp_\@
	jmp \1
.tmp_\@
	.endm

BCC_L .macro
	bcs .tmp_\@
	jmp \1
.tmp_\@
	.endm

BPL_L .macro
	bmi .tmp_\@
	jmp \1
.tmp_\@
	.endm

BMI_L .macro
	bpl .tmp_\@
	jmp \1
.tmp_\@
	.endm

BVS_L .macro
	bvc .tmp_\@
	jmp \1
.tmp_\@
	.endm

BVC_L .macro
	bvs .tmp_\@
	jmp \1
.tmp_\@
	.endm

;●ブランチjsr

BNEJSR .macro
	beq .tmp_\@
	jsr \1
.tmp_\@
	.endm

BEQJSR .macro
	bne .tmp_\@
	jsr \1
.tmp_\@
	.endm

BCSJSR .macro
	bcc .tmp_\@
	jsr \1
.tmp_\@
	.endm

BCCJSR .macro
	bcs .tmp_\@
	jsr \1
.tmp_\@
	.endm

BPLJSR .macro
	bmi .tmp_\@
	jsr \1
.tmp_\@
	.endm

BMIJSR .macro
	bpl .tmp_\@
	jsr \1
.tmp_\@
	.endm

BVSJSR .macro
	bvc .tmp_\@
	jsr \1
.tmp_\@
	.endm

BVCJSR .macro
	bvs .tmp_\@
	jsr \1
.tmp_\@
	.endm

;●ブランチリターン

BEQRTS .macro
	bne .tmp_\@
	rts
.tmp_\@
	.endm

BNERTS .macro
	beq .tmp_\@
	rts
.tmp_\@
	.endm

BCSRTS .macro
	bcc .tmp_\@
	rts
.tmp_\@
	.endm

BCCRTS .macro
	bcs .tmp_\@
	rts
.tmp_\@
	.endm

BPLRTS .macro
	bmi .tmp_\@
	rts
.tmp_\@
	.endm

BMIRTS .macro
	bpl .tmp_\@
	rts
.tmp_\@
	.endm

BVSRTS .macro
	bvc .tmp_\@
	rts
.tmp_\@
	.endm

BVCRTS .macro
	bvs .tmp_\@
	rts
.tmp_\@
	.endm

;●値の操作
TXAY .macro
	txa
	tay
	.endm

TYAX .macro
	tya
	tax
	.endm

INV_A	.macro
	eor #$FF
	clc
	adc #$01
	.endm

;キャリーフラグは計算の中で変化することは無いことを、外部で利用してよい
INV_A_CC	.macro
	bcs .tmp_\@
	eor #$FF
	adc #$01
.tmp_\@
	.endm

;●アドレス操作系

TRASH_GLOBAL_LABEL	.macro
TRASH_GLOBAL_LABEL_\@:
	.endm

BANKORG_D .macro
	.bank (\1>>16)
	.org (\1&$FFFF)
	.endm

BANKORG .macro
	.bank BANK(\1)
	.org (\1)
	.endm

ROMADDR .macro
	.bank ((\1-$10)/$2000)
	.org (((\1-$10)&$1FFF)|$8000)
	.endm

ORG_DELTA .macro
.local_\@
	.org (.local_\@+\1)
	.endm

SETBANK8000 .macro
tmp_\@:
	.org ((tmp_\@&$1FFF)|$8000)
	.endm

SETBANKA000 .macro
tmp_\@:
	.org ((tmp_\@&$1FFF)|$A000)
	.endm

SETBANKC000 .macro
tmp_\@:
	.org ((tmp_\@&$1FFF)|$C000)
	.endm

SETBANKE000 .macro
tmp_\@:
	.org ((tmp_\@&$1FFF)|$E000)
	.endm


;●db系

DB4 .macro
	db LOW(\1>>24)
	db LOW(\1>>16)
	db LOW(\1>>8)
	db LOW(\1)
	.endm

DB3 .macro
	db LOW(\1>>16)
	db LOW(\1>>8)
	db LOW(\1)
	.endm

DB2 .macro
	db LOW(\1>>8)
	db LOW(\1)
	.endm

DB1 .macro
	db LOW(\1)
	.endm

DB_ORG_DELTA .macro
	db LOW(\1)
.local_\@
	.org (.local_\@+\2)
	.endm

BANKORG_DB .macro
	BANKORG_D \1
	db \2
	.endm

BANKORG_DB2 .macro
	BANKORG_D \1
	DB2 \2
	.endm

BANKORG_DB3 .macro
	BANKORG_D \1
	DB3 \2
	.endm

BANKORG_DB4 .macro
	BANKORG_D \1
	DB4 \2
	.endm

DB_HI .macro
	db HIGH(\1)
	.endm

DB_LO .macro
	db LOW(\1)
	.endm

DB_ADDRLHSPLIT .macro
	db LOW (\1)
	ORG_DELTA ((\2)-1)
	db HIGH(\1)
	ORG_DELTA (-(\2))
	.endm

DB_ADDRLHSPLIT_G .macro
TRASH_GLOBAL_LABEL_\@:
	db LOW (\1)
	ORG_DELTA ((\2)-1)
	db HIGH(\1)
	ORG_DELTA (-(\2))
	.endm

;バンクをまたいだ時にエラーを出すincbin
SAFE_INCBIN .macro
.PrevIncBin_\@
	.incbin \1
.NextIncBin_\@
	.IF BANK(.PrevIncBin_\@)!=BANK(.NextIncBin_\@)
	.FAIL ;SAFE_INCBIN \1
	.ENDIF
	.endm

;●テスト系

ORG_TEST	.macro
CurrentPosition\@:
	.IF ((CurrentPosition\@)&$FFFF)!=((\1)&$FFFF)
	.FAIL ;ORG_TEST \1
	.ENDIF
	.endm

END_BOUNDARY_TEST	.macro
CurrentPosition\@:
	.IF ((CurrentPosition\@)&$FFFF)>((\1)&$FFFF)
	.FAIL ;END_BOUNDARY_TEST \1
	.ENDIF
	.endm

END_BOUNDARY_TEST_1FFF	.macro
CurrentPosition\@:
	.IF ((CurrentPosition\@)&$1FFF)>((\1)&$1FFF)
	.FAIL ;END_BOUNDARY_TEST \1
	.ENDIF
	.endm

BANK_BOUNDARY_TEST	.macro
CurrentPosition\@:
	.IF (bank(CurrentPosition\@))>=(\1)
	.FAIL ;BANK_BOUNDARY_TEST \1
	.ENDIF
	.endm

