#ifndef MYDIBOBJ3_HEADER_INCLUDED
#define MYDIBOBJ3_HEADER_INCLUDED

#include <tchar.h>

/*
	���낢��j�]�����A�\�t�g�E�F�A�����_�����O���[�`���B
	�f�o�C�X�Ɨ��r�b�g�}�b�v���擾���āA�����Ƀ����_�����O�B
	�ėp��������������A�����B
*/


#define		RGB_BITS	5
#define		myRGB(r,g,b)		( ( (r)<<(RGB_BITS*2)) | ( (g) << RGB_BITS) | (b))
#define		RGB_MAX		((1<<RGB_BITS) - 1)
#define		MDO3DefaultColorKey	myRGB(RGB_MAX,0,RGB_MAX)

//�[�x���w��ł������Ȃ����ɁA���̒l���w�肷��ƃG���[�ɂȂ�d�l�O�O
#if			RGB_BITS==5
typedef		WORD		BMPD;
#else
#error		
#endif

//�`��ɍۂ���t���O
typedef		DWORD		MDOFLAG;


//*******************************************
//�`��t���O
//*******************************************
//��{�I�A�P�Ɛ�����������
#define		MDO3F_COLORKEY			0x00000001		//�J���[�L�[�𔲂���
#define		MDO3F_CLIP				0x00000002		//�N���b�v���邩
#define		MDO3F_SFCLOOP			0x00000004		//sfc�T�C�h���[�v���邩
#define		MDO3F_SRCLOOP			0x00000008		//src�T�C�h���[�v���邩
#define		MDO3F_USE_WINAPI		0x00000010		//����BitBlt()�����ĂԂ�
//�\�[�X�T�C�h�։e������������
#define		MDO3F_USE_OTHER_COLORKEY	0x00000020		//����sfc�̃J���[�L�[���g�����i�������j
#define		MDO3F_OR_OPERATE		0x00000040		//or���Z�������̂��������邩
#define		MDO3F_AND_OPERATE		0x00000080		//and���Z�������̂��������邩
#define		MDO3F_SIMPLE_COLOR		0x00000100		//�P�F�h������邩
#define		MDO3F_USE_COLOR_TABLE	0x00000200		//�J���[�e�[�u�����g����
#define		MDO3F_BRIGHT_CHANGE		0x00000400		//���邳��ύX���邩�i�������j
#define		MDO3F_X_MIRROR			0x00000800		//�����]
#define		MDO3F_Y_MIRROR			0x00001000		//�c���]
//�������n
#define		MDO3F_BLEND				0x00002000		//�u�����h���邩
#define		MDO3F_LIGHT_BLEND		0x00004000		//���Z�������邩
#define		MDO3F_DARK_BLEND		0x00008000		//���Z�������邩
#define		MDO3F_OR_BLEND			0x00010000		//or�u�����h���邩
#define		MDO3F_AND_BLEND			0x00020000		//and�u�����h���邩

#define		MDO3F_NONE				0x00000000
#define		MDO3F_ALL				0xFFFFFFFF


//�`��t���O�ƁA�e�푮�������߂�\����
typedef struct MDO3Opt_tag
{
	MDOFLAG flag;
	BYTE alpha;
	union
	{
		DWORD	DW;			//��ԏ�ɒu���Ă�������
		int		i;
		BMPD	B;
		int*	Pi;
		BMPD*	PBMPD;
	};
}MDO3Opt;

//������́A�f�t�H���g�̕`�摮���Ƃ��āA�����Ɏw�肵���肷��
extern MDO3Opt *MDO3normal;
extern MDO3Opt *MDO3WINAPI;

//�H����̓v���C�x�[�g��include�t�@�C���ł����悤�ȁc�c�H
//�T�[�t�F�C�X�\����
struct MDO3Surface{
	int width;			//��
	int width_true;		//�{���̕��i���͂Q�̏搔�̕����������Ɋm�ۂ���̂Łj
	int height;			//����
	int clipx;			//�N���b�p�[�w���W
	int clipy;			//�N���b�p�[�x���W
	int clipwidth;		//�N���b�p�[��
	int clipheight;		//�N���b�p�[����
	BMPD *data;			//���ꂪ���ۂ̃r�b�g�}�b�v�C���[�W�c�c
	HBITMAP hbitmap;	//��
	BITMAPINFO info;	//��
	HDC hdc;			//��
	HBITMAP holdbitmap;	//�񂠂�܂�o���ĂȂ���c�c
	BYTE width_bits;	//�������r�b�g�ŕ\����邩
};

//�t���b�v�̂�����
//�t���b�v���Ďg�����ԈႦ�Ă邩���c�c
//�o�b�N�T�[�t�F�[�X���v���C�}���[�T�[�t�F�C�X�ɓ]������c�c���ĈӖ��Ŏg���Ă��ł����B
#define		MDO3FT_NORMAL		0x00
#define		MDO3FT_POS			0x01
#define		MDO3FT_STRETCH		0x02


