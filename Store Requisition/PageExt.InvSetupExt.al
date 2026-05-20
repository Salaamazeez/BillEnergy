pageextension 50502 InvSetupExt extends "Inventory Setup"
{
    layout
    {
        // Add changes to page layout here
        addlast(Numbering)
        {
            field("Store Requisition Nos."; Rec."Store Requisition Nos.")
            {
                ApplicationArea = All;
            }
            field("Store Return Nos."; Rec."Store Return Nos.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}