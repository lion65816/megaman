#ifndef ROCK_STAGE_HEADER_INCLUDED
#define ROCK_STAGE_HEADER_INCLUDED

#include <windows.h>
#include "RockStage_Elem.h"
#include "TextIO.h"
#include "VersatileTileEditor_lua.h"


typedef struct RS_SpData_ RS_SpData;
struct RS_SpData_
{
	int iLoadOffset ; //先頭
	int iAddrBase ;
	int iAddrDeltaS ;
	int iAddrDeltaD ;
	int iSize ;
	int iDataOffset ;
	int iEditMsg ;
	int iEditSize ;
	int iEditLine ;
} ;

class RockStage
{
public:
	/*定数*/
	static const int ciMaxAllocatePage = 0x60 ;
	static const int ciMaxAllocateTile = 0x100 ;
	static const int ciMaxAllocateChip = 0x100 ;
	static const int ciDotPGrap   = 8 ;
	static const int ciGrapPChipW = 2 ;
	static const int ciGrapPChipH = 2 ;
	static const int ciGrapPChipS = ciGrapPChipW*ciGrapPChipH ;
	static const int ciChipPTileW = 2 ;
	static const int ciChipPTileH = 2 ;
	static const int ciChipPTileS = ciChipPTileW*ciChipPTileH ;
	static const int ciTilePPageW = 8 ;
	static const int ciTilePPageH = 8 ;
	static const int ciTilePPageS = ciTilePPageW*ciTilePPageH ;
	static const int ciChipPPageW = ciChipPTileW*ciTilePPageW ;
	static const int ciChipPPageH = ciChipPTileH*ciTilePPageH ;
	static const int ciChipPPageS = ciChipPPageW*ciChipPPageH ;

	static const int ciDotPChipW  = (ciDotPGrap*ciGrapPChipW) ;
	static const int ciDotPChipH  = (ciDotPGrap*ciGrapPChipH) ;
	static const int ciDotPTileW  = (ciDotPGrap*ciGrapPChipW*ciChipPTileW) ;
	static const int ciDotPTileH  = (ciDotPGrap*ciGrapPChipH*ciChipPTileH) ;
	static const int ciDotPPageW  = (ciDotPGrap*ciGrapPChipW*ciChipPPageW) ;
	static const int ciDotPPageH  = (ciDotPGrap*ciGrapPChipH*ciChipPPageH) ;

	static const int ciLayers     = 2 ;

	static const int ciMaxAllocateSpData = 0x800 ;

	static const int ciMaxViewPat = 4 ;

	//Lock Flag
	static const int ciLF_Locked     = 0x01 ;
	static const int ciLF_SemiLocked = 0x02 ;
	static const int ciLF_LockedAnyway = ciLF_Locked|ciLF_SemiLocked ;
	static const int ciLF_Default    = 0x00 ;

	/*変数*/
	static const int aciNOStage[6];

	/*関数*/

	RockStage()
	{
		pVTE = NULL ;
		Clear() ;
		iVersion = 0x0100 ;
	}
	~RockStage()
	{
		Clear() ;
	}

	void SetRom( unsigned char *pucRom , int iRomSize ) ;
	void SetEditMode( int iEditMode ) ;
	void SetDrawParam( int iSfcChr , int iSfcChip , int iSfcChipInfo , BMPD *pPal , int iSfcTmp )
	{
		this->iSfcChr = iSfcChr ;
		this->iSfcChip = iSfcChip ;
		this->iSfcChipInfo = iSfcChipInfo ;
		this->pNESPal = pPal ;
		this->iSfcTmp = iSfcTmp ;
	}
	int GetViewPatNO(){ return iViewPatNO ; }
	void SetViewPatNO( int iViewPatNO ){ this->iViewPatNO = iViewPatNO ; RotateCorrect( &this->iViewPatNO , ciMaxViewPat ) ; iUpdateChr=1 ; }
	void SetViewPatNOD( int iD ){ SetViewPatNO(iViewPatNO+iD) ; }
	void SetDrawMode( int iDrawMode , int iUnusedChip , int iDrawPageNo ){ this->iDrawMode = iDrawMode ; iDrawModeUnusedChip=iUnusedChip ; this->iDrawPageNo = iDrawPageNo ; iUpdateChip=1 ; }
	int GetEditMode(){ return iEditMode ; }
	int IsTilePreservable(){ switch( iEditMode ){ case 1:case 3:case 4:case 5:return 1; }return 0; }

