;by rock5_lite/Rock5easily
;���@�{����ʒu�ɒu���Ă����ׂ��e�[�u���̈ʒu��
;�@�@�ςɂȂ��Ă��܂��Ă���̂����A���Ԃ�ǂ��ɂ����Ă���邾�낤�B


ForegroundOmission_Org:
	BANKORG_D $1B9795
	jmp	UsingFG_Check

	BANKORG ForegroundOmission_Org
FG_table:
	.db	$00,$00,$01,$01,$00,$00,$01,$00
	.db	$00,$01,$00,$00,$00,$00,$01,$00

UsingFG_Check:
	ldy	<$26
	lda	FG_table,y
	bne	.Using
.NotUsing
	jmp	$97C1			; �w�i���ɉB��鏈���̎��̏����փW�����v
.Using
	lda	<$9D			; �ׂ������������s���Č��̏ꏊ�փW�����v
	lsr	a			; |
	jmp	$9798			; |
