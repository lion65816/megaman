;by rock4_haikei/Rock5easily
R5E_Haikei:
	;前景処理のためにフック
	BANKORG_D $3C932B
	bne $933E
	BANKORG_D $3C933E
	jmp R5E_Haikei_main
	BANKORG_D $3C938D
	beq $933E

	;SW_WRAMMapと同時に指定されていなかったら
	;ステージ毎の処理有効/無効リストを用意
	.IF !SW_WRAMMap
	BANKORG_D $3C9FF0
R5E_Haikei_TblPerStage:
	.db $01,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$01
	.ENDIF

	;棒定義を追加するためにごにょごにょする
	;縦棒定義アドレスhiのアドレスを+2
	BANKORG_D $3E9434;3EB434
	.db $4A
	;縦棒定義[00](lo)のアドレス
	BANKORG_D $3E9808;3EB808
	.db LOW(R5E_Haikei_VBar00)
	;縦棒定義[40][41](lo)[00](hi)のアドレス
	BANKORG_D $3E9848;3EB848
	.db LOW(R5E_Haikei_VBar40),LOW(R5E_Haikei_VBar41),HIGH(R5E_Haikei_VBar00)
	;中程
	BANKORG_D $3E9866;3EB866
	.db $D8,$D8
	;縦棒定義[3E][3F][40][41]のアドレス
	BANKORG_D $3E9888;3EB888
	.db $D9,$D9,HIGH(R5E_Haikei_VBar40),HIGH(R5E_Haikei_VBar41)

	BANKORG R5E_Haikei
