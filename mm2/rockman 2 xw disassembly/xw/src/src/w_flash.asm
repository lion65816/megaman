;●武器配置設定
	BANKORG_D $1ED44C+$8 ;タイプ
	BANKORG_D $1ED45E+$8 ;フラグ
	.db $81
	BANKORG_D $1ED470+$8 ;配置Δx
	.db $10-$09 ;※１フレーム目に走る分
	BANKORG_D $1ED482+$8 ;Vxlo
	.db $00
	BANKORG_D $1ED494+$8 ;Vxhi
	.db $09
	BANKORG_D $1ED4A6+$8 ;Vylo
	BANKORG_D $1ED4B8+$8 ;Vyhi
	BANKORG_D $1ED4CA+$8 ;判定サイズ

;●ザコへのダメージ処理
;アトミックファイヤーに送り込みます
	BANKORG_D $1FE964+6
	.db LOW ($E6A4)
	BANKORG_D $1FE96D+6
	.db HIGH($E6A4)

;ちょっとコーディング
	BANKORG_D $1FE6C0
	TRASH_GLOBAL_LABEL
	lda TABLE_DAMAGE_TO_1X_FLASH,y
	pha
	cpx #$02
	bne .no_splitting
	jsr WEAPON_FLASH_SPLITTING
.no_splitting
	pla
	beq $E6CE
;	jmp $E6CE
;	Addr<=1FE6CE


;クイックマンステージのレーザー撃ち落せないかなーｗ　とか試してみたらしい
;	BANKORG_D $1C9CFE
;	.db $E3,$A3,$E3,$A3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3
;	.db $A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3,$A3,$E3
;	.db $A3,$E3,$A3,$A3,$A3,$A3,$E3,$E3,$A3,$A3,$A3,$A3,$A3,$A3,$A3,$E3
;	.db $A3,$A3,$E3,$A3

;●ボスへのダメージ処理
	BANKORG_D $17A911+6
	.db LOW (WEAPON_FLASH_DAMAGE_0X)
	BANKORG_D $17A91A+6
	.db HIGH(WEAPON_FLASH_DAMAGE_0X)

	BANKORG_D $17A66F
TABLE_DAMAGE_TO_0X_FLASH:
	.db  6 ;4ヒート
	.db  3 ;2エアー
	.db  2 ;1ウッド
	.db  3 ;2バブル
	.db  4 ;3クイック
	.db  3 ;2フラッシュ
	.db  8 ;1メタル
	.db  4 ;3クラッシュ
	.db  2 ;1メカドラゴン
	.db  0 ;0ダミー？
	.db  2 ;1ガッツタンク
	.db  0 ;0ダミー？
	.db  5 ;2ワイリーマシン
	.db  2 ;1エイリアン
WEAPON_FLASH_DAMAGE_0X:
	lda A_ObjFlag+1 ;存右？？弾重特当
	and #$08
	bne $A6B2
	ldy <$B3 ;ボスの種類
	lda TABLE_DAMAGE_TO_0X_FLASH,y
	nop
;	jmp $A68A

;	Addr<=17A68A

;●「スクロール時に消えない」を無効に
	BANKORG_D $1C9224+1
	.db $FF

;●アニメーション定義
	BANKORG_D $1FFC10
	.db 2,2
	.db $30,$31,$32,$33 ;※１つ多く定義しておく

;●スプライトNo/Attr定義
	BANKORG_D $1489F8
SPRITE_NA_30:
	.db $01,$5B
	.db $9C,$01
SPRITE_NA_31:
	.db $01,$5B
	.db $9D,$01
SPRITE_NA_32:
	.db $01,$5B
	.db $9E,$01
SPRITE_NA_33:
	.db $01,$5B
	.db $9A,$01

;●スプライトΔ位置定義
	BANKORG_D $15B470+2
SPRITE_POS_5B:
	.db $FC,$FC

;定義したスプライト情報のアドレス指定

	BANKORG_D $148000+$30
	.db LOW (SPRITE_NA_30)
	BANKORG_D $148200+$30
	.db HIGH(SPRITE_NA_30)
	BANKORG_D $148000+$31
	.db LOW (SPRITE_NA_31)
	BANKORG_D $148200+$31
	.db HIGH(SPRITE_NA_31)
	BANKORG_D $148000+$32
	.db LOW (SPRITE_NA_32)
	BANKORG_D $148200+$32
	.db HIGH(SPRITE_NA_32)
	BANKORG_D $148000+$33
	.db LOW (SPRITE_NA_33)
	BANKORG_D $148200+$33
	.db HIGH(SPRITE_NA_33)
	BANKORG_D $148400+ $5B
	.db LOW (SPRITE_POS_5B-2)
	BANKORG_D $148500+ $5B
	.db HIGH(SPRITE_POS_5B-2)
