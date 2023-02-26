#ifndef _R1_GraphicsBank_HEADER_INCLUDED
#define _R1_GraphicsBank_HEADER_INCLUDED

class R1_GraphicsBank : public Task0810
{
public:
	R1_GraphicsBank( Task0810 *Pparent , bool handle_enabled=true ) : Task0810( Pparent , TP_R1_GraphicsBank , handle_enabled )
	{
		this->InitFuncCalled() ;
		Finit();
	}
	R1_GraphicsBank() : Task0810() {;};
protected:
	void Finit() ;
	void Fmain() ;
	void Fdest() ;
	void Fdraw() ;

	static const int ciVRAMLines = 5 ;
	static const int ciLongStages = 10 ;
	static const int ciPages = 0x30 ;
	static const int ciSpOff_GrpOffset  = 0x240 ;
	static const int ciSpSize_GrpOffset = ciPages ;
	static const int ciSpOff_GrpData    = 0x280 ;
	static const int ciSpSize_GrpData   = 0x79 ;
	static const int ciSp_SizePerGrp    = (0x0B) ;
	static const int ciSp_NOGrp         = (ciSpSize_GrpData/ciSp_SizePerGrp) ;
	static const int ciSpOff_RoomConnection = 0x000 ;
	static const int ciSpSize_RoomConnection = 0x30 ;

	unsigned char aucData[ RockStage::ciMaxAllocateSpData ] ;
	unsigned char aucPrev[ RockStage::ciMaxAllocateSpData ] ;
	int aiRoomNo[ciPages] ;
	unsigned char ucRoomLock ;
	int iButton ;
	int aiObjVRAMPat[256*ciVRAMLines] ;
	int aiBossVRAMPat[ciLongStages*ciVRAMLines] ;
	TASKHANDLE hBEOffset ;
private:
} ;

#endif /*_R1_GraphicsBank_HEADER_INCLUDED*/
