;by Rock5easily

	.IF Enable_BossRoomJump ;{
	SETBANKA000
BossRoomJump_cm0F_L7:
	ldy	#$00		; Y���W�X�^��#$00�����[�h
	jsr	$EA3F		; X������(�u���b�N�ɂ߂荞�܂Ȃ��悤��)�ړ��A���E�̃u���b�N�ɂԂ�������L�����[1�H
	bcc	.L		;

	lda	#$07		;
	cmp	$0558		;
	beq	.L		;
	jsr	$EA98		;

	lda	#$00		; ���b�N�}����Y�������x���Z�b�g 05.00
	sta	$03D8		; |
	lda	#$05		;
	sta	$03F0		;
.L
	ldy	#$80		; Y���W�X�^��#$80�����[�h
	cpy	$0330		; ���b�N�}����X���W(low)�Ɣ�r
	beq	BossRoomJump_cm0F_L2		; ��v�����$8779�ɃW�����v
	lda	$0420		; ���b�N�}���̕��������[�h
	and	#$01		; �ŉ���bit(�E)���o��
	bne	BossRoomJump_cm0F_L3		; �����Ă����$8777�ɃW�����v
	bcs	BossRoomJump_cm0F_L2		; #$80 �� ���b�N�}����X���W(low) �Ȃ��$8779�ɃW�����v
BossRoomJump_cm0F_R2:
	rts
BossRoomJump_cm0F_L3:
	bcs	BossRoomJump_cm0F_R2		; #$80 �� ���b�N�}����X���W(low) �Ȃ�΃��^�[��
BossRoomJump_cm0F_L2:
	sty	$0330		; Y���W�X�^�̒l�����b�N�}����X���W(low)�ɃZ�b�g
	lda	$0558		;
	cmp	#$07		;
	beq	BossRoomJump_cm0F_R2		;
	
	lda	#$00		; 
	sta	$0498		; ���b�N�}���̕ϐ�A��#$00���Z�b�g
	sta	$0480		; ���b�N�}���̕ϐ�B��#$00���Z�b�g
	sta	$03D8		; ���b�N�}����Y�������x���Z�b�g 08.00
	lda	#$08		; |
	sta	$03F0		; |
	sta	$0468		;
	
	lda	#$07		; ���b�N�}���̃A�j���[�V�����ԍ���#$07�ɃZ�b�g
	jmp	$EA98		; |

	SETBANK8000
	.ENDIF ;}
