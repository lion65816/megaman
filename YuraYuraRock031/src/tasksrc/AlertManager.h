#ifndef _AlertManager_HEADER_INCLUDED
#define _AlertManager_HEADER_INCLUDED

class AlertManager : public Task0810
{
public:
	AlertManager( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_AlertManager , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	AlertManager() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;
private:
} ;

#endif /*_AlertManager_HEADER_INCLUDED*/
