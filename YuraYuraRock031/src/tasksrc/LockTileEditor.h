#ifndef _LockTileEditor_HEADER_INCLUDED
#define _LockTileEditor_HEADER_INCLUDED

class LockTileEditor : public Task0810
{
public:
	LockTileEditor( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_LockTileEditor , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	LockTileEditor() : Task0810() {;};
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
	unsigned char aucHit[32*32] ;
	unsigned char aucFlag[16*16] ;
	int iTiles ;
	int iValidFill ;
	int i12Mode ;
private:
} ;

#endif /*_LockTileEditor_HEADER_INCLUDED*/
