#include <windows.h>
#include <stdio.h>
#include <stdarg.h>
#include <math.h>
#include "nnsys.h"




static class sintableclass
{
private:
	double *MPsintable;
	int     Msintablesenv;
public:
	sintableclass()
	{
		MPsintable=NULL;
		Msintablesenv=0;
	}
	~sintableclass()
	{
		if(MPsintable)
		{
			GlobalFree(MPsintable);
			MPsintable = NULL;
			Msintablesenv = 0;
		}
	}
	void   Set(int senv)
	{
		if(senv > 0)
		{
			if(MPsintable)GlobalFree(MPsintable);
			MPsintable = (double *)GlobalAlloc(GMEM_FIXED , sizeof(double)*senv);
			for(int i=0 ; i<senv ; i++){
				MPsintable[i] = sin(2*PI/senv*i);
			}
		}
	}
	double Get(int angle)
	{
		return MPsintable[angle];
	}
	int GetSenv()
	{
		return Msintablesenv;
	}
}sintable;

void MakeSinTable(int sintablesenv){
	sintable.Set(sintablesenv);
}
double ESin(int angle){
	while(angle < 0)return -ESin(-angle);
	angle %= sintable.GetSenv();
	return sintable.Get(angle);
}
double ECos(int angle){
	return ESin(angle + sintable.GetSenv()/4);
}

int GetSinTableSenv()
{
	return sintable.GetSenv();
}





static bool rndtablebemade=false ;

static unsigned int rndtable[33] ;
static int rndptr;
static unsigned char *Pex_rnd ;


unsigned int mrnd()
{
	if( !rndtablebemade )smrnd( 34057 , NULL ) ;
	rndptr %= 33 ;
int pos ;
	if( !Pex_rnd )
		pos = rndptr+9 ;
	else
		pos = rndptr+6+((*Pex_rnd)*59)%9 ;
	pos %= 33 ;
	rndtable[ rndptr ] += rndtable[pos] ;
	rndptr++ ;

	return rndtable[ rndptr-1 ] ;
}
double dmrnd()
{
	return mrnd()/(double)0x100000000 ;
}
void smrnd( int seed , unsigned char *Pes )
{
int i ;
	rndtablebemade = true ;
	Pex_rnd = Pes ;
	rndptr = 15 ;
	rndtable[0] = seed ;
	for( i=1 ; i<33 ; i++ )
		rndtable[i] = 0x46A2E297*rndtable[i-1] + 0x00EF353B;
}

unsigned int mrnd(MYRND_PARAM *Pmrp)
{
	Pmrp->rndptr %= 33 ;
int pos ;
	if( !Pmrp->Pex_rnd )
		pos = Pmrp->rndptr+9 ;
	else
		pos = Pmrp->rndptr+6+((*Pmrp->Pex_rnd)*59)%9 ;
	pos %= 33 ;
	Pmrp->rndtable[ Pmrp->rndptr ] += Pmrp->rndtable[pos] ;
	Pmrp->rndptr++ ;

	return Pmrp->rndtable[ Pmrp->rndptr-1 ] ;
}
double dmrnd(MYRND_PARAM *Pmrp)
{
	return mrnd(Pmrp)/(double)0x100000000 ;
}
void smrnd( MYRND_PARAM *Pmrp , int seed , unsigned char *Pes )
{
int i ;
	Pmrp->Pex_rnd = Pes ;
	Pmrp->rndptr = 15 ;
	Pmrp->rndtable[0] = seed ;
	for( i=1 ; i<33 ; i++ )
		Pmrp->rndtable[i] = 0x46A2E297*Pmrp->rndtable[i-1] + 0x00EF353B;
}


//かなりテキトーな２４ビットハッシュ（？）値作成
unsigned int EHash( unsigned char *Pd , int length )
{
unsigned int h;
int i;
	h = 0;
	for ( i=0 ; i<length ; i++) {
		h = h * 137 + Pd[i] ;
	}
	return h % 0x01000000;
}
