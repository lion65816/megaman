;$Size 0093
	list
	SIZE_CALCULATOR
	nolist
MISC_ORG:

	BANKORG $1C8128
	jsr MISC_AtEnteringStage
	BANKORG $1EC5A5
	jsr MISC_AtClosingWeaponWindow
	BANKORG $1ED33E
	jsr MISC_AtRockmanDamaged

	BANKORG $1EC01F ;ディレイスクロール簡易修正
	bit <$01

;●ピピバグ
	;ピピが卵を動かす処理
	BANKORG_D $1DAC37
	jmp MISC_Pipi_Sub1

	;ピピが画面外に出るときや倒された時に卵を消す処理
	BANKORG $1DAC85
	jsr MISC_Pipi_Sub2
	bne .NotDelete
	sta $0430,y ;Flag+10
.NotDelete
	rts
	;(ここもrts)
	
	BANKORG $1EC89C ;除算バグ
	stx <$0B

;●アニメーションスキップバグ
	BANKORG_D $1ECCB7
	jsr MISC_SETUP_GAUGE_SPRITE_INIT
	BANKORG_D $1ECCBD
	jsr MISC_SETUP_GAUGE_SPRITE_INIT
	BANKORG_D $1ECD4B
	jsr MISC_SETUP_GAUGE_SPRITE_INIT
	BANKORG_D $1ECD51
	jsr MISC_SETUP_GAUGE_SPRITE_INIT

	BANKORG_D $1ECE28
	jmp MISC_DELETE_OBJX_CLC_RTS

	BANKORG_D $1ECF3A
	jmp MISC_DELETE_OBJX_CLC_RTS
	
	BANKORG_D $1ECE70
	jmp MISC_CANCEL_SPRITE_SETUP
	
	BANKORG_D $1ECEE8
	beq $CEF2

	;スプライト用メモリ初期化の最適化
	BANKORG $1ECC79
	jsr MISC_InitDMASrc

	BANKORG $1ED97E+$6B ;ワイリーマシンの弾の判定サイズ
	db $07

	BANKORG MISC_ORG

;●ピピバグ
MISC_Pipi_Sub1:
	jsr MISC_Pipi_Sub2
	bne .NotMoveEgg
	jmp $AC3B
.NotMoveEgg
	jmp $AC74

;ゼロなら卵が存在、非ゼロなら卵は消失済み
MISC_Pipi_Sub2:
	ldy $0110,x
	dey
	lda $0430,y ;Flag+10
	bpl .Empty
	lda $0410,y ;Type+10
	cmp #$3A
	rts
.Empty
	;非ゼロならなんでもいい
	txa
	rts

MISC_DELETE_OBJX_CLC_RTS:
	lsr $0420,x
	clc
	rts

MISC_CANCEL_SPRITE_SETUP:
	;最後のスプライトのアトリビュート。
	;正常な状態ならF8は未使用時以外にはならない
	lda $02FE
	cmp #$F8
	bne .canceled
	lda $8400,y
	jmp $CE73
.canceled
	jmp $CEF2

MISC_SETUP_GAUGE_SPRITE_INIT:
	lda $02FE
	cmp #$F8
	beq .NormalProc
	lda <$06
	bne .NormalProc
	jmp $CFE0
.NormalProc
	jmp $CF5A

;登録されたアドレスをコールし、飛び先でrtsが実行されたら呼び出し元に戻る。
;a,x,yの値が飛び先に渡されるが、
;y(3の倍数)でアドレスを指定するため実用上a,xのみが渡る。
;x,y,pレジスタが正しく戻ってくる。
MISC_LONG_CALL:
	sta vTmpLongCallA
	lda <vCurPrgBank
	pha
	;原作だとこのバンク切り替えでx,yが保持されない
	lda .Tbl+2,y
	jsr rSwapPrg
	jsr .Sub
	sta vTmpLongCallA
	php
	pla
	sta vTmpLongCallP
	pla
	jsr rSwapPrg
	lda vTmpLongCallP
	pha
	lda vTmpLongCallA
	plp
	rts

.Sub
	lda .Tbl+1,y
	pha
	lda .Tbl+0,y
	pha
	lda vTmpLongCallA
	rts

DA_LHB_m1 .macro ;Data Address Lo Hi Bank
	db LOW (\1-1)
	db HIGH(\1-1)
	db BANK(\1)/2
	.endm

.Tbl
	DA_LHB_m1 Weapon6_CollisionProc
	DA_LHB_m1 Weapon2_ObjHandler
	DA_LHB_m1 Weapon1_Split
	DA_LHB_m1 Weapon4_Split
	DA_LHB_m1 Weapon6_CollisionProcB


MISC_AtClosingWeaponWindow:
	jsr rSwapPrg
	lda #$00
	sta vBusterTimer
	rts

MISC_AtRockmanDamaged:
	jsr $D3A5
	lda #$00
	sta vBusterTimer
	rts

	list
	SIZE_CALCULATOR
	nolist
