pageextension 50207 PurchaseOrderExt extends "Purchase Order"
{
    layout
    {
        modify("Location Code")
        {
            Visible = false;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
    }

    actions
    {
        modify("Create &Whse. Receipt")
        {
            Visible = false;
        }
        modify("Create Inventor&y Put-away/Pick")
        {
            Visible = false;
        }
        modify("Send Intercompany Purchase Order")
        {
            Visible = false;
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                Rec.CheckPurchaseAmount();
                Rec.TestField()
            end;
        }
        modify(Release)
        {
            trigger OnBeforeAction()
            begin
                Rec.CheckPurchaseAmount();
                Rec.TestField()
            end;
        }

        addafter("Archive Document")
        {
            action(TestCreatePurchaseInvoice)
            {
                ApplicationArea = All;
                Caption = 'Test Purchase Invoice';
                Image = TestReport;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ESSMgt: Codeunit "ESS Management";
                    PurchaseLines: Text;
                    Result: Text;
                begin
                    PurchaseLines :=
                    '[{"No":"INV-000001","Description":"Laptop Computer","Quantity":2,"UnitCost":250000,"Amount":500000},' +
                    '{"No":"INV-000002","Description":"Office Chair","Quantity":4,"UnitCost":75000,"Amount":300000}]';

                    Result := ESSMgt.CreateOrEditPurchaseInvoice('', 'DV-0000001', '102001', PurchaseLines);
                    Message(Result);
                end;
            }
        }
    }
}