	int GetChip( unsigned int iOffset ){ RotateCorrect( &iOffset , _countof(aucChip) ) ; return aucChip[iOffset] ; }
	void SetChip( unsigned int iOffset , int data ){  RotateCorrect( &iOffset , _countof(aucChip) ) ; aucChip[iOffset] = data ; }
	int GetChipHit( unsigned int iOffset ){  RotateCorrect( &iOffset , _countof(aucChipHit) ) ; return aucChipHit[iOffset] ; }
	void SetChipHit( unsigned int iOffset , int data ){ RotateCorrect( &iOffset , _countof(aucChipHit) ) ; aucChipHit[iOffset] = data ; }
	int GetVChip( unsigned int iOffset ){ RotateCorrect( &iOffset , _countof(aucVChip) ) ; return aucVChip[iOffset] ; }
	void SetVChip( unsigned int iOffset , int data ){  RotateCorrect( &iOffset , _countof(aucVChip) ) ; aucVChip[iOffset] = data ; }
	int GetVChipHit( unsigned int iOffset ){  RotateCorrect( &iOffset , _countof(aucVChipHit) ) ; return aucVChipHit[iOffset] ; }
	void SetVChipHit( unsigned int iOffset , int data ){ RotateCorrect( &iOffset , _countof(aucVChipHit) ) ; aucVChipHit[iOffset] = data ; }
	int GetVChipValid( unsigned int iOffset ){  RotateCorrect( &iOffset , _countof(aucVChipValid) ) ; return aucVChipValid[iOffset] ; }
	void SetVChipValid( unsigned int iOffset , int data ){ RotateCorrect( &iOffset , _countof(aucVChipValid) ) ; aucVChipValid[iOffset] = data ; }
	int GetSpData( unsigned int iOffset ){ if( iOffset>=_countof(aucSpData) )return -1 ; return aucSpData[iOffset] ; }
	void SetSpData( unsigned int iOffset , int data ){ if( iOffset>=_countof(aucSpData) )return ; aucSpData[iOffset] = data ; }
	void ExportSpData( unsigned char *pucDest ){ memcpy( pucDest , aucSpData , _countof(aucSpData) ) ; }
	void ImportSpData( unsigned char *pucSrc  ){ memcpy( aucSpData , pucSrc  , _countof(aucSpData) ) ; }
	int  ExportMultiplexPage( unsigned char *pucDest ){ pucDest[0]=pucDest[1]=0; if( aiMultiplexOriginalPage[0]<0 ){ return 0 ; } pucDest[0]=aiMultiplexOriginalPage[0]; if( aiMultiplexOriginalPage[1]<0 ){ return 1 ; } pucDest[1]=aiMultiplexOriginalPage[1]; return 2 ; } ;
	void ImportMultiplexPage( unsigned char *pucSrc  ){ if( aiMultiplexOriginalPage[0]<0 ){ return   ; } aiMultiplexOriginalPage[0]=pucSrc [0]; if( aiMultiplexOriginalPage[1]<0 ){ return   ; } aiMultiplexOriginalPage[1]=pucSrc [1]; return   ; } ;
	int GetPreTile    ( unsigned int iOffset ){ RotateCorrect( &iOffset , _countof(aucPreTile    ) ); return aucPreTile    [iOffset]; }
	int GetPreTileHit ( unsigned int iOffset ){ RotateCorrect( &iOffset , _countof(aucPreTileHit ) ); return aucPreTileHit [iOffset]; }
	int GetPreTileFlag( unsigned int iOffset ){ RotateCorrect( &iOffset , _countof(aucPreTileFlag) ); return aucPreTileFlag[iOffset]; }
	int GetPrePage    ( unsigned int iOffset ){ RotateCorrect( &iOffset , _countof(aucPrePage    ) ); return aucPrePage    [iOffset]; }
	int GetPrePageFlag( unsigned int iOffset ){ RotateCorrect( &iOffset , _countof(aucPrePageFlag) ); return aucPrePageFlag[iOffset]; }
	void SetPreTile    ( unsigned int iOffset , int iData ){ RotateCorrect( &iOffset , _countof(aucPreTile    ) ); aucPreTile    [iOffset]=iData ; }
	void SetPreTileHit ( unsigned int iOffset , int iData ){ RotateCorrect( &iOffset , _countof(aucPreTileHit ) ); aucPreTileHit [iOffset]=iData ; }
	void SetPreTileFlag( unsigned int iOffset , int iData ){ RotateCorrect( &iOffset , _countof(aucPreTileFlag) ); aucPreTileFlag[iOffset]=iData ; }
	void SetPrePage    ( unsigned int iOffset , int iData ){ RotateCorrect( &iOffset , _countof(aucPrePage    ) ); aucPrePage    [iOffset]=iData ; }
	void SetPrePageFlag( unsigned int iOffset , int iData ){ RotateCorrect( &iOffset , _countof(aucPrePageFlag) ); aucPrePageFlag[iOffset]=iData ; }

