	; 足場処理メイン
;	BANKORG_D $3FEFD0		; 未使用領域を利用する
BANK3F_Foothold:
	cmp	#$40			; はしご(頂点)なら細かく座標チェックへ
	beq	.JmpF1BC		; |
	cmp	#$44			;
	bne	.JmpF1C4		;
.JmpF1BC
	jmp	$F1BC			; はしご(頂点)か足場の場合
.JmpF1C4
	jmp	$F1C4			; はしご(頂点)でも足場でもない場合
BANK3F_Foothold_End:

; 重力加算のないルーチンへの対応
BANK3F_OnewayBlock:
	cmp	#$48
	beq	.JmpF0F3
	and	#$10
	bne	.JmpF0F3
	clc
	rts
.JmpF0F3
	jmp	$F0F3

; 重力加算のあるルーチンへの対応
BANK3F_OnewayBlockG:
	cmp	#$48			; 一方通行ブロックならば下方向への座標補正処理へ
	beq	.JmpF225		; |
	and	#$10			; ブロック属性を持っていなければキャリークリアしてリターンへ
	beq	.JmpF22B		; |
.JmpF225
	jmp	$F225			; 下方向への座標補正処理
.JmpF22B
	jmp	$F22B			; キャリークリアしてリターン
.End

CustomBlock_Main:
	php			; ジャンプ元で潰した処理を実行
	ror	<$0F		; |

	.IF SW_WRAMMap
	jmp [aProcCustomBlock_Conv]
CustomBlock_Conveyor:
	.ENDIF
;	lda	<$39		; すでに何かに乗っていた場合はジャンプ元に帰る
;	bne	.Jmp92C8	; |
	
	lda	#$01		; Platform directionに#$01(右)をセット
	sta	<$39		; |
.CheckCenter
	lda	<$46		; インデックス1のBlock types in each tested positionをロード
	cmp	#$D0		; #$D0(コンベア右)ならば.SetSpeedにジャンプ
	beq	.SetSpeed	; |
	cmp	#$D4		; #$F0(コンベア左)ならば.SetDirLeftにジャンプ
	beq	.SetDirLeft	; |
	lda	<$45		; インデックス0のBlock types in each tested positionをロード
	cmp	<$46		; インデックス1のBlock types in each tested positionと等しくないなら.CheckSideにジャンプ
	bne	.CheckSide	; |
	lda	<$47		; インデックス2のBlock types in each tested positionをロード
.CheckSide
	cmp	#$D0		; #$D0なら.SetSpeedにジャンプ
	beq	.SetSpeed	; |
	cmp	#$D4		; #$F0でなければ.Jmp92C8にジャンプ
	bne	.ClearDir	; |
.SetDirLeft
	inc	<$39		; Platform directionをインクリメント(#$02=左にする)
; コンベアの速度
.SetSpeed
	lda	#$80		; Platform X speed lowに#$80をセット
	sta	<$3A		; |
	lda	#$00		; Platform X speed highに#$00をセット
	sta	<$3B		; |
	jmp	CustomBlock_return; .Jmp92C8

.ClearDir
	lda	#$00		; Platform directionに#$00(無効)をセット
	sta	<$39		; |

	.IF SW_WRAMMap
CustomBlock_SkipConveyor:
	jmp [aProcCustomBlock_FlSn]
CustomBlock_FlowSnow:
	.ENDIF

;雪・水流のための地形読み取り
;雪:C8
;水流:80 A0 C0
;ただし、足元がハシゴの頂点の時は処理しない
	lda <aTerrain+1
	cmp #$40
	beq .NoSnowFlow
	ldy #$10
	jsr rTerrainTestHB
	lda <$10
	bpl .NoSnowFlow
	cmp #$C8
	beq .Snow
	jmp $9319 ;水流処理へつないでしまう(そこで、80,A0,C0との一致を確認、一致しない時は帰路に)
.Snow
	jmp $92F6 ;雪の処理
.NoSnowFlow
.Jmp92C8
	.IF SW_WRAMMap
CustomBlock_SkipFlowSnow:
	.ENDIF
CustomBlock_return:
	jmp	$92C8		; ジャンプ元へ戻る
.End
