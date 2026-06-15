namespace BILLENERGY.BILLENERGY;

page 50178 PayrollList
{
    ApplicationArea = All;
    Caption = 'Payroll List';
    PageType = List;
    SourceTable = PayrollHeader;
    UsageCategory = Tasks;
    CardPageId = PayrollHeader;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Payroll Period"; Rec."Payroll Period")
                {
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Filter"; Rec."Shortcut Dimension 1 Filter")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed By"; Rec."Closed By")
                {
                    ToolTip = 'Specifies the value of the Closed By field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ToolTip = 'Specifies the value of the Closed Date field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
