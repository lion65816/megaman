#include "RockStage_p.h"
#include "mymemorymanage.h"
#include "HT/NESSys.h"

const int RockStage::aciNOStage[6] = {6,8,0x14,0x15,0x12,0x10} ;

VersatileTileEditor_Lua<unsigned char> *(VersatileTileEditor_Lua<unsigned char>::pProcessing) ;



void RockStage::SetRom( unsigned char *pucRom , int iRomSize )
{
	this->pucRom = pucRom ;
	this->iRomSize = iRomSize ;
	CorrectEditModeStageNORomDependedValue() ;
}
void RockStage::SetEditMode( int iEditMode )
{
	this->iEditMode = iEditMode ;
	CorrectEditModeStageNORomDependedValue() ;
}
void RockStage::Clear()
{
	iEditMode = 0 ;
	iStageNO = 0 ;
	aiMultiplexOriginalPage[0] = aiMultiplexOriginalPage[1] = -1 ;
	iIsValid = 0 ;
	memset( aucChipMap , 0x00 , sizeof(aucChipMap) ) ;
	memset( aucChip , 0x00 , sizeof(aucChip) ) ;
	memset( aucChipHit , 0x00 , sizeof(aucChipHit) ) ;
	memset( aucSpData , 0x00 , sizeof(aucSpData) ) ;
	memset( aucPreTile     , 0x00 , sizeof(aucPreTile    ) ) ;
	memset( aucPreTileHit  , 0x00 , sizeof(aucPreTileHit ) ) ;
	memset( aucPreTileFlag , ciLF_Default , sizeof(aucPreTileFlag) ) ;
	memset( aucPrePage     , 0x00 , sizeof(aucPrePage    ) ) ;
	memset( aucPrePageFlag , ciLF_Default , sizeof(aucPrePageFlag) ) ;


	memset( aucVChip , 0x00 , sizeof(aucVChip) ) ;
	memset( aucVChipHit , 0x00 , sizeof(aucVChipHit) ) ;
	memset( aucVChipValid , 0x00 , sizeof(aucVChipValid) ) ;
	iAddrPageList =
	iAddrObjectSuffixList =
	iMaxPageList =
	aiAddrObjectPage[0] = aiAddrObjectPage[1] =
	aiAddrObjectX[0] = aiAddrObjectX[1] =
	aiAddrObjectY[0] = aiAddrObjectY[1] =
	aiAddrObjectType[0] = aiAddrObjectType[1] =
	iMaxObjectAlloc =
	aiMaxObject[0] = aiMaxObject[1] =
	iAddrChip =
	iAddrChipHit =
	iMaxChip =
	iAddrTile =
	iMaxTile =
	iAddrPage =
	iMaxPage = 
	iAddrTileColor =
	iProcessPageCount =
	iProcessPageCount =
	iMultiplexStage =
	aiMultiplexStage_DeltaAddr[0] =
	aiMultiplexStage_DeltaAddr[1] =
	iImportObject =
	iExportObject =
	iIsEditObject =
	iExportPageList =
	iTilingMethod =
	iHaveVChip =
	iChipMethod = 
	0 ;

	iX = iY = 0 ;
	iViewPatNO = 0 ;
	memset( iViewPatGraph , 0x00 , sizeof(iViewPatGraph) ) ;
	memset( iViewPatColor , 0x00 , sizeof(iViewPatColor) ) ;
	OU[0].Clear() ;
	OU[1].Clear() ;
	OU[2].Clear() ;
	if( pVTE ){ delete pVTE ; pVTE = NULL ; }
	pucRom = NULL ;
	iRomSize = 0 ;


	iDrawMode = 0 ;
	iDrawModeUnusedChip = 0 ;
	iPreDrawMode = -1 ;
	iUpdateChr = iUpdateChip = 1 ;
}

int RockStage::Save( LPCTSTR filename )
{
	if( !iIsValid ){ return -1; }
	if( filename ){ strFileName = filename ; }
	
	unsigned char aucObjectImage[0x100*8] ;
	{ //オブジェクトイメージの作成
		memset( aucObjectImage , 0xFF , sizeof(aucObjectImage) ) ;
		OU[0].ExportToROM( iEditMode , aucObjectImage+0x000 , aucObjectImage+0x100 , aucObjectImage+0x200 , aucObjectImage+0x300 , iMaxObjectAlloc ) ;
		OU[1].ExportToROM( iEditMode , aucObjectImage+0x400 , aucObjectImage+0x500 , aucObjectImage+0x600 , aucObjectImage+0x700 , iMaxObjectAlloc ) ;
	}
	TextIOManager *pTIOM = GetTIOM( strFileName.c_str() , aucObjectImage , sizeof(aucObjectImage) , 0 ) ;
	int iRV = pTIOM->DoSaving() ;
	delete pTIOM ;
	return iRV ;
}

