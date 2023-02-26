#ifndef _SpEditor_HEADER_INCLUDED
#define _SpEditor_HEADER_INCLUDED

class SpEditor : public Task0810
{
public:
	SpEditor( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_SpEditor , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	SpEditor() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	unsigned char aucData[ RockStage::ciMaxAllocateSpData ] ;
	unsigned char aucMultiplexPage[ 2 ] ;
	int iButton ;
	tstring *pstrEnemyPat ;
private:
} ;

#endif /*_SpEditor_HEADER_INCLUDED*/
