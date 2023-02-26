DisableCollision_Org:

DisableCollision_Tmp .macro
	BANKORG_D ($1C86C3+\1)
	.db \2
	BANKORG_D ($1C88C3+\1)
	TRASH_GLOBAL_LABEL
	DB_ADDRLHSPLIT \3,$D0
	.endm

	DisableCollision_Tmp $00,$1D,SkipCollision;無し
	DisableCollision_Tmp $01,$1D,SkipCollision;ダミー/武器ダメ0/Spr12
	DisableCollision_Tmp $1E,$1D,SkipCollision;ウェーブステージ水上バイク終了
	DisableCollision_Tmp $6D,$1D,SkipCollision;チャージマンの煙エフェクト/Ｌ缶等
;	DisableCollision_Tmp $71,$1D,SkipCollision;ビッグペッツの胸部(反射用)

;	DisableCollision_Tmp $C9,$1D,SkipCollision;
;	DisableCollision_Tmp $CA,$1D,SkipCollision;
;	DisableCollision_Tmp $CB,$1D,SkipCollision;
;	DisableCollision_Tmp $CC,$1D,SkipCollision;
;	DisableCollision_Tmp $CD,$1D,SkipCollision;
;	DisableCollision_Tmp $CE,$1D,SkipCollision;
;	DisableCollision_Tmp $CF,$1D,SkipCollision;

;	DisableCollision_Tmp $43,$03,SkipCollision;(ダミー/武器ダメ0/Spr12)

	;★03(ティウン)
	BANKORG_D $1DB86D
	bne $B872
	jmp SkipCollision
	;▲04(チャージステージ列車に入る)
	BANKORG_D $0AA676
	jsr SkipCollision_TestCollision_Rts
	bit <$00
	;▲05(ウェーブステージパイプの入り口)
	BANKORG_D $0AA69F
	jsr SkipCollision_TestCollision_Rts
	bit <$00
	;★06(重力反転↓|↑ロング)/07(重力反転↑|↓ショート)
	BANKORG_D $05A000
	jsr SkipCollision_TestCollision_Rts
	bit <$00
	;★08(重力反転↑/↓ロング)
	BANKORG_D $05A035
	jsr SkipCollision_TestCollision_Rts
	bit <$00
	;●09(スターステージ上下足場マネージャ)
	BANKORG_D $05A078
	lda #$7F
	BANKORG_D $05A07D
	bit <$00
	jsr DisableCollision_SetReturnPoint
;●0A(ジャイロステージエレベータ１)
;●0B(ジャイロステージエレベータ２)
	;★0C(ジャイロステージ落下床)
	BANKORG_D $05A1D1
	jmp DisableCollision_0C
	;★0D(ウェーブステージ浮遊泡)
	BANKORG_D $05A238
	lda #$3F
	BANKORG_D $05A23D
	bit <$00
	jsr DisableCollision_SetReturnPoint
	BANKORG_D $05A2A4
	lda #$AB
	BANKORG_D $05A2A9
	bit <$00
	jsr DisableCollision_SetReturnPoint
;●0E(ウェーブステージ泡マネージャ)
;●0F(プレスの仕掛けマネージャ)
;▲22(エディ)
	;●23(テッキューン)
	BANKORG_D $1C9631
	jmp DisableCollision_58
	;●24(ミザイルのジェネレータ)
	DisableCollision_Tmp $24,$1D,DisableCollision_24
	;★2C(タテパッカンの弾)
	DisableCollision_Tmp $2C,$1D,SkipCollision_Bullet_MoveX
	;★2E(ダイダイン)
	BANKORG_D $1C9660
	lda #LOW (DisableCollision_2E)
	BANKORG_D $1C9665
	lda #HIGH(DisableCollision_2E)
;▲30(中爆発×５マネージャ)
	;★37(ライダージョーの弾)
	DisableCollision_Tmp $37,$1D,SkipCollision_Bullet_MoveX
;●38(隕石マネージャ)
	;★3C(バウンダーの弾)
	DisableCollision_Tmp $3C,$1D,SkipCollision_Bullet_MoveXY
	;★3F(トスマシーンの弾)
	BANKORG_D $1DA0B5
	jmp SkipCollision_Bullet_MoveX
;●41(チャージステージのラスターマネージャ)
;▲42(ウェーブステージ水上バイク乗り込み)
	;★47(ワイリーカプセルの落下弾)
;	DisableCollision_Tmp $47,$04,DisableCollision_47
	BANKORG_D $04A540
	bcs $A54D
	BANKORG_D $04A545
	lda #$4A
	BANKORG_D $04A54A
	jmp SkipCollision_Bullet_MoveX
	jmp SkipCollision_Bullet
	;★48(スターステージ上下足場)
	BANKORG_D $05A525
	lda #$2C
	BANKORG_D $05A52A
	bit <$00
	jsr DisableCollision_SetReturnPoint
;▲49(ブルース４の縦スクロールマネージャ)
;●4A(ブルース３の動く床(生成))
;●4B(ブルース３の動く床(消去))
;▲4D(ボス撃破後ティウン吸引)
	;★4E(オクトパーの弾)
	DisableCollision_Tmp $4E,$1D,DisableCollision_4E7F
	;★51(メットールマミーの弾)
	DisableCollision_Tmp $51,$1D,DisableCollision_MoveXY_Stone
	;★55(タバン/メットールK-1000/アパッチジョー/トンデオールの弾)
	DisableCollision_Tmp $55,$1D,DisableCollision_MoveXY_Stone
