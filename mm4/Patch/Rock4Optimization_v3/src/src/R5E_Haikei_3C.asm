;by rock4_haikei/Rock5easily
R5E_Haikei_main:
	;SW_WRAMMapがあれば、フラグを参照するように変更
	.IF !SW_WRAMMap
	ldy	<$22		; Current levelをロード
	lda	R5E_Haikei_TblPerStage,y		; $95F0の値をロード
	beq	R5E_Haikei_Return		; 0ならばReturnにジャンプ
	.ELSE
	lda vForegroundFlag
	beq R5E_Haikei_Return
	.ENDIF

	lda	<$95		; Synchronous frame counterをロード
	lsr	a		; 2bit右シフト
	lsr	a		; |
	bcs	R5E_Haikei_Return		; キャリーが1ならReturnにジャンプ

	lda	$0528		; ロックマンのdisplay flagsをロード
	and	#$DF		; 5bit目(背景に隠れる)をクリア
	sta	$0528		; |
	ldy	#$40		; 左右方向のチップ属性チェック
	jsr	$D428		; |
	lda	<$41		; Largest block type foundをロード
	cmp	#$E0		; #$E0(背景の裏に隠れる)ならSetSprieFlagにジャンプ
	beq	R5E_Haikei_SetSprieFlag	; |
	ldy	#$41		; 左右方向のチップ属性チェック
	jsr	$D428		; |
	lda	<$41		; Largest block type foundをロード
	cmp	#$E0		; #$E0(背景の裏に隠れる)でなければReturnにジャンプ
	bne	R5E_Haikei_Return		; |

R5E_Haikei_SetSprieFlag:
	lda	$0528		; ロックマンのdisplay flagsの5bit目(背景に隠れる)を1にセット
	ora	#$20		; |
	sta	$0528		; |

R5E_Haikei_Return:
	plp			; ステータスレジスタにポップ
	rts			; リターン
