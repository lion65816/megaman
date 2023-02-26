#ifndef _GraphicsBankEditor_HEADER_INCLUDED
#define _GraphicsBankEditor_HEADER_INCLUDED

class GraphicsBankEditor : public Task0810
{
public:
	GraphicsBankEditor( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_GraphicsBankEditor , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	GraphicsBankEditor() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;
	unsigned char aucData[ RockStage::ciMaxAllocateSpData ] ;
	int iButton ;
	int aiObjVRAMPat[256*6] ;
	int aiBossVRAMPat[16*6] ;
private:
} ;

#endif /*_GraphicsBankEditor_HEADER_INCLUDED*/
