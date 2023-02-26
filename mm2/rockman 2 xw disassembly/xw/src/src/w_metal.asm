;●武器配置設定
	BANKORG_D $1ED44C+$7 ;タイプ
	BANKORG_D $1ED45E+$7 ;フラグ
	BANKORG_D $1ED470+$7 ;配置Δx
	.db $10
	BANKORG_D $1ED482+$7 ;Vxlo
	.db $00
	BANKORG_D $1ED494+$7 ;Vxhi
	.db $05
	BANKORG_D $1ED4A6+$7 ;Vylo
	BANKORG_D $1ED4B8+$7 ;Vyhi
	.db $00
	BANKORG_D $1ED4CA+$7 ;判定サイズ

;●ダメージ
;・ボス
	BANKORG_D $17A985
	.db  5 ;4ヒート
	.db  3 ;2エアー
	.db 10 ;1ウッド
	.db  3 ;2バブル
	.db  4 ;3クイック
	.db  3 ;2フラッシュ
	.db  2 ;1メタル
	.db  3 ;3クラッシュ
	.db  1 ;1メカドラゴン
	.db  0 ;0ダミー？
	.db  1 ;1ガッツタンク
	.db  0 ;0ダミー？
	.db  2 ;2ワイリーマシン
	.db  1 ;1エイリアン
;・ザコ
	BANKORG_D $1FECC2+$6D
	.db 20 ;ブービーム

