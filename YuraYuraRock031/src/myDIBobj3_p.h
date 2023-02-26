#include <tchar.h>

#ifndef MYDIBOBJ3_PRIVATE_HEADER_INCLUDED
#define MYDIBOBJ3_PRIVATE_HEADER_INCLUDED

/*
	���낢��j�]�����A�\�t�g�E�F�A�����_�����O���[�`���B
	�c�c�́A�����ŗp����w�b�_�t�@�C���B
*/

#ifndef	PI
#define		PI		3.141592653589
#endif

extern BMPD *PAlphaTable;

#define		min3(a,b,c)	(min(min(a,b),c))
#define		max3(a,b,c)	(max(max(a,b),c))
#define		MYABS(val)				((val>=0) ? (val) : (-(val)))
template <class TN> void MYSWAP(TN *val1 , TN *val2)
{
TN tmp;
	tmp = *val1;
	*val1 = *val2;
	*val2 = tmp;
}


#define		SafeGF(obj)		if(obj){GlobalFree(obj);obj=NULL;}

#ifdef _DEBUG
#define DEBUG_OUTPUT		OutputDebugString
#else
#define DEBUG_OUTPUT(str)	;
#endif

//�T�[�t�F�C�X�ɃG���[���������ǂ����`�F�b�N
inline bool MyDIBObj3 :: SFCCheck(int num)
{
	if(sfc == NULL)return false;
	if(num < 0 || num >= maxsurface){
		DEBUG_OUTPUT(_T("SFCCheck()�T�[�t�F�C�X�ԍ��ُ�I\n"));
		return false;
	}
	if(sfc[num].data == NULL)
	{
		DEBUG_OUTPUT(_T("SFCCheck()�T�[�t�F�C�X�������O�Ɏg���悤�Ƃ��܂����B\n"));
		return false;
	}
	return true;
}

//�N���b�s���O���s��
//�c�����]�����邹���ŁA�����Ⴎ����Ȃ�ł����c�c���Ԃ񂠂��Ă�Ǝv�����B
inline bool MyDIBObj3 :: Clipping( const MDO3Opt *opt , bool srcadjust , int *Px , int *Py , int *Pw , int *Ph , int *Psx , int *Psy  , int sx , int sy , int sw , int sh )
{
	if(*Px<sx)
	{
		(*Pw) -= (sx-*Px);
		if(srcadjust)
		{
			if( !(opt->flag & MDO3F_X_MIRROR) )
				(*Psx)+=(sx-*Px);
		}
		(*Px)=sx ;
	}
	if(*Py<sy)
	{
		(*Ph)-=(sy-*Py);
		if(srcadjust)
		{
			if( !(opt->flag & MDO3F_Y_MIRROR) )
			(*Psy)+=(sy-*Py);
		}
		(*Py)=sy;
	}
	if( sx+sw < (*Px) + (*Pw) )
	{
int tmp=sw - ((*Px) - sx);
		if(srcadjust)
		{
			if( opt->flag & MDO3F_X_MIRROR )
				(*Psx)+=(*Pw)-tmp;
		}
		*Pw = tmp ;
	}
	if( sy+sh < (*Py) + (*Ph) )
	{
int tmp=sh - ((*Py) - sy);
		if(srcadjust)
		{
			if( opt->flag & MDO3F_X_MIRROR )
				(*Psy)+=(*Ph)-tmp;
		}
		*Ph = tmp;
	}
	if(*Pw<=0 || *Ph<=0)return false;
	return true;
}

//�\�[�X�����͂ݏo�Ȃ��悤�Ɂi�v���O�������~�X��Ȃ�����͕��ʂ͂��肦�Ȃ��j
inline bool MyDIBObj3 :: ReverseClipping( int srcx , int srcy , int width , int height , int src )
{
	if( srcx < 0 || srcy < 0 || 
		srcx + width  > sfc[src].width || 
		srcy + height > sfc[src].height
	)
	{
		DEBUG_OUTPUT(_T("�\�[�X���N���b�s���O�Ɉ����������Ă��܂�\n")) ;
		return false;
	}
	return true ;
}



#define		Rmask		0x7C00
#define		Gmask		0x03E0
#define		Bmask		0x001F


