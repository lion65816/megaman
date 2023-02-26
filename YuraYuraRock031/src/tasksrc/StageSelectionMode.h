#ifndef _StageSelectionMode_HEADER_INCLUDED
#define _StageSelectionMode_HEADER_INCLUDED

class StageSelectionMode : public Task0810
{
public:
	StageSelectionMode( Task0810 *Pparent , bool handle_enabled=true , int iEditMode=0 ) : Task0810( Pparent , TP_StageSelectionMode , handle_enabled )
	{
		this->iEditMode = iEditMode ;
		this->InitFuncCalled() ;
		Finit();
	}
	StageSelectionMode() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	int RipStage( int iStage , LPCTSTR filename ) ;
	int iEditMode ;
	int iPushedButton ;
	TASKHANDLE hEditButton ;
private:
} ;

#endif /*_StageSelectionMode_HEADER_INCLUDED*/
