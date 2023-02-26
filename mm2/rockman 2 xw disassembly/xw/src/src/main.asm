	.include "src/labels.asm"

	.include "src/w_buster.asm"
	.include "src/w_metal.asm"
	.include "src/w_heat.asm"
	.include "src/w_wood.asm"
	.include "src/w_quick.asm"
	.include "src/w_air.asm"
	.include "src/w_bubble.asm"
	.include "src/w_flash.asm"
	.include "src/w_clash.asm"

	.include "src/logo.asm"

	.include "src/pool_shotproc.asm"
	.include "src/pool_objproc.asm"
	.include "src/pool_unused.asm"

	;ディレイスクロール簡易修正
	BANKORG_D $1EC01F
	bit <$01
	.include "src/QuickRecover.asm"


