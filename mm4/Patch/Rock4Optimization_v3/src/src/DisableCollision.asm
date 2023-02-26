DisableCollision_Org:

DisableCollision_Tmp .macro
	BANKORG_D ($3A8683+\1-$D0)
	.db \2
	BANKORG_D ($3A8683+\1)
	TRASH_GLOBAL_LABEL
	DB_ADDRLHSPLIT \3,$D0
	.endm




	;●00(無し)等
	DisableCollision_Tmp $00,$3B,SkipCollision;無し
	DisableCollision_Tmp $01,$3B,SkipCollision;イロイロ処理無しObj
	DisableCollision_Tmp $60,$3B,SkipCollision;ブライトマンＳ暗闇でも見える床/ブーンブロック
	DisableCollision_Tmp $80,$3B,SkipCollision;エフェクト全般
;	DisableCollision_Tmp $81,$3B,SkipCollision;スカルマンのスカルバリア/イベントシーンダミー
	DisableCollision_Tmp $CC,$38,SkipCollision;ドリルマンの潜行時の煙
	;●26カバトンキューの台座等
	DisableCollision_Tmp $26,$3B,SkipCollision;カバトンキュー台座１つずつ
;	DisableCollision_Tmp $28,$3B,SkipCollision;ドリルボムで壊せる壁
;	DisableCollision_Tmp $67,$3B,SkipCollision;メットールダディの一部？
	DisableCollision_Tmp $99,$3D,SkipCollision;スクエアマシンの壁
;	DisableCollision_Tmp $AC,$3B,SkipCollision;タコトラッシュの一部
;	DisableCollision_Tmp $BB,$3B,SkipCollision;ワイリーマシンの一部
;	DisableCollision_Tmp $CD,$3B,SkipCollision;エスカルーの一部
	;12(ホバー)
	;●39(ホバーの弾)
	DisableCollision_Tmp $39,BANK(SkipCollision_Bullet_MoveX),SkipCollision_Bullet_MoveX
	;●15(サソリーヌジェネレータ)
	BANKORG_D $3A93BC
	TRASH_GLOBAL_LABEL
	lda oVal0,x
	bne .NotDecTimerhi
	dec oVal1,x
.NotDecTimerhi
	dec oVal0,x
	lda oVal1,x
	beq $93CF
	jmp SkipCollision
	END_BOUNDARY_TEST $3A93CF
	;16(バッタン)
	;●1B(ウォールブラスターの弾)
	BANKORG_D $3A9925
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;●1E(１００ワットン弾)
	BANKORG_D $3A9A70
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;32(ワッパー分裂した輪)
	;●34(ハエハエーの弾)
	DisableCollision_Tmp $34,$3B,SkipCollision_Bullet_MoveY
	;C8(ドンパンの花火ジェネレーター)
	;38(ドンパンの花火)
	;40(落石ジェネレータ)
	;42(エディ)
	;43(その場エディ)
	;44(エディのアイテム)
	;●4F(トーテムポールンの弾)
	DisableCollision_Tmp $4F,$3B,SkipCollision_Bullet_MoveX
	;●51(メットールの弾) ※ダメージ設定上スカルバリアーで消せません
	BANKORG_D $3BA6CD
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;●66(メットールスイムの水泡)
	DisableCollision_Tmp $66,$3B,DisableCollision_66
	;●63(スケルトンジョーの投げる骨)
	BANKORG_D $3BABCF
	jsr rYmoveG
	jmp SkipCollision_Bullet_MoveX
	;●6A(スカルメットの弾)
	BANKORG_D $3BAD6A
	jsr rYmoveG
	jmp SkipCollision_Bullet_MoveX
	;●6E(ヘリポンの弾)
	DisableCollision_Tmp $6E,$3B,SkipCollision_Bullet_MoveX
	;●9B(マミーラの投げた頭)
	BANKORG_D $3BB29D
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;●A8(ガチャッポンの直進弾)
	DisableCollision_Tmp $A8,$3B,SkipCollision_Bullet_MoveX
	;●A9(ガチャッポンの放物弾)
	BANKORG_D $3BB592
	jsr rYmoveG
	jmp SkipCollision_Bullet_MoveX
	;●B1(パカット24の弾)
	DisableCollision_Tmp $B1,$3B,SkipCollision_Bullet_MoveX
	;B4(アップンダウンのジェネレータ)
	;BD(トゲヘロジェネレータ(右端に配置))
	;CE(トゲヘロジェネレータ(左端に配置))
	;●B5(針ブロック)
	BANKORG_D $3BB9EC
	jmp DisableCollision_B5
	;●9D(撃破爆発→アイテム)
	BANKORG_D $3BBBE5
	jmp DisableCollision_9D
	;●C2(ワイヤー/バルーン)C1(置いてあるアイテム)
	BANKORG_D $3BBC54
	jmp DisableCollision_C1
	;C6(落下するアイテム?)（※たぶん未使用）
	;●タイプ20(リングS虹足場1)×4
	BANKORG_D $3DA01B
	jmp DisableCollision_20_1
	BANKORG_D $3DA0C0+1
	.db LOW (DisableCollision_20_2)
	BANKORG_D $3DA0C5+1
	.db HIGH(DisableCollision_20_2)
	BANKORG_D $3DA167+1
	.db LOW (DisableCollision_20_3)
	BANKORG_D $3DA16C+1
	.db HIGH(DisableCollision_20_3)
	
	;90(モビーの始末係)
	;2D(エスカルー撃破処理)
	;3A(ワッパー撃破処理)
	;●2E(ティウン)
	BANKORG_D $3DA904
	TRASH_GLOBAL_LABEL
	bne .Delete
	jmp SkipCollision
