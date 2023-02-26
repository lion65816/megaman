;$StuffItem src/weapon.asm
;$StuffItem src/misc.asm
;$StuffItem src/misc_2.asm
;$StuffItem src/w_0_buster.asm
;$StuffItem src/w_0_buster_2.asm
;$StuffItem src/w_1_heat.asm
;$StuffItem src/w_2_air.asm
;$StuffItem src/w_2_air_2.asm
;$StuffItem src/w_3_wood.asm
;$StuffItem src/w_3_wood_2.asm
;$StuffItem src/w_4_bubble.asm
;$StuffItem src/w_4_bubble_2.asm
;$StuffItem src/w_5_quick.asm
;$StuffItem src/w_6_flash.asm
;$StuffItem src/w_7_metal.asm
;$StuffItem src/w_8_clash.asm


;	BANKORG $0E8A80 ;クラッシュ・ワイリー１の空き　なるべく使わない
;	FILL_TEST $0E9000
	BANKORG   $15BB36
	.include "src/sprite.asm"
	.include "src/pool_15.asm"
	FILL_TEST $15BFE0
	BANKORG   $1BBE00
	.include "src/pool_1B.asm"
	FILL_TEST $1BBFE0
	BANKORG   $1DBD24
	.include "src/pool_1D.asm"
	FILL_TEST $1DBFE0

	BANKORG $1EDA69 ;射出処理
;$StuffSpace 1EDA69 1EDA87-1
	.include "src/w_4_bubble_2.asm" ;$StuffedItem
	FILL_TEST $1EDA87 ;射出モーションに変更
	BANKORG $1EDA9C ;射出処理２
;$StuffSpace 1EDA9C 1EDC4A-1
	.include "src/w_8_clash.asm" ;$StuffedItem
	.include "src/w_3_wood.asm" ;$StuffedItem
	FILL_TEST $1EDC4A ;投擲モーションに変更

	BANKORG $1EDD31 ;武器処理
;$StuffSpace 1EDD31 1EE000-1
	.include "src/w_7_metal.asm" ;$StuffedItem
	.include "src/weapon.asm" ;$StuffedItem
	FILL_TEST $1EE000 ;バンク境界
	BANKORG $1FE000 ;続き
;$StuffSpace 1FE000 1FE11C-1
	.include "src/w_5_quick.asm" ;$StuffedItem
	.include "src/w_2_air.asm" ;$StuffedItem
	FILL_TEST $1FE11C ;クラッシュボムのテーブル
	BANKORG $1FE155 ;メタルブレード～
;$StuffSpace 1FE155 1FE18D-1
	.include "src/w_2_air_2.asm" ;$StuffedItem
	FILL_TEST $1FE18D ;～アイテム１号


	BANKORG $1FF2A2 ;末端の空き容量
;$StuffSpace 1FF2A2 1FF900-1
	.include "src/w_6_flash.asm" ;$StuffedItem
	.include "src/misc_2.asm" ;$StuffedItem
	.include "src/misc.asm" ;$StuffedItem
	.include "src/w_1_heat.asm" ;$StuffedItem
	.include "src/w_3_wood_2.asm" ;$StuffedItem
	.include "src/w_4_bubble.asm" ;$StuffedItem
	FILL_TEST $1FF900
	BANKORG $1FFF87
;$StuffSpace 1FFF87 1FFFE0-1
	.include "src/w_0_buster_2.asm" ;$StuffedItem
	.include "src/w_0_buster.asm" ;$StuffedItem
	FILL_TEST $1FFFE0
