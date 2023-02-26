AtRoomScrolling_Org:

	BANKORG_D $3ECB68 ;右
	jsr AtRoomScrolling_Trig
	BANKORG_D $3ECDE3 ;上下
	jsr AtRoomScrolling_Trig
	BANKORG_D $3FE642 ;カプセルワープ
	jsr AtRoomScrolling_Trig

	BANKORG AtRoomScrolling_Org
