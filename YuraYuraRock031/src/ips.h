#ifndef IPS_HEADER_INCLUDED
#define IPS_HEADER_INCLUDED

//成功で0、失敗で負数、拡張に対応するには、pucDestにNULL、ppucExpDestにポインタを渡す
int IPSPatch( unsigned char *pucDest , int iDestSize , unsigned char *pucSrc , int iSrcSize , unsigned char **ppucExpDest=NULL , int *piExpSize=NULL ) ;
//成功で*ppucOutのサイズ(正数)、失敗で負数、成功時は*ppucOutを呼び出し側でfreeすること
int IPSCreate( unsigned char *pucDest , unsigned char *pucBase , int iDestSize , unsigned char **ppucOut ) ;

//成功で0、失敗で負数
int IPSPatch_f( unsigned char *pucDest , int iDestSize , const TCHAR * filename , unsigned char **ppucExpDest=NULL , int *piExpSize=NULL ) ;
//成功で0、失敗で負数
int IPSCreate_f( unsigned char *pucDest , unsigned char *pucBase , int iDestSize , const TCHAR * filename ) ;

#endif /*IPS_HEADER_INCLUDED*/

