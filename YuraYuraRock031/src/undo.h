#include <windows.h>
#include <assert.h>
#include <memory.h>

#ifndef UNDO_HEADER_INCLUDED
#define UNDO_HEADER_INCLUDED

class Undo
{
public:
	Undo()
	{
		assert( 0 ) ;
	}
	Undo( BYTE *pDestination , int iBuffreSizePerStep , int iNumberOfStep )
	{
		assert( iBuffreSizePerStep > 0 ) ;
		assert( iNumberOfStep > 0 ) ;
		int iSize ;
		iSize = iBuffreSizePerStep * iNumberOfStep ;
		assert( iSize <= 1024*1024*128 ) ;
		pbBuffer = new BYTE[ iSize ] ;
		if( pbBuffer )
		{
			memset( pbBuffer , 0 , iSize ) ;
			this->pDestination       = pDestination ;
			this->iBufferSizePerStep = iBuffreSizePerStep ;
			this->iNumberOfStep      = iNumberOfStep ;
		}

		Reset() ;
	}
	~Undo()
	{
		if( pbBuffer )
		{
			delete pbBuffer ;
			pbBuffer = NULL ;
		}
	}

	void Reset() ;

	void Preserve() ;
	bool DoUndo() ;
	bool DoRedo() ;


	void GetCounter( int *piCurrent , int *piTimes )
	{
		int iNOU = iLatest - iOldest + 1 ;
		(*piCurrent) = iLatest - iCurrent ;
		(*piTimes)   = iNOU ;
	}
private:
	BYTE *pbBuffer ;
	BYTE *pDestination ;
	int  iBufferSizePerStep ;
	int  iNumberOfStep ;

	int  iLatest ;
	int  iOldest ;
	int  iCurrent ;
} ;



#endif /*UNDO_HEADER_INCLUDED*/