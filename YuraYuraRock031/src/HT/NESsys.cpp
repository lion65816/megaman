#include <windows.h>

static BYTE bittable[8] = {0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01};
static BYTE bittabler[8] = {0x01,0x02,0x04,0x08,0x10,0x20,0x40,0x80};

static UINT *Pcolortable4 ;
static void (*PCLSFUNK)(int sfc , int x , int y , int w , int h , UINT color );

void SetNESPalette( UINT *Pict4 )
{
	Pcolortable4  = Pict4 ;
}

void SetNESDrawRoutine( void (*PiCLSFUNK)(int,int,int,int,int,UINT) , UINT *Pict4 )
{
	PCLSFUNK      = PiCLSFUNK ;
	SetNESPalette( Pict4 ) ;
}


void DrawNESCharacter( BYTE *Pbuf , int sfc , int x , int y , bool emphasis , int zoom)
{
BYTE tmp[8];
int ix,iy;
UINT tcolor;
	for( iy=0 ; iy<8 ; iy++ )
	{
		for( ix=0 ; ix<8 ; ix++ )tmp[ix] = 0;
		for( ix=0 ; ix<8 ; ix++ )
		{
			if( Pbuf[0+iy]&bittable[ix] )tmp[ix] |= 1 ;
			if( Pbuf[8+iy]&bittable[ix] )tmp[ix] |= 2 ;
		}
		for( ix=0 ; ix<8 ; ix++ )
		{
			tcolor = tmp[ix] ;
			if( emphasis )tcolor = Pcolortable4[tcolor] ;
			PCLSFUNK( sfc , x+ix*zoom , y+iy*zoom , zoom , zoom , tcolor ) ;
		}
	}
}