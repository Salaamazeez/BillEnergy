namespace BILLENERGY.BILLENERGY;

page 50129 JobFunction
{
    ApplicationArea = All;
    Caption = 'Job Function';
    PageType = List;
    SourceTable = JobFunction;
    UsageCategory = Tasks;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Job Title Code"; Rec."Job Title Code")
                {
                    ToolTip = 'Specifies the value of the Job Title Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
