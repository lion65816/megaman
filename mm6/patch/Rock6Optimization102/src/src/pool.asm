POOL_org:

;●バンク0D(完全空きのバンク)
	BANKORG_D $0D8000
	nop ;バンク先頭にロングコールできないため
	.include "src/misc.asm"
	.include "src/atEnteringStage.asm"
	.include "src/rockman.asm"
	.include "src/atReset.asm"
	.include "src/terrain.asm"
	FILL_TEST $0DA000

;●バンク38 狭いがたぶん未使用/大幅に足りていない
	BANKORG_D $389FC8
	.include "src/rockman_38.asm"
	FILL_TEST $38A000

;●常時割り当てられるプログラムバンクの後方
	BANKORG $3FFAC0
	.include "src/terrain_s.asm"
	.include "src/misc_s_xfer.asm"
	.include "src/misc_s.asm"
	.include "src/rockman_s.asm"
	FILL_TEST $3FFF40

	;3FFFDD～は使えません

	BANKORG POOL_org
