;by Rock5easily

	.IF Enable_BossRoomJump ;{
	SETBANKA000
BossRoomJump_cm0F_L7:
	ldy	#$00		; Yレジスタに#$00をロード
	jsr	$EA3F		; X方向に(ブロックにめり込まないように)移動、左右のブロックにぶつかったらキャリー1？
	bcc	.L		;

	lda	#$07		;
	cmp	$0558		;
	beq	.L		;
	jsr	$EA98		;

	lda	#$00		; ロックマンのY方向速度をセット 05.00
	sta	$03D8		; |
	lda	#$05		;
	sta	$03F0		;
.L
	ldy	#$80		; Yレジスタに#$80をロード
	cpy	$0330		; ロックマンのX座標(low)と比較
	beq	BossRoomJump_cm0F_L2		; 一致すれば$8779にジャンプ
	lda	$0420		; ロックマンの方向をロード
	and	#$01		; 最下位bit(右)取り出し
	bne	BossRoomJump_cm0F_L3		; 立っていれば$8777にジャンプ
	bcs	BossRoomJump_cm0F_L2		; #$80 ≧ ロックマンのX座標(low) ならば$8779にジャンプ
BossRoomJump_cm0F_R2:
	rts
BossRoomJump_cm0F_L3:
	bcs	BossRoomJump_cm0F_R2		; #$80 ≧ ロックマンのX座標(low) ならばリターン
BossRoomJump_cm0F_L2:
	sty	$0330		; Yレジスタの値をロックマンのX座標(low)にセット
	lda	$0558		;
	cmp	#$07		;
	beq	BossRoomJump_cm0F_R2		;
	
	lda	#$00		; 
	sta	$0498		; ロックマンの変数Aに#$00をセット
	sta	$0480		; ロックマンの変数Bに#$00をセット
	sta	$03D8		; ロックマンのY方向速度をセット 08.00
	lda	#$08		; |
	sta	$03F0		; |
	sta	$0468		;
	
	lda	#$07		; ロックマンのアニメーション番号を#$07にセット
	jmp	$EA98		; |

	SETBANK8000
	.ENDIF ;}
