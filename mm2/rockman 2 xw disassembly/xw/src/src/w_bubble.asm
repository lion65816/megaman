;●武器配置設定
	BANKORG_D $1ED44C+$4 ;タイプ
	BANKORG_D $1ED45E+$4 ;フラグ
	.db $83
	BANKORG_D $1ED470+$4 ;配置Δx
	BANKORG_D $1ED482+$4 ;Vxlo
	BANKORG_D $1ED494+$4 ;Vxhi
	BANKORG_D $1ED4A6+$4 ;Vylo
	.db $00
	BANKORG_D $1ED4B8+$4 ;Vyhi
	.db $00
	BANKORG_D $1ED4CA+$4 ;判定サイズ

;●ダメージ
;・ボス
	BANKORG_D $17A95B
	.db  5 ;4ヒート
	.db  3 ;2エアー
	.db  2 ;1ウッド
	.db  3 ;2バブル
	.db  8 ;3クイック
	.db  3 ;2フラッシュ
	.db  2 ;1メタル
	.db  4 ;3クラッシュ
	.db  1 ;1メカドラゴン
	.db  0 ;0ダミー？
	.db  1 ;1ガッツタンク
	.db  0 ;0ダミー？
	.db  3 ;2ワイリーマシン
	.db  1 ;1エイリアン



