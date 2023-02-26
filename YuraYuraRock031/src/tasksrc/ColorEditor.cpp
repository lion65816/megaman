#include "../common.h"

#define IncYOrReturn()		{if(!pTask){return;}tRect.y+=pTask->GetRect().h;}

#define RectSize 24
static const int iPalX0=24 ;
static const int iPalY0=24 ;

static void NesRect( int x , int y , int c )
{
	GL::mdo.Cls( MDO3WINAPI , GL::SFC_BACK , x , y , RectSize , RectSize , GL::NESColor[c&0x3F] ) ;
	UINT color=RGB(32,32,32) ;
	if( c<0x20 ){ color=RGB(224,224,224); }
	_TCHAR atcTmp[32] ;
	_stprintf_s( atcTmp , _countof(atcTmp) , _T("%02X") , c ) ;
	GL::mdo.Text( GL::SFC_BACK , atcTmp , x , y , 12 , 6 , color ) ;
}

void ColorEditor::Finit()
{
	iSelectedColor = 0 ;
	{//マップなどの表示Off
		MainMode *pTask = (MainMode*)SolveHandle( GetParentHandle() ) ;
		assert( pTask ) ;
		pTask->SetDrawState( 1 , 0 , 0 ) ;
	}
	//RSからコピーしておく
	GL::RS.ExportSpData( aucData ) ;

	TaskObject *pTask ;
	Task1206Rect tRect = {iPalX0,iPalY0+RectSize*4,8,16,0} ;

	switch( GL::RS.GetEditMode() )
	{
	case 1:
		{
			tRect.y += RectSize ;
			pTask = new ColorEditor_sub( this , tRect , aucData+0x100 , 0x60 , 0x10 , RectSize , &iSelectedColor ) ;
			IncYOrReturn() ;
		}
	break ;
	case 2:
		{
			pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(498) , -1 , -1 , -1 ) ;
			IncYOrReturn() ;
			pTask = new TaskObjectBinaryEditor( this , true , tRect , aucData+0x80 , 1 , 2 , -1 ) ;
			IncYOrReturn() ;
			pTask = new ColorEditor_sub( this , tRect , aucData+0x82 , 0x60 , 0x10 , RectSize , &iSelectedColor ) ;
			IncYOrReturn() ;
			pTask = new TaskObjectBoxText( this , false , tRect ,  GLMsg(498) , -1 , -1 , -1 ) ;
			IncYOrReturn() ;
			pTask = new TaskObjectBinaryEditor( this , true , tRect , aucData+0x100 , 1 , 2 , -1 ) ;
			IncYOrReturn() ;
			pTask = new ColorEditor_sub( this , tRect , aucData+0x102 , 0x60 , 0x10 , RectSize , &iSelectedColor ) ;
			IncYOrReturn() ;
		}
	break ;
	default:
		assert( 0 ) ;
	}

	GL::RequestRedraw() ;
	return ;
}
void ColorEditor::Fmain()
{

	{
		TaskObjectBinaryEditor *pBE ;
		for( int i=0 ;; i++ )
		{
			pBE = (TaskObjectBinaryEditor*)SolveHandle( SearchTask( TP_BINARY_EDITOR , TP_BINARY_EDITOR , i ) ) ;
			if( !pBE ){break;}
			if( pBE->IsChanged() )
			{
				//RSに書き戻す
				GL::RS.ImportSpData( aucData ) ;
				GL::iStageUpdated = 1 ;
				GL::RequestRedraw() ;
			}
		}
		ColorEditor_sub *pCE ;
		for( int i=0 ;; i++ )
		{
			pCE = (ColorEditor_sub*)SolveHandle( SearchTask( TP_ColorEditor_sub , TP_ColorEditor_sub , i ) ) ;
			if( !pCE ){break;}
			if( pCE->IsChanged() )
			{
				//RSに書き戻す
				GL::RS.ImportSpData( aucData ) ;
				GL::iStageUpdated = 1 ;
				GL::RS.UpdateGraphicsPattern() ;
				GL::RequestRedraw() ;
			}
		}
	}
	{
		int iMx , iMy ;
		int iPointPos ;
		iMx = GetMousePosX() - x - iPalX0 ;
		iMy = GetMousePosY() - y - iPalY0 ;
		iPointPos = iMx/RectSize+iMy/RectSize*16 ;
		if( ( MouseOn(MB_L) ||  MouseOn(MB_R) ) && iMx>=0 && iMy>=0 && iMx<RectSize*16 && iPointPos<0x40 )
		{
			if( VAR_LET( iSelectedColor , iPointPos ) )
			{
				GL::RequestRedraw() ;
			}
		}
	}

	return ;
}
void ColorEditor::Fdest()
{
	return ;
}
void ColorEditor::Fdraw()
{
	for( int i=0 ; i<0x40 ; i++ )
	{
		NesRect( iPalX0+i%16*RectSize , iPalY0+i/16*RectSize , i ) ;
	}
	{
		int x0 , y0 ;
		x0 = iPalX0+(iSelectedColor&0x3F)%16*RectSize ;
		y0 = iPalY0+(iSelectedColor&0x3F)/16*RectSize ;
		GL::mdo.Box( MDO3WINAPI , GL::SFC_BACK , x0   , y0   , x0+RectSize   , y0+RectSize   , myRGB(  0 , 31 ,  0 ) ) ;
		GL::mdo.Box( MDO3WINAPI , GL::SFC_BACK , x0-1 , y0-1 , x0+RectSize+1 , y0+RectSize+1 , myRGB(  0 ,  0 , 31 ) ) ;
		GL::mdo.Box( MDO3WINAPI , GL::SFC_BACK , x0+1 , y0+1 , x0+RectSize-1 , y0+RectSize-1 , myRGB( 31 , 31 ,  0 ) ) ;
	}

	return ;
}



void ColorEditor_sub::Finit()
{
	UpdateXY() ;
	return ;
}
void ColorEditor_sub::Fmain()
{
	int iMx , iMy ;
	int iPointPos ;
	iMx = GetMousePosX() - x ;
	iMy = GetMousePosY() - y ;
	iPointPos = iMx/RectSize+iMy/RectSize*iLine ;
	if( iMx>=0 && iMy>=0 && iMx<RectSize*iLine && iPointPos<iDataSize )
	{
		if( MouseOn(MB_L) )
		{
			if( VAR_LET(pucData[ iPointPos ] , *piSelectedColor ) )
			{
				iChanged = 1 ;
				GL::RequestRedraw() ;
			}
		}
		if( MouseOn(MB_R) )
		{
			if( VAR_LET( *piSelectedColor , pucData[ iPointPos ] ) )
			{
				GL::RequestRedraw() ;
			}
		}
	}
	return ;
}
void ColorEditor_sub::Fdest()
{
	return ;
}
void ColorEditor_sub::Fdraw()
{
	for( int i=0 ; i<iDataSize ; i++ )
	{
		NesRect( x+i%iLine*RectSize , y+i/iLine*RectSize , pucData[i] ) ;
	}
	return ;
}