//�{�̃N���X
class MyDIBObj3{
private:
	int maxsurface;			//�T�[�t�F�C�X�ő吔
	int primarywidth;		//�v���C�}���[�T�[�t�F�[�X�̕�
	int primaryheight;		//������
	HDC hdcp;				//�ΏۃE�C���h�E�̃f�o�C�X�R���e�L�X�g�n���h��
	HWND hwndp;				//�ΏۃE�C���h�E�̃E�C���h�E�n���h��
	HINSTANCE hinstancep;	//�ΏۃA�v���P�[�V�����̃C���X�^���X�n���h��
	BMPD colorkey;			//�J���[�L�[
protected:

	MDO3Surface *sfc;		//�T�[�t�F�C�X�ւ̃|�C���^�Bmaxsurface�������m�ۂ����

	//�T�[�t�F�C�X�ɃG���[���������𒲂ׂ�
	inline bool SFCCheck(int num);
	//�N���b�s���O�p
	inline bool Clipping(  const MDO3Opt *opt , bool srcadjust , int *Px , int *Py , int *Pw , int *Ph , int *Psx , int *Psy , int sx , int sy , int sw , int sh );
	//�\�[�X����͂ݏo�Ȃ��悤�ɃN���b�v
	inline bool ReverseClipping( int srcx , int srcy , int width , int height , int src );
	//�HWINAPI��cls���ĂԂ��߂̊֐��H
	void EXCls(int isfc,int x,int y,int width,int height,BMPD color);

	//����`�悷�邽�߂̊֐��́A����������
	inline void Line_sub1( bool isXY , double sloped , const MDO3Opt *opt , int isfc , double a1d , double b1d , double a2d , double b2d , BMPD color );
	inline void Line_sub2( bool isXY , double sloped , const MDO3Opt *opt , int isfc , double a1d , double b1d , double a2d , double b2d , BMPD color );
public:
	//�R���X�g���N�^�ɂ́A�ő�T�[�t�F�C�X�A�o�b�N�T�[�t�F�C�X�̕��A�����A�J���[�L�[���w�肷��
	//�T�[�t�F�C�X�́Anosfc+1�����B
	//�O�Ԃ̃T�[�t�F�C�X���A�o�b�N�T�[�t�F�C�X�ŁAnosfc�Ԃ܂Ŏg�����Ƃ��o����B
	MyDIBObj3(int nosfc,int width,int height,BMPD icolorkey=MDO3DefaultColorKey);
	//�Ȃ��������Ȃ��Ă��A����ɗ����Ă������悤�ȍ\���������Ǝv�����c�c
	~MyDIBObj3();

	//�������B�ΏۃE�C���h�E�̃n���h���ƁA�ΏۃA�v���P�[�V�����̃C���X�^���X�n���h����n��
	void Initialize(HWND hwndpval,HINSTANCE hinstanceval);
	//�T�[�t�F�C�X���쐬
	void CreateSurface(int isfc,int width,int height);
	//�T�[�t�F�C�X�����
	void ReleaseSurface(int isfc);
	//�e�����B�f�X�g���N�^������Ă΂�܂����c�c
	void Release();
	//�r�b�g�}�b�v��ǂݍ���
	void LoadBitmapFile(int isfc,LPCTSTR filename);
	//�r�b�g�}�b�v�ɏ����o���@�Q�S�r�b�g�J���[����
	void SaveBitmapFile( LPCTSTR filename , int isfc , int x=-1 , int y=-1 , int width=-1 , int height=-1 ) ;
	//�T�[�t�F�C�X�̃f�o�C�X�R���e�L�X�g�n���h�����擾
	HDC GetHDC(int isfc);
	//�J���[�L�[���Z�b�g
	void SetColorKey(BMPD icolorkey=MDO3DefaultColorKey);
	//�T�[�t�F�C�X�ɃN���b�p�[���Z�b�g
	void SetClipper( int isfc , int ix , int iy , int iw , int ih );
	//�T�[�t�F�C�X�̃N���b�p�[���擾
	void GetClipper( int isfc , int *pix , int *piy , int *piw , int *pih );
	//�o�b�N�T�[�t�F�C�X�̓��e���A�v���C�}���[�T�[�t�F�C�X�ɓ]��
	void Flip( int fliptype=MDO3FT_NORMAL , int* argv = NULL );
	//�r�b�g�}�b�v�ւ̃|�C���^���擾����
	BMPD *GetSurfacePointer(int isfc);
	//�w��ʒu�̐F���擾�B��{�I�ɂ͎g��Ȃ�����y
	BMPD Pick( int isfc , int x , int y ) ;