.Delete
	jmp rDeleteObjX
	END_BOUNDARY_TEST $3DA90D
	;2F(ブライトSのリフト(片道))
	;C9(ブライトSのリフト(往復))
	;4B(カバトンキューの始末係)
	;4C(１００ワットン撃破後)
	;57(ドリルSのレバー未使用仕掛け1)×４
	;5B(ドリルSのレバー)
	;5E(ダストSプレスマネージャ)
	;6B(ダイブS水量マネージャ1)
	;6C(ダイブS水量マネージャ2)
	;●CF(ダイブS水位変動地帯のトゲ)
	BANKORG_D $3DAFAC
	jmp DisableCollision_CF
	;●6F(ロックマンが水に飛び込んだときの水しぶき)
	BANKORG_D $3DAFB3
	jmp DisableCollision_6F
	;73(ダストS組みあがる足場)
	;●74(ダストS組みあがる足場の断片)
	BANKORG_D $3DB033
	jmp DisableCollision_74
	BANKORG_D $3DB084+1
	.db LOW (DisableCollision_74_2)
	BANKORG_D $3DB089+1
	.db HIGH(DisableCollision_74_2)
	BANKORG_D $3DB0C0+1
	.db LOW (DisableCollision_74_3)
	BANKORG_D $3DB0C5+1
	.db HIGH(DisableCollision_74_3)
	;●8A(モスラーヤの弾)
	BANKORG_D $3DB5C8
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;●88(モスラーヤの一部)
	DisableCollision_Tmp $88,$3D,SkipCollision_SkipDamage
	;●89(モスラーヤの一部)
	DisableCollision_Tmp $89,$3D,SkipCollision_SkipDamage
	;●93(コサックキャッチャーのアーム)
	DisableCollision_Tmp $93,$3D,SkipCollision
	;●94(コサックキャッチャーの弾)97(スクエアマシンの弾)
	BANKORG_D $3DBA90
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;96(スクエアマシンのリフト)
	BANKORG_D $3DBD7A+1
	.db LOW (DisableCollision_96)
	BANKORG_D $3DBD7F+1
	.db HIGH(DisableCollision_96)

	;AE(タコトラッシュの炎)
	;AF(タコトラッシュのリフト)
	;B3(ワープカプセル)
	;29(モスラーヤ/スクエアマシン/メットールダディ/タコトラッシュ撃破処理)
	;BF(ワイリーマシンの砲撃)
	;2A(８ボス撃破後のティウン吸収)4D(ワイリーカプセルの収束弾)
	;49(コックローチツイン１匹目の始末係)
	;4A(コックローチツイン２匹目の始末係)
	;45(コックローチツインの足場)
	;5D(コサック3の出現床)
	;C3(ブーンブロックマネージャ)
	;C5(収束弾の実体)
	;●72(スカルマンの弾)
	BANKORG_D $38AA64
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;76(リングマンのリングブーメラン)
	;7A(ダストマンのダストクラッシャー分裂前)
	;7B(ダストマンのダストクラッシャー分裂後)
	;82(ドリルマンの煙マネージャ)
	;●85(ファラオウェーブ)
	DisableCollision_Tmp $85,$3B,SkipCollision_Bullet_MoveX
	;●86(ファラオショット) ※上下にはみ出た時消える処理がなくなっているけど別に問題はないだろう
	BANKORG_D $38B52E
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;●8C(ブライトマンの弾)
	BANKORG_D $38B718
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	;●9F(コックローチツイン２の大弾)A0(コックローチツイン１・２の弾)
	BANKORG_D $38BC62
	TRASH_GLOBAL_LABEL
	lda oYhe,x
	beq .NotSuicide
	jmp rDeleteObjX
.NotSuicide
	jsr rYpmeVy
	jmp SkipCollision_Bullet_MoveX
	END_BOUNDARY_TEST $38BC71

	BANKORG DisableCollision_Org
