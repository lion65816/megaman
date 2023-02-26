#include "common.h"



class ModeManager : public Task0810
{
public:
	ModeManager( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_MODE_MANAGER , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	ModeManager() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

private:
} ;

