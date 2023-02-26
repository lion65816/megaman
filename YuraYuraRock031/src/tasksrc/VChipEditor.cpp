#include "../common.h"

void VChipEditor::Finit()
{
	SetDrawOrderPandC(true,false) ;
	{//メッセージ
		Task1206Rect tRect={0,0,8,16,1} ;
		new TaskObjectBoxText( this , true , tRect , GLMsg(276) , -1 , -1 , -1 ) ;
	}
	ChipEditor::Finit() ;
}
int VChipEditor::GetChipFromRS( int Offset )
{
	return GL::RS.GetVChip( Offset ) ;
}
void VChipEditor::SetChipToRS( int Offset , int iValue )
{
	GL::RS.SetVChip( Offset , iValue ) ;
}
int VChipEditor::GetChipHitFromRS( int Offset )
{
	return GL::RS.GetVChipHit( Offset ) ;
}
void VChipEditor::SetChipHitFromRS( int Offset , int iValue )
{
	GL::RS.SetVChipHit( Offset , iValue ) ;
}
int VChipEditor::GetChipEditorMode()
{
	return 1 ;
}
void VChipEditor::VChipProc( int iPosition )
{
	{
		int iTmp = 0 ;
		if( KeyPush( KC_SPACE ) )
		{
			int iAttr = -(GL::RS.GetVChipValid( iPosition )*2-1) ;
			iValidFill = iAttr ;
		}
		if( KeyRelease( KC_SPACE ) )
		{
			iValidFill = 0 ;
		}
		if( iValidFill )
		{
			int iTmp = (iValidFill + 1) / 2 ;
			if( iTmp != GL::RS.GetVChipValid( iPosition ) )
			{
				GL::RS.SetVChipValid( iPosition , iTmp ) ;
				GL::iStageUpdated = 1 ;
				GL::RequestRedraw() ;
				GL::RS.DrawChip( &GL::mdo , GetChipEditorMode() , 0 ) ;
			}
		}
	}
	return ;
}