int RockStage::Load( LPCTSTR filename )
{
	Clear() ;
	unsigned char aucObjectImage[0x100*8] ;
	TextIOManager *pTIOM = GetTIOM( filename , aucObjectImage , sizeof(aucObjectImage) , 1 ) ;
	int iRV = pTIOM->DoLoading() ;
	delete pTIOM ;
	if( !iRV )
	{
		strFileName = filename ;
		//この段階ではRomがセットされているとは限らない
		CorrectEditModeStageNODependedValue() ;
		OU[0].Initialize(iMaxObjectAlloc,iEditMode) ;
		OU[0].SetPositionLimit( 0 , 0 , iProcessPageCount*256-1 , 255 ) ;
		OU[0].ImportFromROM( iEditMode , aucObjectImage+0x000 , aucObjectImage+0x100 ,
						aucObjectImage+0x200 , aucObjectImage+0x300 ,
						aiMaxObject[0] , iProcessPageCount ) ;
		OU[1].Initialize(iMaxObjectAlloc,iEditMode) ;
		OU[1].SetPositionLimit( 0 , 0 , iProcessPageCount*256-1 , 255 ) ;
		OU[1].ImportFromROM( iEditMode , aucObjectImage+0x400 , aucObjectImage+0x500 ,
						aucObjectImage+0x600 , aucObjectImage+0x700 ,
						aiMaxObject[1] , iProcessPageCount ) ;
		UpdateVTE() ;
		iIsValid = 1 ;
	}
	return iRV ;
}
void RockStage::CorrectEditModeStageNODependedValue()
{
	int iE = iEditMode-1 ;
	int iS = iStageNO ;

	{
		static const int aciAdPLB[] = { 0x008C00, 0/*無*/,0x00AA00,0x20B500,0x00A900, 0/*無*/} ;
		static const int aciAdPLD[] = { 0x020000, 0/*無*/,0x010000,0x010000,0x010000, 0/*無*/} ;
		iAddrPageList = aciAdPLB[iE] + aciAdPLD[iE]*iS ;
	}
	{
		static const int aciAdPALB[] = { 0x008C30, 0/*無*/,0/*無*/,0/*無*/,0/*無*/,0/*無*/} ;
		static const int aciAdPALD[] = { 0x020000, 0/*無*/,0/*無*/,0/*無*/,0/*無*/,0/*無*/} ;
		iAddrPageAddrList = aciAdPALB[iE] + aciAdPALD[iE]*iS ;
	}
	{
		static const int aciAdOSLB[] = { 0/*無*/, 0/*無*/,0/*無*/,0x20B300,0x00AC00, 0/*無*/} ;
		static const int aciAdOSLD[] = { 0/*無*/, 0/*無*/,0/*無*/,0x010000,0x010000, 0/*無*/} ;
		iAddrObjectSuffixList = aciAdOSLB[iE] + aciAdOSLD[iE]*iS ;
	}
	{
		static const int aciMPL[] = {0x30,0/*無*/,0x30,0x30,0x50,0/*無*/} ;
		iMaxPageList = aciMPL[iE] ;
	}
	{
		static const int aciAdOPB[] = {-1/*ROM依存*/,0x01B600,0x00AB00,0x20B100,0x00AA00,-1/*ROM依存*/} ;
		static const int aciAdOPD[] = {-1/*ROM依存*/,0x020000,0x010000,0x010000,0x010000,-1/*ROM依存*/} ;
		aiAddrObjectPage[0] = aciAdOPB[iE] + aciAdOPD[iE]*iS ;
	}
	{
		static const int aciAdOXB[] = {-1/*ROM依存*/,0x01B700,0x00AC00,0x20B180,0x00AA80,-1/*ROM依存*/} ;
		static const int aciAdOXD[] = {-1/*ROM依存*/,0x020000,0x010000,0x010000,0x010000,-1/*ROM依存*/} ;
		aiAddrObjectX[0] = aciAdOXB[iE] + aciAdOXD[iE]*iS ;
	}
	{
		static const int aciAdOYB[] = {-1/*ROM依存*/,0x01B800,0x00AD00,0x20B200,0x00AB00,-1/*ROM依存*/} ;
		static const int aciAdOYD[] = {-1/*ROM依存*/,0x020000,0x010000,0x010000,0x010000,-1/*ROM依存*/} ;
		aiAddrObjectY[0] = aciAdOYB[iE] + aciAdOYD[iE]*iS ;
	}
	{
		static const int aciAdOTB[] = {-1/*ROM依存*/,0x01B900,0x00AE00,0x20B280,0x00AB80,-1/*ROM依存*/} ;
		static const int aciAdOTD[] = {-1/*ROM依存*/,0x020000,0x010000,0x010000,0x010000,-1/*ROM依存*/} ;
		aiAddrObjectType[0] = aciAdOTB[iE] + aciAdOTD[iE]*iS ;
	}
	{
		static const int aciMO[] = {0x80/*とりあえず128個にしておく*/,0x100,0xC0,0x80,0x80,0x80/*とりあえず128個にしておく*/} ;
		aiMaxObject[0] = iMaxObjectAlloc = aciMO[iE] ;
	}
	{
		static const int aciMO2[] = {0x80/*とりあえず128個にしておく*/,0x40,0,0,0,0} ;
		aiMaxObject[1] = aciMO2[iE] ;
		if( iEditMode==2 )
		{
			aiAddrObjectPage[1] = 0x01BA00 + 0x020000*iS ;
			aiAddrObjectX[1]    = 0x01BA40 + 0x020000*iS ;
			aiAddrObjectY[1]    = 0x01BA80 + 0x020000*iS ;
			aiAddrObjectType[1] = 0x01BAC0 + 0x020000*iS ;
		}
	}
	{
		
	}
	{
		static const int aciAdCB[] = {-2/*無*/,-2/*無*/,0x00BB00,0x20A000,0x00AD00,-1/*ROM依存*/} ;
		static const int aciAdCD[] = {-2/*無*/,-2/*無*/,0x010000,0x010000,0x010000,-1/*ROM依存*/} ;
		iAddrChip = aciAdCB[iE] + aciAdCD[iE]*iS ;
	}
	{
		static const int aciAdCHB[] = {-2/*無*/,-2/*無*/,0x00BF00,0x20A400,0x00B100,-1/*ROM依存*/} ;
		static const int aciAdCHD[] = {-2/*無*/,-2/*無*/,0x010000,0x010000,0x010000,-1/*ROM依存*/} ;
		iAddrChipHit = aciAdCHB[iE] + aciAdCHD[iE]*iS ;
	}
	iMaxChip = 256 ;
	{
		static const int aciAdTB[] = {0x008000,0x008000,0x00B700,0x20A500,0x00B200,-1/*ROM依存*/} ;
		static const int aciAdTD[] = {0x020000,0x020000,0x010000,0x010000,0x010000,-1/*ROM依存*/} ;
		iAddrTile = aciAdTB[iE] + aciAdTD[iE]*iS ;
	}
	{
		static const int aciMT[] = {192,256,256,256,256,256} ;
		iMaxTile =  aciMT[iE] ;
	}
	{
		static const int aciAdPB[] = {0x0083C0,0x008500,0x00AF00,0x20A900,0x00B600,-1/*ROM依存*/} ;
		static const int aciAdPD[] = {0x020000,0x020000,0x010000,0x010000,0x010000,-1/*ROM依存*/} ;
		iAddrPage = aciAdPB[iE] + aciAdPD[iE]*iS ;
	}
	{
		static const int aciMP[] = {0x20,0x2C,0x20,0x20,0x28,0x20} ;
		iMaxPage = aciMP[iE] ;
	}
	iProcessPageCount = max(iMaxPageList,iMaxPage) ;
	{
		static const int aciAdB[] = {0x008300,0x008400,-1/*無*/,-1/*無*/,-1/*無*/,-1/*無*/} ;
		static const int aciAdD[] = {0x020000,0x020000,-1/*無*/,-1/*無*/,-1/*無*/,-1/*無*/} ;
		iAddrTileColor = aciAdB[iE] + aciAdD[iE]*iS ;
	}
	{
		static const int aciTM[] = {3,2,0,0,0,1} ;
		iTilingMethod = aciTM[iE] ;
	}
	{
		static const int aciExpPL[] = {0,0,1,1,1,0} ;
		iImportObject = iExportObject = iIsEditObject = 1 ;
		iExportPageList = aciExpPL[iE] ;
	}
	{
		static const int aciHVC[] = {0,0,0,0,0,1} ;
		iHaveVChip = aciHVC[iE] ;
	}
	{
		static const int aciChipMethod[] = {2,1,0,0,0,0} ;
		iChipMethod = aciChipMethod[iE] ;
	}
	{
		static const int aciObjectStoreMethod[] = {1,0,0,0,0,0} ;
		ObjectStoreMethod = aciObjectStoreMethod[iE] ;
	}
	{
		static const int aciPreTileMethod[] = {1,1,0,0,0,0} ;
		iPreTileMethod = aciPreTileMethod[iE] ;
	}


	iMultiplexStage = -1 ;
	aiMultiplexStage_DeltaAddr[0] = aiMultiplexStage_DeltaAddr[1] = -1 ;
	/*微補正*/
	switch( iEditMode )
	{
	case 3:
		{
			switch( iS )
			{
			case 0x0D:
				{
					iMultiplexStage = iEditMode*100 + iS ;
					aiMultiplexStage_DeltaAddr[0]=0x10000 ;
					aiMultiplexStage_DeltaAddr[1]=0x30000 ;
				}
			break ;
			case 0x0E:case 0x10:case 0x13:
				iAddrPageList=iMaxPageList=0;
				iProcessPageCount = iMaxPage = 0x20 ;
				iExportObject=iIsEditObject=iExportPageList=0 ;
			break ;
			}
		}
	break ;
	case 5:
		{
			switch( iS )
			{
			case 0x08:case 0x0E:
				{
					iMultiplexStage = iEditMode*100 + iS ;
					if( iS == 0x08 ){ aiMultiplexStage_DeltaAddr[0]=0x030000; }
					else { aiMultiplexStage_DeltaAddr[0]=0x010000; }
				}
			break ;
			case 0x0B:case 0x0F:case 0x10:case 0x11: 
				iExportObject=iIsEditObject=iExportPageList=0 ; 
				iProcessPageCount = iMaxPage ;
			break ;
			}
		}
	break;
	default:
		;
	}

}
void RockStage::CorrectEditModeStageNORomDependedValue()
{
	CorrectEditModeStageNODependedValue() ;
	if( !pucRom ){ return ;}
	int iE = iEditMode-1 ;
	int iS = iStageNO ;
	if( iEditMode==1 )
	{ //１はROM中からオブジェクトデータを読まなければならない
		for( int iL=0 ; iL<2 ; iL++ )
		{
			if( iL && iS >= 4 )
			{
				aiMaxObject[1] = 0 ;
				break ;
			}

			int iAddr = 0x0DA452+iL*6*2+iS*2 ;
			/*
			aiMaxObject[iL] = GetROM16p(iAddr+2)-GetROM16p(iAddr) ;
			if( aiMaxObject[iL]<0 )
			{
				aiMaxObject[iL] = 0 ;
			}
			assert( aiMaxObject[iL]%4==1 ) ;
			aiMaxObject[iL] /= 4 ;
			*/
			iAddr = 0x0D0000 + GetROM16p(iAddr) ;
			aiAddrObjectPage[iL] = iAddr+0 ;
			aiAddrObjectX[iL]    = iAddr+1 ;
			aiAddrObjectY[iL]    = iAddr+2 ;
			aiAddrObjectType[iL] = iAddr+3 ;
			aiMaxObject[iL] = 0 ;
			for( int iO=0 ; iO<iMaxObjectAlloc ; iO++ )
			{
				if( GetROM8p(aiAddrObjectPage[iL]+iO*4)>=iProcessPageCount )
				{ break; }
				aiMaxObject[iL] = iO + 1 ;
			}
		}
	}
	if( iEditMode==6 )
	{ //６はROM中から読まなければならない
		aiMaxObject[0] = GetROM8p(0x3A80DF+iS)+1 ; //FFの分を含む
		int iAddr ;
		iAddr = 0x3A0000 + GetROM8p(0x3A80CF+iS)*256 + GetROM8p(0x3A80BF+iS) + 1 ;
		aiAddrObjectPage[0] = iAddr+aiMaxObject[0]*0 ;
		aiAddrObjectX[0]    = iAddr+aiMaxObject[0]*1 ;
		aiAddrObjectY[0]    = iAddr+aiMaxObject[0]*2 ;
		aiAddrObjectType[0] = iAddr+aiMaxObject[0]*3 ;
		iAddrPage = GetROM8p(0x3EDF25+iS)*0x10000 + GetROM8p(0x3EDF45+iS) *0x100 
		            + GetROM8p(0x3EDF35+iS) ;
		iAddrChip = GetROM8p(0x3EDF55+iS)*0x10000 + GetROM8p(0x3EDF65+iS) *0x100 ;
		iAddrChipHit = iAddrChip+0x400 ;
		iAddrTile = GetROM8p(0x3EDF55+iS)*0x10000 + GetROM8p(0x3EDF75+iS) *0x100 ;
		aiMaxObject[0]-- ;//編集としてはFFの分を含まない
	}
}


