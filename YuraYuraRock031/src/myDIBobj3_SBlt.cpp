#include <windows.h>
#include "myDIBobj3.h"
#include "myDIBobj3_p.h"


/*
	�X�g���b�`�]���̊֐��B
	���j�́AmyDIBobj3_Cls.cpp�ɏ����Ă݂��B
*/

//�Œ菬��ForStretch�炵��
#define UBITSFS			14
#define	D2FFS(num)		((INT32)((num)*(1<<UBITSFS)))
#define F2IFS(num)		((num)>>UBITSFS)

//���񂭂炢�ɂȂ�ƁA���[�v�W�J���ʂ����đ����̂��ǂ����^�킵���B
//�������A�e�X�g���Ă݂��瑬����������A�����Ȃ��Ă�񂶂�Ȃ����ȁc�c
#define RenderLoopForSBlt(BLTYPE,CKTYPE,SETYPE)	;\
for( iy=0 ; iy<height ; iy++ )				   \
{                                              \
	psx = prepsx ;                             \
	for( ix=0 ; ix<tw ; ix+=8 )                \
	{                                          \
		PixelSet(opt,&Pwline[ix+0],Prline[F2IFS(psx)],BLTYPE,CKTYPE,SETYPE);	\
		psx += vx ;                            \
		PixelSet(opt,&Pwline[ix+1],Prline[F2IFS(psx)],BLTYPE,CKTYPE,SETYPE);	\
		psx += vx ;                            \
		PixelSet(opt,&Pwline[ix+2],Prline[F2IFS(psx)],BLTYPE,CKTYPE,SETYPE);	\
		psx += vx ;                            \
		PixelSet(opt,&Pwline[ix+3],Prline[F2IFS(psx)],BLTYPE,CKTYPE,SETYPE);	\
		psx += vx ;                            \
		PixelSet(opt,&Pwline[ix+4],Prline[F2IFS(psx)],BLTYPE,CKTYPE,SETYPE);	\
		psx += vx ;                            \
		PixelSet(opt,&Pwline[ix+5],Prline[F2IFS(psx)],BLTYPE,CKTYPE,SETYPE);	\
		psx += vx ;                            \
		PixelSet(opt,&Pwline[ix+6],Prline[F2IFS(psx)],BLTYPE,CKTYPE,SETYPE);	\
		psx += vx ;                            \
		PixelSet(opt,&Pwline[ix+7],Prline[F2IFS(psx)],BLTYPE,CKTYPE,SETYPE);	\
		psx += vx ;                            \
	}                                          \
	for(  ; ix<width ; ix++ )                  \
	{                                          \
		PixelSet(opt,&Pwline[ix],Prline[F2IFS(psx)],BLTYPE,CKTYPE,SETYPE);	\
		psx += vx ;                            \
	}                                          \
	Pwline += prowline ;                       \
	psy += vy ;                                \
	if(psy&((~0)<<UBITSFS))                    \
	{                                          \
		Prline += prorline*(F2IFS(psy)) ;      \
		psy &= ~((~0)<<UBITSFS);               \
	}                                          \
}