	int  R12_GetLatterPageNumber() ;
	int  R12_GetEndPageNumber() ;
	void AutoSpData_12_sub( int *piRoomNoPerPage , int iMaxRoom , unsigned char *pucSP ) ;
	void AutoSpData_1_0();
	void AutoSpData_2_0();
	void AutoSpData_2_1();
	int AutoSpData_3_1();
	int AutoSpData_3_2();
	int AutoSpData_3_3( tstring *pstrObjPat , tstring *pstrMessage );

	int AutoObjBankData_1( int iOffset , int *piObjPat , int *piBossPat );
	int AutoObjBankData_2( int iOffset , int *piObjPat , int *piBossPat );
	int AutoObjBankData_2_sub( int iOffset , int iXp , int *piRPP );


	tstring GetFileName(){ return strFileName ; }
	void SetFileName( tstring strFileName ){ this->strFileName = strFileName ; }


	void Clear() ;
	int ImportFromRom( int iStageNO ) ;
	int ExportToRom( int *piPage , int *piTile , int *piMaxPage , int *piMaxTile , unsigned char *pucRomMask ) ;
	int RemapObject( unsigned char *pucRomMask , int *piOutCurSize , int *piOutMaxSize ) ;
	int RemapObject_1( unsigned char *pucRomMask , int *piOutCurSize , int *piOutMaxSize ) ;
	int RemapObject_6( unsigned char *pucRomMask , int *piOutCurSize , int *piOutMaxSize ) ;
	int Save( LPCTSTR filename ) ;
	//rstgを読み込むがROMは読み込まない。もとよりこの関数を終えないとどのROMを読めば良いかが不明である。
	//この関数のあとROMをセットする必要があり、セットされるまではROM依存の設定が読み込まれない。
	int Load( LPCTSTR filename ) ;
	void CorrectEditModeStageNODependedValue() ;
	void CorrectEditModeStageNORomDependedValue() ;
	void DrawChr( MyDIBObj3 *pMDO ) ;
	void DrawChip( MyDIBObj3 *pMDO  , int iVMode , int iFlag ) ;
	void UpdateSFC( MyDIBObj3 *pMDO , int iVChip ) ;
	void Draw( MyDIBObj3 *pMDO , int iSfc , int x , int y , int iDrawEditor , int iDrawMap , int iDrawObject , int iVChip ) ;
	void SaveBitmapChip( MyDIBObj3 *pMDO , LPCTSTR filename ) ;
	void SaveBitmapPage( MyDIBObj3 *pMDO , LPCTSTR filename ) ;
	void SaveBitmapMap ( MyDIBObj3 *pMDO , LPCTSTR filename ) ;
	int CulcPageTileAmount( int *piPage , int *piTile , int *piMaxPage , int *piMaxTile , int *piPrePage , int *piPreTile ) ;
	int GetObjCount( int *piObj , int *piMaxObj , int iOUNO=0 ) ;
	int LoadSpData( RS_SpData *ptSp ) ;
	void ReserveUpdateChrChip(){ iUpdateChr = iUpdateChip = 1 ; }
	void UpdateGraphicsPattern() ;
	void LoadLua( LPCTSTR filename ){ pVTE->LoadLua(filename); }
	void UnloadLua(){ pVTE->UnloadLua(); }


