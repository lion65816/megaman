#include <windows.h>
#include <stdio.h>
#include "myDIBobj3.h"
#include "myDIBobj3_p.h"

//�f�t�H���g�c�c�ł͂Ȃ����A�Ƃ��ɕ`��ɓ���ȕ����w�肵�Ȃ��Ƃ����O��ł́A
//�`��֐��ɓn���A�`�摮���|�C���^

static MDO3Opt MDO3normal_body = { MDO3F_COLORKEY | MDO3F_CLIP , 0xFF , 0 };
MDO3Opt *MDO3normal = &MDO3normal_body;
static MDO3Opt MDO3WINAPI_body = { MDO3F_COLORKEY | MDO3F_CLIP | MDO3F_USE_WINAPI , 0xFF , SRCCOPY };
MDO3Opt *MDO3WINAPI = &MDO3WINAPI_body;
BMPD *PAlphaTable=NULL;

//�������e�[�u�����A����Q�Ƃ���Ă��邩
//�����Ƃ��A���̃N���X���Q�ȏ�g���A�v���P�[�V�������Ă��肦��񂾂낤��
static int NOAlphaTableReferenced=0;

//�T�[�t�F�C�X��HDC��Ԃ��B
//���Ă������A����͍P��I�ɕێ����Ă��Ă������̂Ȃ̂��낤���c�c
HDC MyDIBObj3 ::GetHDC(int isfc)
{
	if(!SFCCheck(isfc))return NULL;
	return sfc[isfc].hdc;
}

//�J���[�L�[���Z�b�g����
void MyDIBObj3 ::SetColorKey(BMPD icolorkey)
{
	colorkey = icolorkey;
}

//�T�[�t�F�C�X�ɃN���b�p�[���Z�b�g�B
//�Z�b�g���ɁA�ςȒl���w�肳��Ă��Ȃ������`�F�b�N�B
//����Ƃ͕ʂɁA(x0,y0)-(x1,y1)�^�C�v��������ق��������C�����Ȃ��ł��Ȃ��B

void MyDIBObj3 ::SetClipper( int isfc , int ix , int iy , int iw , int ih )
{
	if(!SFCCheck(isfc))return;
	//�N���b�p�[�̃N���b�s���O
	if( ix < 0 ){ iw += ix ; ix = 0 ;}
	if( iy < 0 ){ ih += iy ; iy = 0 ;}
	if( iw < 0 || ih < 0 )
	{
		ix = iy = iw = ih  = 0;
		return;
	}
	if( ix+iw > sfc[isfc].width_true )
	{
		iw = sfc[isfc].width_true-ix;
	}
	if( iy+ih > sfc[isfc].height )
	{
		ih = sfc[isfc].height-iy;
	}
	sfc[isfc].clipx = ix ;
	sfc[isfc].clipy = iy ;
	sfc[isfc].clipwidth = iw;
	sfc[isfc].clipheight = ih;
}

//�N���b�p�[�̒l���擾����
void MyDIBObj3 ::GetClipper( int isfc , int *pix , int *piy , int *piw , int *pih )
{
	if(!SFCCheck(isfc))return;
	if( pix ){ *pix = sfc[isfc].clipx ; }
	if( piy ){ *piy = sfc[isfc].clipy ; }
	if( piw ){ *piw = sfc[isfc].clipwidth ; }
	if( pih ){ *pih = sfc[isfc].clipheight ; }
}
/*
�T�[�t�F�C�X����A�r�b�g�}�b�v�ւ̃|�C���^���擾�B
����𗘗p���āA�A�v���P�[�V�������ŃO���O���������邱�Ƃ��o����킯�B
�c�c�����Ƃ��A�I�[�o�[���C�h����΂����̂ł́A�Ƃ����b�����邯�ǂˁB
*/
BMPD *MyDIBObj3 :: GetSurfacePointer(int isfc){
	if(!SFCCheck(isfc))return NULL;
	return sfc[isfc].data;
}

//�F���擾
BMPD MyDIBObj3 :: Pick( int isfc , int x , int y )
{
	if(!SFCCheck(isfc))return 0xFFFF ;
	if( x<0 || y<0 ||
		x>sfc[isfc].width_true || y>sfc[isfc].height )return 0xFFFF ;
	return sfc[isfc].data[(y<<sfc[isfc].width_bits)|x] ;
}

