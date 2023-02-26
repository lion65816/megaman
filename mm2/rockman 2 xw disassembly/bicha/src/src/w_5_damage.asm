;●ダメージ
;・ボス
	BANKORG_D $17A969
	.db $32 ;ヒート
	.db $32 ;エアー
	.db $21 ;ウッド
	.db $43 ;バブル
	.db $32 ;クイック
	.db $32 ;フラッシュ
	.db $21 ;メタル
	.db $21 ;クラッシュ
	.db $20 ;メカドラゴン
	.db  0 ;ダミー？
	.db $20 ;ガッツタンク
	.db  0 ;ダミー？
	.db $20 ;ワイリーマシン
	.db $00 ;エイリアン
;・ザコ   ObjectList.txt by Rock5easily
	BANKORG_D $1FEBD2
	.db $E6 ;シュリンク
	.db $E6 ;シュリンク(アンコウより発生)
	.db  0 ;*アンコウのシュリンク発生器
	.db  0 ;*M-445生成
	.db $FF ;M-445
	.db  0 ;*M-445生成解除(種類03を削除)
	.db  0 ;*アンコウの爆発
	.db  0 ;*クロウ生成
	.db $FF ;クロウ
	.db  0 ;*クロウ生成解除(種類07を削除)
	.db $F5 ;タニッシー
	.db $FF ;タニッシーの殻
	.db $A2 ;ケロッグ
	.db $FF ;子ケロッグ
	.db  0 ;*ロックマンの水泡
	.db $31 ;アンコウの弱点

	.db  0 ;*アンコウのボディ
	.db  0 ;*アンコウのパレット設定
	.db  0 ;*クラッシュマン・ワイリーステージ4のリフト
	.db  0 ;*乗ると落下するブロック
	.db  0 ;*レーザー生成
	.db  0 ;*レーザー
	.db $A5 ;バットン
	.db $A2 ;ロビット
	.db  0 ;*ロビットの弾
	.db $21 ;フレンダー関係
	.db  0 ;*フレンダーの尻尾
	.db  0 ;*フレンダーの弾
	.db  0 ;*フレンダー
	.db $A5 ;モンキング
	.db  0 ;*クック生成
	.db $A2 ;クック

	.db  0 ;*クック生成解除(種類1Eを削除)
	.db  0 ;*テリー生成
	.db $FF ;テリー
	.db $61 ;チャンキーメーカー
	.db  0 ;*チャンキー
	.db  0 ;*パレット変更(暗闇・クイックマンステージ)
	.db  0 ;*パレット変更(チャンキーメーカー登場時)
	.db  0 ;*パレット変更(元に戻す・クイックマンステージ)
	.db  0 ;*パレット変更(チャンキーメーカー撃破時)
	.db $A1 ;ピエロボットの歯車
	.db $FF ;ピエロボットの本体
	.db  0 ;*フライボーイ生成
	.db $82 ;フライボーイ
	.db $F9 ;クラッシュボムで破壊できるブロック
	.db  0 ;*フレンダー通り抜け防止透明ブロック
	.db  0 ;*シャッターに設置

	.db  0 ;*プレス
	.db $FA ;ブロッキー
	.db  0 ;*ブロッキーの判定
	.db  0 ;*崩れたブロッキー
	.db $FF ;ネオメットール
	.db  0 ;*ネオメットール/スナイパーアーマー/スナイパージョーの弾
	.db $AA ;マタサブロウ
	.db  0 ;*ピピ生成
	.db $FF ;ピピ
	.db  0 ;*ピピ生成解除(種類37を削除)
	.db $FF ;ピピの卵
	.db $FF ;*ピピの卵の破片
	.db $FF ;子ピピ
	.db $A3 ;カミナリゴローの本体
	.db  0 ;*カミナリゴロー
	.db  0 ;*カミナリゴローの弾

	.db  0 ;*ゴブリン(1)
	.db  0 ;*ゴブリン(2)
	.db  0 ;*パレット変更(ゴブリンを消す1・エアーマンステージ)
	.db  0 ;*パレット変更(ゴブリンを消す2・エアーマンステージ)
	.db  0 ;*ゴブリンの角
	.db $FF ;プチゴブリン
	.db $62 ;スプリンガー
	.db  0 ;*モール生成
	.db $A5 ;モール(上へ)
	.db $A5 ;モール(下へ)
	.db  0 ;*モール生成解除(種類47を削除)
	.db $72 ;ショットマン(左向き)
	.db $72 ;ショットマン(右向き)
	.db  0 ;ショットマンの弾
	.db $21 ;スナイパーアーマー
	.db $A2 ;スナイパージョー

	.db $A5 ;スクワーム発生装置
	.db $A5 ;スクワーム
	.db  0 ;*プレスの鎖の部分の判定
	.db  0 ;*ブーンブロック(1)
	.db  0 ;*ブーンブロック(2)
	.db  0 ;*ブーンブロック(3)
	.db  0 ;*パレット変更？(クラッシュマンステージ)
	.db $F9 ;クラッシュボムで壊せるブロック
	.db  0 ;*
	.db  0 ;*
	.db  0 ;*
	.db  0 ;*
	.db  0 ;*
	.db  0 ;*
	.db  0 ;*クラッシュマンのクラッシュボム
	.db  0 ;*クラッシュマンのクラッシュボムの爆発

	.db  0 ;*
	.db  0 ;*リーフシールド
	.db  0 ;*
	.db  0 ;*ワイリーステージ1のボス前足場
	.db  0 ;*メカドラゴン出現？
	.db  0 ;*
	.db  0 ;*
	.db  0 ;*
	.db  0 ;*
	.db  0 ;*
	.db $21 ;ピコピコ君
	.db  0 ;*ブービームの放つ弾
	.db  0 ;*
	.db $E4 ;ブービーム
	.db  0 ;*
	.db  0 ;*

	.db  0 ;*
	.db $FF ;ビッグフィッシュ
	.db  0 ;*ワイリーステージ6の雫(1)
	.db  0 ;*ワイリーステージ6の雫(2)
	.db  0 ;*
	.db  0 ;*
	.db  0 ;*ライフエネルギー回復大
	.db  0 ;*ライフエネルギー回復小