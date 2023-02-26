	BANKORG_D $1EDA9C
	;※アトミックファイヤーは弄らずに問題なし
SHOTPROC_1: ;H
	.include "src/ws_heat.asm"
SHOTPROC_2: ;A
	.include "src/ws_air.asm"
SHOTPROC_3: ;W
	.include "src/ws_wood.asm"
SHOTPROC_4: ;B
	.include "src/ws_bubble.asm"
SHOTPROC_5: ;Q
	.include "src/ws_quick.asm"
SHOTPROC_6: ;F
	.include "src/ws_flash.asm"
SHOTPROC_7: ;M
	.include "src/ws_metal.asm"
SHOTPROC_8: ;C
	.include "src/ws_clash.asm"

;	Addr<=1EDC4A

	BANKORG_D $1EDCB5+1
	.db LOW (SHOTPROC_1)
	.db LOW (SHOTPROC_2)
	.db LOW (SHOTPROC_3)
	.db LOW (SHOTPROC_4)
	.db LOW (SHOTPROC_5)
	.db LOW (SHOTPROC_6)
	.db LOW (SHOTPROC_7)
	.db LOW (SHOTPROC_8)
	BANKORG_D $1EDCC1+1
	.db HIGH(SHOTPROC_1)
	.db HIGH(SHOTPROC_2)
	.db HIGH(SHOTPROC_3)
	.db HIGH(SHOTPROC_4)
	.db HIGH(SHOTPROC_5)
	.db HIGH(SHOTPROC_6)
	.db HIGH(SHOTPROC_7)
	.db HIGH(SHOTPROC_8)

