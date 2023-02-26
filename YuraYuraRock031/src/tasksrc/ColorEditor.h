#ifndef _ColorEditor_HEADER_INCLUDED
#define _ColorEditor_HEADER_INCLUDED

class ColorEditor : public Task0810
{
public:
	ColorEditor( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_ColorEditor , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	ColorEditor() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	unsigned char aucData[ RockStage::ciMaxAllocateSpData ] ;
	int iSelectedColor ;
private:
} ;

class ColorEditor_sub : public TaskObject
{
public:
	ColorEditor_sub( Task0810 *Pparent , Task1206Rect tRect , unsigned char *pucDest , int iDestSize , int iLine , int iPalSize , int *piSelectedColor ) : TaskObject( Pparent , TP_ColorEditor_sub , true , tRect )
	{
		this->pucData = pucDest ;
		this->iDataSize = iDestSize ;
		this->iLine = iLine ;
		this->piSelectedColor = piSelectedColor ;
		this->tRect.w = iLine * iPalSize ;
		this->tRect.h = (iDestSize+iLine-1)/iLine * iPalSize ;
		iChanged = 0 ;
		this->InitFuncCalled() ;
		Finit();
	}
	ColorEditor_sub() : TaskObject() {;};
	bool IsChanged(){ if( iChanged ){ iChanged=0;return true; }return false; }
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	unsigned char *pucData ;
	int iDataSize ;
	int iLine ;
	int iChanged ;
	int *piSelectedColor ;
private:
} ;



#endif /*_ColorEditor_HEADER_INCLUDED*/