/*
�R���X�g���N�^�B
�T�[�t�F�C�X���@�@�o�b�N�T�[�t�F�C�X���@�@�����@�@�J���[�L�[
��n���B
���s����ƁAsfc��NULL�ɂȂ��Ă���B
���̏�Ԃł́A���̂����Ȃ�֐����A�����Ȃ��������Ȃ��c�c�͂��B
���̂ق��̊֐��ɂ��Ă��A���s���Ă��A�����Ȃ��������Ȃ��c�c�Ƃ����̂𗝑z�Ƃ��Ă���B
�����܂ŗ��z�ŁA�֐��Ƀ}�Y�C�l��H�ׂ�����Ƃ������莀�񂾂肷�邯�ǁB
���łɁA�����������Ɏg���e�[�u�����쐬�B
*/
MyDIBObj3 :: MyDIBObj3(int nosfc,int width,int height,BMPD icolorkey)
{
	nosfc ++ ;
	maxsurface = nosfc ;
	primarywidth  = width;
	primaryheight = height;
	colorkey = icolorkey;
	sfc = (MDO3Surface*)GlobalAlloc( GMEM_FIXED , sizeof(MDO3Surface)*nosfc );
	if( sfc )
	{
		for( int i=0 ; i<nosfc ; i++ )
		{
			sfc[i].data = NULL;
		}
		SetColorKey( icolorkey ) ;
	}
	if(!PAlphaTable)
	{
		NOAlphaTableReferenced = 1;
		// 2 x 8000h * 16 * 2 = 2 x 2^15 x 2^4 * 2 = 2^21 = (2^10)^2*2^1 = 2M�I
		//�e�[�u�����g���A�t�ɑ��x�����̌����ɂȂ�ƒ��������c�c
		//l�́A�r�b�g�}�b�v�̍ŏ�ʃr�b�g���s��Ȃ��ߕK�v
		//�؎̂Ċ���Z�Ȃ��߁A�኱�Â��Ȃ邪�A�����m�i�H�j�𑫂��Z���Ĉ��S
		PAlphaTable = (BMPD*)GlobalAlloc( GMEM_FIXED , sizeof(BMPD)*0x8000*16*2 );
		for( int a=0 ; a<16 ; a++ )
		for( int l=0 ; l<2  ; l++ )
		for( int r=0 ; r<32 ; r++ )
		for( int g=0 ; g<32 ; g++ )
		for( int b=0 ; b<32 ; b++ )
		{
			PAlphaTable[(a<<16)|(l<<15)|(r<<10)|(g<<5)|b] = 
				((r*a/15)<<10)|((g*a/15)<<5)|(b*a/15);
		}
	}
}
/*
�f�X�g���N�^�B
�Ȃ��������Ȃ��Ă��A���ꂾ���ő��v�Ȏd�l�B
*/
MyDIBObj3 :: ~MyDIBObj3()
{
	Release();
	NOAlphaTableReferenced --;
	if(!NOAlphaTableReferenced)
	{
		PAlphaTable = (BMPD*)GlobalFree( PAlphaTable );
	}
}

/*
�������B
�Ώۂ̃E�C���h�E�n���h���ƁA�C���X�^���X�n���h����n��
���łɁA�o�b�N�T�[�t�F�C�X���쐬����B
*/
void MyDIBObj3 :: Initialize(HWND hwndpval,HINSTANCE hinstanceval)
{
	if(!sfc)return;
	hwndp = hwndpval;
	hinstancep = hinstanceval;
	hdcp = GetDC( hwndp );
	CreateSurface( 0 , primarywidth , primaryheight );
}

