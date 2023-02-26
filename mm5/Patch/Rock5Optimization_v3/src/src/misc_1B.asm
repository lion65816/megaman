	.IF Enable_FixDownScrollingGlitch ;{
FixDownScrollingGlitch_org:
	BANKORG_D $1B8128
	jsr FixDownScrollingGlitch_Trig
	BANKORG_D $1B8309
	jsr FixDownScrollingGlitch_Trig
	BANKORG_D $1B84F2
	jsr FixDownScrollingGlitch_Trig
	BANKORG FixDownScrollingGlitch_org
FixDownScrollingGlitch_Trig:
	cmp #$F0
	bcc .NotUpdateYhe
	cmp #$F8
	bcc .IncYhe
;-
	;cs
	sbc #$10
	dec oYhe+0
	jmp .conf
;+
.IncYhe
	;cc
	adc #$10
	inc oYhe+0
;	jmp .conf
.conf
.NotUpdateYhe
	sta oYhi+0
	rts
	.ENDIF ;}


	.IF Enable_FixAwkwardMoveAfterSlide ;{
FixAwkwardMoveAfterSlide_org:
	BANKORG_D $1B829E
	jsr FixAwkwardMoveAfterSlide_org
	
	BANKORG FixAwkwardMoveAfterSlide_org
	jsr $964C
	bcs .rts
	lda <vReverseG
	eor #$01
	tay
	jsr $9845 ;‘¦Ž€ƒtƒ‰ƒO‚ðˆÛŽ‚µ‚½‚Ü‚Ü‰¡–_”»’è
	lda <$10
	and #$10
	beq .clcrts
	lda <vReverseG
	bne .reverse
	jsr rPushBackYp
	clc ;jmp‚æ‚èclc rts‚Ì•û‚ªˆÀ‚¢
	rts
.reverse
	jsr rPushBackYn
.clcrts
	clc
.rts
	rts
	.ENDIF ;}
	
	
