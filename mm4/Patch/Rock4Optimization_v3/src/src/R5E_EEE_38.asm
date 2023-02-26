;by rock4_effectenemyex/Rock5easily
R5E_EEE_ChkEffectEnemyID:
	cmp	#$F0		; IDがF0以上なら拡張処理へ
	bcs	R5E_EEE_EffectEnemyEx	; |
	
	and	#$3F		; ジャンプ元で潰した処理を行う
	tay			; |
	jmp	$808C		; ID:C0～EFは通常の処理へ戻る
	
R5E_EEE_EffectEnemyEx:
	and	#$0F		; 下位4bit取り出し
	tay			;
	lda	R5E_EEE_ProcAddrLow,y	;
	sta	<$06		;
	lda	R5E_EEE_ProcAddrHigh,y	;
	sta	<$07		;
	ldy	<$04		;
	lda	$B200,y		; オブジェクトのY座標をロード
	jmp	[$0006]		;
	
R5E_EEE_ProcAddrLow:
	.db	low(R5E_EEE_ProcF0), low(R5E_EEE_ProcF1), low(R5E_EEE_ProcF2), low(R5E_EEE_ProcF3)
	.db	low(R5E_EEE_ProcF4), low(R5E_EEE_ProcF5), low(R5E_EEE_ProcF6), low(R5E_EEE_ProcF7)
	.db	low(R5E_EEE_ProcF8), low(R5E_EEE_ProcF9), low(R5E_EEE_ProcFA), low(R5E_EEE_ProcFB)
	.db	low(R5E_EEE_ProcFC), low(R5E_EEE_ProcFD), low(R5E_EEE_ProcFE), low(R5E_EEE_ProcFF)
R5E_EEE_ProcAddrHigh:
	.db	high(R5E_EEE_ProcF0), high(R5E_EEE_ProcF1), high(R5E_EEE_ProcF2), high(R5E_EEE_ProcF3)
	.db	high(R5E_EEE_ProcF4), high(R5E_EEE_ProcF5), high(R5E_EEE_ProcF6), high(R5E_EEE_ProcF7)
	.db	high(R5E_EEE_ProcF8), high(R5E_EEE_ProcF9), high(R5E_EEE_ProcFA), high(R5E_EEE_ProcFB)
	.db	high(R5E_EEE_ProcFC), high(R5E_EEE_ProcFD), high(R5E_EEE_ProcFE), high(R5E_EEE_ProcFF)

; ここからID:F0の処理(設置Y座標より下のスプライトを背景に隠す)
R5E_EEE_ProcF0:
;	lda	$B200,y		; オブジェクトのY座標をロード
	sta	<$EF		; $EFに格納(指定座標より下のスプライトを背景に隠す)
	rts			; リターン
	
	
; ここからID:F1の処理(BGMを設置Y座標で指定したトラックに変更)
R5E_EEE_ProcF1:
;	lda	$B200,y		; オブジェクトのY座標をロード
	cmp	<$D9		; 現在のトラック番号と比較
	beq	.R0		; 一致すればリターン
	jmp	$F6BC		; 音楽を鳴らす
.R0
	rts			;
	
; ここからID:F2の処理(重力値を設置Y座標で指定した値に変更(デフォルト=$40))
R5E_EEE_ProcF2:
;	lda	$B200,y		; オブジェクトのY座標をロード
	sta	<$99		;
	rts			;

; ここからID:F3の処理(Y座標を00以外にしてセット -> 強制スクロール開始, Y座標を00にしてセット -> 強制スクロール解除)
R5E_EEE_ProcF3:
;	lda	$B200,y		; オブジェクトのY座標をロード
	beq	.L0		;
	lda	#$80		;
.L0
	sta	<$06		; 
	lda	<$2C		;
	and	#$7F		; 最上位bitをクリア
	ora	<$06		; 強制スクロール有効なら最上位bitが1となる
	sta	<$2C		;
	rts			; リターン

; ここからID:F4の処理(風の設定。 Y座標 = 00 -> 無効, 01 -> 右, 02 -> 左)
R5E_EEE_ProcF4:
;	lda	$B200,y		; オブジェクトのY座標をロード
	and	#$03		; 下位2bit取り出し
	sta	<$06		;
	lda	<$2C		;
	and	#$FC		; 下位2bitをクリア
	ora	<$06		;
	sta	<$2C		;
	rts			; リターン

; ここからID:F5の処理(BGパレットフェードイン・フェードアウトの設定。Y座標 = 00 -> フェードイン, 01 -> フェードアウト)
R5E_EEE_ProcF5:
;	lda	$B200,y		; オブジェクトのY座標をロード
	and	#$01		;
	beq	.FadeIn	;
.FadeOut
	; BGパレットフェードアウト
	lda	$0135		;
	and	#$7F		;
	bne	.R0		; 0にならなければリターン
	sta	$0136		;
	lda	#$10		;
	sta	$0137		;
	lda	#$01		;
	sta	$0135		;
	lda	#$58		;
	sta	$0143		;
	lda	#$02		;
	sta	$0144		;
.R0
	rts			; リターン
.FadeIn
	lda	$0135		; $135の値をロード
	beq	.R0		; 0ならばリターン
	bmi	.R0		; 最上位bitが1ならばリターン
	lda	#$00		; 
	sta	$0136		;
	lda	#$30		;
	sta	$0137		;
	lda	#$80		;
	sta	$0135		;
	rts			; リターン

; ここから先はまだ実装なし
R5E_EEE_ProcF6:
R5E_EEE_ProcF7:
R5E_EEE_ProcF8:
R5E_EEE_ProcF9:
R5E_EEE_ProcFA:
R5E_EEE_ProcFB:
R5E_EEE_ProcFC:
R5E_EEE_ProcFD:
R5E_EEE_ProcFE:
R5E_EEE_ProcFF:
	rts			; リターン