	int ProcessChip( int iBx , int iBy , int iPx , int iPy , int iDo=1 )
	{
		if( !iIsValid ){return 0;}
		if( !pVTE ){ assert(0); }
		pVTE->SetPosition( iBx , iBy ) ;
		pVTE->SetTilePalette( iPx , iPy ) ;
		if( !iDo ){ return 0 ; }
		return pVTE->DoEdit() ;
	}
	void LoadClipFile( LPCTSTR filename )
	{
		if( pVTE ){ pVTE->LoadClipFile( filename ) ; }
	}
	int ProcessObj( int iBx , int iBy , int iOUNO=0 )
	{
		if( !iIsValid || !iIsEditObject ){return 0;}
		assert( iOUNO==0 || iOUNO==1 ) ;
		return OU[iOUNO].DoEdit( iBx , iBy ) ;
	}
	int GetObjSelection( int iOUNO=0 )
	{
		assert( iOUNO==0 || iOUNO==1 ) ;
		return OU[iOUNO].GetSelectSuffix(0) ;
	}
	int SetObjParam( int iOffset , int iValue , int iOUNO=0 )
	{
		assert( iOUNO==0 || iOUNO==1 ) ;
		switch( iOffset )
		{
		case 0:return OU[iOUNO].SetXByteS( 1 , iValue ) ;
		case 1:return OU[iOUNO].SetXByteS( 0 , iValue ) ;
		case 2:return OU[iOUNO].SetYS( iValue ) ;
		case 3:return OU[iOUNO].SetTS( iValue ) ;
		default:
			assert( 0 ) ;
		}
		assert( 0 ) ;
		return 0 ;
	}
	void SetObjParamPointer( unsigned char *pucParamOut , int *piParamOut , int iOUNO=0 )
	{
		assert( iOUNO==0 || iOUNO==1 ) ;
		OU[iOUNO].SetParamPointer( pucParamOut , piParamOut ) ;
	}
	void ReleaseObjParamPointer( unsigned char *pucParamOut , int *piParamOut , int iOUNO=0 )
	{
		assert( iOUNO==0 || iOUNO==1 ) ;
		OU[iOUNO].ReleaseParamPointer( pucParamOut , piParamOut ) ;
	}
	void SetObjDeltaYList( int (*paiSrc)[256] , int iOUNO=0 )
	{
		assert( iOUNO==0 || iOUNO==1 ) ;
		OU[iOUNO].ClearDeltaYList() ;
		OU[iOUNO].SetDeltaYList( paiSrc ) ;
	}
	int IsValid(){ return iIsValid ; }
	int IsEditObject(){ return iIsEditObject ; }

protected:
	/*変数*/
	/*変数/ステージ情報*/
	int iEditMode ;
	int iStageNO ;
	int iVersion ;
	int aiMultiplexOriginalPage[2] ;
	int iIsValid ;

