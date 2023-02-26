#ifndef _ObjectEditor_HEADER_INCLUDED
#define _ObjectEditor_HEADER_INCLUDED

class ObjectEditor : public Task0810
{
public:
	ObjectEditor( Task0810 *Pparent , bool handle_enabled=true , int iOUNO=0 ) : Task0810( Pparent , TP_ObjectEditor , handle_enabled )
	{
		this->InitFuncCalled() ;
		this->iOUNO = iOUNO ;
		Finit();
	}
	ObjectEditor() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	tstring strNameTable[256] ;
	int iListValue ;
	unsigned char aucParam[4] ;
	TASKHANDLE hText ;
	void UpdateText() ;
	int iOUNO ;
private:
	int IsRemapableObj() ;
} ;

#endif /*_ObjectEditor_HEADER_INCLUDED*/
