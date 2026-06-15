namespace BILLENERGY.BILLENERGY;

page 50029 SalarySetup
{
    //ApplicationArea = All;
    Caption = 'Salary Setup';
    PageType = Document;
    SourceTable = SalarySetupHeader;
    UsageCategory = Tasks;

    layout
    {

        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Salary Code"; Rec."Salary Code")
                {
                    ToolTip = 'Specifies the value of the Salary Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Employee Cadre Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Apply to"; Rec."Apply to")
                {
                    ToolTip = 'Specifies the value of the Apply to field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Gross Pay"; Rec."Gross Pay")
                {
                    ToolTip = 'Specifies the value of the Gross Pay field.', Comment = '%';
                    ApplicationArea = All;
                }

                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }

            }
            part(SalarySetuplines; SalarySetupSubform)
            {
                ApplicationArea = all;
                SubPageLink = "Salary Code" = field("Salary Code");
            }
        }

    }
}