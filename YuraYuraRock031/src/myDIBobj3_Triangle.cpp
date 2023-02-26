#if 0

#include <windows.h>
#include "myDIBobj3.h"
#include "myDIBobj3_p.h"
/*
	�O�p�`��`�悷��֐��B
	���j�́AmyDIBobj3_Cls.cpp�ɏ����Ă݂��B

	�c�c�Q�_�𓯂����W�Ɏw�肵�āA�P�_�����Ⴄ�Ƃ��A�Q�̎O�p�`�͂҂�����q����Ȃ��Ƃ����Ȃ��̂����A
	���̂Q�_�������ɋ߂��Ƃ���Ȃ��񂾂����ȁc�c
	�����ɋ߂��Ȃ�Ă����̂̓U���ɂ��邱�ƂɎv���邪�Ȃ��B
	���Ă������A���܂��̃\�[�X�������A�Ȃɂ���Ă񂾂��S���킩��񂩂����c�c

	�����M���āA�떂�����Č��͋󂩂Ȃ��悤�ɂ����B
	���A����ɏ��X�L�͈͂������悤�ɂ������߁A���������d�˂�Ɓc�c
	���ꂾ������Ȃ��A�Ȃ񂩕ςȏo�����肪������c�c
	����ɘM���āA�c�����ɋ����I�ɂP�傫������悤�ɂ����c�c
	���܂�Ɍ����c�c
*/

//�Œ菬��ForTRIangle�炵��
#define UBITSFTRI			14
#define	D2FFTRI(num)		((INT32)((num)*(1<<UBITSFTRI)))
#define F2IFTRI(num)		((num)>>UBITSFTRI)










//�Q�_�������̌������h�~�p���܂����g�����̗V��
//�i�����J�����͏d�Ȃ��������c�c�Ƃ������z�j
#define FILL_WIDTH			0

