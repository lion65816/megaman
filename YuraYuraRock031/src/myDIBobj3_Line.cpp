#include <windows.h>
#include "myDIBobj3.h"
#include "myDIBobj3_p.h"

/*
	����`�悷��֐��B
	���j�́AmyDIBobj3_Cls.cpp�ɏ����Ă݂��B
*/


//�Œ菬��ForLine
#define UBITSFL			14
#define	D2FFL(num)		((INT32)(num*(1<<UBITSFL)))
#define F2IFL(num)		(num>>UBITSFL)


//�͈͂��Q���ɕ����Ă����āA�K������M���M���̈ʒu��T���B
//���炵�����������A�ĊO��������
//�E����ɔ͈͓�
static int DivideCorrectR( int sa , int ea , int cb0 , int cb1 , int b0 , INT32 slope)
{
	//���Ԉʒu
int ma = (ea+sa)/2 ;
int mb ;
	//�M���M���ʒu�ł���
	if( ma == sa )
	{
		return ea ;//�E���͈͓�������
	}
	//���Ԉʒu�Ōv�Z
	mb = b0 + slope * (ma-sa) ;
	if( cb0 <= mb && mb < cb1 )
	{
	//���Ԉʒu�͂n�j������
		return DivideCorrectR( sa , ma , cb0 , cb1 , b0 , slope ) ;
	}
	else
	{//���Ԉʒu�̓_��������
		return DivideCorrectR( ma , ea , cb0 , cb1 , mb , slope ) ;
	}
}
//������ɔ͈͓�
static int DivideCorrectL( int sa , int ea , int cb0 , int cb1 , int b0 , INT32 slope)
{
	//���Ԉʒu
int ma = (ea+sa)/2 ;
int mb ;
	//�M���M���ʒu�ł���
	if( ma == sa )
	{
		return sa ;//�����͈͓�������
	}
	//���Ԉʒu�Ōv�Z
	mb = b0 + slope * (ma-sa) ;
	if( cb0 <= mb && mb < cb1 )
	{
	//���Ԉʒu�͂n�j������
		return DivideCorrectL( ma , ea , cb0 , cb1 , mb , slope ) ;
	}
	else
	{//���Ԉʒu�̓_��������
		return DivideCorrectL( sa , ma , cb0 , cb1 , b0 , slope ) ;
	}
}
//�����␳����K�v������B���́A�}�C�i�[�P�[�X�ł���B
//�Ȃ��Ȃ�A��ʂ��܂����ł��܂��Ƃ��́A���t�̍��W�n���K�p����邩��B
//�c�c�������A�\���͂���B
//���Ԃ�A���Ԃ̈ʒu�͔͈͓��Ȃ̂Łi����ۂǂ������ȉ�ʔ䗦���Ƙb������Ă��邯�ǁj
//�͈͓����ǂ������ׁA�͈͓��Ȃ�ADivideCorrectR,L������B
//�͈͊O��������c�c�x�O���B
static bool EitherCorrect( int *Psa , int *Pea , INT32 *Ppdb , int cb0 , int cb1 , int b0 , INT32 slope )
{
int ma=((*Pea)+(*Psa))/2 ;
int mb=b0+slope*(ma-(*Psa));
	if( mb < cb0 || cb1 <= mb )return false;
int tmp;
	tmp = DivideCorrectR( (*Psa) , ma , cb0 , cb1 , b0 , slope ) ;
	*Ppdb += ((tmp-*Psa)*slope) ;
	*Psa = tmp ;
	*Pea = DivideCorrectL( ma , (*Pea) , cb0 , cb1 , mb , slope ) ;
	return true;
}


#define RenderLoopForLine(BLTYPE,CKTYPE,SETYPE)							\
	for( na=sa ; na<ea ; na++ )											\
	{																	\
		if( isXY )														\
		{																\
			PixelSet(opt,&P00[ na | (F2IFL(pdb)<<noshift)],color,BLTYPE,CKTYPE,SETYPE);	\
		}																\
		else															\
		{																\
			PixelSet(opt,&P00[ F2IFL(pdb) | (na<<noshift)],color,BLTYPE,CKTYPE,SETYPE);	\
		}																\
		pdb += slope ;													\
	}


