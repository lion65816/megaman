;●武器配置設定
	BANKORG_D $1ED44C+$0 ;タイプ
	BANKORG_D $1ED45E+$0 ;フラグ
	BANKORG_D $1ED470+$0 ;配置Δx
	BANKORG_D $1ED482+$0 ;Vxlo
	BANKORG_D $1ED494+$0 ;Vxhi
	BANKORG_D $1ED4A6+$0 ;Vylo
	BANKORG_D $1ED4B8+$0 ;Vyhi
	BANKORG_D $1ED4CA+$0 ;判定サイズ

;●ダメージ
;・ボス
	BANKORG_D $17A923
	.db  4 ;4ヒート
	.db  2 ;2エアー
	.db  1 ;1ウッド
	.db  2 ;2バブル
	.db  3 ;3クイック
	.db  2 ;2フラッシュ
	.db  1 ;1メタル
	.db  3 ;3クラッシュ
	.db  1 ;1メカドラゴン
	.db  0 ;0ダミー？
	.db  1 ;1ガッツタンク
	.db  0 ;0ダミー？
	.db  2 ;2ワイリーマシン
	.db  1 ;1エイリアン

;・ザコ
	BANKORG_D $1FE976+$6A
	.db  2 ;ピコピコ

