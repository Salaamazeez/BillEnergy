page 50139 PerformanceAppraiserListClosed
{
    ApplicationArea = All;
    Caption = 'Closed Performance Appraiser List';
    PageType = List;
    SourceTable = PerformanceAppraisalHeader;
    UsageCategory = Lists;
    Editable = false;
    SourceTableView = where(Closed = const(True));
    CardPageId = 50131;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Appraisal Year"; Rec."Appraisal Year")
                {
                    ToolTip = 'Specifies the value of the Appraisal Year field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
