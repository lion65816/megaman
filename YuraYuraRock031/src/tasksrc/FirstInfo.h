#ifndef _FirstInfo_HEADER_INCLUDED
#define _FirstInfo_HEADER_INCLUDED

class FirstInfo : public Task0810
{
public:
	FirstInfo( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_FirstInfo , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	FirstInfo() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;
	int iButton ;
private:
} ;

#endif /*_FirstInfo_HEADER_INCLUDED*/