void MyDIBObj3 :: SBlt(const MDO3Opt *opt,int isfc,int x,int y,int width,int height,int isrc,int srcx,int srcy,int srcwidth , int srcheight)
{
	if( !SFCCheck( isfc ) )return;
	if( !SFCCheck( isrc ) )return;

//���ƍ����̃X�P�[��
double scalex,scaley;
	scalex = (double)  srcwidth /  width ;
	scaley = (double) srcheight / height ;
//�N���b�v���ꂽ��́Asrc�̍��W�𕂓�������
double srcxd,srcyd;
	//�w�����N���b�s���O
	srcxd = srcx ;
	if( x < sfc[isfc].clipx )
	{//���ɂ͂ݏo�Ă���
		width -= (sfc[isfc].clipx-x);
		srcxd += (sfc[isfc].clipx-x)*scalex ;
		x = sfc[isfc].clipx ;
	}
	if( x+width > sfc[isfc].clipx+sfc[isfc].clipwidth )
	{//�E�ɂ͂ݏo���Ă���
		width = sfc[isfc].clipx+sfc[isfc].clipwidth-x ;
	}
	//�w�����N���b�s���O
	srcyd = srcy ;
	if( y < sfc[isfc].clipy )
	{//��ɂ͂ݏo�Ă���
		height -= (sfc[isfc].clipy-y);
		srcyd += (sfc[isfc].clipy-y)*scaley ;
		y = sfc[isfc].clipy ;
	}
	if( y+height > sfc[isfc].clipy+sfc[isfc].clipheight )
	{//���ɂ͂ݏo���Ă���
		height = sfc[isfc].clipy+sfc[isfc].clipheight-y ;
	}
//src�ʒu�A���ʒu�̋L��
INT32 psx,psy,prepsx;
	psx = D2FFS(srcxd);
	psy = D2FFS(srcyd);
	prepsx = psx ;
//�x�N�g������Ȃ����ǂ��c�c�ړ���
INT32 vx,vy;
	vx = D2FFS( scalex ) ;
	vy = D2FFS( scaley ) ;
//�����Ȃ�̂��킩��񂪁A��̓ǂݏ����ʒu�擪�̃|�C���^
BMPD *Pwline,*Prline;
//���́A�i���l�̑ޔ�
int prowline,prorline;
//�J�E���^�c�c�f�p�������H
int ix,iy;
//�A�����[���Ɏg���A���̌��E�l
int tw=width-7;
	Pwline = &sfc[isfc].data[x|(y<<sfc[isfc].width_bits)] ;
	if(opt->flag&MDO3F_Y_MIRROR)
	{//����Ȓ��x�Ŗ��Ȃ��݂���
		Prline = &sfc[isrc].data[(srcheight-F2IFS(psy)-1)<<sfc[isrc].width_bits];
		psy %= D2FFS(1) ;
		prorline = -sfc[isrc].width ;
	}
	else
	{
		Prline = &sfc[isrc].data[(F2IFS(psy)<<sfc[isrc].width_bits)];
		psy %= D2FFS(1) ;
		prorline = sfc[isrc].width ;
	}
	prowline = sfc[isfc].width ;
	if(opt->flag&MDO3F_X_MIRROR)
	{
		vx *= -1 ;
		prepsx = D2FFS(srcwidth+srcx)-1-(prepsx-D2FFS(srcx));
	}
//////////////////////////////////////////////////////////////////////////////////
switch(opt->flag & (MDO3F_BLEND | MDO3F_LIGHT_BLEND | MDO3F_DARK_BLEND | MDO3F_OR_BLEND | MDO3F_AND_BLEND )){
case MDO3F_BLEND:
if((opt->alpha&0xF0)==0)return;
if((opt->alpha&0xF0)!=0xF0){
DWORD alphaselector= ((opt->alpha)&0xF0)<<(-4+16);
BMPD *AT     = &PAlphaTable[ alphaselector ] ;
BMPD *AT_inv = &PAlphaTable[ alphaselector^(0x0F<<16) ] ;
	switch(opt->flag & (MDO3F_OR_OPERATE | MDO3F_AND_OPERATE | MDO3F_SIMPLE_COLOR | MDO3F_USE_COLOR_TABLE | MDO3F_BRIGHT_CHANGE)){
	case 0:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_blend,CK_none,SE_none);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_blend,CK_colorkey,SE_none);break;default:return;}
	break;case MDO3F_USE_COLOR_TABLE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_blend,CK_none,SE_colortable);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_blend,CK_colorkey,SE_colortable);break;default:return;}
	break;case MDO3F_SIMPLE_COLOR:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_blend,CK_none,SE_simple);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_blend,CK_colorkey,SE_simple);break;default:return;}
	break;case MDO3F_OR_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_blend,CK_none,SE_or);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_blend,CK_colorkey,SE_or);break;default:return;}
	break;case MDO3F_AND_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_blend,CK_none,SE_and);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_blend,CK_colorkey,SE_and);break;default:return;}
	break;default:return;}