/*
�T�[�t�F�C�X���쐬����B
����Ȋ֐��Ȃ̂ɁA���s���Ă������Ԃ��Ȃ��̂͂ǂ��Ȃ̂�H
�쐬���s�����T�[�t�F�C�X���g���Ă��A�����Ȃ����Ǔ����Ȃ��c�c�Ƃ����d�l�炵��
*/
void MyDIBObj3 :: CreateSurface(int isfc,int width,int height)
{
	if(!sfc)return;
	if( isfc < 0 || isfc >= maxsurface ) return ;
	if( isfc != 0 && !sfc[0].data ) return;
	if( sfc[isfc].data ) return;
	if( width <= 0 || height <= 0 ) return;

	sfc[isfc].clipx = 0;
	sfc[isfc].clipy = 0;
	sfc[isfc].clipwidth  = width ;
	sfc[isfc].clipheight = height ;
	sfc[isfc].width_true = width;
	{
int tmp,i;
		tmp = 1;
		for( i=0 ; i<20 ; i++ )
		{
			if( width <= tmp )break;
			tmp <<= 1;
		}
		width = 1<<i;
	sfc[isfc].width_bits = i;
	}
	sfc[isfc].width  = width;
	sfc[isfc].height = height;

BITMAPINFOHEADER *pbh;
	pbh = &sfc[isfc].info.bmiHeader;
	pbh->biSize=sizeof(BITMAPINFOHEADER);
	pbh->biWidth=width;
	pbh->biHeight=-height;						//�s�œV�n���Ȃ�
	pbh->biPlanes=1;
	pbh->biBitCount=16;	
	pbh->biCompression=BI_RGB;
	pbh->biSizeImage=0;
	pbh->biXPelsPerMeter=0;
	pbh->biYPelsPerMeter=0;
	pbh->biClrUsed=0;
	pbh->biClrImportant=0;

	sfc[isfc].hbitmap = CreateDIBSection(
		hdcp,
		&(sfc[isfc].info),
		DIB_RGB_COLORS,
		(void **)&(sfc[isfc].data),
		NULL,
		NULL);

	if( sfc[isfc].hbitmap==0 || !sfc[isfc].data )
	{
		if(sfc[isfc].hbitmap != 0)DeleteObject(sfc[isfc].hbitmap);
		sfc[isfc].data = NULL;
		DEBUG_OUTPUT(_T("makesurface() DIB�̏����Ɏ��s�I\n"));
		return;
	}

	sfc[isfc].hdc = CreateCompatibleDC(hdcp);
	if(sfc[isfc].hdc == NULL)
	{
		DeleteObject(sfc[isfc].hbitmap);
		sfc[isfc].data = NULL;
		DEBUG_OUTPUT(_T("makesurface() HDC�̏����Ɏ��s�I\n"));
		return;
	}
	sfc[isfc].holdbitmap = (HBITMAP)SelectObject(sfc[isfc].hdc,sfc[isfc].hbitmap);
	if(sfc[isfc].holdbitmap == NULL)
	{
		DeleteObject(sfc[isfc].hbitmap);
		sfc[isfc].data = NULL;
		DEBUG_OUTPUT(_T("makesurface() �r�b�g�}�b�v���t���Ɏ��s�I\n"));
	}
}