void RockStage::DrawChr( MyDIBObj3 *pMDO )
{
	iUpdateChip = 1 ;
	iUpdateChr = 0 ;
	{//ppuファイルの読み込み
		unsigned char *pucBuf = OpenPPUFile() ;
		if( pucBuf )
		{
			static const int aciBGAddr[6] = {0x0000,0x0000,0x0000,0x0000,0x0000,0x0000,} ;
			for( int i=0 ; i<256 ; i++ )
			{
				DrawNESCharacter( pucBuf+i*0x10 , iSfcChr , i%16*8 , i/16*8 , false , 1 ) ;
			}
			free( pucBuf ) ;
			return ;
		}
	}
	int iCurAddr = -1 ;
	for( int i=0 ; i<256 ; i++ )
	{
		if( i%16==0 )
		{
			int iTmp = iViewPatGraph[iViewPatNO*16+i/16] ;
			if( iTmp>=0 )
			{
				iCurAddr = iTmp ;
			}
		}
		unsigned char *pSrc ;
		if( GetROM8(5) ){ pSrc=ROMc(0)+iCurAddr ; }
		else{  pSrc=ROMp( iCurAddr );  }
		DrawNESCharacter( pSrc , iSfcChr , i%16*8 , i/16*8 , false , 1 ) ;
		iCurAddr += 0x10 ;
	}
}
void RockStage::DrawChip( MyDIBObj3 *pMDO , int iVMode , int iFlag )
{
	iUpdateChip = 0 ;

	unsigned char *pucChip = aucChip ;
	unsigned char *pucChipHit = aucChipHit ;

	if( iVMode )
	{//変化チップモード
		pucChip = aucVChip ;
		pucChipHit = aucVChipHit ;
	}

	BMPD color[16] ;
	switch( iDrawMode )
	{
	case 0:
		{
			unsigned char *pucBuf = OpenPPUFile() ;
			if( pucBuf )
			{
				for( int i=0 ; i<16 ; i++ )
					color[i] =  pNESPal[pucBuf[0x3F00+i]&0x3F] ;
				free( pucBuf ) ;
			}
			else
			{
				for( int i=0 ; i<16 ; i++ )
					color[i] = pNESPal[iViewPatColor[iViewPatNO*16+i]&0x3F] ;

			}
		}
	break ;
	case 1:
		{
			BMPD BW1[4] = {myRGB(0,0,0),myRGB(31,31,31),myRGB(20,20,20),myRGB(10,10,10)} ;
			for( int i=0 ; i<16 ; i++ )
				color[i] = BW1[i%4] ;
		}
	break ;
	case 2:
		{
			BMPD BW2[4] = {myRGB(0,0,0),myRGB(12,12,12),myRGB(8,8,8),myRGB(4,4,4)} ;
			for( int i=0 ; i<16 ; i++ )
				color[i] = BW2[i%4] ;
		}
	break ;
	}
	MDO3Opt topt = *MDO3normal ;
	topt.flag |= MDO3F_USE_COLOR_TABLE ;
	for( int i=0 ; i<256 ; i++ )
	{
		topt.PBMPD = color+(pucChipHit[i]&3)*4;
		for( int q=0 ; q<4 ; q++ )
		{
			int ix , iy , itn ,  isx , isy ;
			ix = i%8*16 + q%2*8 ;
			iy = i/8*16 + q/2*8 ;
			itn =  pucChip[ q*0x100+i ] ;
			isx = itn%16*8 ;
			isy = itn/16*8 ;
			pMDO->Blt( &topt , iSfcChip , ix , iy , 8 , 8 , iSfcChr , isx , isy ) ;
		}
		if( !(iFlag&1) && iDrawMode==2 )
		{
			int iChipHitValue = pucChipHit[i]/16 ;
			if( iEditMode==6 )
			{
				iChipHitValue = GetROM8p( aucSpData[0x1E0]*0x10 + 0x3EDB13 + iChipHitValue ) & 0x1F ;
			}
			pMDO->Blt( MDO3normal , iSfcChip , i%8*16 , i/8*16 , 16 , 16 , iSfcChipInfo , iChipHitValue%16*16 , ((iEditMode-1)+iChipHitValue/16)*16 ) ;
			if( pucChipHit[i]&0x08 )
				pMDO->Text( iSfcChip , _T("8") , i%8*16+2 , i/8*16+2 , 10 , 5 , RGB(255,255,255) ) ;
			if( pucChipHit[i]&0x04 )
				pMDO->Text( iSfcChip , _T("4") , i%8*16+9 , i/8*16+2 , 10 , 5 , RGB(255,255,255) ) ;
		}
		if( iVMode && !aucVChipValid[i] )
		{
			MDO3Opt topt = *MDO3normal ;
			topt.flag |= MDO3F_BLEND ;
			topt.alpha = 0xC0 ;
			pMDO->Cls( &topt , iSfcChip , i%8*16 , i/8*16 , 16 , 16 , myRGB(0,0,0) ) ;
			pMDO->Line( MDO3normal , iSfcChip , i%8*16 , i/8*16+ 0 , i%8*16+15 , i/8*16+15 , myRGB(31,0,0)  ) ;
		}
		if( iDrawModeUnusedChip )
		{
			int q ;
			for( q=0 ; q<_countof(aucChipMap) ; q++ )
			{
				if( aucChipMap[q] == i ){ break; }
			}
			if( q == _countof(aucChipMap) )
			{
				int ix , iy ;
				ix = i%8*16 ;
				iy = i/8*16 ;
				pMDO->Line( MDO3normal , iSfcChip , ix+ 0 , iy+ 0 , ix+15 , iy+15 , myRGB(0,31,0)  ) ;
				pMDO->Line( MDO3normal , iSfcChip , ix+ 0 , iy+15 , ix+15 , iy+ 0 , myRGB(31,0,0)  ) ;
			}
		}
	}
}
void RockStage::UpdateSFC( MyDIBObj3 *pMDO , int iVChip )
{
	if( iUpdateChr )
	{ DrawChr( pMDO ) ;}
	if( iUpdateChip )
	{ DrawChip( pMDO , iVChip , 0 ) ;}
}
void RockStage::Draw( MyDIBObj3 *pMDO , int iSfc , int x , int y , int iDrawEditor , int iDrawMap , int iDrawObject , int iVChip )
{
	if( !iIsValid ){return;}
	UpdateSFC( pMDO , iVChip ) ;
	pVTE->SetPosition( x , y ) ;
	if( iDrawMap>0 )
	{
		pVTE->DrawMap( pMDO , iSfc , 16 , 16 , 1 ) ;
		if( iDrawPageNo )
		{
			for( int i=0 ; i<iProcessPageCount ; i++ )
			{
				int iX = x+256*i ;
				if( iX>=0 && iX<1024*4 )
				{
					_TCHAR atcTmp[32] ;
					_stprintf_s( atcTmp , _countof(atcTmp) , _T("%02X") , i ) ;
					pMDO->BoxMoji( iSfc , atcTmp , x+256*i , y+256 , 24 , 12 , RGB(255,255,255) , RGB(0,0,0) ) ;
				}
			}
		}
	}
	if( iDrawObject>0 ){ if(iDrawObject==1){OU[0].Draw( pMDO , iSfc , x , y ) ;}else{OU[1].Draw( pMDO , iSfc , x , y ) ;} }
	if( iDrawEditor>0 ){ pVTE->DrawEditor( pMDO , iSfc ) ; }
}
void RockStage::SaveBitmapChip( MyDIBObj3 *pMDO , LPCTSTR filename )
{
	pMDO->SaveBitmapFile( filename , iSfcChip ) ;
}
void RockStage::SaveBitmapPage( MyDIBObj3 *pMDO , LPCTSTR filename )
{
	pMDO->CreateSurface( iSfcTmp , ciDotPPageW*iProcessPageCount , ciDotPPageH*ciLayers ) ;
	Draw( pMDO , iSfcTmp , 0 , 0 , 0 , 1 , 0 , 0 ) ;
	pMDO->SaveBitmapFile( filename , iSfcTmp ) ;
	pMDO->ReleaseSurface( iSfcTmp ) ;
}
void RockStage::SaveBitmapMap ( MyDIBObj3 *pMDO , LPCTSTR filename )
{
	static const int ciMaxRoom = 128 ;
	static const int ciListSize = 128 ;
	static const int ciListCenter = (ciListSize/2*ciListSize+ciListSize/2) ;
	int aiPagePos[ciMaxRoom] ;
	int aiPageList[ciListSize*ciListSize] ;
	for( int i=0 ; i<_countof(aiPagePos) ; i++ ){ aiPagePos[i]=-1; }
	for( int i=0 ; i<_countof(aiPageList) ; i++ ){ aiPageList[i]=-1; }

	UpdateSFC( pMDO , 0 ) ;

//	aiPagePos[0] = ciListCenter ;
//	aiPageList[ciListCenter] = 0 ;


	switch( iEditMode )
	{
	case 1:
	case 2:
		{
			static const int aciMaxRoom[2] = { R1_MaxRoom , R2_MaxRoom } ;
			static const int aciRoomConnectionOffset[2] = { SPOf1_RoomConnection , SPOf2_RoomConnection } ;
			static const int aciFirstRoom[2] = { 1 , 0 } ;
			const int ciMaxRoom = aciMaxRoom[ iEditMode==2 ] ;
			const int ciRoomConnectionOffset = aciRoomConnectionOffset[ iEditMode==2 ] ;
			const int ciFirstRoom = aciFirstRoom[ iEditMode==2 ] ;

			int iCurPos = ciListCenter ;
			int iCurPage = 0 ;
			int iStg = 0 ;
			for( int iR=ciFirstRoom ; iR<ciMaxRoom ; iR++ )
			{
				int iRaw = aucSpData[ciRoomConnectionOffset+iR] ;
				int iSize = (iRaw&0x1F)+1 ;
				int iCon = (iRaw&0xE0) ;
				for( int iS=0 ; iS<iSize ; iS++ )
				{
					if( iCurPage>=_countof(aiPagePos) ){break;}
					if( iCurPos>=_countof(aiPageList) ){break;}
					aiPagePos[iCurPage] = iCurPos ;
					aiPageList[iCurPos] = iCurPage ;
					iCurPage++ ;
					if( iS<iSize-1 )
					{
						iCurPos++;
					}
				}
				switch( iCon )
				{
				case 0x20:
				case 0x60:
				case 0xA0:
				case 0xE0:
					iCurPos++;break ;
				case 0x40:
				case 0xC0:
					iCurPos+=ciListSize;break ;
				break;
				case 0x80:
					iCurPos-=ciListSize;break ;
				break;
				}
				if( !iCon )
				{
					if( !iStg )
					{
						iCurPos++ ;
						iStg++ ;
						if( iEditMode==2 )
						{
							iR = aucSpData[SPOf2_CP_Room+3] - 1 ;
							iCurPage = aucSpData[SPOf2_StageBorder] ;
						}
					}
					else
					{
						break;
					}
				}

			}
		}
	break;
	case 3:
	{
		int iCurPos = ciListCenter-1 ;
		int iCurPage = 0 ;
		for( int iR=0 ; iR<R3_MaxRoom ; iR++ )
		{
			int iRaw = aucSpData[SPOf3_RoomConnection+iR] ;
			int iSize = (iRaw&0x1F)+1 ;
			int iCon = (iRaw&0xE0) ;
			if( !iCon || iCon>=0xC0 ){break;}
			switch( iCon )
			{
			case 0x20:
				iCurPos++;break ;
			case 0x40:
			case 0x60:
				iCurPos+=ciListSize;break ;
			break;
			case 0x80:
			case 0xA0:
				iCurPos-=ciListSize;break ;
			break;
			}
			for( int iS=0 ; iS<iSize ; iS++ )
			{
				if( iCurPage>=_countof(aiPagePos) ){break;}
				if( iCurPos>=_countof(aiPageList) ){break;}
				aiPagePos[iCurPage] = iCurPos ;
				aiPageList[iCurPos] = iCurPage ;
				iCurPage++ ;
				if( iS<iSize-1 )
				{
					switch( iCon )
					{
					case 0x40:iCurPos+=ciListSize;break ;
					case 0x80:iCurPos-=ciListSize;break ;
					default:iCurPos++;break ;
					}
				}
			}
		}
	}
	break;
	case 4:
	case 5:
	{
		int iCurPos = ciListCenter-1 ;
		int iCurPage = 0 ;
		int iBranchAfter = 0 ;
		int iBranches = (iEditMode==4) ? 4 : 5 ;
		int iSPOF_RC  = (iEditMode==4) ? SPOf4_RoomConnection : SPOf5_RoomConnection ;
		int iSPOF_Br  = (iEditMode==4) ? SPOf4_Branch : SPOf5_Branch ;
		int iMaxRoom  = (iEditMode==4) ? R4_MaxRoom : R5_MaxRoom ;
		int iOfBrDt_r  = (iEditMode==4) ? 2 : 3 ;
		int iOfBrDt_p  = (iEditMode==4) ? 3 : 2 ;
		for( int iB=-1 ; iB<iBranches ; iB++ )
		{
			int iRorg ;
			if( iB==-1 )
			{
				iRorg = 0 ;
			}
			else
			{
				if( aucSpData[iSPOF_Br+iB*4+0]>=iProcessPageCount ){break;}
				iCurPos = aiPagePos[aucSpData[iSPOF_Br+iB*4+0]] ;
				if( iCurPos == -1 ){continue;} //対応が面倒なのでこうしておく
				switch( aucSpData[iSPOF_Br+iB*4+1] )
				{
				case 0x20:iCurPos++;break;
				case 0x40:iCurPos+=ciListSize;break ;
				case 0x80:iCurPos-=ciListSize;break ;
				}
				iRorg = aucSpData[iSPOF_Br+iB*4+iOfBrDt_r] ;
				iCurPage = aucSpData[iSPOF_Br+iB*4+iOfBrDt_p] ;
				iBranchAfter = 1 ;
			}
			for( int iR=iRorg ; iR<iMaxRoom ; iR++ )
			{
				int iRaw = aucSpData[iSPOF_RC+iR] ;
				int iSize = (iRaw&0x0F)+1 ;
				int iCon = (iRaw&0xE0) ;
				if( !iCon || iCon>=0xC0 ){break;}
				if( !iBranchAfter )
				{
					switch( iCon )
					{
					case 0x20:
						iCurPos++;break ;
					case 0x40:
					case 0x60:
						iCurPos+=ciListSize;break ;
					break;
					case 0x80:
					case 0xA0:
						iCurPos-=ciListSize;break ;
					break;
					}
				}
				iBranchAfter = 0 ;
				for( int iS=0 ; iS<iSize ; iS++ )
				{
					if( iCurPage>=_countof(aiPagePos) ){break;}
					if( iCurPos>=_countof(aiPageList) ){break;}
					aiPagePos[iCurPage] = iCurPos ;
					aiPageList[iCurPos] = iCurPage ;
					iCurPage++ ;
					if( iS<iSize-1 )
					{
						switch( iCon )
						{
						case 0x40:iCurPos+=ciListSize;break ;
						case 0x80:iCurPos-=ciListSize;break ;
						default:iCurPos++;break ;
						}
					}
				}
			}
		}
	}
	break;
	case 6:
		{
			int iProcessFlag[ciMaxAllocatePage] ;
			for( int i=0 ; i<iProcessPageCount ; i++ ){ iProcessFlag[i] = 0 ; }
			iProcessFlag[0] = 1 ;
			aiPagePos[0] = ciListCenter ;
			aiPageList[ciListCenter] = 0 ;

			for( int iAgain=0 ; iAgain<1 ; iAgain++ )
			{
				for( int iP=0 ; iP<iProcessPageCount ; iP++ )
				{
					if( iProcessFlag[iP] <= 0 ){ continue; }
					iProcessFlag[iP] = -1 ;
					int iEdge ;
					for( int iO=-1 ;; )
					{
						iO = OU[0].GetElemInArea( ciDotPPageW*iP , 0 , ciDotPPageW , ciDotPPageH , iO ) ;
						if( iO < 0 ){ break; }
						if( OU[0].GetT( iO ) != 0x80 ){ continue; }
						int iSOy = OU[0].GetY( iO ) ;
						if( iSOy >= 0x80 ){ continue ; }
						if( iSOy==0x0C )
						{ 
							iProcessFlag[iP+1] = 1 ;
							aiPagePos[iP+1] = aiPagePos[iP]+ciListSize ;
							aiPageList[aiPagePos[iP+1]] = iP+1 ;
							iAgain = -1 ;
							break ;
						}


						int iAddr = 0x390000 + GetROM8p(0x39836B+iSOy)*0x100 + GetROM8p(0x3982EB+iSOy) ; 
						iEdge = GetROM8p( iAddr ) ;
						if( iEdge >= 0x80 ){ iAddr+=2; iEdge = GetROM8p( iAddr ) ; }
						iAddr ++ ;
						{
							int iProcAddr=GetROM16p( iAddr ) ;
							if( iProcAddr==0x8084 || iProcAddr == 0x8E84 )
							{
								iEdge |= 1 ;
							}
						}
						iAddr += 2 ;
						for( ;; )
						{
							int iDir = GetROM8p( iAddr ) ;
							iAddr ++ ;
							if( !iDir ){ break; }
							if( iDir>=7 ){ break; }
							iAddr +=2 ;
							int iWarp = GetROM8p( iAddr ) ;
							if( iWarp>=0x80 )
							{
								iAddr ++ ;
								iWarp &= 0x7F ;
							}
							else
							{
								iWarp = iP ;
							}
							int iDPos = 0 ;
							int iDPage = 0 ;
							switch( iDir )
							{
							case 1: iDPage= 1; iDPos= ciListSize ; break; 
							case 2: iDPage= 1; iDPos=-ciListSize ; break; 
							case 3: iDPage=-1; iDPos= ciListSize ; break; 
							case 4: iDPage=-1; iDPos=-ciListSize ; break; 
							case 5: iDPage= 1; iDPos= 1 ; break; 
							case 6: iDPage=-1; iDPos=-1 ; break; 
							}
							int iDestPage = iWarp + iDPage ;
							int iDestPos  = aiPagePos[iP] + iDPos ;
							if( iDestPage>=0 && iDestPage<iProcessPageCount && !iProcessFlag[iDestPage] )
							{
								iProcessFlag[iDestPage] = 1 ;
								aiPagePos[iDestPage] = iDestPos ;
								aiPageList[aiPagePos[iDestPage]] = iDestPage ;
								iAgain = -1 ;
							}
						}
					}
					if( (iEdge & 2) && iP && !iProcessFlag[iP-1] )
					{ //左にスクロール可能
						iProcessFlag[iP-1] = 1 ;
						aiPagePos[iP-1] = aiPagePos[iP]-1 ;
						aiPageList[aiPagePos[iP-1]] = iP-1 ;
						iAgain = -1 ;
					}
					if( (iEdge & 1) && iP<iProcessPageCount-1 && !iProcessFlag[iP+1] )
					{ //右にスクロール可能
						iProcessFlag[iP+1] = 1 ;
						aiPagePos[iP+1] = aiPagePos[iP]+1 ;
						aiPageList[aiPagePos[iP+1]] = iP+1 ;
						iAgain = -1 ;
					}

//					OU[0].GetElemByPosition

				}
			}
		}
	break ;
	default:
		assert( 0 ) ;
//		aiPagePos[0] = ciListCenter ;
//		aiPageList[ciListCenter] = 0 ;
	break;
	}

	{
		int iXmin,iXmax,iYmin,iYmax;
		{//最小のxを取得
			int iFlag = -1 ;
			for( iX=0 ; iX<ciListSize ; iX++ )
			{
				for( iY=0 ; iY<ciListSize ; iY++ )
				{
					int iTmp = aiPageList[ iY*ciListSize + iX ] ;
					if( iTmp>=0 ){ iFlag=iX; break; }
				}
				if( iFlag>=0 ){ break; }
			}
			iXmin=iFlag ;
		}
		{//最大のxを取得
			int iFlag = -1 ;
			for( iX=ciListSize-1 ; iX>=0 ; iX-- )
			{
				for( iY=0 ; iY<ciListSize ; iY++ )
				{
					int iTmp = aiPageList[ iY*ciListSize + iX ] ;
					if( iTmp>=0 ){ iFlag=iX; break; }
				}
				if( iFlag>=0 ){ break; }
			}
			iXmax=iFlag ;
		}
		{//最小のyを取得
			int iFlag = -1 ;
			for( iY=0 ; iY<ciListSize ; iY++ )
			{
				for( iX=0 ; iX<ciListSize ; iX++ )
				{
					int iTmp = aiPageList[ iY*ciListSize + iX ] ;
					if( iTmp>=0 ){ iFlag=iY; break; }
				}
				if( iFlag>=0 ){ break; }
			}
			iYmin=iFlag ;
		}
		{//最大のyを取得
			int iFlag = -1 ;
			for( iY=ciListSize-1 ; iY>=0 ; iY-- )
			{
				for( iX=0 ; iX<ciListSize ; iX++ )
				{
					int iTmp = aiPageList[ iY*ciListSize + iX ] ;
					if( iTmp>=0 ){ iFlag=iY; break; }
				}
				if( iFlag>=0 ){ break; }
			}
			iYmax=iFlag ;
		}
		assert( iXmax>=iXmin ) ;
		assert( iYmax>=iYmin ) ;
		assert( iXmax-iXmin<=ciListSize ) ;
		assert( iYmax-iYmin<=ciListSize ) ;
		static const int iEffDotPPageH = 240 ;
		pMDO->CreateSurface( iSfcTmp , ciDotPPageW*(iXmax-iXmin+1) , iEffDotPPageH*(iYmax-iYmin+1) ) ;
		pMDO->Cls( MDO3WINAPI , iSfcTmp , 0 , 0 ,  ciDotPPageW*(iXmax-iXmin+1) , iEffDotPPageH*(iYmax-iYmin+1) , 0 ) ;
		{
			for( int iP=0 ; iP<iProcessPageCount ; iP++ )
			{
				int iPP = aiPagePos[iP] ;
				if( iPP < 0 ){ continue; }
				int iXP0,iYP0 ;
				iXP0 = (iPP%ciListSize-iXmin)*ciDotPPageW ;
				iYP0 = (iPP/ciListSize-iYmin)*iEffDotPPageH ;
				for( int iC=0 ; iC<240 ; iC++ )
				{
					int iCx,iCy,iCn,iSx,iSy ;
					iCx = iC%ciChipPPageW ;
					iCy = iC/ciChipPPageW ;
					iCn = pVTE->GetData( iP*ciChipPPageW+iCx , iCy ) ;
					iCx *= 16 ;
					iCy *= 16 ;
					iCx += iXP0 ;
					iCy += iYP0 ;
					iSx = iCn%8*16 ;
					iSy = iCn/8*16 ;
					pMDO->Blt( MDO3WINAPI , iSfcTmp , iCx , iCy , 16 , 16 , iSfcChip , iSx , iSy ) ;
				}
			}
		}
		pMDO->SaveBitmapFile( filename , iSfcTmp ) ;
		pMDO->ReleaseSurface( iSfcTmp ) ;
	}

}





