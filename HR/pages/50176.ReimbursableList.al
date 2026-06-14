namespace BILLENERGY.BILLENERGY;

page 50176 ReimbursableList
{
    ApplicationArea = All;
    Caption = 'Reimbursable List';
    PageType = List;
    SourceTable = ReimbursableHeader;
    UsageCategory = Tasks;
    CardPageId = Reimbursable;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    Editable = false;
                }
                field("Global Dimension 1 Code Filter"; Rec."Global Dimension 1 Code Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code Filter field.', Comment = '%';
                    Editable = false;
                }
                field("Global Dimension 2 Code Filter"; Rec."Global Dimension 2 Code Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code Filter field.', Comment = '%';
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    Editable = false;
                }
                field("Reimbursable Paid"; Rec."Reimbursable Paid")
                {
                    ToolTip = 'Specifies the value of the Reimbursable Paid field.', Comment = '%';
                    Editable = false;
                }
            }
        }
    }
}
