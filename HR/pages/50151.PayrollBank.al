namespace BILLENERGY.BILLENERGY;

page 50151 PayrollBank
{
    ApplicationArea = All;
    Caption = 'Payroll Bank';
    PageType = List;
    SourceTable = PayrollBank;
    UsageCategory = Lists;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Bank Code"; Rec."Bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Sort Code"; Rec."Sort Code")
                {
                    ToolTip = 'Specifies the value of the Sort Code field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
