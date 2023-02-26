#ifndef _ChipEditor_HEADER_INCLUDED
#define _ChipEditor_HEADER_INCLUDED

#include "VersatileTileEditor.h"

class ChipEditor : public Task0810
{
public:
	ChipEditor( Task0810 *Pparent , TaskP taskp , bool handle_enabled=true ) : Task0810( Pparent , taskp , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	ChipEditor() : Task0810() {;};
	void SetClipFile( LPCTSTR filename )
	{
		pVTE->LoadClipFile( filename ) ;
	}
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	void ImportWorkingData() ;
	void ExportWorkingData() ;
	int GetWorkingOffset( int iChipOffset ) ;
	VersatileTileEditor<unsigned char> *pVTE;
	unsigned char aucWorking[32*32] ;
	virtual int GetChipFromRS( int Offset ) ;
	virtual void SetChipToRS( int Offset , int iValue ) ;
	virtual int GetChipHitFromRS( int Offset ) ;
	virtual void SetChipHitFromRS( int Offset , int iValue ) ;
	virtual int GetChipEditorMode() ;
	virtual void VChipProc( int iPosition ) ;
private:
} ;

#endif /*_ChipEditor_HEADER_INCLUDED*/
