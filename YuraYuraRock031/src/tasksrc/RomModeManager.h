#ifndef _RomModeManager_HEADER_INCLUDED
#define _RomModeManager_HEADER_INCLUDED

class RomModeManager : public Task0810
{
public:
	RomModeManager( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_RomModeManager , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	RomModeManager() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	int iSelectedRomMode ;
private:
} ;

#endif /*_RomModeManager_HEADER_INCLUDED*/
