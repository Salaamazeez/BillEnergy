pageextension 50123 SalesInvoiceExt extends "Sales Invoice"
{
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                // Rec.TestField()
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            begin
                // Rec.TestField()
            end;
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                // Rec.TestField()
            end;
        }
        modify(Release)
        {
            trigger OnBeforeAction()
            begin
                // Rec.TestField()
            end;
        }
    }

    procedure TestField()
    begin
        Rec.TestField("Shortcut Dimension 1 Code");
        Rec.TestField("Shortcut Dimension 2 Code");
    end;
}
