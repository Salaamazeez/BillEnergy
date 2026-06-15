pageextension 50012 VendorExt extends "Vendor Card"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;

            }

        }
    }

        actions
    {
        addafter("Ledger E&ntries")
        {
            action("Sync Vendor To HMRS")
            {
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Sync Vendor To HMRS';
                ApplicationArea = Basic;
                trigger OnAction()
                var
                    PortalMgt: Codeunit "Portal Mgt";
                begin
                    PortalMgt.SendVendorToHRMS(Rec);
                end;
            }
        }
    } 

    var
        myInt: Integer;
}