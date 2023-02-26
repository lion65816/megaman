#include <windows.h>
#include "myDIBobj3.h"
#include "myDIBobj3_p.h"

/*
	��`�P�F�h��֐��B
	�ǂ̕`��֐����ł����A���傢��������΂킩��Ƃ���A�}�N�����g�Ȏd�l�ł��B
	���������܂ŁA�r���h�Ɏ��Ԃ�������A����ɂ͎��s�t�@�C���̃T�C�Y�͔��B
	�u�b�{�{���R���p�C���ɍۂ��ăq�[�v���g���ʂ����ȂǁA�����S��B
*/

/*
	�����_�����O�̃��[�v�B�z�肳���S�Ă̏������ŁA���̃}�N�����ĂԁB
	���v�������̂����A��r�́w����l�ȉ��x���A�w�O�Ɣ�r�x�̕����������낤���c�c
	���[�v���t�����ɂ����ق��������H
	�i�܂��A�������ǂ����Ȃ�Ċ��ˑ������ǂˁc�c�ł���ʓI�ɂO�Ƃ̔�r�͑��������悤�ȁc�c�H�j
*/

#define RenderLoopForCls(BLTYPE,CKTYPE,SETYPE)	;\
{																			\
BMPD *Psfc;																	\
int ix,iy;																	\
int tw=width-7;																\
	Psfc = &sfc[isfc].data[(y<<sfc[isfc].width_bits)+x];					\
	for( iy=0 ; iy<height ; iy++)											\
	{																		\
		for( ix=0 ; ix<tw ; ix+=8 )											\
		{																	\
			PixelSet(opt,&Psfc[ix+0],color,BLTYPE,CKTYPE,SETYPE);			\
			PixelSet(opt,&Psfc[ix+1],color,BLTYPE,CKTYPE,SETYPE);			\
			PixelSet(opt,&Psfc[ix+2],color,BLTYPE,CKTYPE,SETYPE);			\
			PixelSet(opt,&Psfc[ix+3],color,BLTYPE,CKTYPE,SETYPE);			\
			PixelSet(opt,&Psfc[ix+4],color,BLTYPE,CKTYPE,SETYPE);			\
			PixelSet(opt,&Psfc[ix+5],color,BLTYPE,CKTYPE,SETYPE);			\
			PixelSet(opt,&Psfc[ix+6],color,BLTYPE,CKTYPE,SETYPE);			\
			PixelSet(opt,&Psfc[ix+7],color,BLTYPE,CKTYPE,SETYPE);			\
		}																	\
		for(  ; ix<width ; ix++ )											\
		{																	\
			PixelSet(opt,&Psfc[ix+0],color,BLTYPE,CKTYPE,SETYPE);			\
		}																	\
		Psfc += sfc[isfc].width;											\
	}																		\
}


void MyDIBObj3 :: Cls(const MDO3Opt *opt,int isfc,int x,int y,int width,int height,BMPD color)
{
	if( !SFCCheck( isfc ) )return;
	if( opt->flag & MDO3F_CLIP )
	{
		if( !Clipping( opt ,  false , &x , &y , &width , &height , NULL , NULL , sfc[isfc].clipx , sfc[isfc].clipy , sfc[isfc].clipwidth , sfc[isfc].clipheight ) )return;
	}
//////////////////////////////////////////////////////////////////////////////////////////
switch(opt->flag & (MDO3F_BLEND | MDO3F_LIGHT_BLEND | MDO3F_DARK_BLEND | MDO3F_OR_BLEND | MDO3F_AND_BLEND )){
case MDO3F_BLEND:
if((opt->alpha&0xF0)==0)return;
if((opt->alpha&0xF0)!=0xF0){
DWORD alphaselector= ((opt->alpha)&0xF0)<<(-4+16);
BMPD *AT     = &PAlphaTable[ alphaselector ] ;
BMPD *AT_inv = &PAlphaTable[ alphaselector^(0x0F<<16) ] ;
RenderLoopForCls(BL_blend,CK_none,SE_none);break;}
case 0:
RenderLoopForCls(BL_none,CK_none,SE_none);break;
case MDO3F_LIGHT_BLEND:
RenderLoopForCls(BL_lightblend,CK_none,SE_none);break;
case MDO3F_DARK_BLEND:
RenderLoopForCls(BL_darkblend,CK_none,SE_none);break;
case MDO3F_OR_BLEND:
RenderLoopForCls(BL_or,CK_none,SE_none);break;
case MDO3F_AND_BLEND:
RenderLoopForCls(BL_and,CK_none,SE_none);break;
default:return;}
//////////////////////////////////////////////////////////////////////////////////////////

}