break;}
case 0:
	switch(opt->flag & (MDO3F_OR_OPERATE | MDO3F_AND_OPERATE | MDO3F_SIMPLE_COLOR | MDO3F_USE_COLOR_TABLE | MDO3F_BRIGHT_CHANGE)){
	case 0:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_none,CK_none,SE_none);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_none,CK_colorkey,SE_none);break;default:return;}
	break;case MDO3F_USE_COLOR_TABLE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_none,CK_none,SE_colortable);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_none,CK_colorkey,SE_colortable);break;default:return;}
	break;case MDO3F_SIMPLE_COLOR:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_none,CK_none,SE_simple);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_none,CK_colorkey,SE_simple);break;default:return;}
	break;case MDO3F_OR_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_none,CK_none,SE_or);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_none,CK_colorkey,SE_or);break;default:return;}
	break;case MDO3F_AND_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_none,CK_none,SE_and);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_none,CK_colorkey,SE_and);break;default:return;}
	break;default:return;}
break;
case MDO3F_LIGHT_BLEND:
	switch(opt->flag & (MDO3F_OR_OPERATE | MDO3F_AND_OPERATE | MDO3F_SIMPLE_COLOR | MDO3F_USE_COLOR_TABLE | MDO3F_BRIGHT_CHANGE)){
	case 0:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_lightblend,CK_none,SE_none);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_lightblend,CK_colorkey,SE_none);break;default:return;}
	break;case MDO3F_USE_COLOR_TABLE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_lightblend,CK_none,SE_colortable);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_lightblend,CK_colorkey,SE_colortable);break;default:return;}
	break;case MDO3F_SIMPLE_COLOR:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_lightblend,CK_none,SE_simple);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_lightblend,CK_colorkey,SE_simple);break;default:return;}
	break;case MDO3F_OR_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_lightblend,CK_none,SE_or);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_lightblend,CK_colorkey,SE_or);break;default:return;}
	break;case MDO3F_AND_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_lightblend,CK_none,SE_and);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_lightblend,CK_colorkey,SE_and);break;default:return;}
	break;default:return;}
break;
case MDO3F_DARK_BLEND:
	switch(opt->flag & (MDO3F_OR_OPERATE | MDO3F_AND_OPERATE | MDO3F_SIMPLE_COLOR | MDO3F_USE_COLOR_TABLE | MDO3F_BRIGHT_CHANGE)){
	case 0:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_darkblend,CK_none,SE_none);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_darkblend,CK_colorkey,SE_none);break;default:return;}
	break;case MDO3F_USE_COLOR_TABLE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_darkblend,CK_none,SE_colortable);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_darkblend,CK_colorkey,SE_colortable);break;default:return;}
	break;case MDO3F_SIMPLE_COLOR:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_darkblend,CK_none,SE_simple);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_darkblend,CK_colorkey,SE_simple);break;default:return;}
	break;case MDO3F_OR_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_darkblend,CK_none,SE_or);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_darkblend,CK_colorkey,SE_or);break;default:return;}
	break;case MDO3F_AND_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_darkblend,CK_none,SE_and);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_darkblend,CK_colorkey,SE_and);break;default:return;}
	break;default:return;}
