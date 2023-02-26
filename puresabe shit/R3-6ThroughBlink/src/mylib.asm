BEQ_L .macro
	bne .local_label_in_macro_\@
	jmp \1
.local_label_in_macro_\@
	.endm

BNE_L .macro
	beq .local_label_in_macro_\@
	jmp \1
.local_label_in_macro_\@
	.endm

BCS_L .macro
	bcc .local_label_in_macro_\@
	jmp \1
.local_label_in_macro_\@
	.endm

BCC_L .macro
	bcs .local_label_in_macro_\@
	jmp \1
.local_label_in_macro_\@
	.endm

BPL_L .macro
	bmi .local_label_in_macro_\@
	jmp \1
.local_label_in_macro_\@
	.endm

BMI_L .macro
	bpl .local_label_in_macro_\@
	jmp \1
.local_label_in_macro_\@
	.endm


SETBANK8000 .macro
local_label_in_macro_\@:
	.org ((local_label_in_macro_\@&$1FFF)|$8000)
	.endm

SETBANKA000 .macro
local_label_in_macro_\@:
	.org ((local_label_in_macro_\@&$1FFF)|$A000)
	.endm


BANKORG_D .macro
	.bank (\1>>16)
	.org (\1&$FFFF)
	.endm

BANKORG .macro
	.bank BANK(\1)
	.org (\1)
	.endm


INV_A	.macro
	eor #$FF
	clc
	adc #$01
	.endm

INV_A_CC	.macro
	bcs .local_label_in_macro_\@
	INV_A
.local_label_in_macro_\@
	.endm

TRASH_GLOBAL_LABEL	.macro
.TRASH_GLOBAL_LABEL_\@
	.endm

