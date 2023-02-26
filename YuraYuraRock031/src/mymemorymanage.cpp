/*
	�悭�Ӑ}�̂킩��Ȃ��������Ǘ����[�`���B
*/
#include <stdio.h>
#include <string.h>
#include <io.h>
#include <malloc.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <memory.h>
#include <assert.h>

#include "mymemorymanage.h"



//�ꑧ�œǂޗ�
#define READLENGTH	0x00100000

static int ret;
#define	ERRRET(tok,num)		{ret=-num;goto tok##num;}


/*	�t�@�C��������ptrbuf�Ƀ����������蓖�Ă����[�h�B
	�t�@�C���T�C�Y��Ԃ��B
	-1	�o�b�t�@����łȂ�
	-2�@�ꎞ�o�b�t�@���m�ۂł��Ȃ�
	-3�@�t�@�C�����I�[�v���ł��Ȃ�
	-4�@�t�@�C�����ǂ߂Ȃ�
	-5�@�ꎞ�o�b�t�@���g���ł��Ȃ�
	-6�@�Ԃ��ׂ��o�b�t�@���m�ۂł��Ȃ�
*/
int LoadMemoryFromFile( LPCTSTR filename , unsigned char **ptrbuf)
{
	//�o�b�t�@���`�F�b�N
	if(*ptrbuf != NULL)return -1 ;

	FILE *fp ;
	if( _tfopen_s( &fp , filename , _T("rb") ) ) return -3 ;

	int size ;
	fseek( fp , 0 , SEEK_END ) ;
	size = ftell( fp ) ;
	fseek( fp , 0 , SEEK_SET ) ;

	//���ۂɕԂ��o�b�t�@���m��
	*ptrbuf = (unsigned char*)malloc(size);
	if(*ptrbuf == NULL){fclose(fp);return -6;}

	fread( *ptrbuf , 1 , size , fp ) ;

	fclose( fp ) ;
	return size ;
}

/*
	���������t�@�C���ɏ����o���B
	0	����I��
	-1	�t�@�C�����J���Ȃ�
	-2	�t�@�C���ɏ����Ȃ�
*/
int WriteFileFromMemory( LPCTSTR filename , unsigned char *data , int length )
{
FILE *fp ;
	if( _tfopen_s( &fp , filename , _T("wb") ) )ERRRET(ERRWFFM,1);
	if( fwrite( data , 1 , length , fp ) < (size_t)length )ERRRET(ERRWFFM,2);
	/*
int filehand;
	filehand = _open(filename , _O_CREAT | _O_BINARY | _O_TRUNC | _O_WRONLY , _S_IREAD | _S_IWRITE );
	if(filehand == -1)ERRRET(ERRWFFM,1);
	if(_write(filehand , data , length) < length)ERRRET(ERRWFFM,2);
	*/
	ret = 0;
ERRWFFM2:
//	_close(filehand);
	fclose( fp ) ;
ERRWFFM1:
	return ret;
}

#define		EXPAND_SIZE_AT_ONCE		0x0100
#define		BUFFER_SIZE_LIMIT		0x2000

/*
	0...����I��
	1...�I�[�܂œǂݍ���ŏI��
	-1..�ǂݍ��ݎ��s
	-2..�������m�ێ��s
*/
int ReadALine( int filehand , char **PPreturnbuf)
{
	char *Pbuffer=NULL;
	int buffersize=0;
	int i;
	for( i=0 ;; i++)
	{
		if(buffersize <= i)
		{
			if(!Pbuffer)
			{
				Pbuffer = (char*)malloc(sizeof(char)*EXPAND_SIZE_AT_ONCE);
			}
			else
			{
				if( buffersize >= BUFFER_SIZE_LIMIT )
				{
					Pbuffer[i-1] = '\0';
					*PPreturnbuf = Pbuffer;
					return -2;
				}
				Pbuffer = (char*)realloc(&Pbuffer , buffersize+sizeof(char)*EXPAND_SIZE_AT_ONCE);
			}
			if( !Pbuffer )
			{
				*PPreturnbuf = NULL;
				return -2;
			}
			buffersize += EXPAND_SIZE_AT_ONCE;
		}
		switch(_read( filehand , &Pbuffer[i] , 1 ))
		{
		case 1:
			if(Pbuffer[i] == '\n')
			{
				Pbuffer[i] = '\0';
				*PPreturnbuf = Pbuffer;
				return 0;
			}
		break;
		case 0:
			Pbuffer[i] = '\0';
			*PPreturnbuf = Pbuffer;
			return 1;
		break;
		default:
			Pbuffer[i] = '\0';
			*PPreturnbuf = Pbuffer;
			return 1;
		}
	}
	assert(0);
	return -1;
}

/*
	��s�����B�����̂ق��̂Ɣ�ׂĂ��蔲���Ȃ͖̂����ŁA���܂�g���Ȃ�
*/
int WriteALine( int filehand , char *Pbuffer )
{
//int rv;
	_write( filehand , Pbuffer , strlen(Pbuffer) );
	return 0;
}

#if 0
int MMMOpenForTextInput( char *Pname )
{
	return _open( Pname , _O_TEXT | _O_RDONLY);
}
int MMMOpenForTextOutput( char *Pname )
{
	return _open( Pname , _O_CREAT | _O_TEXT | _O_TRUNC | _O_WRONLY , _S_IREAD | _S_IWRITE );
}
int MMMOpenForBinaryInput( char *Pname )
{
	return _open( Pname , _O_BINARY | _O_RDONLY);
}
int MMMOpenForBinaryOutput( char *Pname )
{
	return _open( Pname , _O_CREAT | _O_BINARY | _O_TRUNC | _O_WRONLY , _S_IREAD | _S_IWRITE );
}
int MMMClose( int filehand )
{
	return _close( filehand ) ;
}
#endif