break;
case MDO3F_OR_BLEND:
	switch(opt->flag & (MDO3F_OR_OPERATE | MDO3F_AND_OPERATE | MDO3F_SIMPLE_COLOR | MDO3F_USE_COLOR_TABLE | MDO3F_BRIGHT_CHANGE)){
	case 0:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_or,CK_none,SE_none);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_or,CK_colorkey,SE_none);break;default:return;}
	break;case MDO3F_USE_COLOR_TABLE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_or,CK_none,SE_colortable);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_or,CK_colorkey,SE_colortable);break;default:return;}
	break;case MDO3F_SIMPLE_COLOR:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_or,CK_none,SE_simple);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_or,CK_colorkey,SE_simple);break;default:return;}
	break;case MDO3F_OR_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_or,CK_none,SE_or);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_or,CK_colorkey,SE_or);break;default:return;}
	break;case MDO3F_AND_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_or,CK_none,SE_and);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_or,CK_colorkey,SE_and);break;default:return;}
	break;default:return;}
break;
case MDO3F_AND_BLEND:
	switch(opt->flag & (MDO3F_OR_OPERATE | MDO3F_AND_OPERATE | MDO3F_SIMPLE_COLOR | MDO3F_USE_COLOR_TABLE | MDO3F_BRIGHT_CHANGE)){
	case 0:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_and,CK_none,SE_none);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_and,CK_colorkey,SE_none);break;default:return;}
	break;case MDO3F_USE_COLOR_TABLE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_and,CK_none,SE_colortable);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_and,CK_colorkey,SE_colortable);break;default:return;}
	break;case MDO3F_SIMPLE_COLOR:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_and,CK_none,SE_simple);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_and,CK_colorkey,SE_simple);break;default:return;}
	break;case MDO3F_OR_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_and,CK_none,SE_or);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_and,CK_colorkey,SE_or);break;default:return;}
	break;case MDO3F_AND_OPERATE:
		switch(opt->flag & (MDO3F_COLORKEY | MDO3F_USE_OTHER_COLORKEY)){case 0:RenderLoopForSBlt(BL_and,CK_none,SE_and);break;case MDO3F_COLORKEY:RenderLoopForSBlt(BL_and,CK_colorkey,SE_and);break;default:return;}
	break;default:return;}
break;
default:return;}
//////////////////////////////////////////////////////////////////////////////////

	return;
#if 0
//�e�X�g
	for( iy=0 ; iy<height ; iy++ )
	{
		psx = prepsx ;
		for( ix=0 ; ix<tw ; ix+=8 )
		{
			Pwline[ix+0] = Prline[F2IFS(psx)] ;
			psx += vx ;
			Pwline[ix+1] = Prline[F2IFS(psx)] ;
			psx += vx ;
			Pwline[ix+2] = Prline[F2IFS(psx)] ;
			psx += vx ;
			Pwline[ix+3] = Prline[F2IFS(psx)] ;
			psx += vx ;
			Pwline[ix+4] = Prline[F2IFS(psx)] ;
			psx += vx ;
			Pwline[ix+5] = Prline[F2IFS(psx)] ;
			psx += vx ;
			Pwline[ix+6] = Prline[F2IFS(psx)] ;
			psx += vx ;
			Pwline[ix+7] = Prline[F2IFS(psx)] ;
			psx += vx ;
		}
		for(  ; ix<width ; ix++ )										
		{
			Pwline[ix] = Prline[F2IFS(psx)] ;
			psx += vx ;
		}
		Pwline += prowline ;
		psy += vy ;

#if 0
//�ǂ���r������A�l���������瑁�������e�X�g�B
//���_�͂T�O���P�O�O���B���������āA�����̗p����
//*
		if(psy&D2FFS(1))
/*/
		if(psy>=D2FFS(1))
//*/
		{
/*
			psy &= ~D2FFS(1);
/*/
			psy -= D2FFS(1);
//*/
			Prline += prorline ;
		}
#endif
		if(psy&((~0)<<UBITSFS))
		{
			//�Ō�ɁA���傧�����ƁA�|�C���^�A�̈�̐���w����ł����ǁc�c�b�o�t����O�o���܂���悤�ɁB
			Prline += prorline*(F2IFS(psy)) ;
			psy &= ~((~0)<<UBITSFS);
		}

	}

#endif
}
