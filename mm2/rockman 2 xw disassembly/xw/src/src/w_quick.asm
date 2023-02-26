;●定数
C_Quick_V = $04 ;速さ


;●武器配置設定
	BANKORG_D $1ED44C+$5 ;タイプ
	BANKORG_D $1ED45E+$5 ;フラグ
	BANKORG_D $1ED470+$5 ;配置Δx
	BANKORG_D $1ED482+$5 ;Vxlo
	.db $00
	BANKORG_D $1ED494+$5 ;Vxhi
	.db C_Quick_V
	BANKORG_D $1ED4A6+$5 ;Vylo
	.db $E0 ;微妙に下に移動することで、それっぽい戻り挙動になる
	BANKORG_D $1ED4B8+$5 ;Vyhi
	.db $FF
	BANKORG_D $1ED4CA+$5 ;判定サイズ


;●ダメージ
;・ボス
	BANKORG_D $17A969
	.db  5 ;4ヒート
	.db  3 ;2エアー
	.db  2 ;1ウッド
	.db  3 ;2バブル
	.db  4 ;3クイック
	.db  3 ;2フラッシュ
	.db  2 ;1メタル
	.db 10 ;3*クラッシュ
	.db  1 ;1メカドラゴン
	.db  0 ;0ダミー？
	.db  3 ;1*ガッツタンク
	.db  0 ;0ダミー？
	.db  3 ;2ワイリーマシン
	.db  1 ;1エイリアン

