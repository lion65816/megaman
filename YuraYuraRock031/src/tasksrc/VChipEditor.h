#ifndef _VChipEditor_HEADER_INCLUDED
#define _VChipEditor_HEADER_INCLUDED

#include "VersatileTileEditor.h"

class VChipEditor : public ChipEditor
{
public:
	VChipEditor( Task0810 *Pparent , bool handle_enabled=true ) : ChipEditor( Pparent , TP_VChipEditor , handle_enabled )
	{
		this->InitFuncCalled() ;
		iValidFill = 0 ;
		Finit();
	}
	VChipEditor() : ChipEditor() {;};
protected:
	void Finit() ;
	virtual int GetChipFromRS( int Offset ) ;
	virtual void SetChipToRS( int Offset , int iValue ) ;
	virtual int GetChipHitFromRS( int Offset ) ;
	virtual void SetChipHitFromRS( int Offset , int iValue ) ;
	virtual int GetChipEditorMode() ;
	virtual void VChipProc( int iPosition ) ;
	int iValidFill ;
private:
} ;

#endif /*_VChipEditor_HEADER_INCLUDED*/
