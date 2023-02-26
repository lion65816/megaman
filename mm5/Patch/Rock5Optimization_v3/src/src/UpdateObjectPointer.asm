;by rock5_lite/Rock5easily

UpdateObjectPointer_Org:

	BANKORG_D $1C8039
Update_Object_Pointer:
	inx
	stx	<$A6
	cpx	#$18
	bne	$8004
	jmp	$8044

	BANKORG UpdateObjectPointer_Org
