MidExp_Org:

MidExp_Sub .macro
	BANKORG_D \1
	TRASH_GLOBAL_LABEL
	DB_ADDRLHSPLIT \2,\3
	.endm

	MidExp_Sub $0BB800+$1FF,MidExp_NA0,$200
	MidExp_Sub $0BB800+$1FE,MidExp_NA1,$200
	MidExp_Sub $0BB800+$1FD,MidExp_NA2,$200
	MidExp_Sub $0BB800+$1FC,MidExp_NA3,$200
	MidExp_Sub $0BB800+$1FB,MidExp_NA4,$200
	MidExp_Sub $0BB800+$1FA,MidExp_NA5,$200
	MidExp_Sub $0BB800+$1F9,MidExp_NA6,$200
	MidExp_Sub $0BB800+$1F8,MidExp_NA7,$200
	MidExp_Sub $0BB800+$1F7,MidExp_NA8,$200
	
	MidExp_Sub $0BBC00+$FF,MidExp_R0,$100
	MidExp_Sub $0BBC00+$FE,MidExp_L0,$100
	MidExp_Sub $0BBC00+$FD,MidExp_R1,$100
	MidExp_Sub $0BBC00+$FC,MidExp_L1,$100
	MidExp_Sub $0BBC00+$FB,MidExp_R2,$100
	MidExp_Sub $0BBC00+$FA,MidExp_L2,$100
	MidExp_Sub $0BBC00+$F9,MidExp_R3,$100
	MidExp_Sub $0BBC00+$F8,MidExp_L3,$100
	MidExp_Sub $0BBC00+$F7,MidExp_R4,$100
	MidExp_Sub $0BBC00+$F6,MidExp_L4,$100
	MidExp_Sub $0BBC00+$F5,MidExp_R5,$100
	MidExp_Sub $0BBC00+$F4,MidExp_L5,$100
	MidExp_Sub $0BBC00+$F3,MidExp_R6,$100
	MidExp_Sub $0BBC00+$F2,MidExp_L6,$100
	MidExp_Sub $0BBC00+$F1,MidExp_R7,$100
	MidExp_Sub $0BBC00+$F0,MidExp_L7,$100
	MidExp_Sub $0BBC00+$EF,MidExp_R8,$100
	MidExp_Sub $0BBC00+$EE,MidExp_L8,$100

	MidExp_Sub $0BBE00+$FF,MidExp_Ani,$100
	
	
	BANKORG_D $3A9F8A
	TRASH_GLOBAL_LABEL
	lda #$10
	sta oFlag,x ; <����D��O���u��>
	lda oType,x
	cmp #$83
	beq .Damaging
	OBJX_SET_ROUTINE .Wait
.Wait
	pla
	pla
	jmp $8052
.Damaging
	OBJX_SET_ROUTINE .Wait2
.Wait2
	rts
	END_BOUNDARY_TEST $3A9FE8

;3B
	BANKORG_DB $35A5B2+1,$FF
	BANKORG_DB $3A82C3+1,$FF
	BANKORG_DB $3A8E57+1,$FF
	BANKORG_DB $3BA013+1,$FF
	BANKORG_DB $3DB652  ,$FF ;���X���[��
;47
;83
	BANKORG_DB $38B2D8+1,$FF
	BANKORG_DB $3BB77B+1,$FF
	BANKORG_DB $3DA7F6+1,$FF

;�������~�T�̌Ăяo��
	BANKORG_DB $35A91D+1,$00
	BANKORG_DB $35AC55+1,$00
	BANKORG_DB $35ADF1+1,$00
	BANKORG_DB $3DA5DF+1,$00
	BANKORG_DB $3DA86C+1,$00
	BANKORG_DB $3DA8A2+1,$00
	BANKORG_DB $3DAA73+1,$00

	;�X�v���C�g��`�̂���o���N�𒲐�
	BANKORG_DB $3FDFFA+$3B,$0B
	BANKORG_DB $3FDFFA+$47,$0B
	BANKORG_DB $3FDFFA+$83,$0B

	BANKORG MidExp_Org