	unsigned char aucChipMap[ ciMaxAllocatePage*ciChipPPageS*ciLayers ] ;
	unsigned char aucChip[ ciMaxAllocateChip*ciGrapPChipS ] ;
	unsigned char aucChipHit[ ciMaxAllocateChip ] ;

	unsigned char aucVChip[ ciMaxAllocateChip*ciGrapPChipS ] ;
	unsigned char aucVChipHit[ ciMaxAllocateChip ] ;
	unsigned char aucVChipValid[ ciMaxAllocateChip ] ;

	unsigned char aucSpData[ ciMaxAllocateSpData ] ;

	unsigned char aucPreTile    [ ciMaxAllocateTile*ciChipPTileS ] ;
	unsigned char aucPreTileHit [ ciMaxAllocateTile*ciChipPTileS ] ;
	unsigned char aucPreTileFlag[ ciMaxAllocateTile ] ;
	unsigned char aucPrePage    [ ciMaxAllocatePage*ciTilePPageS] ;
	unsigned char aucPrePageFlag[ ciMaxAllocateTile ] ;

	ObjectUnit OU[3] ; //[0]標準 [1]1の後半/2のアイテム [2]ワーキング

	/*↓iEditMode/iStageNO(シリーズ番号/ステージ数)依存であり、セーブはされない*/
	int iAddrPageList ;
	int iAddrPageAddrList ;
	int iAddrObjectSuffixList ;
	int iMaxPageList ;
	int aiAddrObjectPage[2] ;
	int aiAddrObjectX[2] ;
	int aiAddrObjectY[2] ;
	int aiAddrObjectType[2] ;
	int iMaxObjectAlloc ;
	int aiMaxObject[2] ;
	int iAddrChip ;
	int iAddrChipHit ;
	int iMaxChip ;
	int iAddrTile ;
	int iMaxTile ;
	int iAddrPage ;
	int iMaxPage ;
	int iAddrTileColor ; //1,2用タイルの色
	int iProcessPageCount ;
	int iMultiplexStage ;
	int aiMultiplexStage_DeltaAddr[2] ;
	int iImportObject ;
	int iExportObject ;
	int iIsEditObject ;
	int iExportPageList ;
	int iTilingMethod ;
	int iHaveVChip ;
	int iChipMethod ;
	int ObjectStoreMethod ;
	int iPreTileMethod ;
	/*↑iEditMode/iStageNO(シリーズ番号/ステージ数)依存であり、セーブはされない*/

	/*変数/編集関係*/
	int iX , iY ;
	int iViewPatNO ;
	int iViewPatGraph[ciMaxViewPat*16] ;
	unsigned char iViewPatColor[ciMaxViewPat*16] ;
	VersatileTileEditor_Lua<unsigned char> *pVTE;
	tstring strFileName ;


	unsigned char *pucRom ;
	int iRomSize ;
	unsigned char *pucRomOrg ;
	int iRomSizeOrg ;
	/*変数/画像処理関係*/
	int iSfcChr ;
	int iSfcChip ;
	int iSfcChipInfo ;
	int iSfcTmp ;
	BMPD *pNESPal ;
	int iDrawMode ;
	int iDrawModeUnusedChip ;
	int iDrawPageNo ;
	int iPreDrawMode ;
	int iUpdateChr ;
	int iUpdateChip ;

	/*関数*/
	//ROMアクセス系
#include "SafeRomIO.h"
#define SAFE_ROM_IO_DEST   pucRom+0x10
#define SAFE_ROM_IO_SIZE   pucRom[4]*0x4000
#define SAFE_ROM_IO_SUF(a) a##p
#include "SafeRomIO.h"
#define SAFE_ROM_IO_DEST   pucRom+0x10+pucRom[4]*0x4000
#define SAFE_ROM_IO_SIZE   pucRom[5]*0x2000
#define SAFE_ROM_IO_SUF(a) a##c
#include "SafeRomIO.h"
#define SAFE_ROM_IO_DEST   pucRomOrg+0x10
#define SAFE_ROM_IO_SIZE   pucRomOrg[4]*0x4000
#define SAFE_ROM_IO_SUF(a) a##o
#include "SafeRomIO.h"

