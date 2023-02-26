	.IF Enable_InvincibleTimeType=1
Misc_InvTime1:
	lda <$2F
	bmi .BossHit
	jmp $8183
.BossHit
	lda $05B8,x
	jmp $817D
	.ENDIF
	.IF Enable_InvincibleTimeType=2
Misc_InvTime23:
	lda <$2F
	bmi .Hit
	lda $05B8,x
	bne .rts
.Hit
	jmp $809D
.rts
	rts
	.ENDIF
	.IF Enable_InvincibleTimeType=3
Misc_InvTime23:
	lda $05B8,x
	bne .rts
	jmp $809D
.rts
	rts
	.ENDIF


	.IF Enable_FixPukaPukaWarp ;{
FixPukaPukaWarp_Org:
	BANKORG_D $1C8A65
	jmp FixPukaPukaWarp_Addtion

	BANKORG FixPukaPukaWarp_Org
FixPukaPukaWarp_Addtion:
	jsr rNewObjY
	bcs .CharOver
	jmp $8A68
.CharOver
	rts
	.ENDIF ;}

	.IF Enable_NerfedSpike ;{
NerfedSpike:
	sbc NerfedSpike_Tbl_Damage,y
	cmp #$81
	bcs .Damaged
	jmp $8332
.Damaged
	sta <aWeaponEnergy+0
	jmp $82E1
	.ENDIF ;}