int RockStage::CulcPageTileAmount( int *piOutPage , int *piOutTile , int *piOutMaxPage , int *piOutMaxTile , int *piPrePage , int *piPreTile )
{
	int iRV = 0 ;
	int iOutPage = 0 ;
	int iOutTile = 0 ;
	int iOutMaxPage = 0 ;
	int iOutMaxTile = 0 ;
	int iOutPrePage = 0 ;
	int iOutPreTile = 0 ;
	try
	{
		int iRVsub = 0 ;
		switch( iEditMode )
		{
		case 1: iRVsub = CulcPageTileAmount_sub_1( &iOutPage , &iOutTile , &iOutMaxPage , &iOutMaxTile , &iOutPrePage , &iOutPreTile ) ; break ;
		case 2: iRVsub = CulcPageTileAmount_sub_2( &iOutPage , &iOutTile , &iOutMaxPage , &iOutMaxTile , &iOutPrePage , &iOutPreTile ) ; break ;
		case 3: iRVsub = CulcPageTileAmount_sub_3( &iOutPage , &iOutTile , &iOutMaxPage , &iOutMaxTile , &iOutPrePage , &iOutPreTile ) ; break ;
		case 4: iRVsub = CulcPageTileAmount_sub_4( &iOutPage , &iOutTile , &iOutMaxPage , &iOutMaxTile , &iOutPrePage , &iOutPreTile ) ; break ;
		case 5: iRVsub = CulcPageTileAmount_sub_5( &iOutPage , &iOutTile , &iOutMaxPage , &iOutMaxTile , &iOutPrePage , &iOutPreTile ) ; break ;
		case 6: iRVsub = CulcPageTileAmount_sub_6( &iOutPage , &iOutTile , &iOutMaxPage , &iOutMaxTile , &iOutPrePage , &iOutPreTile ) ; break ;
		}
		if( iRVsub<0 ){ throw iRVsub; }
	}
	catch( int iErr )
	{
		iRV = iErr ;
	}

	if( piOutPage ){ *piOutPage=iOutPage; }
	if( piOutTile ){ *piOutTile=iOutTile; }
	if( piPrePage ){ *piPrePage=iOutPrePage; }
	if( piPreTile ){ *piPreTile=iOutPreTile; }
	if( piOutMaxPage ){ *piOutMaxPage=iMaxPage; }
	if( piOutMaxTile ){ *piOutMaxTile=iMaxTile; }

	if( iOutPage>iMaxPage || iOutTile>iMaxTile ){ iRV=1; }
	return iRV ;
}
int RockStage::GetObjCount( int *piObj , int *piMaxObj , int iOUNO )
{
	assert( iOUNO==0 || iOUNO==1 ) ;
	int iRV = 0 ;
	int iTmp = OU[iOUNO].GetCount();
	if( piObj ){ (*piObj)=iTmp; }
	if( piMaxObj ){ (*piMaxObj)=aiMaxObject[0] ; if(iOUNO){(*piMaxObj)=aiMaxObject[1] ;} }
	if( iTmp>aiMaxObject[0] ){iRV=1;}
	return iRV ;
}


