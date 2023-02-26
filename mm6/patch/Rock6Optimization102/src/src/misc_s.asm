Misc_S_org:
;雑多な処理(固定バンク配置)
	BANKORG Misc_S_org

	;ロングコール関係のルーチン {
;バンクをまたいだプログラムのコール
;呼び出し先にはa,x,yが正しく渡る。
;呼び出し元にはa,x,y,フラグが正しく帰る。
;バンク先頭(8000,A000)へのジャンプには失敗するので注意。
Misc_LongCall:
.TmpZPMem1 = $17
.TmpZPMem2 = $31
	;呼び出し先に渡すa,yを退避
	sta <.TmpZPMem2
	sty <.TmpZPMem2+1
	;記述されたアドレスの読み出しのためのポインタ設定
	pla
	sta <.TmpZPMem1+0
	pla
	sta <.TmpZPMem1+1
	;復帰位置をスタックに書き込み
	clc
	lda <.TmpZPMem1+0
	adc #$03
	tay
	lda <.TmpZPMem1+1
	adc #$00
	pha
	tya
	pha
	;現在のプログラムバンクをスタックに書き込み
	lda <vCurBnk8
	pha
	lda <vCurBnkA
	pha
	;復帰用ルーチンのアドレスをスタックに書き込み
	lda #HIGH(Misc_LongReturn-1)
	pha
	lda #LOW(Misc_LongReturn-1)
	pha
	;呼び出しアドレスを読み込み、アドレスをスタックに書き込み
	ldy #$01
	lda [.TmpZPMem1],y
	pha
	sta vLongCallTmp
	iny
	lda [.TmpZPMem1],y
	pha
	iny
	;呼び出しバンクを読み込み、アドレスより妥当な位置のバンクを切り替え
	lda vLongCallTmp
	cmp #$A0
	lda [.TmpZPMem1],y
	ldy #$06
	bcc .call_2_8000
	iny
.call_2_8000
	sty <vMMC3Cmd
	sty ioMMC3Cmd
	sta ioMMC3Value
	sta vCurBnk8-6,y ;0ページ不可
	;呼び出し先に渡すz,yの復元
	ldy <.TmpZPMem2+1
	lda <.TmpZPMem2
	rts

Misc_LongReturn:
.TmpZPMem1 = $17
	sta <.TmpZPMem1
	php
	pla
	sta <.TmpZPMem1+1
	;Prg(A000)を戻す
	lda #$07
	sta <vMMC3Cmd
	sta ioMMC3Cmd
	pla
	sta ioMMC3Value
	sta <vCurBnkA
	;Prg(8000)を戻す
	lda #$06
	sta <vMMC3Cmd
	sta ioMMC3Cmd
	pla
	sta ioMMC3Value
	sta <vCurBnk8
	;a,フラグ
	lda <.TmpZPMem1+1
	pha
	lda <.TmpZPMem1
	plp
	rts
	; ロングコール関係のルーチン}
	;追加のルーチン {
Misc_SwapPrgBank8:
	sta <vCurBnk8
	lda #$06
	sta <vMMC3Cmd
	sta ioMMC3Cmd
	lda <vCurBnk8
	sta ioMMC3Value
	rts
	;}

	.IF SW_FastScrolling ;{
;転送待ちウェイト
Misc_FastScrollingWait1:
	sta <vLastScrollDirection
	db $2C ;Bit Hack
Misc_FastScrollingWait2:
	;Bit Hack
	sta <vNTMirroring
	;Bit Hackここまで
.loop
	lda <vVRAMXferSize
	beq .rts
	jsr rWaitThread
	jmp .loop
.rts
	rts

	.ENDIF ;}
	.IF SW_FixSpriteGlitch_LEdge ;{
	;バグが発生しうるフレームにおいて、
	;0番目のスプライトがゲージである時はそのまま処理を続行する。
	;バグが発生しうるフレームにて、スプライト00がゲージになることはありえないので
	;バグが発生するシチュエーションであることを利用している。
	;なお、SW_FixSpriteGlitch_Gaugeも入れておかないと、この条件が破綻する。
Misc_SpriteGlitch_LEdge:
	bcs .TestCond
.ExitSetup
	inc <$8C
	jmp $E26D
.TestCond
	lda aSprDMASrc+1 ;最初のスプライト
	cmp #$9F
	beq .ContinueSetup
	bcs .ExitSetup
	cmp #$85
	bcs .ExitSetup
	cmp #$81
	bcc .ExitSetup
.ContinueSetup
	jmp $E26D

	.ENDIF ;};
	.IF SW_OptimizeDMASrcFilling ;{
	;メモ:利用スプライト数が少ない時は最適化できるが
	;スプライト数が多い時(＝より最適化したい時)に逆効果になっているのが痛い。
	;外したほうが良いかもしれない。
	;・実測例(※ROM上のどこに割り当てられるか、等で結果が変わります)
	;E271～E27E間を実測。原作 → 最適化後
	;ロックマン＋ゲージ1本     : 884 / 772 → 422 / 375
	;スプライト1枚(チート再現) : 1012 → 474
	;スプライト63枚(チート再現): 20 → 80
	;スプライト59枚以上利用する時は、原作のほうが早い。
Misc_OptimizeDMASrcFilling:
;10バイト分は呼び出し元へ移動{
;	lda <$8C ;現在のスプライト数
;	pha
;	and #$E0
;	tax
;	pla
;	and #$1F
;	lsr a
;}
	bcs .rts
	tay
	lda .Tbl_Addr+0,y
	sta <$08
	lda .Tbl_Addr+1,y
	sta <$09
	lda #$F0
	clc ;※xの値を進める時以外キャリーフラグに触らないこと
	jmp [$0008]
.loop
	tax
	lda #$F0
.X00
	sta aSprDMASrc+$00,x
.X04
	sta aSprDMASrc+$04,x
.X08
	sta aSprDMASrc+$08,x
.X0C
	sta aSprDMASrc+$0C,x
.X10
	sta aSprDMASrc+$10,x
.X14
	sta aSprDMASrc+$14,x
.X18
	sta aSprDMASrc+$18,x
.X1C
	sta aSprDMASrc+$1C,x
	txa
	adc #$20
	bne .loop

.rts
	jmp $E27E
.Tbl_Addr
	dw .X00
	dw .X04
	dw .X08
	dw .X0C
	dw .X10
	dw .X14
	dw .X18
	dw .X1C

	.ENDIF ;}
	.IF SW_OptimizeCollision ;{
Misc_Collision:
	ldy <$08 ;τ判定サイズ1/後に判定W
	clc
	lda $F849,y ;判定サイズY
	ldy <$0A ;τ判定サイズ2/後にΔx;
	adc $F849,y ;判定サイズY
	ldy <vTmpB
	sta <$09 ;τ判定H
	bmi .LargeHitBox
	sec
	lda <$02 ;τYhi[x]
	sbc oYhi,y
	bpl .NotInvA ;bplなのががポイントで、ページを跨ごうが近い方の距離で計算される
	INV_A
.NotInvA
	cmp <$09 ;τ判定H
	bcc .ContinueCollisionProc
	beq .ContinueCollisionProc
;命中なし
;	ldy <vTmpB
	rts
.ContinueCollisionProc
.LargeHitBox
	lda <vTmpA
	sta <$08 ;τ判定サイズ1/後に判定W
	stx <vTmpA

;	ldy <vTmpB
	lda oXhe,y
	sta <$05 ;τXhe[y]
	lda oYhe,y
	sta <$07 ;τYhe[y]
	lda oYhi,y
	sta <$06 ;τYhi[y]/後に|Δy|
	jmp $F75C

	.ENDIF ;}
	.IF SW_OptimizeGamepad ;{
	;メモ:ループ展開しただけ。
	;２コンと外部入力コントローラをサポートしない
	;511 => 138
Misc_ObtimizeGamepad:
	lda <$40
	eor #$FF
	sta <$44
	ldx #$01
	stx $4016
	dex
	stx $4016
	lda $4016
	lsr a
	rol <$40
	lda $4016
	lsr a
	rol <$40
	lda $4016
	lsr a
	rol <$40
	lda $4016
	lsr a
	rol <$40
	lda $4016
	lsr a
	rol <$40
	lda $4016
	lsr a
	rol <$40
	lda $4016
	lsr a
	rol <$40
	lda $4016
	lsr a
	rol <$40
	lda <$40
	and <$44
	sta <$42
	jmp $C739
	.ENDIF ;}
	;穴あきテーブルがあるので、その隙間を何かに使い回すべき。
	;スイッチが2が指定された時はプログラムを詰める。
	.IF SW_OptimizeSoundProcess ;{
Misc_OptimizeSP_TblRegAddr:
	.db $0C,$08,$04,$00 ;先頭４バイト

	.IF SW_OptimizeSoundProcess=2
	;スイッチが2の時は穴あきテーブルにプログラムを詰め込む
Misc_OptimizeSP_MemFillForEffect:
.loop
	sta $0700+$00,y
	sta $0700+$04,y
	sta $0700+$08,y
	sta $0700+$0C,y
	sta $0700+$10,y
	sta $0700+$14,y
	sta $0700+$18,y
	sta $0700+$1C,y
	sta $0700+$20,y
	sta $0700+$24,y
	dey
	bpl .loop
	rts
	db 0,0
	.ELSE
	;それ以外の時は無駄なデータで埋める。この部分は別用途に転用可能。サイズは変えないように。
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0
	.ENDIF
.Addr1
	.db $0C,$08,$04,$00
	.IF (.Addr1)-(Misc_OptimizeSP_TblRegAddr)!=$28
	.FAIL Misc_OptimizeSP_TblRegAddrテーブルが不正です
	.ENDIF

	.IF SW_OptimizeSoundProcess=3
Misc_OptimizeSP_MemFillForEffect:
	sta $0700+$02
	sta $0700+$03
	sta $0700+$04
	sta $0700+$05
	sta $0700+$06
	sta $0700+$07
	sta $0700+$08
	sta $0700+$09
	sta $0700+$0A
	sta $0700+$0B
	sta $0700+$0C
	sta $0700+$0D
	sta $0700+$0E
	sta $0700+$0F
	sta $0700+$10
	sta $0700+$11
	sta $0700+$12
	sta $0700+$13
	sta $0700+$14
	sta $0700+$15
	sta $0700+$16
	sta $0700+$17
	sta $0700+$18
	sta $0700+$19
	sta $0700+$1A
	sta $0700+$1B
	sta $0700+$1C
	sta $0700+$1D
	sta $0700+$1E
	sta $0700+$1F
	sta $0700+$20
	sta $0700+$21
	sta $0700+$22
	sta $0700+$23
	sta $0700+$24
	sta $0700+$25
	sta $0700+$26
	sta $0700+$27
	rts
	.ENDIF

	.ENDIF ;}
	.IF SW_OmitRushAdaptor=2 ;{
SW_OmitRushAdaptor2_Xfer:
	ldy <$9B ;アダプター使用状態
	lda <$04 ;サブ画面を開く前のアダプター使用状態
	beq .Normal2Adaptor
	iny
	iny
.Normal2Adaptor
	lda OmitRushAdaptor_TblXfer-1,y
	jsr rReserveTransfer ;VRAM転送aを実行/状況によりキューが開くのを待つ
	jmp $965F

	.ENDIF ;}
	.IF SW_NerfedSpike ;{
Misc_NerfedSpike:
	ldy vSpikeTouched
	beq .rts
	ldy #$00
	sty vSpikeTouched
	lda <$A2
	bne .rts
	inc <$96
	sec
	lda oHP+0
	sbc #SW_NerfedSpike
	sta oHP+0
.rts
	lda oHP+0
	rts
	.ENDIF ;}