	//����{
	//��`�h��Ԃ�
	void Cls(const MDO3Opt *opt,int isfc,int x,int y,int width,int height,BMPD color);
	//��`�]��
	void Blt(const MDO3Opt *opt,int isfc,int x,int y,int width,int height,int isrc,int srcx,int srcy);
	//�e�L�X�g�`��
	void Text(int isfc,LPCTSTR str,int x,int y,int height=12,int width=6,UINT color=0);
	void TextEX(int isfc,LPCTSTR str,int x,int y,HFONT hfont,UINT color=0);
	SIZE TestText(int isfc,LPCTSTR str,int height=12,int width=6);
	SIZE TestTextEX(int isfc,LPCTSTR str,HFONT hfont);

	//���}�`�`��
	//����`��
	void Line(const MDO3Opt *opt,int isfc,double x1,double y1,double x2,double y2,BMPD color);
	//�O�p�`�`��
	void Triangle( const MDO3Opt *opt , int isfc , double x0 , double y0 , double x1 , double y1 , double x2 , double y2 , BMPD color );
	//�\��H
//	void Circle(const drawoption *opt,int isfc,int cx,int cy,int radius,BMPD color);

	//�����Ɖ��p
	//�X�g���b�`�]��
	void SBlt(const MDO3Opt *opt,int isfc,int x,int y,int width,int height,int isrc,int srcx,int srcy,int srcwidth , int srcheight);
	//��]�`��\��H
//	void rollblt(const drawoption *opt,int isfc,int x,int y,int width,int height,int isrc,int srcx,int srcy,double angle);
//	void brightchange(int isfc,int x,int y,int width,int height,int brightness);

