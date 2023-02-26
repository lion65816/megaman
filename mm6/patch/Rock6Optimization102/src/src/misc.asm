Misc_org:
;雑多な処理
	.IF SW_FixChargeBusterSE ;{
	;メモ:ロックマン６は効果音を鳴らす処理が怪しいのだが、ここではそれは関係なく
	;単にチャージショットの効果音優先度が低いために聴こえていない。
	;チャージを弾かれた時の音が聴こえなくなってしまうのでそちらも修正。
	;また、中チャージでは豆音に変更。（これは好みの問題）
	BANKORG $36D705 ;弾かれた時の音の優先度
	.db $08 ;+1
	BANKORG $36D715 ;チャージショットの効果音優先度
	.db $08 ;+1
	BANKORG $388CC2+1 ;中チャージ
	.db $23
	.ENDIF ;}
	.IF SW_FastScrolling ;{
	;●右
	BANKORG $3ED733 ;画面移動量
	lda #$04
	BANKORG $3ED73D ;ループ回数
	ldy #$40
	BANKORG $3ED746 ;ロックマン移動量
	lda #$84
	;●左（値を調整して、描画されない不具合に対応しているらしい）
	BANKORG $3ED769 ;画面移動量
	lda #$04
	BANKORG $3ED775 ;１フレ目の画面位置(FCであるべき)
	lda #$F8
	BANKORG $3ED77D ;ループ回数
	ldy #$3F
	BANKORG $3ED79A ;ロックマン移動量
	lda #$60
	;●下その１
	BANKORG $3ED7C8 ;ループ回数
	ldx #$3C
	BANKORG $3ED7CA ;画面移動量
	lda #$04
	BANKORG $3ED7D4 ;ロックマン移動タイミング
	and #$01
	;●下その２
	BANKORG $3ED805 ;ループ回数
	ldx #$3C
	BANKORG $3ED807 ;画面移動量
	lda #$04
	BANKORG $3ED811 ;ロックマン移動タイミング
	and #$01
	;●上その１
	BANKORG $3ED853 ;ループ回数
	ldx #$3C
	BANKORG $3ED855 ;画面移動量
	lda #$FC
	BANKORG $3ED85F ;ロックマン移動タイミング
	and #$01
	;●上その２
	BANKORG $3ED890 ;ループ回数
	ldx #$3C
	BANKORG $3ED892 ;画面移動量
	lda #$FC
	BANKORG $3ED89C ;ロックマン移動タイミング
	and #$01
	;移動後転送未消化時のウェイト
	BANKORG $3ED75C
	jmp Misc_FastScrollingWait1
	BANKORG $3ED7B0
	jmp Misc_FastScrollingWait1
	BANKORG $3ED7ED
	jmp Misc_FastScrollingWait2
	BANKORG $3ED82A
	jmp Misc_FastScrollingWait2
	BANKORG $3ED86F
	jmp Misc_FastScrollingWait2
	BANKORG $3ED8AC
	jmp Misc_FastScrollingWait2
	.ENDIF ;}

	.IF SW_QuickFading ;{
	BANKORG $3ECA40 ;フェードアウト
	lda #SW_QuickFading
	BANKORG $3ECA90 ;フェードイン
	lda #SW_QuickFading
	BANKORG $3B8917 ;エンディングメドレーinit
	lda #$72+(4-SW_QuickFading)*11
	BANKORG $3B8D00
	DB2_SEPARATED $427+(4-SW_QuickFading)*11*2,$8
	DB2_SEPARATED $4B3+(4-SW_QuickFading)*11*2,$8
	DB2_SEPARATED $4B6+(4-SW_QuickFading)*11*2,$8
	DB2_SEPARATED $409+(4-SW_QuickFading)*11*2,$8
	DB2_SEPARATED $427+(4-SW_QuickFading)*11*2,$8
	DB2_SEPARATED $42B+(4-SW_QuickFading)*11*2,$8
	DB2_SEPARATED $499+(4-SW_QuickFading)*11*2,$8
	DB2_SEPARATED $3C4+(4-SW_QuickFading)*11*2,$8
	.ENDIF ;}
	.IF SW_OmitRushAdaptor=1 ;{
	BANKORG $3893EF
	nop
	nop
	.ENDIF ;}
	.IF SW_OmitRushAdaptor=2 ;{
	BANKORG $389407 ;転送を前倒し
	jsr SW_OmitRushAdaptor2_Xfer
	BANKORG $38941C ;本来の転送処理スキップする位置を呼び出すように変更(*4)
	jsr $9980
	BANKORG $389422
	jsr $9904
	BANKORG $38942D
	jsr $977F
	BANKORG $389433
	jsr $986B
	BANKORG $38997B ;削った部分にテーブルを設ける
OmitRushAdaptor_TblXfer:
	db $04,$05,$07,$06
	FILL_TEST $389980
	BANKORG $3898FF
	FILL_TEST $389904
	BANKORG $38977A
	FILL_TEST $38977F
	BANKORG $389866
	FILL_TEST $38986B

	BANKORG $38965F ;３段スクロール開始時、メットと選択アダプターのグラフィックも消す
	jsr $9624 ;Obj[7>1]削除
	jsr $E1E1 ;スプライトセットアップ
	jmp $9669
	FILL_TEST $389669

	BANKORG $38967E ;本来メット等を動かす処理の代わりにキャンセル可能処理を書く
	lda <vPadPress
	beq $969A
	jsr $CA3D ;フェードアウト
	pla
	sta vNewRaster
Misc_CloseSS_pla2:
	pla
	pla
	lda #$00
	sta <vRasterEnabled
	sta <vScreenX
	sta <vScreenNT
	jmp $9591 ;サブ画面を閉じる
	
	BANKORG $3896B5 ;なぜか書き込み手順がおかしく、一瞬変な位置が表示されるので修正
	sta <vScreenX
	lda #$01
	sta <vScreenNT
	jsr rWaitThread
	jmp $96C2
	FILL_TEST $3896C2

	BANKORG $3896A4 ;スクロール速さ
	adc #$10
	BANKORG $3896AD ;スクロール終了座標
	cmp #$F0
	;ラッシュ降下
	BANKORG $3896EC
	lda #$5A
	sta oYhi,x
	BANKORG $389701
	lda #$08
	bne $971A
	BANKORG $389748
	bit <$00
	;ノーマル→パワー
	BANKORG $389784 ;待ち無し
	bit <$00
	bit $0000
	BANKORG $3897FC ;文字表示後、ボタン押下で終了できるように
	jsr $9764
	;ノーマル→ジェット
	BANKORG $389870 ;待ち無し
	bit <$00
	bit $0000
	BANKORG $3898FB ;文字表示後、ボタン押下で終了できるように
	jsr $9764
	;ジェット→パワー
	BANKORG $389985 ;待ち無し
	bit <$00
	bit $0000
	;パワー→ジェット
	BANKORG $389909 ;待ち無し
	bit <$00
	bit $0000
	
	;文字送りの速さ
	BANKORG $389830
	lda #$02 ;1にしてしまうと音がおかしくなる

	.ENDIF ;}

	.IF SW_FixSpriteGlitch_Gauge ;{
	;メモ:ゲージのスプライトセットアップ中、スプライト数オーバーを返すために、
	;スプライトの使用数の変数の最下位ビットを1にする処理だが
	;その変数は、ゲージ処理開始時にロードされ、ゲージ処理中には参照されない。
	;そのため、次のゲージにスプライト数オーバーが通知されず、
	;スプライト00から使用されてしまうために起きていた問題。
	;スプライト数を指すyの最下位ビットを1に書き込むように変更。
	;スプライト数オーバーは、オブジェクト→ゲージと処理された時のみ起こるので
	;変数には書き込む処理は必要が無く、消してしまって問題がない。はず。
	BANKORG $3ED045
	iny
	rts
	.ENDIF ;}
	.IF SW_FixSpriteGlitch_LEdge ;{
	;メモ:各オブジェクトのスプライトセットアップ処理の中で
	;オブジェクト全体を左右や上下に反転表示させる時は、
	;処理の都合上、中心座標から少し補正した位置に居るとして計算する。
	;この処理で、以下の条件を満たすと、問題が生じる。
	;・降順に処理するフレーム
	;・そのフレーム最初に処理するオブジェクト
	;・補正した位置が画面外
	;最後のスロットだけではなく、続く全てのオブジェクトの処理がスキップされてしまい
	;結果、30FPSになったかのような現象が起きる。
	BANKORG $3FE287
	lda <$F3
	lsr a
	jmp Misc_SpriteGlitch_LEdge
	FILL_TEST $3FE292
	.ENDIF ;}
	.IF SW_SynchronizeAnimation ;{
	BANKORG $3FE24F
	lda oFlag,x
	ora <$8C
	and #$01
	ora oYhe,x
	bne $E26D
	ORG_TEST $3FE25B
	
	.ENDIF ;}
	.IF SW_OptimizeDMASrcFilling ;{
	BANKORG $3FE271
	lda <$8C ;現在のスプライト数
	pha
	and #$E0
	tax
	pla
	and #$1F
	lsr a
	jmp Misc_OptimizeDMASrcFilling
	FILL_TEST $3FE27E
	.ENDIF ;}
	.IF SW_OptimizeObjectSpriteProc ;{
	;メモ：偶数・奇数フレームに対応して、
	;昇順・降順のテーブルを作る処理に時間がかかるので(所要サイクル355/288)
	;ゲームのブート時に作り、そこを参照させる。
	;また、現在バンクをスタックに積む処理をサブルーチン経由させずに行う。
	;テーブルを作る時間はなくなったが、テーブル参照のため、
	;各オブジェクトで3サイクルずつロスを生じる難点も。（差し引きでは十分に得）
	BANKORG $3FE1EA
	lda #HIGH(aTblSpriteOrder)
	sta <$31+1
	lda <$F3
	lsr a
	lda #LOW(aTblSpriteOrder)
	bcs .NormalOrder
	lda #LOW(aTblSpriteOrder+$18)
.NormalOrder
	sta <$31
	lda <vCurBnkA
	pha
	lda <vCurBnk8
	pha
	jmp $E209
	FILL_TEST $3FE209

	BANKORG $3FE20F
	lda [$31],y
	tax

	;スプライトセットアップ処理最内周の最適化 {
	;条件:ヤマトマンステージ突入地点(チート(3B7)で上下左右反転)
	;E267にブレークし、Step Overした時のサイクル数
	;反転無し 1073 => 909   (←原作の処理がアレらしい。反転無しが一番遅いって……)
	;左右反転 1022 => 939   (←原作にバグがあり、Y方向にはみ出すと逆側から出てくる)
	;上下反転 1040 => 1025
	;両方反転 1060 => 1034
	;ちょっとでかいスプライトで検証：
	;2273 => 1880
	;2138 => 1958
	;2180 => 2164
	;2212 => 2181
	;スプライトの形状により最適化効果が変わってくるが、概ね良好のようだ。

	BANKORG $3FE2C7 ;上位バイトが同じなので1サイクルだけ得
	lda #$E3
	sta $0009

	BANKORG $3FE2A2
	DB2_SEPARATED Misc_Optimize_SprSetup,4
	DB2_SEPARATED Misc_Optimize_SprSetupX,4
	DB2_SEPARATED Misc_Optimize_SprSetupY,4
	DB2_SEPARATED Misc_Optimize_SprSetupY,4

	BANKORG $3FE320
Misc_Optimize_SprSetup:
	clc
.loop
	;cc /ループ時は必ずccになるように調整
	lda [$0E],y
	bmi .Dy_n
	adc <$01
	bcc .Dy_n_conf
	clc
.IncY_OutOfScreen
	iny
	bne .OutOfScreen
.Dy_n
	adc <$01
	bcc .IncY_OutOfScreen
	clc
.Dy_n_conf
	;cc /Dyが負の時のみclc/Dyが正の時に得
	sta $0200,x
	lda [$0C],y
	sta $0201,x
	iny
	lda [$0E],y
	bmi .Dx_n
	adc <$00
	bcc .Dx_p_conf
	clc
	bcc .OutOfScreen
.Dx_n
	adc <$00
	bcc .OutOfScreen
	clc
.Dx_p_conf
	;cc /Dxが負の時のみclc/inx*4を置き換え/Dxが正の時に得
	sta $0203,x
	lda [$0C],y
	eor <$8D
	sta $0202,x
	txa
	adc #$04
	tax
	beq .SpriteOver
	;cc
.OutOfScreen
	iny
	dec <$02
	bpl .loop
.SpriteOver
	stx <$8C
	rts

Misc_Optimize_SprSetupX:
	clc
.loop
	;cc /ループ時は必ずccになるように調整
	lda [$0E],y
	bpl .Dy_p
	adc <$01
	bcs .Dy_n_conf
.IncY_OutOfScreen
	clc
	iny
	bne .OutOfScreen
.Dy_p
	adc <$01
	bcs .IncY_OutOfScreen
	sec
.Dy_n_conf
	;cs /Dyが正の時のみsec/Dyが負の時に得(たぶん負が少し多い)
	sta $0200,x
	lda [$0C],y
	sta $0201,x
	iny
;	sec
	lda #$F8
	sbc [$0E],y
	clc
	bmi .Dx_n
	adc <$00
	bcc .Dx_p_conf
	clc
	bcc .OutOfScreen
.Dx_n
	adc <$00
	bcc .OutOfScreen
	clc
.Dx_p_conf
	;cc /Dxが負の時のみclc/inx*4を置き換え/Dxが正の時に得
	sta $0203,x
	lda [$0C],y
	eor <$8D
	sta $0202,x
	txa
	adc #$04
	tax
	beq .SpriteOver
	;cc
.OutOfScreen
	iny
	dec <$02
	bpl .loop
.SpriteOver
	stx <$8C
	rts

Misc_Optimize_SprSetupY:
;Y反転はレアケースなので、一つにまとめてしまう(コードサイズが肥大化するため)
.loop
	sec
	lda #$F8
	sbc [$0E],y
	clc
	bpl .Dy_p
	adc <$01
	bcs .Dy_n_conf
.IncY_OutOfScreen
	iny
	bne .OutOfScreen
.Dy_p
	adc <$01
	bcs .IncY_OutOfScreen
	sec
.Dy_n_conf
	;cs /Dyが正の時のみsec/Dyが負の時に得(たぶん負が少し多い)
	sta $0200,x
	lda [$0C],y
	sta $0201,x
	iny

	;左右反転の有無で分岐。
	;馬鹿でかいペナルティあるため、無理やり下記の最適化を行い
	;損するケースを（たぶん）無くしている。
	bit <$8D
	bvc .NotInverseX
.InverseX
;	sec
	lda #$F8
	sbc [$0E],y
	clc
	bmi .Dx_n
	adc <$00
	bcc .Dx_p_conf
	bcs .OutOfScreen
.Dx_n
	adc <$00
	bcc .OutOfScreen
	clc
.Dx_p_conf
	;cc /Dxが負の時のみclc/inx*4を置き換え/Dxが正の時に得
	sta $0203,x
	lda [$0C],y
	eor <$8D
	sta $0202,x
	txa
	adc #$04
	tax
	beq .SpriteOver
	;cc
.OutOfScreen
	iny
	dec <$02
	bpl .loop
.SpriteOver
	stx <$8C
	rts
.NotInverseX
	;合流するためのjmpすらケチった結果、左右反転は別に書くことにした。
	;しかし、全経路で分岐が入るため、分岐までを書くことで
	;コードを$100境界内部で完結させる。これにより、$100境界をまたぐペナルティを回避できる。
	lda [$0E],y
	clc
	bmi .Dx_n
	adc <$00
	bcc .Dx_p_conf
	bcs .OutOfScreen
	FILL_TEST $3FE400
	FILL_TEST $3FE41C
	; スプライトセットアップ処理最内周最適化ここまで}
	.ENDIF ;}

	.IF SW_OptimizeCollision ;{
	;ある測定例では、50フレームの間の当たり判定処理にかかった時間が以下のように減少。
	;104429 => 64892
	;しかし、この測定例が、多くの場合における平均的な条件かどうかはわからない。

	BANKORG $3FF7A8
	ldy <vTmpB
	ldx <vTmpA
	BANKORG $3FF7DB
	ldy <vTmpB
	ldx <vTmpA
	
	BANKORG $3FF72A
	lda #$00
	sta <$11
	lda oXhi,y
	sta <$04 ;τXhi[y]/後に|Δx|
	sty <vTmpB
	ldy <$08 ;τ判定サイズ1/後に判定W
	clc
	lda $F7E0,y ;判定サイズX
	ldy <$0A ;τ判定サイズ2/後にΔx;
	adc $F7E0,y ;判定サイズX
	sta <vTmpA
	bmi .LargeHitBox
	sec
	lda <$00 ;τXhi[x]
	sbc <$04 ;τXhi[y]/後に|Δx|
	bpl .NotInvA ;bplなのががポイントで、ページを跨ごうが近い方の距離で計算される
	INV_A
.NotInvA
	cmp <vTmpA
	bcc .ContinueCollisionProc
	beq .ContinueCollisionProc
;命中なし
	ldy <vTmpB
	rts
.ContinueCollisionProc
.LargeHitBox
	jmp Misc_Collision
	ORG_TEST $3FF75C


	.ENDIF ;}


	.IF SW_QuickRecovering ;{
	BANKORG $3B94E5
	rts 
	BANKORG $3B9516
	rts
	.ENDIF ;}
	.IF SW_DisableChargeCancel ;{
	BANKORG $3884C2 ;アニメーション停止を削除
	bit $0000
	BANKORG $3884DB
	bit <$00
	BANKORG $3884E3
	bit <$9E
	bpl .NotResetTimer
	sta <$9E
.NotResetTimer
	lsr oFlag+0
	asl oFlag+0
	ORG_TEST $3884EF
	BANKORG $388518
	bne $84E9
	.ENDIF ;}

	.IF SW_NerfedSpike ;{
	BANKORG $388A89
	inc vSpikeTouched
	bne $8A72
	BANKORG $388AFF
	inc vSpikeTouched
	bne $8AED
	BANKORG $388EE5
	jsr Misc_NerfedSpike
	.ENDIF ;}



	.IF SW_OptimizeGamepad ;{
	BANKORG $3EC0A6
	jsr Misc_ObtimizeGamepad
	.ENDIF ;}
	.IF SW_OptimizeSoundProcess ;{
	;ある条件下における、3700フレーム間のサウンドドライバのplay処理の
	;フレーム平均サイクル 3272.7 => 3151.5 (-121.2)
	;サウンドドライバ全体からすると、3%強最適化されたといえる？

	;乗算のadc #$00を削る(原作8/大抵は3/incされる時は7)
	;被乗数の、1が現れるビットの回数だけ効果がある。
	BANKORG $348010
	bcc Misc_OptimizeSP_Multi0
	BANKORG $348019
	bcc .NotIncHighByte
	inc <$C1
.NotIncHighByte
Misc_OptimizeSP_Multi0:
	dey
	bne $800C
	rts
	ORG_TEST $348021
	;レジスタを叩く処理の最適化
	;叩く位置を算出するためにテーブルを利用する。
	BANKORG $3480EC
	sta <$C4
	tya
	ora Misc_OptimizeSP_TblRegAddr,x
	tay
	lda <$C4
	sta $4000,y
	rts
	FILL_TEST $3480FE
	;モジュレーションアドレスの計算を簡略化/テーブルを使えばガリガリ削れるかもしれない
	;55>=41
	BANKORG $348683
	tya
	asl a
;	rol <$C3
	asl a
	rol <$C3
	asl a
	rol <$C3
	clc
	adc #LOW($8B0F-8)
	sta <$C5
	lda <$C3
	and #$03
	adc #HIGH($8B0F-8)
	sta <$C6
	rts
	FILL_TEST $34869F
	;効果音のメモリクリアの最適化
	;ただのループ展開であり、容量を結構食うため、On/Offできるようにしてある
	; 407 => 230 => 169
	.IF SW_OptimizeSoundProcess=2
	BANKORG $348165
	ldy #$03
	jmp Misc_OptimizeSP_MemFillForEffect
	.ENDIF
	.IF SW_OptimizeSoundProcess=3
	BANKORG $348121
	beq $8105
	BANKORG $348135
	bcc $8105
	BANKORG $348165
	sta $0700+$00
	sta $0700+$01
	jmp Misc_OptimizeSP_MemFillForEffect
	ORG_TEST $34816E
	.ENDIF
	.ENDIF ;}

	.IF SW_ModifyFallingBlockSize ;{
	BANKORG $309F9F-3
	db $5B
	.ENDIF ;}

	.IF 0 ;{
	.ENDIF ;}
	;●他の最適化などから依存される処理
	.IFDEF SW_FastTransfer ;{
	.IF SW_SwitchWeapon
	BANKORG $3EC03A
	jsr Rockman_SwitchWeapon_Transfer
	.ENDIF
	BANKORG $3EC79E
	beq Misc_FastTransfer_rts
	BANKORG $3EC7B9 ;転送量テーブルを８バイトに変更
	and #$07
	BANKORG $3EC7BC ;８バイトのテーブルから読み出し
	lda Misc_FastTransfer_Tbl,x
	BANKORG $3EC7C1 ;２つのテーブルは統合できる
	bit $0000
	BANKORG $3EC7CA
	jmp Misc_FastTransferBody
Misc_FastTransfer_rts:
	rts
	FILL_TEST $3EC7D5 ;このアドレスのrtsは利用される
	BANKORG $3EC7D6 ;転送量テーブル
Misc_FastTransfer_Tbl:
	db $08,$01,$02,$03
	db $04,$05,$06,$07
	.ENDIF ;}
	.IFDEF SW_MinimizeAudioQueue ;{
	BANKORG $3EC8BA
	and #$07
	BANKORG $3EC8E4
	and #$07
	.ENDIF ;}
	;●デバッグ
	.IF SW_DebugAlwaysHaveAdaptor ;{
	BANKORG $38932A
	jmp $9331
	BANKORG $38933A
	jmp $9341
	.ENDIF ;}
	BANKORG Misc_org