TextIOManager *RockStage::GetTIOM( LPCTSTR ptcFilename , unsigned char *pucObjectImage , int iObjectImageSize  , int iLoadMode )
{
	TextIOManager *pTIOM = new TextIOManager( ptcFilename , 100 , _T('#') , _T(';') ) ;
	pTIOM->AddIOItem_Comment( _T("ゆらゆらロック　ステージデータファイル") ) ;
	pTIOM->AddIOItem_Comment( _T("") ) ;
	pTIOM->AddIOItem_Comment( _T("Neoぼろくず工房") ) ;
	pTIOM->AddIOItem_Comment( _T("http://borokobo.web.fc2.com/neo/index.html") ) ;
	pTIOM->AddIOItem_Comment( _T("") ) ;
	pTIOM->AddIOItem_16Value( _T("iVersion") , &iVersion ) ;
	pTIOM->AddIOItem_16Value( _T("iEditMode") , &iEditMode ) ;
	pTIOM->AddIOItem_16Value( _T("iStageNO") , &iStageNO ) ;
	pTIOM->AddIOItem_16Value( _T("aiMultiplexOriginalPage0") , aiMultiplexOriginalPage+0 ) ;
	pTIOM->AddIOItem_16Value( _T("aiMultiplexOriginalPage1") , aiMultiplexOriginalPage+1 ) ;

	pTIOM->AddIOItem_Block( _T("aucChipMap") , aucChipMap , sizeof(aucChipMap) ) ;
	pTIOM->AddIOItem_Block( _T("aucChip") , aucChip , sizeof(aucChip) ) ;
	pTIOM->AddIOItem_Block( _T("aucChipHit") , aucChipHit , sizeof(aucChipHit) ) ;

	if( iLoadMode || iHaveVChip )
	{
		pTIOM->AddIOItem_Block( _T("aucVChip") , aucVChip , sizeof(aucVChip) ) ;
		pTIOM->AddIOItem_Block( _T("aucVChipHit") , aucVChipHit , sizeof(aucVChipHit) ) ;
		pTIOM->AddIOItem_Block( _T("aucVChipValid") , aucVChipValid , sizeof(aucVChipValid) ) ;
	}
	pTIOM->AddIOItem_Block( _T("aucPreTile"    ) , aucPreTile     , sizeof(aucPreTile    ) ) ;
	pTIOM->AddIOItem_Block( _T("aucPreTileHit" ) , aucPreTileHit  , sizeof(aucPreTileHit ) ) ;
	pTIOM->AddIOItem_Block( _T("aucPreTileFlag") , aucPreTileFlag , sizeof(aucPreTileFlag) ) ;
	pTIOM->AddIOItem_Block( _T("aucPrePage"    ) , aucPrePage     , sizeof(aucPrePage    ) ) ;
	pTIOM->AddIOItem_Block( _T("aucPrePageFlag") , aucPrePageFlag , sizeof(aucPrePageFlag) ) ;

	pTIOM->AddIOItem_Block( _T("aucSpData") , aucSpData , sizeof(aucSpData) ) ;
	pTIOM->AddIOItem_Block( _T("pucObjectImage") , pucObjectImage , iObjectImageSize ) ;

	pTIOM->AddIOItem_Comment( _T("") ) ;
	pTIOM->AddIOItem_Comment( _T("エディタ設定") ) ;
	pTIOM->AddIOItem_Comment( _T("") ) ;
	pTIOM->AddIOItem_16Value( _T("iX") , &iX ) ;
	pTIOM->AddIOItem_16Value( _T("iY") , &iY ) ;
	pTIOM->AddIOItem_16Value( _T("iViewPatNO") , &iViewPatNO ) ;
	pTIOM->AddIOItem_Block( _T("iViewPatGraph") , (unsigned char*)iViewPatGraph , sizeof(iViewPatGraph) ) ;
	pTIOM->AddIOItem_Block( _T("iViewPatColor") , iViewPatColor , sizeof(iViewPatColor) ) ;

	return pTIOM ; 
}
void RockStage::UpdateVTE()
{
	if( pVTE ){ delete pVTE ; pVTE = NULL ; }
	pVTE = new VersatileTileEditor_Lua<unsigned char>( aucChipMap , ciMaxAllocatePage*ciChipPPageW , ciChipPPageH*ciLayers , 32 , 0 ) ;
	pVTE->SetSFCTile( iSfcChip ) ;
	pVTE->SetClipFileName( _T("clipped.rstgclip") ) ;
	pVTE->SetWindow( 0 , 0 , iProcessPageCount*ciChipPPageW , ciChipPPageH*ciLayers ) ;
	pVTE->SetTileSFCSize( 8 , 32 ) ;
	pVTE->SetChipHitPointer( aucChipHit ) ;
//	pVTE->SetTileSizeEX( 32 , 32 , 16 , 16 ) ; //ズームのテスト(実装する気はない)
}
unsigned char *RockStage::OpenPPUFile()
{//非NULLが返されたときは、呼び出し元でfreeを忘れないようにすること
	unsigned char *pucBuf = NULL ;
	tstring strTmp = strFileName ;

	{
		tstring::size_type LastDot = strTmp.rfind( _T('.') ) ;
		if( LastDot == tstring::npos ){ return NULL ; }
		strTmp[ LastDot ] = _T('\0') ;
	}

	static const TCHAR *apcExt[ciMaxViewPat+1] =
	{
		_T(".ppu"),
		_T(".1.ppu"),
		_T(".2.ppu"),
		_T(".3.ppu"),
		_T(".4.ppu"),
	} ;
	tstring strTmp2 = strTmp.c_str() ;
	strTmp2 += apcExt[iViewPatNO+1] ;
	LoadMemoryFromFile( strTmp2.c_str() , &pucBuf ) ;
	if( pucBuf ){ return pucBuf; }
	if( iViewPatNO ){ return NULL; }
	strTmp2 = strTmp.c_str() ;
	strTmp2 += apcExt[0] ;
	LoadMemoryFromFile( strTmp2.c_str() , &pucBuf ) ;
	return pucBuf ;
}
int RockStage::RemapObject( unsigned char *pucRomMask , int *piOutCurSize , int *piOutMaxSize )
{
	switch( iEditMode )
	{
	case 1: return RemapObject_1( pucRomMask , piOutCurSize , piOutMaxSize ) ;
	case 6: return RemapObject_6( pucRomMask , piOutCurSize , piOutMaxSize ) ;
	}
	assert( 0 ) ;
	return 1 ;
}
int RockStage::RemapObject_1( unsigned char *pucRomMask , int *piOutCurSize , int *piOutMaxSize )
{
	static const int ciObjAddrAddr  = 0x0DA452 ;
	static const int ciObjAddrData  = 0x0DA468 ;
	static const int ciObjBank      = 0x0D0000 ;
	static const int ciObjSize    = 0x0DAB00-ciObjAddrData ;
	static const int ciStages = 10 ;

	assert( iEditMode==1 ) ;
#define MASK(Addr,Size) {if(pucRomMask){int iOffset=ROMp(Addr)-pucRom; memset( pucRomMask+iOffset , 1 , Size ) ;}}
	unsigned char aaucObjectImage[ciStages][0x2000] ;
	int aiObjects[ciStages] ; 
	{//読み出し
		{//オブジェクトの数
			for( int i=0 ; i<ciStages ; i++ )
			{
				int iCnt ;
				int iAddr = GetROM16p( ciObjAddrAddr+i*2 )|(ciObjBank) ;
				for( iCnt=0 ; iCnt<64 ; iCnt++ )
				{
					if( GetROM8p( iAddr+iCnt*4 ) >= iProcessPageCount ){ break; }
				}
				aiObjects[i] = iCnt ;
			}
		}
		{//オブジェクトイメージ
			for( int i=0 ; i<ciStages ; i++ )
			{
				//終端のFFはこれでカバー
				memset( aaucObjectImage[i] , 0xFF , 0x2000 ) ;
				int iAddr ;
				iAddr = GetROM16p( ciObjAddrAddr+i*2 )|(ciObjBank) ;
				memcpy( aaucObjectImage[i] , ROMp(iAddr) , aiObjects[i]*4 ) ; //+1は必要ない
			}
		}
	}
	{//編集中ステージのオブジェクト数とイメージを構成
		for( int iStg=0 ; iStg<2 ; iStg++ )
		{
			int iLongStage = iStageNO+iStg*6 ;
			if( iLongStage>=ciStages ){ break; }
			aiObjects[iLongStage] = OU[iStg].GetCount() ;
			{
				//終端のFFはこれでカバー
				memset( aaucObjectImage[iLongStage] , 0xFF , 0x2000 ) ;
				OU[iStg].ExportToROM( iEditMode , 
								aaucObjectImage[iLongStage] ,
								NULL , NULL , NULL , aiObjects[iLongStage] ) ;
			}
		}
	}
	{//容量を計算
		int iSize=0 ;
		for( int i=0 ; i<ciStages ; i++ )
		{
			iSize += aiObjects[i]*4+1 ;
		}
		iSize ++ ;
		if( piOutMaxSize ){ (*piOutMaxSize) = ciObjSize ; }
		if( piOutCurSize ){ (*piOutCurSize) = iSize ; }
		if( iSize>ciObjSize )
		{
			return -1 ;
		}
	}
	{//詰め込みを実行
		int iCurAddr = ciObjAddrData ;
		for( int i=0 ; i<ciStages ; i++ )
		{
			SetROM16p( ciObjAddrAddr+i*2 , iCurAddr ) ;
			memcpy( ROMp(iCurAddr) , aaucObjectImage[i] , aiObjects[i]*4+1 ) ; 
			MASK( ciObjAddrAddr+i*2 , 2 ) ;
			MASK( iCurAddr , aiObjects[i]*4+1 ) ;
			iCurAddr += aiObjects[i]*4+1 ;
		}
		{//ステージA扱い
			SetROM16p( ciObjAddrAddr+0xA*2 , iCurAddr ) ;
			SetROM8p ( iCurAddr , 0xFF ) ;
			MASK( ciObjAddrAddr+0xA*2 , 2 ) ;
			MASK( iCurAddr , 1 ) ;
		}
	}
#undef MASK
	//オブジェクト数が変わるので更新
	CorrectEditModeStageNORomDependedValue() ;
	return 0 ;
}
int RockStage::RemapObject_6( unsigned char *pucRomMask , int *piOutCurSize , int *piOutMaxSize )
{
	static const int ciObjAddrAddrLo  = 0x3A80BF ; //1低い値なので注意
	static const int ciObjAddrAddrHi  = 0x3A80CF ; //1低い値なので注意
	static const int ciObjAddrObjects = 0x3A80DF ;
	static const int ciObjAddrData    = 0x3A85D9 ;
	static const int ciObjBank        = 0x3A0000 ;
	static const int ciObjSize    = 0x3AA000-ciObjAddrData ;

	assert( iEditMode==6 ) ;
#define MASK(Addr,Size) {if(pucRomMask){int iOffset=ROMp(Addr)-pucRom; memset( pucRomMask+iOffset , 1 , Size ) ;}}
	unsigned char aaucObjectImage[0x10][0x2000] ;
	int aiObjects[0x10] ; //終端のFFを含んだ数である
	{//読み出し
		{//オブジェクトの数
			for( int i=0 ; i<0x10 ; i++ )
			{
				aiObjects[i] = GetROM8p(ciObjAddrObjects+i)+1 ;
			}
		}
		{//オブジェクトイメージ
			for( int i=0 ; i<0x10 ; i++ )
			{
				memset( aaucObjectImage[i] , 0 , 0x2000 ) ;
				int iAddr ;
				iAddr  = GetROM8p(ciObjAddrAddrLo+i) ;
				iAddr += GetROM8p(ciObjAddrAddrHi+i)*256 ;
				iAddr += ciObjBank ;
				iAddr += 1 ;
				memcpy( aaucObjectImage[i] , ROMp(iAddr) , aiObjects[i]*4 ) ;
			}
		}
	}
	{//編集中ステージのオブジェクト数とイメージを構成
		aiObjects[iStageNO] = OU[0].GetCount()+1 ;
		{
			//終端のFFはこれでカバー
			memset( aaucObjectImage[iStageNO] , 0xFF , 0x2000 ) ;
			OU[0].ExportToROM( iEditMode , 
							aaucObjectImage[iStageNO]+aiObjects[iStageNO]*0 ,
							aaucObjectImage[iStageNO]+aiObjects[iStageNO]*1 ,
							aaucObjectImage[iStageNO]+aiObjects[iStageNO]*2 ,
							aaucObjectImage[iStageNO]+aiObjects[iStageNO]*3 ,
							OU[0].GetCount() ) ;
		}
	}
	{//容量を計算
		int iSize=0 ;
		for( int i=0 ; i<0x10 ; i++ )
		{
			iSize += aiObjects[i]*4 ;
		}
		if( piOutMaxSize ){ (*piOutMaxSize) = ciObjSize ; }
		if( piOutCurSize ){ (*piOutCurSize) = iSize ; }
		if( iSize>ciObjSize )
		{
			return -1 ;
		}
	}
	{//詰め込みを実行
		int iCurAddr = ciObjAddrData ;
		for( int i=0 ; i<0x10 ; i++ )
		{
			SetROM8p(ciObjAddrAddrLo +i , (iCurAddr-1)&0xFF ) ;
			SetROM8p(ciObjAddrAddrHi +i , ((iCurAddr-1)/256)&0xFF ) ;
			SetROM8p(ciObjAddrObjects+i , (aiObjects[i]-1) ) ;
			memcpy( ROMp(iCurAddr) , aaucObjectImage[i] , aiObjects[i]*4 ) ; 
			MASK( ciObjAddrAddrLo  +i , 1 ) ;
			MASK( ciObjAddrAddrHi  +i , 1 ) ;
			MASK( ciObjAddrObjects +i , 1 ) ;
			MASK( iCurAddr , aiObjects[i]*4 ) ;
			iCurAddr += aiObjects[i]*4 ;
		}
	}
#undef MASK
	//オブジェクト数が変わるので更新
	CorrectEditModeStageNORomDependedValue() ;
	return 0 ;
}