inline void MyDIBObj3 :: Line_sub2( bool isXY , double sloped , const MDO3Opt *opt , int isfc , double a1d , double b1d , double a2d , double b2d , BMPD color )
{
//a-b���W�n�ƌ���
//�������ɂO�D�T�𑫂��Aa�����̏�����؂�̂āi�܂�l�̌ܓ��j�Aa�����̐����ʒu���v�Z����B
	a1d += 0.5;
	a2d += 0.5;
	b1d += 0.5;
	b2d += 0.5;
//�X�����Œ菬���Ōv�Z����
INT32 slope;
	slope  = D2FFL( sloped ) ;
//���[�v���Ab�ʒu���Œ菬���Ŏ������́Bpresent delta b
INT32 pdb;
	pdb    = D2FFL( b1d );
//a�����؎̂Ăɍۂ���ړ����i�K�����Ɉړ����邽�߁A�����j
	pdb -= D2FFL(sloped*(a1d-(int)a1d));

//�T�[�t�F�C�X�̃[���ʒu
BMPD *P00=sfc[isfc].data ;
int  noshift=sfc[isfc].width_bits ;
//���[�v�J�E���^
int na;
//�J�n�E�I���ʒu
int sa = (int)a1d ;
int ea = (int)a2d ;
//�N���b�s���O
int ca,cas,cb,cbs;
	if( isXY )
	{
		ca  = sfc[isfc].clipx ;
		cas = ca + sfc[isfc].clipwidth ;
		cb  = sfc[isfc].clipy ;
		cbs = cb + sfc[isfc].clipheight ;
	}
	else
	{
		cb  = sfc[isfc].clipx ;
		cbs = cb + sfc[isfc].clipwidth ;
		ca  = sfc[isfc].clipy ;
		cas = ca + sfc[isfc].clipheight ;
	}
//�܂��́Aa�����i���ꂾ���Ȃ�y�Ȃ̂Ɂc�c�j
	if( sa < ca )
	{
		pdb += ((ca-sa)*slope) ;
		sa = ca ;
	}
	if( ea > cas )
	{
		ea = cas ;
	}
	if( sa > ea )return;//�s�K�v���H
//�����b����
//�N���b�v�͈͂��Œ菬���ɂ��Ă�����
	ca  = D2FFL( ca  ) ;
	cas = D2FFL( cas ) ;
	cb  = D2FFL( cb  ) ;
	cbs = D2FFL( cbs ) ;
INT32 expeb;//�\�������A�ŏI���ʒu
	expeb = pdb + slope * (ea-sa) ;
	if( pdb < cb )
	{//�n�܂�̈ʒu�ŁA���������ɂ͂ݏo�Ă���
		if( expeb < cb )
		{//�I���̈ʒu�ŁA���������ɂ͂ݏo�Ă���
			return ;
		}
		else if (expeb >= cbs )
		{//�I���̈ʒu�ŁA���������ɂ͂ݏo�Ă���
			if(!EitherCorrect( &sa , &ea , &pdb , cb , cbs , pdb , slope ))return;
		}
		else
		{//�I���̈ʒu�͂͂ݏo���Ă��Ȃ�
int tmp;
			tmp = DivideCorrectR( sa , ea , cb , cbs , pdb , slope ) ;
			pdb += ((tmp-sa)*slope) ;
			sa = tmp ;
		}
	}
	else if (pdb >= cbs )
	{//�n�܂�̈ʒu�ŁA���������ɂ͂ݏo�Ă���
		if( expeb < cb )
		{//�I���̈ʒu�ŁA���������ɂ͂ݏo�Ă���
			if(!EitherCorrect( &sa , &ea , &pdb , cb , cbs , pdb , slope ))return;
		}
		else if (expeb >= cbs )
		{//�I���̈ʒu�ŁA���������ɂ͂ݏo�Ă���
			return ;	
		}
		else
		{//�I���̈ʒu�͂͂ݏo���Ă��Ȃ�
int tmp;
			tmp = DivideCorrectR( sa , ea , cb , cbs , pdb , slope ) ;
			pdb += ((tmp-sa)*slope) ;
			sa = tmp ;
		}
	}
	else
	{//�n�܂�̈ʒu�͂͂ݏo���Ă��Ȃ�
		if( expeb < cb )
		{//�I���̈ʒu�ŁA���������ɂ͂ݏo�Ă���
			ea = DivideCorrectL( sa , ea , cb , cbs , pdb , slope ) ;
		}
		else if (expeb >= cbs )
		{//�I���̈ʒu�ŁA���������ɂ͂ݏo�Ă���
			ea = DivideCorrectL( sa , ea , cb , cbs , pdb , slope ) ;
		}
		else
		{//�I���̈ʒu�͂͂ݏo���Ă��Ȃ�
			//�Ȃɂ����Ȃ��Ăn�j
		}
	}
/*
	//�e�X�g�p�I�I�I
#ifdef _DEBUG
	ca  = F2IFL( ca  ) ;
	cas = F2IFL( cas ) ;
	cb  = F2IFL( cb  ) ;
	cbs = F2IFL( cbs ) ;
#endif
	for( na=sa ; na<ea ; na++ )
	{
		//�e�X�g���[�`���I�I�I
#ifdef _DEBUG
		if( na < ca || na>= cas || F2IFL(pdb)<cb || F2IFL(pdb)>=cbs)
		{
			MessageBox( hwndp , "�\�����Ƃ��" , "���Ԃ�" , MB_OK ) ;
		}
#endif
		if( isXY )
		{
			P00[ na | (F2IFL(pdb)<<noshift) ] = color ;
		}
		else
		{
			P00[ F2IFL(pdb) | (na<<noshift) ] = color ;
		}
		pdb += slope ;
	}
*/
/////////////////////////////////////////////////////////////////////////////////////////////
switch(opt->flag & (MDO3F_BLEND | MDO3F_LIGHT_BLEND | MDO3F_DARK_BLEND | MDO3F_OR_BLEND | MDO3F_AND_BLEND )){
case MDO3F_BLEND:
if((opt->alpha&0xF0)==0)return;
if((opt->alpha&0xF0)!=0xF0){
DWORD alphaselector= ((opt->alpha)&0xF0)<<(-4+16);
BMPD *AT     = &PAlphaTable[ alphaselector ] ;
BMPD *AT_inv = &PAlphaTable[ alphaselector^(0x0F<<16) ] ;
RenderLoopForLine(BL_blend,CK_none,SE_none);break;}
case 0:
RenderLoopForLine(BL_none,CK_none,SE_none);break;
case MDO3F_LIGHT_BLEND:
RenderLoopForLine(BL_lightblend,CK_none,SE_none);break;
case MDO3F_DARK_BLEND:
RenderLoopForLine(BL_darkblend,CK_none,SE_none);break;
case MDO3F_OR_BLEND:
RenderLoopForLine(BL_or,CK_none,SE_none);break;
case MDO3F_AND_BLEND:
RenderLoopForLine(BL_and,CK_none,SE_none);break;
default:return;}
/////////////////////////////////////////////////////////////////////////////////////////////
}
inline void MyDIBObj3 :: Line_sub1( bool isXY , double sloped , const MDO3Opt *opt , int isfc , double a1d , double b1d , double a2d , double b2d , BMPD color )
{
//a-b���W�n�ƌ���Ba1��a2���r���A�������ق�����傫���ق��ɏ�������悤�ɂ���
	if( a1d < a2d ) 
	{
		Line_sub2( isXY , sloped , opt , isfc , a1d , b1d , a2d , b2d , color ) ;
	}
	else
	{
		Line_sub2( isXY , sloped , opt , isfc , a2d , b2d , a1d , b1d , color ) ;
	}
}
void MyDIBObj3 :: Line(const MDO3Opt *opt,int isfc,double x1,double y1,double x2,double y2,BMPD color)
{
	if(!SFCCheck(isfc))return;
	if(opt->flag & MDO3F_USE_WINAPI )
	{
		MoveToEx(sfc[isfc].hdc,(int)x1,(int)y1,NULL);
		LineTo(sfc[isfc].hdc,(int)x2,(int)y2);
		return;
	}
double deltax,deltay;

	deltax = x2 - x1;
	deltay = y2 - y1;
//	if(MYABS(MYABS(deltax) - MYABS(deltay)) < 0.0000001)return;
	if(MYABS(deltax) >= MYABS(deltay))
	{
		Line_sub1(true,deltay/deltax , opt , isfc , x1 , y1 , x2 , y2 , color);
	}
	else
	{
		Line_sub1(false,deltax/deltay , opt , isfc , y1 , x1 , y2 , x2 , color);
	}
}

