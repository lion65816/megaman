;by rock4_effectenemyex/Rock5easily
R5E_EffectEnemyEx:
	BANKORG_D $388089
	jmp	R5E_EEE_ChkEffectEnemyID

	BANKORG_D $3C92CF
R5E_EEE_Wind:
	lda	<$2C		; $2Cの値の下位2bit取り出し
	and	#$03		; |
	beq	.L0		; 0ならば風処理無効
	
	asl	<$0F		; $0Fの最上位bitをキャリーフラグに押し出す
	bcs	$933E		; 地面に足をついているならば$933Eにジャンプ
	bcc	$9343		; そうでなければ$9343にジャンプ
	
.L0
	.IF SW_CustomBlock ;カスタムブロックがある時は、そちらに残りの処理を任せる
	jmp $933E
	.ELSE
	lda	<$22		; 
	cmp	#$01		; トードマンステージならば$9314にジャンプ
	beq	$9314		; |
	cmp	#$08		; コサックステージ1でなければ$933Eにジャンプ
	bne	$933E		; |
	lda	#$00		; パディング用のダミー命令
; 92E7:
	.ENDIF

	BANKORG_D $3EC981
R5E_EEE_AutoScroll:
	lda	<$2C		; $2Cの値の最上位bitが0なら強制スクロール無効
	bpl	$C9D3		; |
	lda	#$00		; パディング用のダミーの命令
	lda	<$2E		;
	bne	$C98F		;
	lda	<$FC		;
	beq	$C9D3		;
; C98F:

	BANKORG R5E_EffectEnemyEx
