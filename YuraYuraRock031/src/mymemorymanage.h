/*
	�悭�Ӑ}�̂킩��Ȃ��������Ǘ����[�`���B

	�t�@�C������K�o���Ɠǂݍ��݂�������A�������񂾂�B�_���v���Ă�B
	���̑��A�����ł����̂��߂ɍ�������킩��Ȃ��悤�ȃ��[�`���������B
*/
#ifndef MYMEMORYMANAGE_INCLUDED
#define MYMEMORYMANAGE_INCLUDED

#include <tchar.h>
#include <windows.h> //LPCTSTR

/*	�t�@�C��������ptrbuf�Ƀ����������蓖�Ă����[�h�B
	�t�@�C���T�C�Y��Ԃ��B
	-1	�o�b�t�@����łȂ�
	-2�@�ꎞ�o�b�t�@���m�ۂł��Ȃ�
	-3�@�t�@�C�����I�[�v���ł��Ȃ�
	-4�@�t�@�C�����ǂ߂Ȃ�
	-5�@�ꎞ�o�b�t�@���g���ł��Ȃ�
	-6�@�Ԃ��ׂ��o�b�t�@���m�ۂł��Ȃ�
*/
extern int LoadMemoryFromFile( LPCTSTR filename , unsigned char **ptrbuf) ;

/*
	���������t�@�C���ɏ����o���B
	0	����I��
	-1	�t�@�C�����J���Ȃ�
	-2	�t�@�C���ɏ����Ȃ�
*/
extern int WriteFileFromMemory( LPCTSTR filename , unsigned char *data , int length);


/*
�@�@�n�����|�C���^�ɁA���������m�ۂ��āA�����ɂP�s���̋l�߂�B
�@�@�����ƌĂяo��������free���邱��
	0...����I��
	1...�I�[�܂œǂݍ���ŏI��
	-1..�ǂݍ��ݎ��s
	-2..�������m�ێ��s
*/
extern int ReadALine( int filehand , char **PPreturnbuf);

extern int WriteALine( int filehand , char *Pbuffer );

/*
�@��{�I�Ɏ蔲���p�B
�@�I�v�V���i���w�b�_�̑����Ɍ��C������������
�@Output�́ACREAT,TRUNC�ł���B
*/
#if 0
extern int MMMOpenForTextInput( char *Pname );
extern int MMMOpenForTextOutput( char *Pname );
extern int MMMOpenForBinaryInput( char *Pname );
extern int MMMOpenForBinaryOutput( char *Pname );
extern int MMMClose( int filehand ) ;
#endif














/*
	�r�b�g�P�ʂœǂݏ�������ۂ̏�����
*/
extern void BitControlStart(unsigned char *headbyte);
/*
	�r�b�g�J�[�\���Ƀf�[�^��������
	�r�b�g�J�[�\���͂��̕��i��
*/
extern void BitControlAdd(unsigned char data , int nobit , bool isnoproce=false);
/*
	�r�b�g�J�[�\������f�[�^�𓾂�
	�r�b�g�J�[�\���͂��̕��i��
*/
extern unsigned char BitControlGet(int nobit , bool isnoproce=false);
/*
	�r�b�g�J�[�\���̈ړ���
*/
extern int  BitControlGetIOBit();
/*
	�r�b�g�J�[�\���𑀍�
*/
extern void BitControlSeek(int nobit);



#endif//MYMEMORYMANAGE_INCLUDED