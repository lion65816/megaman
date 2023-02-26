;●ロングブランチ

BEQL .macro
	bne .tmp_\@
	jmp \1
.tmp_\@
	.endm

BNEL .macro
	beq .tmp_\@
	jmp \1
.tmp_\@
	.endm

BCSL .macro
	bcc .tmp_\@
	jmp \1
.tmp_\@
	.endm

BCCL .macro
	bcs .tmp_\@
	jmp \1
.tmp_\@
	.endm

BPLL .macro
	bmi .tmp_\@
	jmp \1
.tmp_\@
	.endm

BMIL .macro
	bpl .tmp_\@
	jmp \1
.tmp_\@
	.endm

BVSL .macro
	bvc .tmp_\@
	jmp \1
.tmp_\@
	.endm

BVCL .macro
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

;bankとorgを設定する。それまでのスコープは見えなくなる。
;引数としてシンボルが与えられた時はBANK()を使うようにする。
;しかし、値として$00****が与えられた時は上手く動かないので、BANKORG_Dを使うこと。
BANKORG .macro
	.IF (\1>>16)=0
	.bank BANK(\1) ;エラー時はBANKORG_Dを使ってください
	.org (\1)
TRASH_GLOBAL_LABEL_\@:
	.ELSE
	.bank (\1>>16)
	.org (\1&$FFFF)
TRASH_GLOBAL_LABEL_\@:
	.ENDIF
	.endm

BANKORG_D .macro
	.bank (\1>>16)
	.org (\1&$FFFF)
TRASH_GLOBAL_LABEL_\@:
	.endm

ROMADDR .macro
	.bank ((\1-$10)/$2000)
	.org (((\1-$10)&$1FFF)|$8000)
	.endm

ORG_D .macro
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

;ローカルラベルをグローバル化する。但し、スコープがそのグローバルラベルに移動してしまう。
;その為、スコープの最後で1度だけ行うことが出来る。
GLOBALIZE .macro
.local\@
_TMP_GLOBAL_LABEL\@ = \1-.local\@
	ORG_D _TMP_GLOBAL_LABEL\@
\2:
	ORG_D -(_TMP_GLOBAL_LABEL\@)
	.endm
;↑の２つグローバル化版。
GLOBALIZE2 .macro
.local\@
_TMP_GLOBAL_LABEL1_\@ = \1-.local\@
_TMP_GLOBAL_LABEL2_\@ = \3-.local\@
	ORG_D _TMP_GLOBAL_LABEL1_\@
\2:
	ORG_D -(_TMP_GLOBAL_LABEL1_\@)
	ORG_D _TMP_GLOBAL_LABEL2_\@
\4:
	ORG_D -(_TMP_GLOBAL_LABEL2_\@)
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

DB2 .macro ;dwとバイトオーダーが異なる
	db LOW(\1>>8)
	db LOW(\1)
	.endm

DB1 .macro
	db LOW(\1)
	.endm

DB4444 .macro
	DB4 \1
	DB4 \2
	DB4 \3
	DB4 \4
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

DB2_SEPARATED .macro
	db LOW (\1)
	ORG_D ((\2)-1)
	db HIGH(\1)
	ORG_D (-(\2))
	.endm

DA_LHB .macro ;Data Address Lo Hi Bank
	db LOW (\1)
	db HIGH(\1)
	db BANK(\1)
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

;バンクをまたぐことの出来るdb。バンクをまたいだ時はスコープが変化する。
	.macro DBi
.t\@
	.if \#>=1
	db \1
	.if (.t\@&$1FFF)=$2000-1
	.bank bank(.t\@)+1
IncBank\@:
.t\@
	.endif
	.endif
	.if \#>=2
	db \2
	.if (.t\@&$1FFF)=$2000-2
	.bank bank(.t\@)+1
IncBank\@:
.t\@
	.endif
	.endif
	.if \#>=3
	db \3
	.if (.t\@&$1FFF)=$2000-3
	.bank bank(.t\@)+1
IncBank\@:
.t\@
	.endif
	.endif
	.if \#>=4
	db \4
	.if (.t\@&$1FFF)=$2000-4
	.bank bank(.t\@)+1
IncBank\@:
.t\@
	.endif
	.endif
	.if \#>=5
	db \5
	.if (.t\@&$1FFF)=$2000-5
	.bank bank(.t\@)+1
