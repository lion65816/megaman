#include "undo.h"


void Undo :: Reset()
{
	iLatest = 0 ;
	iOldest = 0 ;
	iCurrent = 0 ;
	memcpy( pbBuffer , pDestination , iBufferSizePerStep ) ;
}

void Undo :: Preserve()
{
	if( !pbBuffer ) return ;
	assert( iOldest <= iCurrent ) ;
	assert( iCurrent <= iLatest ) ;
	iCurrent ++ ;
	iLatest = iCurrent ;

	// ��F���̏ꍇ�͕␳�̕K�v�A��
	//  OLD=0  1   2   3   CUR=4
	//  �o�b�t�@�S���Ƃ��āA��ԌÂ��̂��̂Ă�
	if( iOldest <= iCurrent - iNumberOfStep )
	{
		iOldest = iCurrent-iNumberOfStep+1 ;
	}

	int iSuffix ;
	iSuffix = iCurrent % iNumberOfStep ;
	iSuffix *= iBufferSizePerStep ;
	memcpy( pbBuffer+iSuffix , pDestination , iBufferSizePerStep ) ;

}
bool Undo :: DoUndo()
{
	if( !pbBuffer ) return false ;
	assert( iOldest <= iCurrent ) ;
	assert( iCurrent <= iLatest ) ;

	iCurrent -- ;
	if( iOldest > iCurrent )
	{
		iCurrent = iOldest ;
		return false ;
	}

	int iSuffix ;
	iSuffix = iCurrent % iNumberOfStep ;
	iSuffix *= iBufferSizePerStep ;
	memcpy( pDestination , pbBuffer+iSuffix , iBufferSizePerStep ) ;

	return true ;
}
bool Undo :: DoRedo()
{
	if( !pbBuffer ) return false ;
	assert( iOldest <= iCurrent ) ;
	assert( iCurrent <= iLatest ) ;

	iCurrent ++ ;
	if( iLatest < iCurrent )
	{
		iCurrent = iLatest ;
		return false ;
	}

	int iSuffix ;
	iSuffix = iCurrent % iNumberOfStep ;
	iSuffix *= iBufferSizePerStep ;
	memcpy( pDestination , pbBuffer+iSuffix , iBufferSizePerStep ) ;

	return true ;
}

