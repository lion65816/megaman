#ifndef _R1_VariableField_HEADER_INCLUDED
#define _R1_VariableField_HEADER_INCLUDED

class R1_VariableField : public Task0810
{
public:
	R1_VariableField( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_R1_VariableField , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	R1_VariableField() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	int SubDragging0() ;
	int SubDragging1() ;
	int SubDragging2() ;
	int SubDragging12Sub( mousebuttonidentifyindex MouseCode , int iProcNo ) ;

	void GetVFPosition( unsigned char *pucVF , int *piX0 , int *piY0 , int *piX1 , int *piY1 ) ;
	void FixVFPosition( int *piX0 , int *piY0 , int *piX1 , int *piY1 ) ; //掴むための補正
	int  SetVFPosition( unsigned char *pucVF , int iX0 , int iY0 , int iX1 , int iY1 ) ;

	int NewVF( int iX , int iY ) ;
	int SortVF() ;
	void DeleteVF() ;

	static const int aciSpOffset[2] ;
	static const int ciSpSize   = 0xA0 ;
	static const int ciVFSize   = 6 ;
	static const int ciMaxVF    = (ciSpSize-3)/ciVFSize ;
	static const int ciInvalidPage = 0x30 ;
	unsigned char aucData[ RockStage::ciMaxAllocateSpData ] ;

	int iDragging ;
	int iSelected ;
	int iDragOrgX , iDragOrgY ;
private:
} ;

#endif /*_R1_VariableField_HEADER_INCLUDED*/
