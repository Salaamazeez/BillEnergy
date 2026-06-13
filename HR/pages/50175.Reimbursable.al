namespace BILLENERGY.BILLENERGY;

page 50175 Reimbursable
{
    ApplicationArea = All;
    Caption = 'Reimbursable';
    PageType = Document;
    SourceTable = ReimbursableHeader;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Global Dimension 1 Code Filter"; Rec."Global Dimension 1 Code Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code Filter field.', Comment = '%';
                }
                field("Global Dimension 2 Code Filter"; Rec."Global Dimension 2 Code Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code Filter field.', Comment = '%';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                }
                field("Paid Document No."; Rec."Paid Document No.")
                {
                    ToolTip = 'Specifies the value of the Paid Document No. field.', Comment = '%';
                }
                field("Reimbursable Paid"; Rec."Reimbursable Paid")
                {
                    ToolTip = 'Specifies the value of the Reimbursable Paid field.', Comment = '%';
                }
            }
            part(Reimbursablelines; ReimbursableSalarySubform)
            {
                ApplicationArea = All;
                SubPageLink = "Payroll Period" = field("Period Code");
            }
        }
    }
}
