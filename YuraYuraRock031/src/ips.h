#ifndef IPS_HEADER_INCLUDED
#define IPS_HEADER_INCLUDED

//������0�A���s�ŕ����A�g���ɑΉ�����ɂ́ApucDest��NULL�AppucExpDest�Ƀ|�C���^��n��
int IPSPatch( unsigned char *pucDest , int iDestSize , unsigned char *pucSrc , int iSrcSize , unsigned char **ppucExpDest=NULL , int *piExpSize=NULL ) ;
//������*ppucOut�̃T�C�Y(����)�A���s�ŕ����A��������*ppucOut���Ăяo������free���邱��
int IPSCreate( unsigned char *pucDest , unsigned char *pucBase , int iDestSize , unsigned char **ppucOut ) ;

//������0�A���s�ŕ���
int IPSPatch_f( unsigned char *pucDest , int iDestSize , const TCHAR * filename , unsigned char **ppucExpDest=NULL , int *piExpSize=NULL ) ;
//������0�A���s�ŕ���
int IPSCreate_f( unsigned char *pucDest , unsigned char *pucBase , int iDestSize , const TCHAR * filename ) ;

#endif /*IPS_HEADER_INCLUDED*/

