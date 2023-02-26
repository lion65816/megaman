#ifndef TEXT_INPUT_OUTPUT_HEADER_INCLUDED
#define TEXT_INPUT_OUTPUT_HEADER_INCLUDED

#include <windows.h>
#include <tchar.h>
#include <stdio.h>


typedef struct TextIOItem_tag
{
	int mode ;
	LPTSTR token ;
	void *Pdata ;
	int size ;
} TextIOItem ;

class TextIOManager
{
private:
	//�R�}���h�ɂ���s���̈�
	_TCHAR command_token ;
	//�R�����g�ɂ���s���̈�
	_TCHAR comment_token ;
	//���o�͂���t�@�C����
	LPCTSTR filename ;
	//�h�n�A�C�e���̃o�b�t�@�i�C���X�^���X�쐬���Ɋm�ی�A�Œ�j
	TextIOItem *PItem ;
	//�h�n�A�C�e�����l�߂Ă���ʒu
	int itempos ;
	//�h�n�A�C�e���̍ő吔
	int maxitem ;
public:
	TextIOManager::TextIOManager( LPCTSTR filename , int NOIOItem , _TCHAR command_token , _TCHAR comment_token );
	TextIOManager::~TextIOManager() ;
/*
	�ȉ��̊֐��Ńf�[�^�ɓK���Ȗ��O�i�g�[�N���j�����Ďw�肷�邪
	���ꂼ��ŗL�̖��O�ł���K�v������A
	�܂��A�uBIN�v�͎g���Ă͂����Ȃ��A�X�y�[�X��^�u���܂�ł͂����Ȃ��B
*/
	//�K���ȃR�����g������i�Z�[�u���ɗL���j
	bool AddIOItem_Comment( LPCTSTR token ) ;
	//�P�U�r�b�g�̒l�Bint�^�Ŏ󂯂�B
	bool AddIOItem_16Value( LPCTSTR token , int *Pval ) ;
	//�������u���b�N�B�K���Ȍ^�Ŏ󂯂�B
	bool AddIOItem_Block( LPCTSTR token , void *Pblock , int size ) ;
	//�P�U�r�b�g�̒l�̘A���Bint�^�Ŏ󂯂�B
	bool AddIOItem_16Array( LPCTSTR token , int *Pval , int size ) ;
	//�Z�[�u�����s
	int DoSaving() ;
	//���[�h�����s
	int DoLoading() ;
};


#endif /*TEXT_INPUT_OUTPUT_HEADER_INCLUDED*/