/*
�T�[�t�F�C�X���������B
���ʎ����ł͌ĂԕK�v���������A�T�[�t�F�C�X��������������č�蒼�������ꍇ�ȂǁB
*/
void MyDIBObj3 :: ReleaseSurface(int isfc)
{
	if( isfc < 0 || isfc >= maxsurface )return;
	if( sfc[isfc].data )
	{
		SelectObject(sfc[isfc].hdc,sfc[isfc].holdbitmap);
		DeleteObject(sfc[isfc].hbitmap);
		DeleteDC(sfc[isfc].hdc);
		sfc[isfc].data = NULL;
	}
}
/*
����B�f�X�g���N�^���ĂԂ̂ŁA�ʂɎ����ŌĂԕK�v�͖����B
*/
void MyDIBObj3 :: Release()
{
	if(sfc)
	{
		if(sfc[0].data)
			ReleaseDC( hwndp , hdcp );
		for( int i=0 ; i<maxsurface ; i++ )
			ReleaseSurface(i);
		SafeGF(sfc);
	}
}
/*
	�r�b�g�}�b�v�̃��[�h�B
*/
void MyDIBObj3 :: LoadBitmapFile(int isfc,LPCTSTR filename)
{
	if(!SFCCheck(isfc))return;
	//�ꎞ��Ɨp��HDC��BITMAP�n���h��
	HDC mem1;
	HBITMAP hbm,old;
	//�r�b�g�}�b�v��ǂݍ���
	hbm = (HBITMAP)LoadImage(hinstancep,filename,IMAGE_BITMAP,0,0,LR_LOADFROMFILE);
	if(hbm == 0)
	{
		DEBUG_OUTPUT(_T("�r�b�g�}�b�v�̓ǂ݂��݂Ɏ��s�I\n"));
		return;
	}
	//�E�C���h�E�̂g�c�b�ƌ������̂��郁�����c�b�����
	mem1 = CreateCompatibleDC(hdcp);
	//�Z�b�g����
	old = (HBITMAP)SelectObject(mem1,hbm);
	//�]��
	BitBlt(sfc[isfc].hdc,0,0,sfc[isfc].width,sfc[isfc].height,mem1,0,0,SRCCOPY);
	//�S������
	SelectObject(mem1,old);
	DeleteDC(mem1);
	DeleteObject(hbm);
}
/*
	�r�b�g�}�b�v�̃Z�[�u
	�Q�S�r�b�gbmp���o��
	x�ȍ~�̈�����S��-1�ɂ���ƁA�T�[�t�F�C�X�S�̂��o�͂���
*/
void MyDIBObj3 :: SaveBitmapFile( LPCTSTR filename , int isfc , int x , int y , int width , int height )
{
	if(!SFCCheck(isfc))return;
	if( x==-1 && y==-1 && width==-1 && height==-1 )
	{
		x = y = 0 ;
		width = sfc[isfc].width_true ;
		height = sfc[isfc].height ;
	}
	if( x<0 || y<0 || width<=0 || height<=0 ||
		x+width>sfc[isfc].width_true || y+height>sfc[isfc].height )return ;
int WIDTH ;
	WIDTH = (width+3)/4*4 ;
FILE *fp ;
	if( _tfopen_s( &fp , filename , _T("wb") ) )return ;
BYTE buf[256] ;
int  tmp ;
	buf[0] = 'B' ;
	buf[1] = 'M' ;
	fwrite( buf , 1 , 2 , fp ) ;
	tmp = 0x36 + ( width*3 + (4-width*3%4)%4 ) * height ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	tmp = 0x00000000 ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	tmp = 0x00000036 ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	tmp = 0x00000028 ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	tmp = width ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	tmp = height ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	tmp = 1 ;
	fwrite( &tmp , 2 , 1 , fp ) ;
	tmp = 24 ;
	fwrite( &tmp , 2 , 1 , fp ) ;
	tmp = 0 ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	tmp = ( width*3 + (4-width*3%4)%4 ) * height ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	tmp = 0 ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	fwrite( &tmp , 4 , 1 , fp ) ;
	fwrite( &tmp , 4 , 1 , fp ) ;


	for( int iy=height-1 ; iy>=0 ; iy-- )
	{
		BMPD *Pbmp ;
		Pbmp = &sfc[isfc].data[((iy+y)<<sfc[isfc].width_bits)] ;
		int ix ;
		int iWriteSize = 0 ;
		for( ix=0 ; ix<width ; ix++ )
		{
			BMPD dot ;
			dot = Pbmp[ix+x] ;
			BYTE r,g,b ;
//			r = ( dot >>10 ) & 0x1F ;
//			g = ( dot >>5  ) & 0x1F ;
//			b = ( dot      ) & 0x1F ;
			r = ( dot >>7  ) & 0xF8 ;
			g = ( dot >>2  ) & 0xF8 ;
			b = ( dot <<3  ) & 0xF8 ;
			fwrite( &b , 1 , 1 , fp ) ;
			fwrite( &g , 1 , 1 , fp ) ;
			fwrite( &r , 1 , 1 , fp ) ;
			iWriteSize += 3 ;
		}
		for( ; (iWriteSize&3)!=0 ; iWriteSize++ )
		{
			BYTE dummy=0x00 ;
			fwrite( &dummy , 1 , 1 , fp ) ;
		}
	}
	fclose( fp ) ;
}

