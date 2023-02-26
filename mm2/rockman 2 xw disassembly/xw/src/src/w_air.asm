
C_Air_Amp      = 10
C_Air_T        = 12

; y     = - a ( x - T/4 ) ^ 2 + C_Air_Amp
; dy/dx = - 2 a ( x - T/4 )
; (d/dx)^2 y = - 2 a
; (x,y) = (0,0)  =>  a = - C_Air_Amp / ( T / 4 )^2

C_Air_a_100    = -$100*C_Air_Amp/(C_Air_T/4)/(C_Air_T/4)
C_Air_Vy0_100  = 2*C_Air_a_100*(C_Air_T/4)


;●武器配置設定
	BANKORG_D $1ED44C+$2 ;タイプ
	BANKORG_D $1ED45E+$2 ;フラグ
	BANKORG_D $1ED470+$2 ;配置Δx
	BANKORG_D $1ED482+$2 ;Vxlo
	.db $80
	BANKORG_D $1ED494+$2 ;Vxhi
	.db $00
	BANKORG_D $1ED4A6+$2 ;Vylo
	.db $00
	BANKORG_D $1ED4B8+$2 ;Vyhi
	.db $00
	BANKORG_D $1ED4CA+$2 ;判定サイズ

;●ダメージ
;・ボス
	BANKORG_D $17A93F
	.db 10 ;4ヒート
	.db  3 ;2エアー
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
	.db  1 ;2ワイリーマシン
	.db  2 ;1エイリアン




