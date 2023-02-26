#ifndef NES_SYS_HEADER_INCLUDED
#define NES_SYS_HEADER_INCLUDED

extern void SetNESPalette( UINT *Pict4 ) ;
extern void SetNESDrawRoutine( void (*PiCLSFUNK)(int,int,int,int,int,UINT) , UINT *Pict4 ) ;
extern void DrawNESCharacter( BYTE *Pbuf , int sfc , int x , int y , bool emphasis , int zoom);

#endif /*NES_SYS_HEADER_INCLUDED*/