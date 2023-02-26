CustomBlock:
;-------------------------------------------------
; 下からジャンプして乗れる足場処理
;-------------------------------------------------
;	; 水流(右)、水流(左)の処理を行わないようにするパッチ
;	BANKORG_D $3C9319
;	lda	<$10			; チップ属性ロード
;	jmp	$9329			; 水流(下)のチェック処理へジャンプ

	; 足場処理へ飛ばすためのパッチ
	BANKORG_D $3FF1B8
BANK3F_JmpFoothold:
	jmp	BANK3F_Foothold		; 足場チェック処理へジャンプ
	nop

;-------------------------------------------------
; 上から下への一方通行ブロック処理
;-------------------------------------------------
	BANKORG_D $3FF0EF
BANK3F_JmpOnewayBlock:
	jmp	BANK3F_OnewayBlock
	nop

	BANKORG_D $3FF221
BANK3F_JmpOnewayBlockG:
	jmp	BANK3F_OnewayBlockG
	nop


	;カスタムブロックを受け付けるためのフック
	BANKORG_D $3C82F0
	jsr CustomBlock_Main
	BANKORG_D $3C8358
	jsr CustomBlock_Main

	;ステージによる区別を削除する
	;SW_EffectEnemyExがあるときはそちらで処理する
	.IF !SW_EffectEnemyEx
	BANKORG_D $3C92D3
	bit <$00
	BANKORG_D $3C92DD
	bcs $933E
	.ENDIF

	;流砂をC4に変更
	BANKORG_D $3FF1CE
	.IF SW_WRAMMap
	jmp [aProcCustomBlock_Sand]
	.ELSE
	jmp $F1D4
	.ENDIF
	BANKORG_D $3FF1D4
CustomBlock_Sand:
	BANKORG_D $3FF1D6
	cmp #$C4
	BANKORG_D $3FF22B
CustomBlock_SkipSand:

	.IF SW_CustomBlock_OrgHack
	BANKORG_D $21A400+$00 ;トードマンステージ/なぜか空白に未使用ビットが付与されている
	.db $01
	BANKORG_D $23A400+$18 ;ファラオマンステージ/流砂に04を付与
	DB4 $C5C5C5C5
	BANKORG_D $28A400+$04 ;コサック１/雪に08を付与
	DB3 $CACACA
	.ENDIF

	BANKORG CustomBlock