;▲57(エディの投げたアイテム)
	;★58(Ｇスージーの弾)
	DisableCollision_Tmp $58,$1D,SkipCollision_Bullet_MoveX
	;★5B(ジェットボムの破片)
	DisableCollision_Tmp $5B,$1D,DisableCollision_5B
	;★5E(ロックスローンの岩の破片)
	DisableCollision_Tmp $5E,$1D,SkipCollision_SkipDamage
	;★61(Ｂビッターの弾)
	DisableCollision_Tmp $61,$1D,SkipCollision_Bullet_MoveXY
	;★6A(ストーンマンのパワーストーン)
	BANKORG_D $06A19E
	bcc DisableCollision_6A
	BANKORG_D $06A1A5
	bne $A1AA
DisableCollision_6A:
	jmp SkipCollision_Bullet
	BANKORG_D $06A1D2
	bne DisableCollision_6A
	BANKORG_D $06A1EE
	jmp DisableCollision_6A_2

	;★6C(チャージマンの蒸気)
	DisableCollision_Tmp $6C,$06,DisableCollision_6C
	BANKORG_D $06A425
	lda #LOW (DisableCollision_6C_2)
	BANKORG_D $06A42A
	lda #HIGH(DisableCollision_6C_2)
	;★6F(ジャイロマンのジャイロアタック1)
	BANKORG_D $06A5E3
	bcc DisableCollision_80
	BANKORG_D $06A5EA
	bcs DisableCollision_80
	BANKORG_D $06A61C
	jmp SkipCollision_Bullet_MoveY
;？7A(ビッグペッツの胴体部)
	;出来なくはなさそうなのだが大変そうなので省略
	;★7D(サークリングＱ９のリフト)
	BANKORG_D $02A542
	bcs DisableCollision_7D
	BANKORG_D $02A581
	bne DisableCollision_7D
	BANKORG_D $02A592
	beq DisableCollision_7D
	BANKORG_D $02A59E
DisableCollision_7D:
	jmp SkipCollision
	;★7E(サークリングＱ９の大弾)
	BANKORG_D $02A536
	jmp SkipCollision_Bullet_MoveX
	;★7F(サークリングＱ９のプチ弾)
	DisableCollision_Tmp $7F,$1D,DisableCollision_4E7F
	;★80(ジャイロマンのジャイロアタック2)
	BANKORG_D $06A629
	bcc DisableCollision_80
	BANKORG_D $06A635
	bne $A63A
DisableCollision_80:
	jmp SkipCollision_Bullet
	BANKORG_D $06A642
	bne DisableCollision_80
	BANKORG_D $06A647
	jmp SkipCollision_Bullet_MoveX
	;★82(グラビティーマンの弾)
	DisableCollision_Tmp $82,$07,SkipCollision_Bullet_MoveXY
	;★84(クリスタルマンの反射クリスタル)
	DisableCollision_Tmp $84,$07,DisableCollision_84
	;★85(クリスタルマンの弾)
	DisableCollision_Tmp $85,$07,SkipCollision_Bullet_MoveXY
	;★87(ウェーブマンのモリ)
	DisableCollision_Tmp $87,$07,SkipCollision_Bullet_MoveX
	;★8A(ナパームマンのミサイル)
	DisableCollision_Tmp $8A,$08,DisableCollision_8A
	;★8B(ナパームマンのナパームボム)
	DisableCollision_Tmp $8B,$08,DisableCollision_8B
	;★94(ダークマン３の弾)
	DisableCollision_Tmp $94,$09,SkipCollision_Bullet_MoveXY
	;★95(ダークマン３の石化弾)
	;94/97を移動させて空いた部分を拝借
	BANKORG_D $09A2CE
DisableCollision_95:
	lda #HIGH(SkipCollision_Bullet-1)
	pha
	lda #LOW (SkipCollision_Bullet-1)
	pha
	DisableCollision_Tmp $95,$09,DisableCollision_95
	;★97(ダークマン１の弾)
	DisableCollision_Tmp $97,$09,DisableCollision_MoveXY_Stone2
	;★9A(ダークマン４の弾)
	DisableCollision_Tmp $9A,$09,SkipCollision_Bullet_MoveX
	;★9B(ツインキャノンの弾１)
	DisableCollision_Tmp $9B,$1D,SkipCollision_Bullet_MoveXY
	;★9D(ダチョーンのレーザー)
	DisableCollision_Tmp $9D,$1D,SkipCollision_Bullet_MoveXY
;	;★9F(メットールスイムの弾)
	DisableCollision_Tmp $9F,$1D,DisableCollision_MoveXY_Stone
;▲A2(偽ブルース)
;▲A3(イベントの弾)
;▲A4(ブルース)
	;●A6(ワイリーマシン５吸引攻撃)
	DisableCollision_Tmp $A6,$04,DisableCollision_A6
	;★A7(ワイリーマシン５バウンド弾)
	DisableCollision_Tmp $A7,$04,DisableCollision_A7
	;★A8(ワイリーマシン５ミサイル)
	DisableCollision_Tmp $A8,$04,DisableCollision_A8
;▲A9(ワイリーマシン５から緊急脱出するワイリー)
	;★AB(ワイリーカプセルの回転弾)
	BANKORG_D $04A52B
	dec oVal0,x
	jmp SkipCollision_Bullet_MoveXY
;●AF(ワープカプセル)
;▲B0(ボスラッシュのライフ大)
	;★B6(設置されたアイテム)/★B7(ドロップアイテム)
	BANKORG_D $1DAE42
	jmp DisableCollision_B6B7
	;★B8(ザコ撃破爆発)
	BANKORG_D $1DAE5C
	jmp DisableCollision_B8
;▲BB(噴出す水？)
;ウェーブマンのウォーターウェーブと同じルーチン？
	;★BF(メットールスイムの水泡)
	;判定スキップによる最適化以外も含んでいるが細かいことは気にしない
	DisableCollision_Tmp $BF,$1D,DisableCollision_BF

	BANKORG DisableCollision_Org
