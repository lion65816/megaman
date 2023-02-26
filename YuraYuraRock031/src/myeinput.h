#ifndef MYEINPUT_HEADER_INCLUDED
#define MYEINPUT_HEADER_INCLUDED

/*
	�L�[�{�[�h�E�}�E�X���͏��Ǘ����[�`���B
	�e�t���[���̍Ō��KeyMove���ĂсA���ƁA
	���̃R�[�h���E�C���h�E�v���V�[�W���̃��b�Z�[�W��switch���ɓ���Ďg��
*/
/*
	case WM_KEYDOWN:
		ProOn(wparam);
	break;
	case WM_KEYUP:
		ProOff(wparam);
	break;
	case WM_MOUSEMOVE:
		ProMMove(lparam);
	break;
	case WM_LBUTTONDOWN:
		ProMOn(MB_L);
	break;
	case WM_LBUTTONUP:
		ProMOff(MB_L);
	break;
	case WM_RBUTTONDOWN:
		ProMOn(MB_R);
	break;
	case WM_RBUTTONUP:
		ProMOff(MB_R);
	break;
	case WM_MBUTTONDOWN:
		ProMOn(MB_C);
	break;
	case WM_MBUTTONUP:
		ProMOff(MB_C);
	break;
*/

/*
	�}�E�X�{�^���̃C���f�b�N�X
*/
enum mousebuttonidentifyindex
{
	MB_L = 0,
	MB_R = 1,
	MB_C = 2
};

/*
	�g���O�ɁAKeyStart���Ă�ł��ǂ��c�c
	�Ƃ������A����ɌĂ΂��̂ŌĂ΂Ȃ��ėǂ�
*/
extern bool KeyStart();
//extern void KeyEnd();

/*
	�P�t���[���̍Ō�ɂ�����Ă�
*/
extern void KeyMove();


/*
	On......�����Ă���
	Off.....������Ă���
	Push....�����ꂽ�u��
	Release.�����ꂽ�u��
	�c�c�Ȃ�true��Ԃ�
*/
extern bool KeyOn(int code);
extern bool KeyOff(int code);
extern bool KeyPush(int code);
extern bool KeyRelease(int code);

extern bool MouseOn(mousebuttonidentifyindex wb);
extern bool MouseOff(mousebuttonidentifyindex wb);
extern bool MousePush(mousebuttonidentifyindex wb);
extern bool MouseRelease(mousebuttonidentifyindex wb);

/*
	�}�E�X�̈ʒu���擾����
*/
extern int  GetMousePosX();
extern int  GetMousePosY();

/*
	�����L�[�������ꂽ�i�u�ԁj�Ȃ�A���̔ԍ���Ԃ��B
	������Ă��Ȃ����-1��Ԃ��B
	isHEXenable��true�ɂ���΁AA�`F���ΏۂɂȂ�B
	���������ɉ�����Ă����ꍇ�́A�Ⴂ�����D�悳���B
*/
extern int GetNumberKey( bool isHEXenable = false ) ;

/*
	�����I�ɃL�[��}�E�X�{�^���𗣂������Ƃɂ���B
	�E�C���h�E�v���V�[�W����KEYUP���̃��b�Z�[�W���s���Ȃ��������Ƃɂ�鉟�����ςȂ��h�~�B
*/
extern void ForceReleaseKey();
extern void ForceReleaseMouse();
/*
	�Ăяo���Ɖ�����Ă��Ȃ������ɂ��邱�Ƃ��ł���
*/
extern void InvalidateKey() ;
extern void InvalidateMouse() ;
extern void InvalidateKeyCode(int code);
extern bool IsValidKeyCode(int code);
/*
	�E�C���h�E�v���V�[�W�����ŌĂ�
*/
extern void ProOn(int wparam);
extern void ProOff(int wparam);
extern void ProMOn(mousebuttonidentifyindex wb);
extern void ProMOff(mousebuttonidentifyindex wb);
extern void ProMMove(LONG lparam);


//�L�[���������Ƃ��ɁA�l��ύX���郋�[�`��
template <class mtp> bool KeyScroll( mtp *Pdest , int KEY1 , int KEY2 , int BASE_MULTI , int SHIFT_MULTI , mtp RESET_VALUE )
{
	mtp tmp = 0 ;
	if( KeyPush( KEY1 ) )tmp++ ;
	if( KeyPush( KEY2 ) )tmp-- ;
	tmp *= BASE_MULTI ;
	if( KeyOn( KC_SHIFT ) )tmp *= SHIFT_MULTI ;
	if( KeyOn( KEY1 ) && KeyOn( KEY2 ) )tmp = RESET_VALUE - (*Pdest) ;
	if( tmp )
	{
		(*Pdest) += tmp ;
		return true ;
	}
	return false ;
}


#endif /*MYEINPUT_HEADER_INCLUDED*/
