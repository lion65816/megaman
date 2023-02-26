;by Rock5easily

	.IF Enable_WeaponSelect
	;※DisableCollisionの為にちょっと処理が挟まれています
	;※グラビティーホールド中に変更した時の対応を追加しています

Misc_WeaponSelect_Main:
	beq	Misc_WeaponSelect_CHANGE_WEAPON	; スタートボタンを押していなければ武器チェンジ処理へ

	ldx	#$00		;
	lda	<$16		; セレクトボタンを押しながらならば武器チェンジ処理へ(ロックバスターに変更)
	and	#$20		; |
	bne	Misc_WeaponSelect_CHANGE_WEAPON	; |
	
	lda	#$29		; #$29番の効果音(武器メニュー表示)を鳴らす
	jsr	$EC5D		; |
	jmp	$8000		; 通常の武器メニュー処理へジャンプ

Misc_WeaponSelect_CHANGE_WEAPON:			; ここからセレクトボタン処理

	; ここから武器オブジェクトを消去
	ldy	#$04		; Yレジスタに#$04をロード
.LOOP
	jsr	$F2FE		; オブジェクトy消滅ルーチン
	dey			; Yレジスタをデクリメント
	bne	.LOOP		; 0にならなければ$807Aにジャンプ

	lda	<$14		; SELECT + START ならば武器をロックバスターに変更
	and	#$10		; |
	bne	Misc_WeaponSelect_SETTING		; |

	ldx	<$32		; Current weaponをロード
	lda	<$16		; 下ボタンも一緒に押している時は逆順チェンジ
	and	#$04		; |
	bne	Misc_WeaponSelect_REV_CHANGE	; |

Misc_WeaponSelect_NORMAL_CHANGE:
.LOOP
	inx			;
	cpx	#$0D		;
	bcc	.L		;
	ldx	#$00		;
.L
	lda	<$B0,x		;
	bpl	.LOOP		;
	bmi	Misc_WeaponSelect_SETTING		;
	
Misc_WeaponSelect_REV_CHANGE:
.LOOP
	dex			;
	bpl	.L		;
	ldx	#$0C		;
.L
	lda	<$B0,x		;
	bpl	.LOOP		;

Misc_WeaponSelect_SETTING:
	stx	<$32		;
	ldy	Misc_WeaponSelect_WeaponTable,x	; CurrentWeapon -> Weapon selection in menu order
	sty	<$50		;

	txa			;
	beq	.L		;
	ora	#$80		; #$80とORA
.L
	sta	<$2E		; Weapon bar selectに格納; Current weapon → Weapon selection in menu orderへの変換テーブル
	lda	$85F1,y		; $(#$85F1 + Y)の値をロード
	sta	<$ED		; インデックス1のSprite CHR banksに格納

	; ここからパレットセット
	lda	<$50		; Weapon selection in menu orderをロード
	asl	a		; Aレジスタを左シフト
	asl	a		; Aレジスタを左シフト
	tay			; Aレジスタの値をYレジスタにコピー
	ldx	#$00		; Xレジスタの値に#$00をロード
.LOOP
	lda	$854B,y		; 武器毎のパレットをセット
	sta	$0611,x		; |
	sta	$0631,x		; |
	iny			; |
	inx			; |
	cpx	#$03		; |
	bne	.LOOP		; |

	;※追加分/透過色を書き込み/ついでにDisableCollisionのための処理を呼び出し
	lda aPrePal+$00
	sta aCurPal+$10
	.IF Enable_Disable_Collision
	jsr DisableCollision_SetEraseFlag
	.ENDIF

	lda	#$FF		; Palette changedに#$FFをセット
	sta	<$18		; |

	lda	#$27		; #$29番の効果音(カーソル移動音)を鳴らす(チャージ中に武器チェンジしたときのチャージ音をかき消すため)
	jsr	$EC5D		; |
	
	ldx	#$00		;
	jmp	$821C		;


Misc_WeaponSelect_WeaponTable:
	.db	$00, $01, $02, $03, $04, $05, $08, $09
	.db	$0A, $0B, $0C, $0D, $06

	.ENDIF
