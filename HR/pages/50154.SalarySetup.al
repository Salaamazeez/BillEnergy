namespace BILLENERGY.BILLENERGY;

page 50154 SalarySetup
{
    ApplicationArea = All;
    Caption = 'SalarySetup';
    PageType = Document;
    SourceTable = SalarySetupHeader;

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
                field("Employee Cadre Code"; Rec."Employee Cadre Code")
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
                field("Reimbursable Pay"; Rec."Reimbursable Pay")
                {
                    ToolTip = 'Specifies the value of the Reimbursable Pay field.', Comment = '%';
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