int RockStage::AutoObjBankData_2_sub( int iOffset , int iXp , int *piRPP )
{
	if( iXp>=0 && iXp<iProcessPageCount )
	{
		int iR = piRPP[iXp] ;
		if( iR>=0 && iR<R2_MaxRoom )
		{
			if( iOffset == aucSpData[SPOf2_VRAMOffset+iR] )
			{
				return 1;
			}
		}
	}
	return 0 ;
}
int RockStage::AutoObjBankData_1( int iOffset , int *piObjPat , int *piBossPat )
{
	assert( iOffset>=0 && iOffset<256 && (iOffset%SPOf1_SizeOfGrpData)==0 ) ;
	int iRV = -1 ;
	int aiRPP[ciMaxAllocatePage] ;
	int aiType[256] ;
	//雑魚登場フラグをリセット
	for( int i=0 ; i<_countof(aiType) ; i++ ){ aiType[i] = 0 ; }
	//書き込み先をリセット
	for( int i=0 ; i<SPOf1_GrpLines ; i++ )
	{
		aucSpData[SPOf1_VRAMBody+iOffset+i] = 0 ;
	}
	//ページ毎のルーム番号を計算
	Rock1_SetupListOfRoomPerPage( aiRPP ) ;
	//ボスのグラフィック設定
	{
		for( int iStg=0 ; iStg<2 ; iStg++ )
		{
			int iDestStage = iStageNO + iStg*6 ;
			if( iDestStage >= 0xA ){ continue; }
			int iStartPage = 0 ;
			int iEndPage = iProcessPageCount - 1 ;
			int iBorder=aucSpData[SPOf1_StageBorder] ;
			iBorder = min( iProcessPageCount-1 , iBorder ) ;
			if( iStg ){ iStartPage = iBorder ; }
			else{ iEndPage = iBorder-1 ; }
			for( int i=iStartPage ; i<=iEndPage ; i++ )
			{
				if( aucSpData[SPOf1_VRAMOffset+i]==iOffset &&
					!aucSpData[SPOf1_RoomConnection+aiRPP[i]] )
				{
					for( int q=0 ; q<SPOf1_GrpLines ; q++ )
					{
						aucSpData[SPOf1_VRAMBody+iOffset+q] = piBossPat[iDestStage*SPOf1_GrpLines+q] ;
					}
				}
			}
		}
	}
	{//ザコのグラフィック設定
		for( int iOU=0 ; iOU<2 ; iOU++ )
		{//利用されているオブジェクトを検索
			for( int i=0 ; i<OU[iOU].GetCount() ; i++ )
			{
				int iTmpX = min(OU[iOU].GetX(i)>>8,iProcessPageCount-1) ;
				if( aucSpData[SPOf1_VRAMOffset+iTmpX] == iOffset )
				{
					aiType[ OU[iOU].GetT(i) ] = 1 ;
				}
			}
		}
		{//オブジェクトに対応したパターンを設定
			for( int i=0 ; i<256 ; i++ )
			{
				if( aiType[i] )
				{
					for( int q=0 ; q<SPOf1_GrpLines ; q++ )
					{
						int iPatOffset  = SPOf1_VRAMBody+iOffset+q ;
						int iCurPat  = aucSpData[iPatOffset] ;
						int iDestPat = piObjPat[i*SPOf1_GrpLines+q] ;
						if( !iDestPat ){ continue; }
						if( iCurPat == 0x00 || iCurPat==iDestPat )
						{
							aucSpData[iPatOffset] = iDestPat ;
						}
						else
						{
							iRV = i ;
						}
					}
				}
			}
		}
	}


	{//色を一応設定
		for( int i=0 ; i<2 ; i++ )
		{
			int iOff = SPOf1_VRAMBody+iOffset+SPOf1_GrpLines+i*3 ;
			if( !(aucSpData[iOff+0]|aucSpData[iOff+1]|aucSpData[iOff+2] ) )
			{
				aucSpData[iOff+0] = 0x30 ;
				aucSpData[iOff+1] = 0x10 ;
				aucSpData[iOff+2] = 0x0F ;
			}
		}
	}

	return iRV ;
}
int RockStage::AutoObjBankData_2( int iOffset , int *piObjPat , int *piBossPat )
{
	assert( iOffset>=0 && iOffset<256 && (iOffset%0x12)==0 ) ;
	int iRV=-1 ;
	int aiRPP[ciMaxAllocatePage] ;
	int aiType[256] ;

	//雑魚登場フラグをリセット
	for( int i=0 ; i<_countof(aiType) ; i++ ){ aiType[i] = 0 ; }
	//書き込み先をリセット
	for( int i=0 ; i<2*6 ; i++ )
	{
		aucSpData[SPOf2_VRAMBody+iOffset+i] = 0 ;
	}
	//ページ毎のルーム番号を計算
	Rock2_SetupListOfRoomPerPage( aiRPP ) ;
	//ボスのグラフィック設定
	{
		for( int i=0 ; i<2 ; i++ )
		{
			int iDestStage = iStageNO + i*8 ;
			if( iDestStage >= 0xE ){ continue; }
			int iXp =  aucSpData[SPOf2_BossPage1+i] ;
			if( iDestStage >= 0x8 && !iXp ){ continue; }
			if( AutoObjBankData_2_sub( iOffset , iXp , aiRPP ) )
			{
				for( int q=0 ; q<6 ; q++ )
				{
					aucSpData[SPOf2_VRAMBody+iOffset+q*2+0] = piBossPat[iDestStage*6+q]/256 ;
					aucSpData[SPOf2_VRAMBody+iOffset+q*2+1] = piBossPat[iDestStage*6+q]%256 ;
				}
			}
		}
	}
	//利用されているオブジェクトを検索
	for( int iOU=0 ; iOU<2 ; iOU++ )
	{
		for( int i=0 ; i<OU[iOU].GetCount() ; i++ )
		{
			if( AutoObjBankData_2_sub( iOffset ,  OU[iOU].GetX(i)>>8 , aiRPP ) )
			{
				aiType[ OU[iOU].GetT(i) ] = 1 ;
			}
		}
	}
	//オブジェクトに対応したパターンを設定
	{
		for( int i=0 ; i<256 ; i++ )
		{
			if( aiType[i] )
			{
				for( int q=0 ; q<6 ; q++ )
				{
					int iCurPat =	aucSpData[SPOf2_VRAMBody+iOffset+q*2+0] * 256 +
									aucSpData[SPOf2_VRAMBody+iOffset+q*2+1] ;
					int iDestPat = piObjPat[i*6+q] ;
					if( !iDestPat ){ continue; }
					if( iCurPat == 0x0000 || iCurPat==iDestPat )
					{
						aucSpData[SPOf2_VRAMBody+iOffset+q*2+0] = iDestPat/256 ;
						aucSpData[SPOf2_VRAMBody+iOffset+q*2+1] = iDestPat%256 ;
					}
					else
					{
						iRV = i ;
					}
				}
			}
		}
	}
	return iRV ;
}