#define SET_FOR_TRIANGLE(n1,n2,n3)								;\
	leng[0] = (int)y##n1;										\
	leng[1] = (int)y##n2;										\
	leng[2] = (int)y##n3;										\
	if( x##n2 < ELINE_GETX(&line[n2],y##n2) )					\
	{/*������*/													\
		/*�X�����Z�b�g*/										\
		leftslope[0] = D2FFTRI(line[n3].slope) ;				\
		rightslope[0] = D2FFTRI(line[n2].slope) ;				\
		leftslope[1] = D2FFTRI(line[n1].slope) ;				\
		rightslope[1] = D2FFTRI(line[n2].slope) ;				\
		/*�}�X�ڂ̏�͂��ł̈ʒu�ɕ␳���Z�b�g*/			\
		leftppos[0] = D2FFTRI(x##n1-line[n3].slope*(y##n1-(int)y##n1) ) ;	\
		rightppos[0] = D2FFTRI(x##n1-line[n2].slope*(y##n1-(int)y##n1) ) ;	\
		leftppos[1] = D2FFTRI(x##n2+line[n1].slope*(1-y##n2+(int)y##n2) ) ;	\
		rightconnect = true;									\
	}															\
	else														\
	{/*�E����*/													\
		/*�X�����Z�b�g*/										\
		leftslope[0] = D2FFTRI(line[n2].slope) ;				\
		rightslope[0] = D2FFTRI(line[n3].slope) ;				\
		leftslope[1] = D2FFTRI(line[n2].slope) ;				\
		rightslope[1] = D2FFTRI(line[n1].slope) ;				\
		/*�}�X�ڂ̏�͂��ł̈ʒu�ɕ␳���Z�b�g*/			\
		leftppos[0] = D2FFTRI(x##n1-line[n2].slope*(y##n1-(int)y##n1) ) ;	\
		rightppos[0] = D2FFTRI(x##n1-line[n3].slope*(y##n1-(int)y##n1) ) ;	\
		rightppos[1] = D2FFTRI(x##n2+line[n1].slope*(1-y##n2+(int)y##n2) ) ;	\
		leftconnect = true;										\
	}

/*
#define SET_FOR_TRIANGLE(n1,n2,n3)								;\
	fixfillL = 0 ;	fixfillR = 0 ;								\
	leftppos[0] = rightppos[0] = D2FFTRI(x##n1) ;				\
	leftppos[1]  = D2FFTRI(x##n2);								\
	rightppos[1] = D2FFTRI(ELINE_GETX(&line[n2],y##n2));\
	leng[0] = (int)y##n1;										\
	leng[1] = (int)y##n2;										\
	leng[2] = (int)y##n3;										\
	if( leftppos[1] < rightppos[1] )							\
	{															\
		leftslope[0] = D2FFTRI(line[n3].slope) ;				\
		rightslope[0] = D2FFTRI(line[n2].slope) ;				\
		leftslope[1] = D2FFTRI(line[n1].slope) ;				\
		rightslope[1] = D2FFTRI(line[n2].slope) ;				\
		rightconnect = true;									\
	}															\
	else														\
	{															\
		MYSWAP( &leftppos[1] , &rightppos[1] ) ;				\
		leftslope[0] = D2FFTRI(line[n2].slope) ;				\
		rightslope[0] = D2FFTRI(line[n3].slope) ;				\
		leftslope[1] = D2FFTRI(line[n2].slope) ;				\
		rightslope[1] = D2FFTRI(line[n1].slope) ;				\
		leftconnect = true;										\
	}


*/
#define		SET_FOR_TRIANGLE_MINOR(n1,n2,dp)			;\
		if(y##n1 < y##dp )								\
		{												\
			leng[1] = (int)(y##n1);						\
			leng[2] = (int)(y##dp);						\
			if( x##n1 < x##n2 )								\
			{												\
				leftppos[1] = D2FFTRI(x##n1);				\
				rightppos[1] = D2FFTRI(x##n2);				\
				leftslope[1] = D2FFTRI(line[n2].slope);		\
				rightslope[1] = D2FFTRI(line[n1].slope);	\
			}												\
			else											\
			{												\
				leftppos[1] = D2FFTRI(x##n2);				\
				rightppos[1] = D2FFTRI(x##n1);				\
				leftslope[1] = D2FFTRI(line[n1].slope);		\
				rightslope[1] = D2FFTRI(line[n2].slope);	\
			}											\
			fixfillL = -D2FFTRI(FILL_WIDTH) ;	\
			fixfillR = +D2FFTRI(FILL_WIDTH) ;	\
		}												\
		else											\
		{												\
			leng[1] = (int)(y##dp);						\
			leng[2] = (int)(y##n1);						\
			if( x##n1 < x##n2 )								\
			{												\
				leftppos[1] =								\
				rightppos[1] = D2FFTRI(x##dp);				\
				leftslope[1] = D2FFTRI(line[n2].slope);		\
				rightslope[1] = D2FFTRI(line[n1].slope);	\
			}												\
			else											\
			{												\
				leftppos[1] =								\
				rightppos[1] = D2FFTRI(x##dp);				\
				leftslope[1] = D2FFTRI(line[n1].slope);		\
				rightslope[1] = D2FFTRI(line[n2].slope);	\
			}											\
			fixfillL =-D2FFTRI(FILL_WIDTH) ;	\
			fixfillR = +D2FFTRI(FILL_WIDTH) ;	\
		}


#define	RenderLoopForTriangle_sub(clipenabled,BLTYPE,CKTYPE,SETYPE) ;\
			for(iy=0 ;iy<finexp;iy++)								\
			{														\
int linewidth =  F2IFTRI(rightppos[i])-F2IFTRI(leftppos[i]) ;		\
				if(clipenabled)										\
				{													\
int tmpx=F2IFTRI(leftppos[i]);										\
					if(tmpx<sfc[isfc].clipx)									\
					{															\
						linewidth -= (sfc[isfc].clipx-tmpx);					\
						tmpx = sfc[isfc].clipx ;								\
					}															\
					if(tmpx+linewidth>sfc[isfc].clipx+sfc[isfc].clipwidth)		\
					{															\
						linewidth = sfc[isfc].clipx+sfc[isfc].clipwidth-tmpx;	\
					}															\
					Psfcsenv = Psfc + tmpx ;									\
				}													\
				else												\
				{													\
					Psfcsenv = Psfc + F2IFTRI(leftppos[i]) ;		\
				}													\
int tw=linewidth - 7 ;												\
				for(ix= 0 ; ix<tw  ; ix += 8 )						\
				{													\
	PixelSet(opt,&Psfcsenv[ix+0],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+1],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+2],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+3],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+4],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+5],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+6],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+7],color,BLTYPE,CKTYPE,SETYPE);		\
				}													\
				for( ; ix<linewidth  ; ix ++ )						\
				{													\
	PixelSet(opt,&Psfcsenv[ix+0],color,BLTYPE,CKTYPE,SETYPE);		\
				}													\
				Psfc += sfc[isfc].width ;							\
				leftppos[i]  +=  leftslope[i] ;						\
				rightppos[i]  +=  rightslope[i] ;					\
			}

#define	RenderLoopForTriangle(BLTYPE,CKTYPE,SETYPE) ;\
		if(issideclip)												\
		{															\
			RenderLoopForTriangle_sub(1,BLTYPE,CKTYPE,SETYPE) ;		\
		}															\
		else														\
		{															\
			RenderLoopForTriangle_sub(0,BLTYPE,CKTYPE,SETYPE) ;		\
		}


void MyDIBObj3 :: Triangle( const MDO3Opt *opt , int isfc , double x0 , double y0 , double x1 , double y1 , double x2 , double y2 , BMPD color )
{
ELINE line[3];
int sameheight=0;
//�}�X�ڂ̃Z���^�[������c�c����ɁA���炵�Ċi�q�_������B
	x0 -= 0.5 ;
	y0 -= 0.5 ;
	x1 -= 0.5 ;
	y1 -= 0.5 ;
	x2 -= 0.5 ;
	y2 -= 0.5 ;

	if( !ELINE_SET( &line[0] , x1 , y1 , x2 , y2 ) )sameheight+=1;	
	if( !ELINE_SET( &line[1] , x2 , y2 , x0 , y0 ) )sameheight+=2;	
	if( !ELINE_SET( &line[2] , x0 , y0 , x1 , y1 ) )sameheight+=4;	
INT32 leftslope[2],rightslope[2];
INT32 leftppos[2],rightppos[2];
bool leftconnect,rightconnect;
int leng[3];
	leftconnect = false;
	rightconnect = false;
	switch( sameheight )
	{
	case 0://��v����
		//�������˂������c�c
		if( y0 < y1 )
		{

			if( y2 < y0 )
			{//2 0 1
				SET_FOR_TRIANGLE(2,0,1);
			}
			else if( y2 < y1 )
			{//0 2 1
				SET_FOR_TRIANGLE(0,2,1);
			}
			else
			{//0 1 2
				SET_FOR_TRIANGLE(0,1,2);
			}
		}
		else
		{
			if( y2 < y1 )
			{//2 1 0 
				SET_FOR_TRIANGLE(2,1,0);
			}
			else if( y2 < y0 )
			{//1 2 0
				SET_FOR_TRIANGLE(1,2,0);
			}
			else
			{//1 0 2
				SET_FOR_TRIANGLE(1,0,2);
			}

		}
	break;
/*	case 1://12��v

		SET_FOR_TRIANGLE_MINOR(1,2,0);
	break;
	case 2://20��v
		SET_FOR_TRIANGLE_MINOR(2,0,1);
	break;
	case 4://01��v
		SET_FOR_TRIANGLE_MINOR(0,1,2);
	break;
*/	default:
		return ;
	}
int i,ix,iy;

BMPD *Psfc,*Psfcsenv;


for(i=0 ; i<2 ; i++)
{
	if(i==1 || !sameheight)
	{
//�������N���b�s���O
int ry0,ry1;
	ry0 = leng[i] +(i==1);
	ry1 = leng[i+1]+(i==0) ;
//���̃N���b�s���O�i�͈͂��k�߂邾���I�j
	ry1 = min( ry1 , sfc[isfc].clipy+sfc[isfc].clipheight ) ;
//��̃N���b�s���O�i���E�̌��݈ʒu���A�␳���~�X�������Ă��Ȃ��Ƃ����Ȃ��j
	if( ry0 < sfc[isfc].clipy )
	{
		leftppos[i] += leftslope[i]*( sfc[isfc].clipy-ry0 ) ;
		rightppos[i] += rightslope[i]*( sfc[isfc].clipy-ry0 ) ;
		ry0 = sfc[isfc].clipy ;
	}
//���ǂ́A��������
int finexp=ry1-ry0;
//���܂������g��
	rightppos[i]+=FILL_WIDTH ;
	leftppos[i]+=FILL_WIDTH ;
//�������R�ɕ�����B�N���b�v�K�v�Ȃ��A����A�����āA�������Ȃ��A�ł���B
bool issideclip=false;
int tmpx ;
	//�����ŁA�����I�����̈ʒu
	tmpx = F2IFTRI(leftppos[i]+leftslope[i]*(finexp-1)) ;//�P�Ⴂ�ʒu
	//�����̈ړ��O��̗��ʒu���A�N���b�v���E�Ȃ珈�����Ȃ�
	if( min(F2IFTRI(leftppos[i]),tmpx)
		>= sfc[isfc].clipx+sfc[isfc].clipwidth )continue;
	//�݂͂�������������Aissideclip��true��
	if( 
		F2IFTRI(leftppos[i]) < sfc[isfc].clipx ||
		F2IFTRI(leftppos[i]) >= sfc[isfc].clipx+sfc[isfc].clipwidth ||
		tmpx < sfc[isfc].clipx ||
		tmpx >= sfc[isfc].clipx+sfc[isfc].clipwidth 
		)issideclip=true;
	//�E��
	tmpx = F2IFTRI(rightppos[i]+rightslope[i]*(finexp-1)) ;//�P�Ⴂ�ʒu
	//�E���ƁA�E���̈ړ���̈ʒu�̂��E�����A�N���b�v��荶�Ȃ珈�����Ȃ�
	if( max(F2IFTRI(rightppos[i]),tmpx)
		< sfc[isfc].clipx )continue;
	//�݂͂�������������Aissideclip��true��
	if( 
		F2IFTRI(rightppos[i]) < sfc[isfc].clipx ||
		F2IFTRI(rightppos[i]) >= sfc[isfc].clipx+sfc[isfc].clipwidth ||
		tmpx < sfc[isfc].clipx ||
		tmpx >= sfc[isfc].clipx+sfc[isfc].clipwidth 
		)issideclip=true;





		Psfc = &sfc[isfc].data[ry0<<sfc[isfc].width_bits]  ;
//*
RenderLoopForTriangle(BL_lightblend,CK_none,SE_none);
/*/
//////////////////////////////////////////////////////////////////////////////////////////
switch(opt->flag & (MDO3F_BLEND | MDO3F_LIGHT_BLEND | MDO3F_DARK_BLEND | MDO3F_OR_BLEND | MDO3F_AND_BLEND )){
case MDO3F_BLEND:
if((opt->alpha&0xF0)==0)return;
if((opt->alpha&0xF0)!=0xF0){
DWORD alphaselector= ((opt->alpha)&0xF0)<<(-4+16);
BMPD *AT     = &PAlphaTable[ alphaselector ] ;
BMPD *AT_inv = &PAlphaTable[ alphaselector^(0x0F<<16) ] ;
RenderLoopForTriangle(BL_blend,CK_none,SE_none);break;}
case 0:
RenderLoopForTriangle(BL_none,CK_none,SE_none);break;
case MDO3F_LIGHT_BLEND:
RenderLoopForTriangle(BL_lightblend,CK_none,SE_none);break;
case MDO3F_DARK_BLEND:
RenderLoopForTriangle(BL_darkblend,CK_none,SE_none);break;
case MDO3F_OR_BLEND:
RenderLoopForTriangle(BL_or,CK_none,SE_none);break;
case MDO3F_AND_BLEND:
RenderLoopForTriangle(BL_and,CK_none,SE_none);break;
default:return;}
//////////////////////////////////////////////////////////////////////////////////////////
//*/
		if( rightconnect )
		{
			rightppos[1] = rightppos[0];
//			assert( !fixfillR ) ;
		}
		if( leftconnect )
		{
			leftppos[1] = leftppos[0];
//			assert( !fixfillL ) ;
		}
	}
}
	return ;
}

#endif








#include <windows.h>
#include "myDIBobj3.h"
#include "myDIBobj3_p.h"
/*
	�O�p�`��`�悷��֐��B
	���j�́AmyDIBobj3_Cls.cpp�ɏ����Ă݂��B

	�c�c�Q�_�𓯂����W�Ɏw�肵�āA�P�_�����Ⴄ�Ƃ��A�Q�̎O�p�`�͂҂�����q����Ȃ��Ƃ����Ȃ��̂����A
	���̂Q�_�������ɋ߂��Ƃ���Ȃ��񂾂����ȁc�c
	�����ɋ߂��Ȃ�Ă����̂̓U���ɂ��邱�ƂɎv���邪�Ȃ��B
	���Ă������A���܂��̃\�[�X�������A�Ȃɂ���Ă񂾂��S���킩��񂩂����c�c

	�����M���āA�떂�����Č��͋󂩂Ȃ��悤�ɂ����B
	���A����ɏ��X�L�͈͂������悤�ɂ������߁A���������d�˂�Ɓc�c
	���ꂾ������Ȃ��A�Ȃ񂩕ςȏo�����肪������c�c
	����ɘM���āA�c�����ɋ����I�ɂP�傫������悤�ɂ����c�c
	���܂�Ɍ����c�c
*/

//�Œ菬��ForTRIangle�炵��
#define UBITSFTRI			14
#define	D2FFTRI(num)		((INT32)((num)*(1<<UBITSFTRI)))
#define F2IFTRI(num)		((num)>>UBITSFTRI)










//�Q�_�������̌������h�~�p���܂����g�����̗V��
//�i�����J�����͏d�Ȃ��������c�c�Ƃ������z�j
#define FILL_WIDTH			0

#define SET_FOR_TRIANGLE(n1,n2,n3)								;\
	leftppos[0] = rightppos[0] = D2FFTRI(x##n1) ;				\
	leftppos[1]  = D2FFTRI(x##n2);								\
	rightppos[1] = D2FFTRI(ELINE_GETX(&line[n2],y##n2));		\
	leng[0] = (int)y##n1;										\
	leng[1] = (int)y##n2;										\
	leng[2] = (int)y##n3;										\
	if( leftppos[1] < rightppos[1] )							\
	{															\
		leftslope[0] = D2FFTRI(line[n3].slope) ;				\
		rightslope[0] = D2FFTRI(line[n2].slope) ;				\
		leftslope[1] = D2FFTRI(line[n1].slope) ;				\
		rightslope[1] = D2FFTRI(line[n2].slope) ;				\
		rightconnect = true;									\
	}															\
	else														\
	{															\
		MYSWAP( &leftppos[1] , &rightppos[1] ) ;				\
		leftslope[0] = D2FFTRI(line[n2].slope) ;				\
		rightslope[0] = D2FFTRI(line[n3].slope) ;				\
		leftslope[1] = D2FFTRI(line[n2].slope) ;				\
		rightslope[1] = D2FFTRI(line[n1].slope) ;				\
		leftconnect = true;										\
	}

#define		SET_FOR_TRIANGLE_MINOR(n1,n2,dp)			;\
		if(y##n1 < y##dp )								\
		{												\
			leng[1] = (int)(y##n1);						\
			leng[2] = (int)(y##dp);						\
			if( x##n1 < x##n2 )								\
			{												\
				leftppos[1] = D2FFTRI(x##n1);				\
				rightppos[1] = D2FFTRI(x##n2);				\
				leftslope[1] = D2FFTRI(line[n2].slope);		\
				rightslope[1] = D2FFTRI(line[n1].slope);	\
			}												\
			else											\
			{												\
				leftppos[1] = D2FFTRI(x##n2);				\
				rightppos[1] = D2FFTRI(x##n1);				\
				leftslope[1] = D2FFTRI(line[n1].slope);		\
				rightslope[1] = D2FFTRI(line[n2].slope);	\
			}											\
		}												\
		else											\
		{												\
			leng[1] = (int)(y##dp);						\
			leng[2] = (int)(y##n1);						\
			if( x##n1 < x##n2 )								\
			{												\
				leftppos[1] =								\
				rightppos[1] = D2FFTRI(x##dp);				\
				leftslope[1] = D2FFTRI(line[n2].slope);		\
				rightslope[1] = D2FFTRI(line[n1].slope);	\
			}												\
			else											\
			{												\
				leftppos[1] =								\
				rightppos[1] = D2FFTRI(x##dp);				\
				leftslope[1] = D2FFTRI(line[n1].slope);		\
				rightslope[1] = D2FFTRI(line[n2].slope);	\
			}											\
		}

/*
#define		SET_FOR_TRIANGLE_MINOR(n1,n2,dp)			;\
		if(y##n1 < y##dp )								\
		{												\
			leng[1] = (int)y##n1-1;						\
			leng[2] = (int)y##dp+1;						\
			if( x##n1 < x##n2 )								\
			{												\
				leftppos[1] = D2FFTRI(x##n1);				\
				rightppos[1] = D2FFTRI(x##n2);				\
				leftslope[1] = D2FFTRI(line[n2].slope);		\
				rightslope[1] = D2FFTRI(line[n1].slope);	\
			}												\
			else											\
			{												\
				leftppos[1] = D2FFTRI(x##n2);				\
				rightppos[1] = D2FFTRI(x##n1);				\
				leftslope[1] = D2FFTRI(line[n1].slope);		\
				rightslope[1] = D2FFTRI(line[n2].slope);	\
			}											\
			fixfillL = -leftslope[1]*2-D2FFTRI(FILL_WIDTH) ;	\
			fixfillR = -rightslope[1]*2+D2FFTRI(FILL_WIDTH) ;	\
		}												\
		else											\
		{												\
			leng[1] = (int)y##dp-1;						\
			leng[2] = (int)y##n1+1;						\
			if( x##n1 < x##n2 )								\
			{												\
				leftppos[1] =								\
				rightppos[1] = D2FFTRI(x##dp);				\
				leftslope[1] = D2FFTRI(line[n2].slope);		\
				rightslope[1] = D2FFTRI(line[n1].slope);	\
			}												\
			else											\
			{												\
				leftppos[1] =								\
				rightppos[1] = D2FFTRI(x##dp);				\
				leftslope[1] = D2FFTRI(line[n1].slope);		\
				rightslope[1] = D2FFTRI(line[n2].slope);	\
			}											\
			fixfillL = leftslope[1]*2-D2FFTRI(FILL_WIDTH) ;	\
			fixfillR = rightslope[1]*2+D2FFTRI(FILL_WIDTH) ;	\
		}
  */
#define	RenderLoopForTriangle_sub(clipenabled,BLTYPE,CKTYPE,SETYPE) ;\
			for(iy=0 ;iy<finexp;iy++)								\
			{														\
int linewidth =  F2IFTRI(rightppos[i])-F2IFTRI(leftppos[i]) ;		\
				if(clipenabled)										\
				{													\
int tmpx=F2IFTRI(leftppos[i]);										\
					if(tmpx<sfc[isfc].clipx)									\
					{															\
						linewidth -= (sfc[isfc].clipx-tmpx);					\
						tmpx = sfc[isfc].clipx ;								\
					}															\
					if(tmpx+linewidth>sfc[isfc].clipx+sfc[isfc].clipwidth)		\
					{															\
						linewidth = sfc[isfc].clipx+sfc[isfc].clipwidth-tmpx;	\
					}															\
					Psfcsenv = Psfc + tmpx ;									\
				}													\
				else												\
				{													\
					Psfcsenv = Psfc + F2IFTRI(leftppos[i]) ;		\
				}													\
int tw=linewidth - 7 ;												\
				for(ix= 0 ; ix<tw  ; ix += 8 )						\
				{													\
	PixelSet(opt,&Psfcsenv[ix+0],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+1],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+2],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+3],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+4],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+5],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+6],color,BLTYPE,CKTYPE,SETYPE);		\
	PixelSet(opt,&Psfcsenv[ix+7],color,BLTYPE,CKTYPE,SETYPE);		\
				}													\
				for( ; ix<linewidth  ; ix ++ )						\
				{													\
	PixelSet(opt,&Psfcsenv[ix+0],color,BLTYPE,CKTYPE,SETYPE);		\
				}													\
				Psfc += sfc[isfc].width ;							\
				leftppos[i]  +=  leftslope[i] ;						\
				rightppos[i]  +=  rightslope[i] ;					\
			}

#define	RenderLoopForTriangle(BLTYPE,CKTYPE,SETYPE) ;\
		if(issideclip)												\
		{															\
			RenderLoopForTriangle_sub(1,BLTYPE,CKTYPE,SETYPE) ;		\
		}															\
		else														\
		{															\
			RenderLoopForTriangle_sub(0,BLTYPE,CKTYPE,SETYPE) ;		\
		}


void MyDIBObj3 :: Triangle( const MDO3Opt *opt , int isfc , double x0 , double y0 , double x1 , double y1 , double x2 , double y2 , BMPD color )
{
ELINE line[3];
int sameheight=0;
/*
//�␳�����ق����ǂ��H
	x0 += 0.5 ;
	y0 += 0.5 ;
	x1 += 0.5 ;
	y1 += 0.5 ;
	x2 += 0.5 ;
	y2 += 0.5 ;
//*/
	if( !ELINE_SET( &line[0] , x1 , y1 , x2 , y2 ) )sameheight+=1;	
	if( !ELINE_SET( &line[1] , x2 , y2 , x0 , y0 ) )sameheight+=2;	
	if( !ELINE_SET( &line[2] , x0 , y0 , x1 , y1 ) )sameheight+=4;	
INT32 leftslope[2],rightslope[2];
INT32 leftppos[2],rightppos[2];
//INT32 fixfillL,fixfillR;//�����J���Ȃ��悤�ɂ��܂�����
bool leftconnect,rightconnect;
int leng[3];
	leftconnect = false;
	rightconnect = false;
	switch( sameheight )
	{
	case 0://��v����
		//�������˂������c�c
		if( y0 < y1 )
		{

			if( y2 < y0 )
			{//2 0 1
				SET_FOR_TRIANGLE(2,0,1);
			}
			else if( y2 < y1 )
			{//0 2 1
				SET_FOR_TRIANGLE(0,2,1);
			}
			else
			{//0 1 2
				SET_FOR_TRIANGLE(0,1,2);
			}
		}
		else
		{
			if( y2 < y1 )
			{//2 1 0 
				SET_FOR_TRIANGLE(2,1,0);
			}
			else if( y2 < y0 )
			{//1 2 0
				SET_FOR_TRIANGLE(1,2,0);
			}
			else
			{//1 0 2
				SET_FOR_TRIANGLE(1,0,2);
			}

		}
	break;
	case 1://12��v

		SET_FOR_TRIANGLE_MINOR(1,2,0);
	break;
	case 2://20��v
		SET_FOR_TRIANGLE_MINOR(2,0,1);
	break;
	case 4://01��v
		SET_FOR_TRIANGLE_MINOR(0,1,2);
	break;
	default:
		return ;
	}
int i,ix,iy;

BMPD *Psfc,*Psfcsenv;

for(i=0 ; i<2 ; i++)
{
	if(i==1 || !sameheight)
	{
//�������N���b�s���O
int ry0,ry1;
	ry0 = leng[i] ;
	ry1 = leng[i+1] ;
//���̃N���b�s���O�i�͈͂��k�߂邾���I�j
	ry1 = min( ry1 , sfc[isfc].clipy+sfc[isfc].clipheight ) ;
//��̃N���b�s���O�i���E�̌��݈ʒu���A�␳���~�X�������Ă��Ȃ��Ƃ����Ȃ��j
	if( ry0 < sfc[isfc].clipy )
	{
		leftppos[i] += leftslope[i]*( sfc[isfc].clipy-ry0 ) ;
		rightppos[i] += rightslope[i]*( sfc[isfc].clipy-ry0 ) ;
		ry0 = sfc[isfc].clipy ;
	}
//���ǂ́A��������
int finexp=ry1-ry0;
//���܂������g��
//	rightppos[i]+=fixfillR ;
//	leftppos[i]+=fixfillL ;
//�������R�ɕ�����B�N���b�v�K�v�Ȃ��A����A�����āA�������Ȃ��A�ł���B
bool issideclip=false;
int tmpx ;
	//����
	tmpx = F2IFTRI(leftppos[i]+leftslope[i]*(finexp-1)) ;//�P�Ⴂ�ʒu
	//�����ƁA�����̈ړ���̈ʒu�̂�荶�����A�N���b�v���E�Ȃ珈�����Ȃ�
	if( min(F2IFTRI(leftppos[i]),tmpx)
		>= sfc[isfc].clipx+sfc[isfc].clipwidth )continue;
	//�݂͂�������������Aissideclip��true��
	if( 
		F2IFTRI(leftppos[i]) < sfc[isfc].clipx ||
		F2IFTRI(leftppos[i]) >= sfc[isfc].clipx+sfc[isfc].clipwidth ||
		tmpx < sfc[isfc].clipx ||
		tmpx >= sfc[isfc].clipx+sfc[isfc].clipwidth 
		)issideclip=true;
	//�E��
	tmpx = F2IFTRI(rightppos[i]+rightslope[i]*(finexp-1)) ;//�P�Ⴂ�ʒu
	//�E���ƁA�E���̈ړ���̈ʒu�̂��E�����A�N���b�v��荶�Ȃ珈�����Ȃ�
	if( max(F2IFTRI(rightppos[i]),tmpx)
		< sfc[isfc].clipx )continue;
	//�݂͂�������������Aissideclip��true��
	if( 
		F2IFTRI(rightppos[i]) < sfc[isfc].clipx ||
		F2IFTRI(rightppos[i]) >= sfc[isfc].clipx+sfc[isfc].clipwidth ||
		tmpx < sfc[isfc].clipx ||
		tmpx >= sfc[isfc].clipx+sfc[isfc].clipwidth 
		)issideclip=true;





		Psfc = &sfc[isfc].data[ry0<<sfc[isfc].width_bits]  ;
//*
RenderLoopForTriangle(BL_none,CK_none,SE_none);
/*/
//////////////////////////////////////////////////////////////////////////////////////////
switch(opt->flag & (MDO3F_BLEND | MDO3F_LIGHT_BLEND | MDO3F_DARK_BLEND | MDO3F_OR_BLEND | MDO3F_AND_BLEND )){
case MDO3F_BLEND:
if((opt->alpha&0xF0)==0)return;
if((opt->alpha&0xF0)!=0xF0){
DWORD alphaselector= ((opt->alpha)&0xF0)<<(-4+16);
BMPD *AT     = &PAlphaTable[ alphaselector ] ;
BMPD *AT_inv = &PAlphaTable[ alphaselector^(0x0F<<16) ] ;
RenderLoopForTriangle(BL_blend,CK_none,SE_none);break;}
case 0:
RenderLoopForTriangle(BL_none,CK_none,SE_none);break;
case MDO3F_LIGHT_BLEND:
RenderLoopForTriangle(BL_lightblend,CK_none,SE_none);break;
case MDO3F_DARK_BLEND:
RenderLoopForTriangle(BL_darkblend,CK_none,SE_none);break;
case MDO3F_OR_BLEND:
RenderLoopForTriangle(BL_or,CK_none,SE_none);break;
case MDO3F_AND_BLEND:
RenderLoopForTriangle(BL_and,CK_none,SE_none);break;
default:return;}
//////////////////////////////////////////////////////////////////////////////////////////
//*/
		if( rightconnect )
		{
			rightppos[1] = rightppos[0];
//			assert( !fixfillR ) ;
		}
		if( leftconnect )
		{
			leftppos[1] = leftppos[0];
//			assert( !fixfillL ) ;
		}
	}
}
	return ;
}

