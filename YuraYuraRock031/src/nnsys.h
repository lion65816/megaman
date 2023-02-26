#ifndef NNSYS_HEADER_INCLUDED
#define NNSYS_HEADER_INCLUDED

#ifndef PI
#define		PI		3.1415926535897932384626433832795
#endif

#define D2R(ang)		((ang) * PI / 180)//�x���@to���W�A��
#define R2D(ang)		((ang) * 180 / PI)//���W�A��to�x���@


////////////////////////////////
//����֗��i��������Ȃ��j�֐��S
////////////////////////////////

/*
���J�p�ɍ�蒼���Ă�����Ainline���炯�ɂȂ��Ă��܂����B
*/

//�Œ菬���֘A
/*�}�N�����p�e���v��
#define	DBITS			16
#define	I2F(i)			I2F(DBITS,i)
#define	F2I(f)			F2I(DBITS,f)
#define	D2F(d)			D2F(DBITS,d)
#define	F2D(f)			F2D(DBITS,f)
#define	FMulti(a,b)		FMulti(DBITS,a,b)
#define	FDivide(a,b)	FDivide(DBITS,a,b)
*/
inline __int32 I2F(int db,int i)
{
	return i<<db;
}
inline __int32 F2I(int db,__int32 f)
{
	return f>>db;
}
inline __int32 D2F(int db,double d)
{
	return (__int32)(d*(1<<db));
}
inline double F2D(int db,__int32 f)
{
	return (double)f/(1<<db) ;
}
inline __int32 FMulti( int db , __int32 a , __int32 b )
{//�኱a�̂ق������x���������Ƃ�
	return (a>>((db  )/2))*(b>>((db+1)/2)) ;
}
inline __int32 FDivide( int db , __int32 a , __int32 b )
{
	return D2F( db , (double)a/b ) ;
}

//(x,y)���A(srcx,srcy)-(srcx+width,srcy+height),b�̓����ɑ��݂��邩�B�n���ɕ֗�
inline bool RectIn(int x,int y,int srcx,int srcy,int width,int height)
{
	if((srcx <= x) & (srcy <= y) & (srcx + width > x) & (srcy + height > y))return true; 
	return false;
}
inline bool RectIn(double x,double y,double srcx,double srcy,double width,double height)
{
	if((srcx <= x) & (srcy <= y) & (srcx + width > x) & (srcy + height > y))return true; 
	return false;
}

//double�Ȋp�x���P�����ɕ␳
//�Ȃ񂩏ꍇ�ɂ���Ă₽��d�������c�c
inline void AngleFixPlus(double *Pangle)
{
	while(*Pangle < 0){*Pangle += 2*PI;}
	while(*Pangle >= 2*PI){*Pangle -= 2*PI;}
}
inline void AngleFixEven(double *Pangle)
{
	while(*Pangle < -PI){*Pangle += 2*PI;}
	while(*Pangle >= PI){*Pangle -= 2*PI;}
}
//way�E�F�C�̕����ɋ߂��ق��ɁAangle��␳�������̂�Ԃ�
inline double AboutAngle( double angle , double a0 , int way )
{
double eangle = 2*PI/way;
	return ((int)((angle+a0)/eangle+0.5))*eangle+a0 ;
}


//�����e�[�u������荂�������͂������炵���̂����c�c
//�}���`�X���b�h�ł͎g���Ȃ�
extern void MakeSinTable(int sintablesenv);
extern double ESin(int angle);
extern double ECos(int angle);
extern int GetSinTableSenv();

//�������ǂ�
typedef struct MYRND_PARAM_tag MYRND_PARAM ;
struct MYRND_PARAM_tag
{
	unsigned int rndtable[33] ;
	int rndptr;
	unsigned char *Pex_rnd ;
};
extern unsigned int mrnd();//0�`0xFFFFFFFF�܂ł̐�����Ԃ�
extern double dmrnd();//[0,1)�̏�����Ԃ�
extern void smrnd( int seed , unsigned char *Pes=NULL );//�K���ȃV�[�h�Ɓw�O���x�ւ̃|�C���^�iNULL�j������
extern unsigned int mrnd(MYRND_PARAM *Pmrp);//0�`0xFFFFFFFF�܂ł̐�����Ԃ�
extern double dmrnd(MYRND_PARAM *Pmrp);//[0,1)�̏�����Ԃ�
extern void smrnd( MYRND_PARAM *Pmrp , int seed , unsigned char *Pes=NULL );//�K���ȃV�[�h�Ɓw�O���x�ւ̃|�C���^�iNULL�j������
extern unsigned int EHash( unsigned char *Pd , int length ) ;//���Ȃ�e�L�g�[�ȂQ�S�r�b�g�n�b�V���i�H�j�l�쐬



//////////////
//�e���v���[�g
//////////////

//�������ێ������܂܁A��Βl�𑫂������������c�c
//overrun==false���ƁA�������Ƃ����_��ʂ�߂����Ƃ��A�O�Ŏ~�܂�
template <class mtp> void AbsPlus(mtp* dest , mtp value , bool overrun=true)
{
	if(*dest > 0)
	{
		*dest += value;
		if(!overrun && *dest < 0)*dest = 0;
	}
	else if(*dest < 0)
	{
		*dest -= value;
		if(!overrun && *dest > 0)*dest = 0;
	}
}
//������Ԃ�
template <class mtp> int sign( mtp dest )
{
	if( dest>=0 )return 1 ;
	return -1 ;
}
//�킩��₷����������֐�
template <class mtp> void MYSWAP(mtp* v1 , mtp* v2)
{
mtp tmp;
	tmp = *v1;
	*v1  = *v2;
	*v2  = tmp;
}

//dest��[lo,hi]���ɕ␳����
template <class mtp> void DurCorrect(mtp* dest , mtp valuelo , mtp valuehi )
{
	if( *dest < valuelo ) *dest = valuelo ;
	if( *dest > valuehi ) *dest = valuehi ;
}

//�������A�O�`value-1���ɕ␳����B
//-1��������Avalue-1�ɂȂ�B
template <class mtp> void RotateCorrect(mtp* dest , mtp value )
{
	*dest = (((*dest)%value)+value)%value;
}

//���ł̋����������̏��Z�Ə����قȂ鐮�����Z
//����������K�i������Ă������Ƃ��A���_�t�߂��L���Ȃ�Ȃ��悤�ɂȂ��Ă���
template <class mtp> mtp GaussDivision(mtp dest , mtp value )
{
	if( dest >= 0 )return dest/value;
	dest = -dest-1;
	return -(dest/value)-1 ;
}

////////
//�}�N��
////////

//�킩��₷����Βl��Ԃ�
#define		MYABS(num)			( (num)<0 ? -(num) : (num) )
//�l���X�V�ł�����true��Ԃ�
#define		VAR_LET(dest,num)	( (dest)==(num) ? false : ((dest)=(num),true) )


#endif /*NNSYS_HEADER_INCLUDED*/