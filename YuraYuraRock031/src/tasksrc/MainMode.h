#ifndef _MainMode_HEADER_INCLUDED
#define _MainMode_HEADER_INCLUDED

class MainMode : public Task0810
{
public:
	MainMode( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_MainMode , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	MainMode() : Task0810() {;};
	void SetDrawState( int iDrawMap , int iDrawEditor , int iDrawObject )
	{
		this->iDrawMap = iDrawMap ;
		this->iDrawEditor = iDrawEditor ;
		this->iDrawObject = iDrawObject ;
	}
	int GetDrawMode(){ return iDrawMode ; }
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	void SwitchEditMode() ;
	int iMaxMode ;

	int iDrawMode ;
	int iDrawModeV ;
	int iUChip ;
	int iDrawPageNo ;
	int iDrawMap ;
	int iDrawEditor ;
	int iDrawObject ;
	int iEditMode ;
	int iEditModeOrder ;
private:
} ;

#endif /*_MainMode_HEADER_INCLUDED*/
