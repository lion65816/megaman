#ifndef _LockPageEditor_HEADER_INCLUDED
#define _LockPageEditor_HEADER_INCLUDED

class LockPageEditor : public Task0810
{
public:
	LockPageEditor( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_LockPageEditor , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	LockPageEditor() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;
private:
} ;

#endif /*_LockPageEditor_HEADER_INCLUDED*/
