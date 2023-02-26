	.inesprg $10 ;プログラムバンク数
	.ineschr $00 ;キャラクタバンク数
	.inesmir 1 ;
	.inesmap 1

	.bank 0
	.org $0000

	.incbin "rockman2.prg"
	.include "mylib.asm"

	.IFNDEF VeryHard
VeryHard = 1
	.ENDIF


	BANKORG_D $1DB294
	lda #$35
	
	BANKORG_D $1DB2BD
	jsr Shotman_SetBulletProperty

	BANKORG_D $1FEEC7
	jsr PlaceBullet_
	BANKORG_D $1FEFC0
	jsr PlaceBullet_
	
	BANKORG_D $1680C1 ;フラッシュストッパー
	jsr PlaceBullet_Boss
	BANKORG_D $17A62C
	jsr PlaceBullet_Boss
	BANKORG_D $17A6A4
	jsr PlaceBullet_Boss
	BANKORG_D $17A6EE
	jsr PlaceBullet_Boss
	BANKORG_D $17A742
	jsr PlaceBullet_Boss
	BANKORG_D $17A7A3
	jsr PlaceBullet_Boss
	BANKORG_D $17A7F7
	jsr PlaceBullet_Boss
	BANKORG_D $17A868
	jsr PlaceBullet_Boss
	BANKORG_D $17A8C7
	jsr PlaceBullet_Boss
	
	BANKORG_D $1C92F0+$4D
	.db low(ReturnBullet)
	BANKORG_D $1C9370+$4D
	.db high(ReturnBullet)
	BANKORG_D $1FED3A+$4D
	.db 8 ;ダメージ


	.IF VeryHard!=0
	BANKORG_D $1C92F0+$06
	.db low(Explosion)
	BANKORG_D $1C9370+$06
	.db high(Explosion)
	.ENDIF

	BANKORG_D $1FF2A2
Shotman_SetBulletProperty:
	lda $0430,y ;ObjFlag(存右？？弾重特当)[10];
	ora #$04
	sta $0430,y ;ObjFlag(存右？？弾重特当)[10];
	rts
PlaceBullet_:
	sta $06A0,x
PlaceBullet:
	lda #$4D
	jsr $F137 ;配置
	bcs .CharOver
	lda #$00
	sta $04E0+$10,y
	lda #$81
	sta $0420+$10,y ;ObjFlag(存右？？弾重特当)[10];
.CharOver
	rts
PlaceBullet_Boss:
	php
	sta $06C0+1
	tya
	pha
	txa
	pha
	jsr PlaceBullet
	pla
	tax
	pla
	tay
	plp
	rts



ReturnBullet:
	lda $04E0,x
	bne .NotFirst
	inc $04E0,x
	lda #$05
	sta <$08
	sta <$09
	jsr $F175
.NotFirst
	jmp $EE98

	.IF VeryHard!=0
Explosion:
	lda $0680,x ;ObjSpriteTimer[0];
	bne .NotPlaceBullet
	jsr PlaceBullet
.NotPlaceBullet
	jmp $9671
	.ENDIF