	TextIOManager *GetTIOM( LPCTSTR ptcFilename , unsigned char *pucObjectImage , int iObjectImageSize , int iLoadMode ) ;
	void UpdateVTE() ;
	unsigned char *OpenPPUFile() ;

	int GetPreTileOffsetByTNCN( int iTN , int iCN ){ return iTN/16*0x40+iTN%16*2+iCN/2*0x20+iCN%2; }
	int GetChipOffsetPerTilingMethod( int iTileNo ) ;

	//グラフィックパターン作成系　RockStage_setgrp.cpp
	void SetupGraphicsPattern() ;
	void SetupGraphicsPattern1() ;
	void SetupGraphicsPattern2() ;
	void SetupGraphicsPattern3() ;
	void SetupGraphicsPattern4() ;
	void SetupGraphicsPattern5() ;
	void SetupGraphicsPattern6() ;

	//タイル作成/出力系　RockStage_export2rom.cpp
	int ExportToRom_sub_Chip( unsigned char *pucRomMask ) ;
	int ExportToRom_sub_Object( unsigned char *pucRomMask , int *piOutObjSize , int *piOutMaxSize ) ;
	int ExportToRom_sub_Tile( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , unsigned char *pucRomMask ) ;
	int ExportToRom_sub_SpData( unsigned char *pucRomMask ) ;

	void Rock12_Setup5ByteTile( unsigned char *pucOut , unsigned char *pucColNO , unsigned char *pucHit , int iPage ) ;
	void Rock12_GetHitPattern( int *piOut , int iTileOffset ) ;
	void Rock1_GetHitPattern( int *piOut , int iTileOffset ) ;
	void Rock2_GetHitPattern( int *piOut , int iTileOffset ) ;
	int Rock12_SetupTile( int *piExpTile , int *piTile , unsigned char *pucWholeTile , int iTiles ) ;
	void Rock12_SetupWholeTile( unsigned char *aucWholeTile ) ;
	void Rock12_SetupListOfRoomPerPage( int *piOut ) ;
	void Rock1_SetupListOfRoomPerPage( int *piOut ) ;
	void Rock2_SetupListOfRoomPerPage( int *piOut ) ;

	int CulcPageTileAmount_sub_1( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile ) ;
	int CulcPageTileAmount_sub_2( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile ) ;
	int CulcPageTileAmount_sub_3( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile ) ;
	int CulcPageTileAmount_sub_4( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile ) ;
	int CulcPageTileAmount_sub_5( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile ) ;
	int CulcPageTileAmount_sub_6( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piOutPrePage , int *piOutPreTile ) ;
	int ExportToRom_sub_Tile12( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , unsigned char *pucRomMask ) ;
	int ExportToRom_sub_Tile3456( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , unsigned char *pucRomMask ) ;
	//タイル作成の中心　RockStage_Tiling.cpp
	void SetupTileImage( int *piOut , int iT ) ;
	void SetupTileImage( unsigned char *pucOut , int iT ) ;
	void DoTiling12_sub_Setup5ByteTileByPreTile( unsigned char *pucOut , int iT , int (*pa2iChipHitOfCurStage)[4] ) ;
	int DoTiling12( 
		int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piPrePage , int *piPreTile ,
		unsigned char **ppucOutPageList , unsigned char **ppucOutPage , unsigned char **ppucOutTile , unsigned char **ppucOutTileColor ) ;
	int DoTiling3456( 
		int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piPrePage , int *piPreTile ,
		unsigned char **ppucOutPageList , unsigned char **ppucOutPage , unsigned char **ppucOutTile ) ;

};


#endif /*ROCK_STAGE_HEADER_INCLUDED*/
