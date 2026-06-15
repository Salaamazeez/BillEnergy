namespace BILLENERGY.BILLENERGY;

page 50167 SalarySetupList
{
    ApplicationArea = All;
    Caption = 'Salary Setup List';
    PageType = List;
    CardPageId = SalarySetup;
    SourceTable = SalarySetupHeader;
    UsageCategory = Lists;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Salary Code"; Rec."Salary Code")
                {
                    ToolTip = 'Specifies the value of the Salary Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Employee Cadre Code field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Apply to"; Rec."Apply to")
                {
                    ToolTip = 'Specifies the value of the Apply to field.', Comment = '%';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