IncBank\@:
.t\@
	.endif
	.endif
	.if \#>=6
	db \6
	.if (.t\@&$1FFF)=$2000-6
	.bank bank(.t\@)+1
IncBank\@:
.t\@
	.endif
	.endif
	.if \#>=7
	db \7
	.if (.t\@&$1FFF)=$2000-7
	.bank bank(.t\@)+1
IncBank\@:
.t\@
	.endif
	.endif
	.if \#>=8
	db \8
	.if (.t\@&$1FFF)=$2000-8
	.bank bank(.t\@)+1
IncBank\@:
.t\@
	.endif
	.endif
	.if \#>=9
	db \9
	.if (.t\@&$1FFF)=$2000-9
	.bank bank(.t\@)+1
IncBank\@:
.t\@
	.endif
	.endif
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

FILL_TEST	.macro
CurrentPosition\@:
	.IF ((CurrentPosition\@)&$FFFF)>((\1)&$FFFF)
	.FAIL ;FILL_TEST \1
	.ENDIF
	PaddingTill \1
	.endm

;■■■■■■■■■■■■
;■■■パディング系■■■
;■■■■■■■■■■■■

Padding10 .macro
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.endm
Padding40 .macro
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.endm
Padding100 .macro
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.db $22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22,$22
	.endm
Padding400 .macro
	Padding100
	Padding100
	Padding100
	Padding100
	.endm
Padding1000 .macro
	Padding400
	Padding400
	Padding400
	Padding400
	.endm

PaddingTill .macro
.local1\@
	.IF ( BANK(.local1\@)!=((\1)>>16) )
	.FAIL ; PaddingTill/バンクが異なります
	.ENDIF
	.IF ( ((.local1\@)&$FFFF)>((\1)&$FFFF) )
	.FAIL ; PaddingTill/現在位置が終端アドレスを上回っています
	.ENDIF
	;1000-1FFF
.loAm0\@ = (\1-((BANK(.local1\@)<<16)+.local1\@)) ;詰め物量
	.IF ( .loAm0\@>$2000 )
	.FAIL ; PaddingTill/領域が広すぎます
	.ENDIF
	.IF ( .loAm0\@>=$1000 )
	Padding1000
	.ENDIF
	;0400-0FFF
.loAm1\@ = (.loAm0\@&$0FFF)
	.IF ( .loAm1\@>=$C00 )
	Padding400
	.ENDIF
	.IF ( .loAm1\@>=$800 )
	Padding400
	.ENDIF
	.IF ( .loAm1\@>=$400 )
	Padding400
	.ENDIF
	;0100-03FF
.loAm2\@ = (.loAm1\@&$03FF)
	.IF ( .loAm2\@>=$300 )
	Padding100
	.ENDIF
	.IF ( .loAm2\@>=$200 )
	Padding100
	.ENDIF
	.IF ( .loAm2\@>=$100 )
	Padding100
	.ENDIF
	;0040-00FF
.loAm3\@ = (.loAm2\@&$00FF)
	.IF ( .loAm3\@>=$C0 )
	Padding40
	.ENDIF
	.IF ( .loAm3\@>=$80 )
	Padding40
	.ENDIF
	.IF ( .loAm3\@>=$40 )
	Padding40
	.ENDIF
	;0010-003F
.loAm4\@ = (.loAm3\@&$003F)
	.IF ( .loAm4\@>=$30 )
	Padding10
	.ENDIF
	.IF ( .loAm4\@>=$20 )
	Padding10
	.ENDIF
	.IF ( .loAm4\@>=$10 )
	Padding10
	.ENDIF
	;0004-000F
.loAm5\@ = (.loAm4\@&$000F)
	.IF ( .loAm5\@>=$C )
	.db $22,$22,$22,$22
	.ENDIF
	.IF ( .loAm5\@>=$8 )
	.db $22,$22,$22,$22
	.ENDIF
	.IF ( .loAm5\@>=$4 )
	.db $22,$22,$22,$22
	.ENDIF
	;0000-0003
.loAm6\@ = (.loAm5\@&$0003)
	.IF ( .loAm6\@>=$3 )
	.db $22
	.ENDIF
	.IF ( .loAm6\@>=$2 )
	.db $22
	.ENDIF
	.IF ( .loAm6\@>=$1 )
	.db $22
	.ENDIF
	.endm
