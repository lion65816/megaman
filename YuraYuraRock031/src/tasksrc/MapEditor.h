#ifndef _MapEditor_HEADER_INCLUDED
#define _MapEditor_HEADER_INCLUDED

class MapEditor : public Task0810
{
public:
	MapEditor( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_MapEditor , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	MapEditor() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	TASKHANDLE hText ;
	int iCulcTimer ;
	TASKHANDLE hLockTask ;
	int iLockButton ;
private:
} ;

#endif /*_MapEditor_HEADER_INCLUDED*/
