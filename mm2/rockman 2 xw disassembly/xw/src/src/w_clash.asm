;●武器配置設定
	BANKORG_D $1ED44C+$6 ;タイプ
	BANKORG_D $1ED45E+$6 ;フラグ
	.db $81
	BANKORG_D $1ED470+$6 ;配置Δx
	BANKORG_D $1ED482+$6 ;Vxlo
	.db $00
	BANKORG_D $1ED494+$6 ;Vxhi
	.db $04
	BANKORG_D $1ED4A6+$6 ;Vylo
	.db $00
	BANKORG_D $1ED4B8+$6 ;Vyhi
	.db $00
	BANKORG_D $1ED4CA+$6 ;判定サイズ

;爆風
	BANKORG_D $1ED44C+$C ;タイプ
	BANKORG_D $1ED45E+$C ;フラグ
	BANKORG_D $1ED470+$C ;配置Δx
	BANKORG_D $1ED482+$C ;Vxlo
	.db $00
	BANKORG_D $1ED494+$C ;Vxhi
	.db $04
	BANKORG_D $1ED4A6+$C ;Vylo
	.db $00
	BANKORG_D $1ED4B8+$C ;Vyhi
	.db $00
	BANKORG_D $1ED4CA+$C ;判定サイズ
;●ボスへのダメージ処理
	;当たっても消滅するだけ
	BANKORG_D $17A847
	bne $A893
	BANKORG_D $17A850
	beq $A893
	BANKORG_D $17A876
	.db 0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0
	BANKORG_D $17A893
	lsr A_ObjFlag,x ;存右？？弾重特当
;●ザコへのダメージ処理
	BANKORG_D $1FE8A0
	bne $E8F1
	BANKORG_D $1FE8AB
	beq $E8F1
	BANKORG_D $1FE8D4
	.db 0,0,0,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.db 0
	BANKORG_D $1FE8F1
	lsr A_ObjFlag,x ;存右？？弾重特当

;●ダメージ
;・ボス
	BANKORG_D $17A977
	.db  5 ;4ヒート
	.db  7 ;2*エアー
	.db  2 ;1ウッド
	.db  3 ;2バブル
	.db  4 ;3クイック
	.db  3 ;2フラッシュ
	.db  2 ;1メタル
	.db  4 ;3クラッシュ
	.db  1 ;1メカドラゴン
	.db  0 ;0ダミー？
	.db  1 ;1ガッツタンク
	.db  0 ;0ダミー？
	.db  6 ;2*ワイリーマシン
	.db  1 ;1エイリアン
;ワイリーマシンのカバー脱落前は弾く
	BANKORG_D $169A1D+1
	.db 8
	BANKORG_D $169A21+1
	.db $FF ;ついでに弾く２種類のうち一つを無効に
;・ザコ
	BANKORG_D $1FEC4A+$6D
	.db  0 ;ブービーム

;●スプライトアニメーション
	BANKORG_D $1FFBD8+0
	.db 3
	.db 1