	//���[���R�c�֘A
	//�O�p�`�ό`���ē]���B��Ԃꂩ�Ԃꌇ�ׂ��炯�B���������񂶂�Ȃ�
	//�c�c�A���H������Ǝv������Ȃ���������c�c
//	void Pory(const MDO3Opt *opt,int isfc,int isrc,
//		double x0,double y0,double x1,double y1,double x2,double y2,
//		double u0,double v0,double u1,double v1,double u2,double v2);

	
	
//�⏕�I�Ȋ֐�(�����̊֐��̑g�ݍ��킹)
	//����\��
	void Box(const MDO3Opt *opt,int isfc,int x1,int y1,int x2,int y2,BMPD color)
	{
		if(x1 > x2)
		{
			Box(opt , isfc , x2 , y1 , x1 , y2 , color );
			return;
		}
		if(y1 > y2)
		{
			Box(opt , isfc , x1 , y2 , x2 , y1 , color );
			return;
		}
		Cls( opt , isfc , x1 , y1 , x2-x1 , 1     , color );
		Cls( opt , isfc , x2 , y1 , 1     , y2-y1+1 , color );
		Cls( opt , isfc , x1 , y2 , x2-x1 , 1     , color );
		Cls( opt , isfc , x1 , y1 , 1     , y2-y1 , color );
	};
	//������Hex���ꌅ�\��
	void SmallHex4( int iSfc , int x , int y , int iVal , BMPD c )
	{
		if( iVal == 0 ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 5 , c ) ; // |
			Cls( MDO3WINAPI , iSfc , x+2 , y+0 , 1 , 5 , c ) ; //  |
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 1 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+1 , y+4 , 1 , 1 , c ) ; // __
		}else if( iVal == 1 ){
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 1 , 5 , c ) ;
		}else if( iVal == 2 ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+2 , 1 , 3 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+2 , y+0 , 1 , 3 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 2 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+1 , y+4 , 2 , 1 , c ) ; // __
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 1 , 1 , c ) ; // --
		}else if( iVal == 3 ){
			Cls( MDO3WINAPI , iSfc , x+2 , y+0 , 1 , 5 , c ) ; //  |
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 2 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+0 , y+4 , 2 , 1 , c ) ; // __
			Cls( MDO3WINAPI , iSfc , x+0 , y+2 , 2 , 1 , c ) ; // --
		}else if( iVal == 4 ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 3 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+2 , y+0 , 1 , 5 , c ) ; //  |
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 1 , 1 , c ) ; // --
		}else if( iVal == 5 ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 3 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+2 , y+2 , 1 , 3 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 2 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+0 , y+4 , 2 , 1 , c ) ; // __
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 1 , 1 , c ) ; // --
		}else if( iVal == 6 ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 5 , c ) ; // |
			Cls( MDO3WINAPI , iSfc , x+2 , y+2 , 1 , 3 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 2 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+1 , y+4 , 1 , 1 , c ) ; // __
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 1 , 1 , c ) ; // --
		}else if( iVal == 7 ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 3 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+2 , y+0 , 1 , 5 , c ) ; //  |
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 1 , 1 , c ) ; // ~~
		}else if( iVal == 8 ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 5 , c ) ; // |
			Cls( MDO3WINAPI , iSfc , x+2 , y+0 , 1 , 5 , c ) ; //  |
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 1 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+1 , y+4 , 1 , 1 , c ) ; // __
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 1 , 1 , c ) ; // --
		}else if( iVal == 9 ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 3 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+2 , y+0 , 1 , 5 , c ) ; //  |
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 1 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+0 , y+4 , 2 , 1 , c ) ; // __
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 1 , 1 , c ) ; // --
		}else if( iVal == 0xA ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 5 , c ) ; // |
			Cls( MDO3WINAPI , iSfc , x+2 , y+0 , 1 , 5 , c ) ; //  |
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 1 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 1 , 1 , c ) ; // --
		}else if( iVal == 0xB ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 5 , c ) ; // |
			Cls( MDO3WINAPI , iSfc , x+2 , y+1 , 1 , 1 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+2 , y+3 , 1 , 2 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 1 , 1 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+1 , y+4 , 1 , 1 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 1 , 1 , c ) ;
		}else if( iVal == 0xC ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 5 , c ) ; // |
			Cls( MDO3WINAPI , iSfc , x+2 , y+0 , 1 , 2 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+2 , y+3 , 1 , 2 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 1 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+1 , y+4 , 1 , 1 , c ) ; // __
		}else if( iVal == 0xD ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 5 , c ) ; // |
			Cls( MDO3WINAPI , iSfc , x+2 , y+1 , 1 , 4 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 1 , 1 , c ) ;
			Cls( MDO3WINAPI , iSfc , x+1 , y+4 , 1 , 1 , c ) ; // __
		}else if( iVal == 0xE ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 5 , c ) ; // |
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 2 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+1 , y+4 , 2 , 1 , c ) ; // __
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 1 , 1 , c ) ; // --
		}else if( iVal == 0xF ){
			Cls( MDO3WINAPI , iSfc , x+0 , y+0 , 1 , 5 , c ) ; // |
			Cls( MDO3WINAPI , iSfc , x+1 , y+0 , 2 , 1 , c ) ; // ~~
			Cls( MDO3WINAPI , iSfc , x+1 , y+2 , 2 , 1 , c ) ; // --
		}
	}
	void SmallHex8( int iSfc , int x , int y , int iVal , BMPD c )
	{
		SmallHex4( iSfc , x+0 , y , iVal/16%16 , c ) ;
		SmallHex4( iSfc , x+4 , y , iVal   %16 , c ) ;
	}
	void SmallHex16( int iSfc , int x , int y , int iVal , BMPD c )
	{
		SmallHex8( iSfc , x+0 , y , iVal/256%256 , c ) ;
		SmallHex8( iSfc , x+8 , y , iVal    %256 , c ) ;
	}
	void SmallHex24( int iSfc , int x , int y , int iVal , BMPD c )
	{
		SmallHex8( iSfc , x+0  , y , iVal/65536%256 , c ) ;
		SmallHex8( iSfc , x+8  , y , iVal/256  %256 , c ) ;
		SmallHex8( iSfc , x+16 , y , iVal      %256 , c ) ;
	}
	void SmallHex32( int iSfc , int x , int y , unsigned int iVal , BMPD c )
	{
		SmallHex16( iSfc , x+0  , y , iVal/65536%65536 , c ) ;
		SmallHex16( iSfc , x+16 , y , iVal      %65536 , c ) ;
	}
	void KageMoji( int sfc , LPCTSTR str , int x , int y , int h , int w , UINT c1=0xFFFFFFFF , UINT c2=0xFFFFFFFF )
	{
		if( c1==0xFFFFFFFF ){ c1=RGB(255,255,255); }
		if( c2==0xFFFFFFFF ){ c2=RGB(  0,  0,  0); }
		Text( sfc , str , x+1 , y+1 , h , w , c2 ) ;
		Text( sfc , str , x   , y   , h , w , c1 ) ;
	};
	void BoxMoji( int sfc , LPCTSTR str , int x , int y , int h , int w , UINT c1=0xFFFFFFFF , UINT c2=0xFFFFFFFF )
	{
		if( c1==0xFFFFFFFF ){ c1=RGB(255,255,255); }
		if( c2==0xFFFFFFFF ){ c2=(c1>>2)&0x3F3F3F; }
		Text( sfc , str , x-1 , y   , h , w , c2 ) ;
		Text( sfc , str , x+1 , y   , h , w , c2 ) ;
		Text( sfc , str , x   , y-1 , h , w , c2 ) ;
		Text( sfc , str , x   , y+1 , h , w , c2 ) ;
		Text( sfc , str , x   , y   , h , w , c1 ) ;
	};
};


#endif /*MYDIBOBJ3_HEADER_INCLUDED*/