/*
	�o�b�N�T�[�t�F�C�X���v���C�}���[�T�[�t�F�C�X�ɓ]�����ĉ�ʂɕ\������B
	�c�c���͂����ł߂���d�ɂȂ��Ă�̂�ˁB
	��ʂ��R�Q�r�b�g�ɐݒ肵�Ă���ƁA�ǂ����ABitBlt��16bit->32bit�]�������Ȃ�d���݂����Łc�c
	��ʂ��P�U�r�b�g�ɂ��Ă���Ƒ����Ȃ��ł����ˁc�c
	�Ƃ���ŁA�t���b�v�̈Ӗ����ԈႦ�Ă���悤�ȁB
	�����ɂ́A�t���b�v�̃^�C�v�ƁA���ƁA�^�C�v�ɂ�鑮����n���B
	�ǂ�ȑ������́A��������΂����킩�邩�ƁB
*/
void MyDIBObj3 :: Flip( int fliptype , int* argv )
{
	if(!SFCCheck( 0 ))return;
	int iWidth , iHeight ;
	iWidth  = sfc[0].width_true ;
	iHeight = sfc[0].height ;

	switch( fliptype )
	{
	case 0:
		BitBlt(hdcp,0,0,iWidth,iHeight,sfc[0].hdc,0,0,SRCCOPY);
	break;
	case 1:
		BitBlt(hdcp,argv[0],argv[1],iWidth,iHeight,sfc[0].hdc,0,0,SRCCOPY);
	break;
	case 2:
		StretchBlt(hdcp,0,0,argv[0],argv[1],sfc[0].hdc,0,0,iWidth,iHeight,SRCCOPY);
	break;
	case 3:
		StretchBlt(hdcp,argv[0],argv[1],argv[2],argv[3],sfc[0].hdc,0,0,iWidth,iHeight,SRCCOPY);
	break;
	default:
		__assume(0);
	}
}

/*
	�e�L�X�g�`��B
*/

void MyDIBObj3 :: Text(int isfc,LPCTSTR str,int x,int y,int height,int width,UINT color)
{
	if(!SFCCheck(isfc))return;
HFONT tmpfont;
	tmpfont = CreateFont(height,width,0,0,0,false,false,false,
		SHIFTJIS_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,
		DEFAULT_PITCH | FF_DONTCARE,_T("�l�r ����") );
	if(tmpfont == NULL)
	{
		DEBUG_OUTPUT(_T("Text() �t�H���g�̍쐬�Ɏ��s�I"));
		return;
	}

	TextEX( isfc , str , x , y , tmpfont , color ) ;
	
	DeleteObject(tmpfont);

}
SIZE MyDIBObj3 :: TestText(int isfc , LPCTSTR str , int height , int width )
{
	HFONT tmpfont;
	SIZE  tOut ;
	SIZE  tErrOut ;

	//�擾�ł��Ȃ������Ƃ��̓e�L�g�[�Ȓl
	tErrOut.cx = _tcslen( str ) * width ;
	tErrOut.cy = height ;

	if(!SFCCheck(isfc))return tErrOut ;

	tmpfont = CreateFont(height,width,0,0,0,false,false,false,
		SHIFTJIS_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,
		DEFAULT_PITCH | FF_DONTCARE,_T("�l�r ����") );
	if(tmpfont == NULL)
	{
		DEBUG_OUTPUT(_T("TestText() �t�H���g�̍쐬�Ɏ��s�I"));
		return tErrOut ;
	}
	tOut = TestTextEX( isfc , str , tmpfont ) ;
	DeleteObject(tmpfont);
	if( tOut.cx == -1 )
	{
		return tErrOut ;
	}
	return tOut ;
}
void MyDIBObj3 :: TextEX(int isfc,LPCTSTR str,int x,int y,HFONT hfont,UINT color)
{
	if(!SFCCheck(isfc))return;
HFONT oldfont ;
	SetBkMode(sfc[isfc].hdc,TRANSPARENT);
	SetTextColor(sfc[isfc].hdc,color);

	oldfont = (HFONT)SelectObject(sfc[isfc].hdc,hfont);

	TextOut(sfc[isfc].hdc,x,y,str,_tcslen (str));

	SelectObject(sfc[isfc].hdc,oldfont);
}
SIZE MyDIBObj3 :: TestTextEX( int isfc , LPCTSTR str , HFONT hfont )
{
	int iStrLen ;
	HFONT oldfont ;
	SIZE tOut ;
	tOut.cx = -1 ;
	tOut.cy = -1 ;

	if(!SFCCheck(isfc))return tOut ;

	oldfont = (HFONT)SelectObject( sfc[isfc].hdc , hfont );
	iStrLen = _tcslen( str ) ;

	if( !GetTextExtentPoint32( sfc[isfc].hdc , str , iStrLen , &tOut ) )
	{
	}

	SelectObject( sfc[isfc].hdc , oldfont );
	return tOut ;
}

