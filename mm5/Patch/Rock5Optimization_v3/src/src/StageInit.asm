StageInit_Org:

	;どちらがいいだろうか？
	;ボスラッシュのカプセルワープでもロードは必要だと思うので、後者にしておく
;	BANKORG_D $1EDE45
;	jsr StageInit_Trig
;	BANKORG_D $1ED45D
;	jmp StageInit_Trig

	;→シャッターを閉じる処理との兼ね合いがあり
	;シャッターを閉じるルーチンの位置に置くことにした
	BANKORG_D $1ED3EB
	sta <$0F
	jsr StageInit_Trig


	BANKORG StageInit_Org
