page 50112 Periods
{
    ApplicationArea = All;
    Caption = 'Periods';
    PageType = List;
    SourceTable = PayrollPeriods;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code';
                    ApplicationArea = All;
                }
                field("Period Name"; Rec."Period Name")
                {
                    ToolTip = 'Specifies the value of the Period Name';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Period Start Date';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the Period End Date';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CreatePeriods)
            {
                Caption = 'Create Payroll Periods';
                ApplicationArea = All;
                Image = Period;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Report PayrollPeriodSetup;
            }
        }
    }
}
