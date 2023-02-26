
	BANKORG_D $1EDD31
OBJPROC_0:
OBJPROC_5: ;Q
	.include "src/wo_quick.asm"
OBJPROC_7: ;M
	.include "src/wo_metal.asm"
OBJPROC_8: ;F
	.include "src/wo_flash.asm"
OBJPROC_1: ;H
	.include "src/wo_heat.asm"
;	Addr<=1EDFFF
	BANKORG_D $1FE000
OBJPROC_2: ;A
	.include "src/wo_air.asm"
OBJPROC_3: ;W
	.include "src/wo_wood.asm"
OBJPROC_6: ;C
	.include "src/wo_clash.asm"
;	Addr<=1FE11C
	BANKORG_D $1FE155
	.include "src/wo_common.asm"
;	Addr<=1FE18D

	BANKORG_D $1EDD11
	.db LOW (OBJPROC_0)
	.db LOW (OBJPROC_1)
	.db LOW (OBJPROC_2)
	.db LOW (OBJPROC_3)
	.db LOW (OBJPROC_4)
	.db LOW (OBJPROC_5)
	.db LOW (OBJPROC_6)
	.db LOW (OBJPROC_7)
	.db LOW (OBJPROC_8)
	BANKORG_D $1EDD21
	.db HIGH(OBJPROC_0)
	.db HIGH(OBJPROC_1)
	.db HIGH(OBJPROC_2)
	.db HIGH(OBJPROC_3)
	.db HIGH(OBJPROC_4)
	.db HIGH(OBJPROC_5)
	.db HIGH(OBJPROC_6)
	.db HIGH(OBJPROC_7)
	.db HIGH(OBJPROC_8)

