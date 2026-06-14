namespace BILLENERGY.BILLENERGY;

page 50177 OvertimeList
{
    ApplicationArea = All;
    Caption = 'Overtime List';
    PageType = List;
    CardPageId = Overtime;
    SourceTable = OvertimeHeader;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee Filter"; Rec."Employee Filter")
                {
                    ToolTip = 'Specifies the value of the Employee Filter field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 1 Filter"; Rec."Global Dimension 1 Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Filter field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 2 Filter"; Rec."Global Dimension 2 Filter")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Filter field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Overtime Paid"; Rec."Overtime Paid")
                {
                    ToolTip = 'Specifies the value of the Overtime Paid field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
