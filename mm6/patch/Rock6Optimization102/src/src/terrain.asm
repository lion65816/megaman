Terrain_org:
;地形判定の最適化
	.IF SW_OptimizeTerrain ;{
	BANKORG_D $3ED326
	bne $D330
	BANKORG_D $3ED236
	adc #HIGH(aChipV)
	BANKORG_D $3ED2C2
	lda aChipFlagV,y
	BANKORG_D $3ED42A
	rts
	
	BANKORG_D $3ED356
	adc #HIGH(aChipV)
	BANKORG_D $3ED3CC
	lda aChipFlagV,y

	;チップが変更される時のバンク読み込みを無効に/ポインタを正しく向ける
	BANKORG_D $3ED932
	jmp $D937
	BANKORG_D $3ED937
	lda #HIGH (aChipV)
	BANKORG_D $3ED9AD
	rts

	BANKORG_D $3EDA6C
	jmp Misc_OptTerrain
	
	BANKORG_D $3EDAFF
	rts

	.ENDIF ;}
	.IF SW_OptimizeTerrain2 ;{

	;判定処理本体 {
;使える変数
;<$02 汎用
;<$03 32タイル内の16タイルのオフセットとして利用される
;<$54 ＼ページ定義のアドレスに利用される
;<$55 ／
;<$64 ＼16タイルへのアドレスとして利用される
;<$65 ／
;<$68 ＼32タイルへのアドレスとして利用される
;<$69 ／
;<$4F 判定したXheとして利用される
;<$50 判定したYheとして利用される
;In
;<$00 Δx
;<$01 Δy
;Out
;<$11 一番強い判定
;<$13 チップ番号
;<$4D 判定したXhi
;<$4E 判定したYhi
	BANKORG $3EDA6C
	lda <$4F ;判定Xhe
	and #$0F
	;7XXXにaChipを確保すれば、and #$0Fが省略できそうな気がしたが
	;負のページでバグりそうなのでやめておく
	ora #HIGH(aChip)
	sta <vTmpD
	lda <$4D ;判定Xhi
	and #$F0
	ldy <$4E ;判定Yhi
	ora aTblHighNibble,y
	tay
	lda [vTmpC_00],y
;	sty <vTmpA
	tay
	lda aChipFlagT,y
	cmp <$11
	bcc .NotStrongest ;なんか原作から処理順がバグっぽい気がするんですけど
;	ldy <vTmpA
	sty <$13 ;出力用
	sta <$11
.NotStrongest
	rts
	FILL_TEST $3EDB03
	
	;}
	
	;スクロール時にマップを読み込む
	BANKORG $3ED73A
	jsr Terrain_TrigLoadNextRoom
	BANKORG $3ED772
	jsr Terrain_TrigLoadNextRoom
	BANKORG $3ED7C1
	jsr Terrain_TrigLoadNextRoom
	BANKORG $3ED7FE
	jsr Terrain_TrigLoadNextRoom
	BANKORG $3ED840
	jsr Terrain_TrigLoadNextRoom
	BANKORG $3ED87D
	jsr Terrain_TrigLoadNextRoom

	;破壊されるときに転送されるグラフィック
	BANKORG $3ED937
	lda #HIGH(aChipGrp)
	BANKORG $3ED93B
	lda #LOW (aChipGrp)

	;変化フラグを立てる処理にて、16x16タイルの属性を変更する
	BANKORG $3EDBAD
	jmp Terrain_LoadTerrainFlag80

	BANKORG $3EDD36
	jmp Terrain_SetupNTQueue_V
	FILL_TEST $3EDD3F ;※このアドレスには他の場所から渡る
	
	;NameTableへのデータ転送セットアップ処理 {
	BANKORG $3ED326
Terrain_SetupNTQueue_V:
	lda #$01
	sta <vNTMirroring
	;($4F~$4D,$4E)
	;各種転送に必要な値をセット
	lda #$20
	sta <$5D ;NT書込アドレスhi
	lda <$4D
	lsr a
	lsr a
	lsr a
	sta <$5C ;NT書込アドレスlo
	sta <$5A ;X座標(タイル単位)
	lsr a
	lsr a
	sta <$6A ;NT色テーブル書込時に読み込むデータのオフセット
	ora #$C0
	sta <$5E ;NT色テーブル書込アドレスlo
	lda #$23
	sta <$5F ;NT色テーブル書込アドレスhi
	lda #$00
	sta <$5B
	sta <$6C

	;16タイルのアドレスを計算
	;0000XXXX xxxx0000
	lda <$4D
	and #$F0
	ora #$0E
	sta <$08 ;τ16タイルアドレスlo
	lda <$4F
	and #$0F
	ora #HIGH(aChip)
	sta <$09 ;τ16タイルアドレスhi

	;Grpタイルのアドレスのベースアドレスを計算
	lda #$00
	sta <$0C ;τGrpタイルアドレスlo
	sta <$64 ;τ16タイル色アドレスlo
	sta <$01 ;τ色or値/そのワーキング
	lda <$5A ;X座標(タイル単位)
	and #$01
	ora #HIGH(aChipGrp)
	sta <$0D ;τGrpタイルアドレス(上)hi
	sta <vTmpD ;τGrpタイルアドレス(下)hi
	inc <vTmpD ;τGrpタイルアドレス(下)hi
	inc <vTmpD ;τGrpタイルアドレス(下)hi
	lda #HIGH(aChipFlagC)
	sta <$65 ;τ16タイル色アドレスhi

	lda <$5A ;X座標(タイル単位)
	lsr a
	lsr a
	sta <$61 ;τ色テーブルのオフセット
	lda #$10
	ldy #$33
	bcs .32Tile_RightSide
	lda #$00
	ldy #$CC
.32Tile_RightSide
	sta <$02 ;τ色or値テーブルオフセット(32タイルの左右の位置の差異による)
	sty <$8D ;τ色and値
	ldx #$1C
	bne .First
.loop
	dec <$08 ;※ここに置くと最後の１回分得になる
	ldy #$00
	lda [$08],y
	tay
	lda [$0C],y ;τGrpタイルアドレス(上)lo
	sta aNTXfer+2,x
	lda [vTmpC_00],y ;τGrpタイルアドレス(下)lo
	sta aNTXfer+3,x
	lda [$64],y ;τ16タイル色アドレスlo
	sta <$01 ;τ色or値/そのワーキング

	dec <$08
.First
	ldy #$00
	lda [$08],y
	tay
	lda [$0C],y ;τGrpタイルアドレス(上)lo
	sta aNTXfer+0,x
	lda [vTmpC_00],y ;τGrpタイルアドレス(下)lo
	sta aNTXfer+1,x

	lda [$64],y ;τ16タイル色アドレスlo
	asl a
	asl a
	ora <$02 ;τ色or値テーブルオフセット(32タイルの左右の位置の差異による)
	ora <$01 ;τ色or値/そのワーキング
	tay
	lda .Tbl_Or,y
	sta <$01 ;τ色or値/そのワーキング

	lda <$61 ;τ色テーブルのオフセット
	ora .Tbl_MP+0,x
	tay
	lda aNTColor,y
	and <$8D ;τ色and値
	ora <$01 ;τ色or値/そのワーキング
	sta aNTColor,y

	;cc
	txa
	adc #$FC
	tax
;	dex
;	dex
;	dex
;	dex
	bpl .loop

	lda #$76 ;00,68でなければなんでも良いらしい
	sta <vTrigNTXfer
	pla
	tax
	rts

.Tbl_MP ;穴あきテーブル
	db $00,$00,$00,$00
	db $08,$00,$00,$00
	db $10,$00,$00,$00
	db $18,$00,$00,$00
	db $20,$00,$00,$00
	db $28,$00,$00,$00
	db $30,$00,$00,$00
	db $38
.Tbl_Or
	;(左or右)上上下下の５ビット
	;左側(0,1,2,3)
	db $00,$10,$20,$30
	db $01,$11,$21,$31
	db $02,$12,$22,$32
	db $03,$13,$23,$33
	;右側(0,4,8,C)
	db $00,$40,$80,$C0
	db $04,$44,$84,$C4
	db $08,$48,$88,$C8
	db $0C,$4C,$8C,$CC


	FILL_TEST $3ED42E
	; }

	;シャッターへの対応
	BANKORG $3ED44C ;16タイル属性を一旦変化
	LONG_CALL Terrain_ShutterInit

	BANKORG $3ED485 ;一旦変化させた16タイル属性を戻す
	jsr Terrain_ShutterResume
	
	;武器取得画面への対応
	BANKORG $3BBD3A
	jsr Terrain_WeaponGetScreen

	;カプセルワープへの対応
	BANKORG $3989E0
	jsr Terrain_CapsuleWarp
	BANKORG $398E92
	jsr Terrain_CapsuleWarp
	BANKORG $398F5E
	jsr Terrain_CapsuleWarp


	;ケンタウロスマンステージ突入地点
	BANKORG $398A60
	ldy #$03
	jsr Terrain_VaryFlag

	;ケンタウロスマンステージ水無効
	BANKORG $398A2E
	ldy #$06
	jsr Terrain_VaryFlag

	;ボスラッシュ脱出カプセル
	BANKORG $398F7E
	ldy #$00
	jsr Terrain_VaryFlag

	;ステージ読み込み時(ケンタウロスマンステージ用)(要らない)
	;この場所でフラグ変更後、ステージロードが入り
	;その時に16タイルが正しく読み込まれる
;	BANKORG $3ECDC3
;	ldy #$**
;	jsr Terrain_VaryFlag

	;エックスステージ2
	BANKORG $399236
	ldy #$09
	jsr Terrain_VaryFlag
	rts
	
	;エンディングのデモ
	BANKORG $3B8942
	jsr Terrain_EndingBossDemo

	.ENDIF ;}

	BANKORG Terrain_org

	.IF SW_OptimizeTerrain2 ;{
	SETBANKA000
Terrain_LoadRoom: ;{
	pha
	ldy <vCurStage
	lda .Tbl_RoomAddrlo,y
	sta <vTmpA
	lda .Tbl_RoomAddrhi,y
	sta <vTmpB
	pla
	tay
	lda [vTmpA],y
	sta <$00
	;逆検索
.SeekRoomOrg_loop
	dey
	bmi .SeekRoomOrg_exit
	cmp [vTmpA],y
	beq .SeekRoomOrg_loop
.SeekRoomOrg_exit
	sty <$08 ;τ開始画面数-1/処理中画面数
	;順検索
.SeekRoomEnd_loop
	iny
	cmp [vTmpA],y
	beq .SeekRoomEnd_loop
	sty <$09 ;τ終了画面数+1

	.IF SW_Debug00FillAtLoadingStage ;テスト用のゼロクリア
	lda #$00
	tay
.ZeroFill_loop
	sta aChip+$000,y
	sta aChip+$100,y
	sta aChip+$200,y
	sta aChip+$300,y
	sta aChip+$400,y
	sta aChip+$500,y
	sta aChip+$600,y
	sta aChip+$700,y
	sta aChip+$800,y
	sta aChip+$900,y
	sta aChip+$A00,y
	sta aChip+$B00,y
	sta aChip+$C00,y
	sta aChip+$D00,y
	sta aChip+$E00,y
	sta aChip+$F00,y
	dey
	bne .ZeroFill_loop
	
	.ENDIF

	;使ってよさげの変数
	;00
	;08 09 (3A8032)
	;0A-0F (スプライト処理)
	;11 12 (3A8252)
	;15 16 (3ECB28)

	;バンクにまたいでデータが入っているので、
	;まず、ページ内32x32タイルのデータを先に読みだす
	;ページ内32x32タイルは通常A000にマップされるが、8000にマップして読みだす。
	lda <vMapBankA
	jsr Misc_SwapPrgBank8

	jsr .SetupDestAddr_etc

	lda <$08 ;τ開始画面数-1/処理中画面数
	asl a
	asl a
	asl a
	ora #$07
	sta <$11 ;τ32tilelo
	sec
	lda <aAddrPage+1
	sbc #$20
	sta <$12 ;τ32tilehi

	ldy #$00
.ld32tile_loop_each_line
.ld32tile_loop_in_line
	lda [$11],y ;τ32tilelo
	sta [$15],y ;τ書き込み先lo
	;読み込み32タイルを縦に１進める
	inc <$12 ;τ32tilehi
	;書き込み（一時）32タイルを縦に１進める
	clc
	lda <$15 ;τ書き込み先lo
	adc #$02
	sta <$15 ;τ書き込み先lo
	and #$0F
	bne .ld32tile_loop_in_line
	dec <$0A ;残り処理回数
	beq .ld32tile_exit
	;読み込み32タイルを横に１進める
	sec
	lda <$12 ;τ32tilehi
	sbc #$08
	sta <$12 ;τ32tilehi
	inc <$11 ;τ32tilelo ;自動で256ループする
	;書き込み（一時）32タイルを横に１進める(既に16タイル１個分は動いている)
	clc
	lda <$15 ;τ書き込み先lo
	adc #$10
	sta <$15 ;τ書き込み先lo
	lda <$16 ;τ書き込み先hi
	adc #$00
	and #$6F
	sta <$16 ;τ書き込み先hi
	jmp .ld32tile_loop_each_line
.ld32tile_exit

;	;左端より左は、とりあえず、00番の32タイルを使用
;	lda <$08 ;τ開始画面数-1/処理中画面数
;	bpl .NotFirstScreen
;	lda #$00
;	ldy #$1F
;.FirstScreen_loop
;	sta aChip+$FE0,y
;	dey
;	bpl .FirstScreen_loop
;.NotFirstScreen

	;一時展開した32x32タイル情報を16x16タイルにさらに展開
	lda <vMapBank8
	jsr Misc_SwapPrgBank8

	jsr .SetupDestAddr_etc
	ldy #$00
.ld16tile_loop_each_line
.ld16tile_loop_in_line
	lda [$15],y ;τ書き込み先lo
	sta <$11 ;τ16tilelo
	tya
	asl <$11 ;τ16tilelo
	rol a
	asl <$11 ;τ16tilelo
	rol a
;	clc
	adc <vAddrTileHi
	sta <$12 ;τ16tilehi
	lda [$11],y ;τ16tilelo
	sta [$15],y ;τ書き込み先lo
	iny
	lda [$11],y ;τ16tilelo
	sta <$0F
	iny
	lda [$11],y ;τ16tilelo
	sta <$0E
	iny
	lda [$11],y ;τ16tilelo
	ldy #$11
	sta [$15],y ;τ書き込み先lo
	dey
	lda <$0F
	sta [$15],y ;τ書き込み先lo
	ldy #$01
	lda <$0E
	sta [$15],y ;τ書き込み先lo
	dey
	;書き込み（一時）32タイルを縦に１進める
	clc
	lda <$15 ;τ書き込み先lo
	adc #$02
	sta <$15 ;τ書き込み先lo
	and #$0F
	bne .ld16tile_loop_in_line
	dec <$0A ;残り処理回数
	beq .ld16tile_exit
	;書き込み（一時）32タイルを横に１進める(既に16タイル１個分は動いている)
	clc
	lda <$15 ;τ書き込み先lo
	adc #$10
	sta <$15 ;τ書き込み先lo
	lda <$16 ;τ書き込み先hi
	adc #$00
	and #$6F
	sta <$16 ;τ書き込み先hi
	jmp .ld16tile_loop_each_line
.ld16tile_exit

	rts

.SetupDestAddr_etc
	lda #$E0
	sta <$15 ;τ書き込み先lo
	lda <$08 ;τ開始画面数-1/処理中画面数
	and #$0F
	ora #HIGH(aChip)
	sta <$16 ;τ書き込み先hi

	sec
	lda <$09 ;τ終了画面数+1
	sbc <$08 ;τ開始画面数-1/処理中画面数
	asl a
	asl a
	asl a
	sec
	sbc #$06
	sta <$0A ;残り処理回数
	rts

.Tbl_RoomAddrlo
	db LOW(._0)
	db LOW(._1)
	db LOW(._2)
	db LOW(._3)
	db LOW(._4)
	db LOW(._5)
	db LOW(._6)
	db LOW(._7)
	db LOW(._8)
	db LOW(._9)
	db LOW(._A)
	db LOW(._B)
	db LOW(._C)
	db LOW(._D)
	db LOW(._E)
	db LOW(._F)
.Tbl_RoomAddrhi
	db HIGH(._0)
	db HIGH(._1)
	db HIGH(._2)
	db HIGH(._3)
	db HIGH(._4)
	db HIGH(._5)
	db HIGH(._6)
	db HIGH(._7)
	db HIGH(._8)
	db HIGH(._9)
	db HIGH(._A)
	db HIGH(._B)
	db HIGH(._C)
	db HIGH(._D)
	db HIGH(._E)
	db HIGH(._F)



._0
	db 0,0,0,0,0,0
	db 1
	db 2,2,2,2,2
	db 3
	db 4
	db 5,5,5,5,5,5
	db 6,7,8,9,10
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF

._1
	db 0,0
	db 1,2,3
	db 4,4,4
	db 5,5,5
	db 6
	db 7,7
	db 8,9
	db 10,10,10
	db 11,12,13
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF

._2
	db 0,0,0,0
	db 1
	db 2,2
	db 3
	db 4
	db 5,5,5,5,5
	db 6
	db 7,7,7,7,7,7,7
	db 8,9
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF

._3
	db 0,0,0,0,0,0
	db 1
	db 2,2,2,2,2,2
	db 3
	db 4,4,4,4,4,4,4,4
	db 5,6
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF

._4
	db 0,0,0
	db 1
	db 2,2,2
	db 3,3
	db 4
	db 5,5
	db 6,7,8,9,10,11,12
	db 13,13
	db 14,15,16
	db 17,18
	db 19,19
	db 20,21
	db $FF,$FF

._5
	db 0,0,0
	db 1,2,3
	db 4,4,4
	db 5
	db 6,6,6
	db 7,8,9,10
	db 11,11
	db 12
	db 13,13
	db 14,15
	db 16,16,16,16
	db 17,18,19,20

._6
	db 0,1,2
	db 3,3,3,3
	db 4,5,6
	db 7,7,7,7
	db 8
	db 9,9
	db 10
	db 11,11,11,11
	db 12,13
	db 14,15,16
	db $FF,$FF,$FF,$FF
	db $FF

._7
	db 0,0,0,0,0
	db 1
	db 2,2,2,3
	db 5,5,5,5,6
	db 7
	db 8,8,8
	db 9,10
	db 11,12,13
	db 14,15,16
	db $FF,$FF,$FF,$FF
	db $FF

._8
	db 0,0,0
	db 1,2,3,4,5,6,7
	db 8,8,8,8
	db 9,10,11,12
	db 13,13,13,13
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF

._9
	db 0,0,0,0,0
	db 1,1,1
	db 2,2,2
	db 3,3,3
	db 4,4
	db 5,6,7 ;7の部屋は実は必要ないらしい
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF

._A
	db 0,1
	db 2,2,2,2,2,2
	db 3,3
	db 4
	db 5,5,5,5,5
	db 6,7
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF

._B
	db 0,1
	db 2,2,2,2,2,2
	db 3,4
	db 5,5,5,5,5
	db 6
	db 7,7,7,7,8,9
	db 10,10,10
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF

._C
	db 0,0,0
	db 1,2,3,4,5,6,7,8,9,10,11
	db 12,13,14,15,16,17
	db 18,19,20,21
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF

._D
	db 0,0,0,0
	db 1
	db 2,2,2,2,2
	db 3,4,4,4,5,6
	db 7,7,7
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF

._E
	db 0,0,0,0,0,0
	db 1,2
	db 3,4,5,6,7,8,9,10,11
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF

._F
	db 0,1,2,3,4,5,6
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF
	db $FF




	db $FF ;終端に一応置いておく
	
	; }
Terrain_Load16Flag: ;{
	jsr Terrain_Load16Flag_common

	lda #$00
	sta <$0A ;Bit読み出し回数
;	sta <$0B ;読み出し中フラグデータ
	sta <$0C ;フラグオフセット
;	sta <$0D ;tmp
	ldx #$03
.ld16Grp_loop
	dec <$0A ;Bit読み出し回数
	bpl .ld16Grp_FlagNotInc
	sty <$0D ;tmp
	ldy <$0C ;オフセット
	lda aChipVaried,y
	sta <$0B ;読み出し中フラグデータ
	tya
	clc
	adc #$01
	and #$1F
	sta <$0C ;オフセット
	lda #$07
	sta <$0A ;Bit読み出し回数
	ldy <$0D ;tmp
.ld16Grp_FlagNotInc
	lsr <$0B ;読み出し中フラグデータ
	bcs .ld16Grp_Varied
	lda [vTmpC_00],y ;τ16tilelo
	bcc .ld16Grp_NotVaried_conf
.ld16Grp_Varied
	lda [$11],y ;τ読み込み破壊チップlo
.ld16Grp_NotVaried_conf
	sta [$15],y ;τ書き込み先lo
	iny
	bne .ld16Grp_loop
	inc <vTmpD
	inc <$12 ;τ読み込み破壊チップhi
	inc <$16
	dex
	bpl .ld16Grp_loop

.ld16Flag_loop
	dec <$0A ;Bit読み出し回数
	bpl .ld16Flag_FlagNotInc
	sty <$0D ;tmp
	ldy <$0C ;オフセット
	inc <$0C ;オフセット
	lda aChipVaried,y
	sta <$0B ;読み出し中フラグデータ
	lda #$07
	sta <$0A ;Bit読み出し回数
	ldy <$0D ;tmp
.ld16Flag_FlagNotInc
	lsr <$0B ;読み出し中フラグデータ
	bcs .ld16Flag_Varied
	lda [vTmpC_00],y ;τ16tilelo
	bcc .ld16Flag_NotVaried_conf
.ld16Flag_Varied
	lda [$11],y ;τ読み込み破壊チップlo
.ld16Flag_NotVaried_conf
	tax
	and #$03
	sta aChipFlagC,y
	lda aTblHighNibble,x
	ora <$00 ;地形テーブルのオフセット
	tax
	lda $DB13,x
	sta aChipFlagT,y
	iny
	bne .ld16Flag_loop
	rts

;}
Terrain_Load16Flag_8:
	jsr Terrain_Load16Flag_common
	lda <$80
	lsr a
	lsr a
	lsr a
	tay
	lda aChipVaried,y
	sta <$0B ;読み出し中フラグデータ
	lda <$80
	and #$F8
	tay
	lda #$00
	sta <$0C

	lda #$08
	sta <$0A ;残り回数
.loop
	lsr <$0B ;読み出し中フラグデータ
	bcs .ld16Flag_Varied
	lda <vTmpD
	bcc .ld16Flag_NotVaried_conf
.ld16Flag_Varied
	lda <$12
.ld16Flag_NotVaried_conf
	sta <$0D
	lda [$0C],y
	sta aChipGrp+$000,y
	inc <$0D
	lda [$0C],y
	sta aChipGrp+$100,y
	inc <$0D
	lda [$0C],y
	sta aChipGrp+$200,y
	inc <$0D
	lda [$0C],y
	sta aChipGrp+$300,y
	inc <$0D
	lda [$0C],y
	and #$03
	sta aChipFlagC,y
	lda [$0C],y
	tax
	lda aTblHighNibble,x
	ora <$00 ;地形テーブルのオフセット
	tax
	lda $DB13,x
	sta aChipFlagT,y

	iny
	dec <$0A ;残り回数
	bne .loop

	rts

Terrain_Load16Flag_common:
	lda <vMapBank8
	jsr Misc_SwapPrgBank8

	ldy <vCurStage
	lda $DB03,y
	asl a
	asl a
	asl a
	asl a
	sta <$00 ;地形テーブルのオフセット

	lda #$00
	tay
	sta <$15 ;τ書き込み先lo
	sta <$11 ;τ読み込み破壊チップlo
	lda <vAddrChipHi
	sta <vTmpD
	lda #$9B
	sta <$12 ;τ読み込み破壊チップhi
	lda #HIGH(aChipGrp)
	sta <$16 ;τ書き込み先hi
	rts

Terrain_LoadTerrainFlag80_body: ;{
	lda <vMapBank8
	jsr Misc_SwapPrgBank8

	ldy <vCurStage
	lda $DB03,y
	asl a
	asl a
	asl a
	asl a
	sta <vTmpA ;地形テーブルのオフセット

	ldy <$80
	lda #$9B
	sta <vTmpD
	lda [vTmpC_00],y
	sta aChipGrp+$000,y
	inc <vTmpD
	lda [vTmpC_00],y
	sta aChipGrp+$100,y
	inc <vTmpD
	lda [vTmpC_00],y
	sta aChipGrp+$200,y
	inc <vTmpD
	lda [vTmpC_00],y
	sta aChipGrp+$300,y
	inc <vTmpD
	lda [vTmpC_00],y
	pha
	and #$0F
	sta aChipFlagC,y

	pla
	tay
	lda aTblHighNibble,y
	ora <vTmpA ;地形テーブルのオフセット
	tay
	lda $DB13,y
	ldy <$80
	sta aChipFlagT,y
	rts

;}
Terrain_ShutterInit:
	lda #$00
	sta <$EF
	lda <$80
	;2bitは捨てる
	lsr a
	lsr a
	sta vTerrain2Shutter
	lsr a ;bit 2でマスクを決定
	;上位5bitをオフセットに
	tay
	lda #$0F
	bcc .Mask0F
	lda #$F0
.Mask0F
	ora aChipVaried,y
	sta aChipVaried,y
	jsr Terrain_Load16Flag_8
	lsr <$80
	rts
Terrain_ShutterResume_Body:
	lda vTerrain2Shutter
	lsr a
	tay
	lda #$0F
	bcc .Mask0F
	lda #$F0
.Mask0F
	eor aChipVaried,y
	sta aChipVaried,y
	dec <$80 ;この処理までに１大きい位置を指している
	jmp Terrain_Load16Flag_8
Terrain_WeaponGetScreen_Body:
	ldy #$01
	sty aChipFlagT+8
	dey
	sty aChipFlagT+0
	tya
.loop
	tya
	and #$08
	sta aChip+$700,y
	dey
	bne .loop
	rts

Terrain_CapsuleWarp_Body:
	pha
	jsr Terrain_LoadRoom
	pla
	rts

Terrain_VaryFlag_Body:
.loop
	lda .Tbl+0,y
	bmi .rts
	sta <$0A
	lda .Tbl+1,y
	sta <$0B
	iny
	iny
	tya
	pha
	ldy <$0A
	lda <$0B
	sta aChipVaried,y
	tya
	asl a
	asl a
	asl a
	sta <$80
	jsr Terrain_Load16Flag_8
	pla
	tay
	bne .loop

.rts
	rts
	
.Tbl
	;ボスラッシュ
	db $0C,$FF
	db $FF
	;ケンタウロス/00
	db $18,$00
	db $FF
	;ケンタウロス/07
	db $18,$07
	db $FF
	;エックスステージ２落下床
	db $18,$00
	db $19,$00
	db $1A,$00
	db $FF
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;空きスペースにしておく



	SETBANK8000
	.ENDIF ;}

