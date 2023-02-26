;●武器配置設定
	BANKORG_D $1ED44C+$1 ;タイプ
	BANKORG_D $1ED45E+$1 ;フラグ
	BANKORG_D $1ED470+$1 ;配置Δx
	.db $10
	BANKORG_D $1ED482+$1 ;Vxlo
	.db $00
	BANKORG_D $1ED494+$1 ;Vxhi
	.db $08
	BANKORG_D $1ED4A6+$1 ;Vylo
	BANKORG_D $1ED4B8+$1 ;Vyhi
	BANKORG_D $1ED4CA+$1 ;判定サイズ


;●ザコへのダメージ処理
;タイムストッパーと共通にします
	BANKORG_D $1FE6B1
	lda <V_CurWeapon
	lsr a
	;H:1 F:6
	bcs $E6BA
	bcc $E6C0
;	;実質フラッシュ多段ヒットのために無敵処理を無効に
;	BANKORG_D $1FE6DD
;	bne $E6E5
;	beq $E6E5

;●ボスへのダメージ処理
;タイムストッパー？のためにチマチマ処理を修正
	;大玉のダメージのみ参照する
	BANKORG_D $17A66C
	jmp $A68A

;●「スクロール時に消えない」を無効に
	BANKORG_D $1C9228+1
	.db $FF

;●スプライトアニメーション
	BANKORG_D $1FFBDF+1
	.db 0
	.db $2F,$4E,$4D,$50,$4F,$52,$51,$00

;●ダメージ
;技の性質があまりに変わっているため、全体的に修正
;・ボス
	BANKORG_D $17A931
	.db $FF;4ヒート
	.db  3 ;2エアー
	.db  2 ;1ウッド
	.db  3 ;2バブル
	.db  4 ;3クイック
	.db  8 ;2*フラッシュ
	.db  2 ;1メタル
	.db  4 ;3クラッシュ
	.db  1 ;1メカドラゴン
	.db  0 ;0ダミー？
	.db  1 ;1ガッツタンク
	.db  0 ;0ダミー？
	.db  3 ;2*ワイリーマシン
	.db  0 ;1エイリアン
;・ザコ
	BANKORG_D $1FE9F2
	.db 20 ;00シュリンク
	.db 20 ;シュリンク？
	.db  0 ;
	.db  0 ;
	.db 20 ;M-445
	.db  0 ;
	.db 20 ;撃破爆発(なぜかダメージ指定がある)
	.db  0 ;

	.db 20 ;クロウ
	.db  0 ;
	.db  5 ;タニッシー
	.db 10 ;タニッシーの殻
	.db  3 ;ケロッグ
	.db 20 ;子ケロッグ
	.db  0 ;
	.db  2 ;アンコ

	.db  0 ;10
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db 10 ;バットン
	.db  5 ;ロビット

	.db  0 ;
	.db  1 ;フレンダー
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  7 ;モンキング
	.db  0 ;
	.db 10 ;クック

	.db  0 ;20
	.db  0 ;
	.db 20 ;テリー
	.db  0 ;チャンキーメーカー
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;
	.db  5 ;ピエロボットのギア
	.db 20 ;ピエロボットの本体
	.db  0 ;
	.db  7 ;フライボーイ
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;30プレス
	.db 10 ;ブロッキー
	.db  0 ;
	.db  0 ;
	.db 20 ;メットール
	.db  0 ;
	.db  5 ;マタサブロウ
	.db  0 ;

	.db 20 ;ピピ
	.db  0 ;
	.db 20 ;ピピのタマゴ
	.db 20 ;ピピの卵の殻(なぜかダメージ指定がある)
	.db 20 ;子ピピ
	.db  5 ;カミナリゴロー(本体)
	.db  0 ;
	.db  0 ;

	.db  0 ;40
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db 20 ;プチゴブリン
	.db  1 ;スプリンガー
	.db  0 ;

	.db  7 ;モール
	.db  7 ;モール
	.db  0 ;
	.db  5 ;ショットマン
	.db  5 ;ショットマン
	.db  0 ;
	.db  1 ;スナイパーアーマー
	.db  2 ;スナイパージョー

	.db  5 ;50スクワームのジェネレータ
	.db 10 ;スクワーム
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;60
	.db  0 ;リーフシールド
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;

	.db  0 ;
	.db  0 ;
	.db  2 ;ピコピコ
	.db  0 ;
	.db  0 ;
	.db  1 ;ブービーム
	.db  0 ;
	.db  0 ;

	.db  0 ;70
	.db  1 ;ビッグフィッシュ
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
	.db  0 ;
