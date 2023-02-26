;●武器配置設定
	BANKORG_D $1ED44C+$3 ;タイプ
	BANKORG_D $1ED45E+$3 ;フラグ
	.db $87
	BANKORG_D $1ED470+$3 ;配置Δx
	.db $10
	BANKORG_D $1ED482+$3 ;Vxlo
	.db $40
	BANKORG_D $1ED494+$3 ;Vxhi
	.db $03
	BANKORG_D $1ED4A6+$3 ;Vylo
	.db $00
	BANKORG_D $1ED4B8+$3 ;Vyhi
	.db $00
	BANKORG_D $1ED4CA+$3 ;判定サイズ

;●スプライトアニメーション
	BANKORG_D $1FFBF0+0
	.db 3
	.db 1
	.db $56,$58,$57,$59

;●ダメージ
;・ボス
	BANKORG_D $17A94D
	.db  5 ;4ヒート
	.db  3 ;2エアー
	.db  2 ;1ウッド
	.db  6 ;2*バブル
	.db  4 ;3クイック
	.db  3 ;2フラッシュ
	.db  2 ;1メタル
	.db  4 ;3クラッシュ
	.db  5 ;1*メカドラゴン
	.db  0 ;0ダミー？
	.db  1 ;1ガッツタンク
	.db  0 ;0ダミー？
	.db  4 ;2ワイリーマシン
	.db  1 ;1エイリアン