//�}�N�����g�Ȏd�l
//���̂������A�ٗl�Ƀr���h�Ɏ��Ԃ�������̂����c�c
//���łɁA�t�@�C���T�C�Y���傫���ȁc�c

//SE�c�c�\�[�X�G�t�F�N�g�c�c������
#define SE_none(opt,srcd)				(srcd)
#define SE_and(opt,srcd)				((srcd)&opt->B)
#define SE_or(opt,srcd)					((srcd)|opt->B)
#define SE_simple(opt,srcd)				(opt->B)
#define SE_colortable(opt,srcd)			(opt->PBMPD[srcd])

//CK�c�c�J���[�L�[
#define CK_none(opt,srcd)				(1)
#define CK_colorkey(opt,srcd)			((srcd)!=colorkey)

//BL�c�c�u�����h
#define BL_none(opt,Psfc,srcd)			(srcd)
#define BL_or(opt,Psfc,srcd)			(*Psfc|srcd)
#define BL_and(opt,Psfc,srcd)			(*Psfc&srcd)
#define BL_lightblend(opt,Psfc,srcd)	( LightBlendAssist(*Psfc,srcd) )
#define BL_darkblend(opt,Psfc,srcd)		( DarkBlendAssist(*Psfc,srcd) )
#define BL_blend(opt,Psfc,srcd)			(AT_inv[ *Psfc ] + AT[ srcd ] )
//AT��AT_inv�́A���[�J���ϐ��Ƃ��ă��[�v�O�Ōv�Z�����

//�P�s�ŕ\���Ȃ������̂����Ԃ��Ԋ֐�����

//���Z�����i�d���j
inline BMPD LightBlendAssist(BMPD sfcd,BMPD srcd)
{
BMPD tmp = (sfcd&0x7BDF) + (srcd&0x7BDF) ;
BMPD mask= (( ( tmp ) >> 5 ) &  0x0421)*0x1F ;
	return tmp|mask;
}
//���Z�����i�����Əd���j
inline BMPD DarkBlendAssist(BMPD sfcd,BMPD srcd)
{
BMPD tmp[3] = { 
	(sfcd & Rmask) - (srcd & Rmask) ,
	(sfcd & Gmask) - (srcd & Gmask) ,
	(sfcd & Bmask) - (srcd & Bmask) ,
};
	if( tmp[0] > 0x1F<<10 )tmp[0] = 0;
	if( tmp[1] > 0x1F<<5 )tmp[1] = 0;
	if( tmp[2] > 0x1F )tmp[2] = 0;
	return tmp[0] | tmp[1] | tmp[2];
}

//�����ɁA��̂ق��̃}�N�������蓖�ĂāA�ŏI�I�ɂP�s�N�Z���o�͂����
#define	PixelSet(opt,Psfc,srcd,BLTYPE,CKTYPE,SETYPE)	if(CKTYPE(opt,srcd))*Psfc=BLTYPE(opt,Psfc,SETYPE( opt , srcd ));

//������ێ�����\����
//isvertical��false���ƁAX-Y���W�n�Atrue����Y-X���W�n
//�c�c�ƁA�v�������A�Ȃ񂩈Ⴄ�悤�ȁB��肩���ŁAY-X���W�n�ɑΉ����Ă��Ȃ��H
typedef struct ELINE_tag
{
	double y0;
	double slope;
	bool isvertical;
}ELINE;

//�Q�_���g���āA��̒����\���̂��Z�b�g����
inline bool ELINE_SET( ELINE *Pdest , double x0 , double y0 , double x1 , double y1 )
{
double dx,dy;
	dx = x1-x0;
	dy = y1-y0;
	if( MYABS(dy) < 0.00001 )
	{
		Pdest->isvertical = false;
		return false;
	}
	Pdest->slope = dx/dy;
	Pdest->y0    = x0 - Pdest->slope * y0 ;
	Pdest->isvertical = true;
	return true;
}

//�����\���̂̒����Ay���w��l�̂Ƃ���x���ǂ��ɂ��邩
inline double ELINE_GETX( ELINE *Pdest , double y )
{
	return Pdest->slope * y + Pdest->y0 ;
}

#endif /*MYDIBOBJ3_PRIVATE_HEADER_INCLUDED*/