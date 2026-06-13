namespace BILLENERGY.BILLENERGY;

page 50155 PayrollHeader
{
    ApplicationArea = All;
    Caption = 'Payroll Header';
    PageType = Document;
    SourceTable = PayrollHeader;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Payroll Period"; Rec."Payroll Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';

                }
                field("Payroll Creation Date"; Rec."Payroll Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payroll Creation Date field.', Comment = '%';

                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';

                }
                field("Employee Filter"; Rec."Employee Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee Filter field.', Comment = '%';

                }
                field("Salary Code Filter"; Rec."Salary Code Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salary Code Filter field.', Comment = '%';

                }
                field("Shortcut Dimension 1 Filter"; Rec."Shortcut Dimension 1 Filter")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Filter field.', Comment = '%';

                }
                field("Shortcut Dimension 2 Filter"; Rec."Shortcut Dimension 2 Filter")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Closed By"; Rec."Closed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed By field.', Comment = '%';

                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed Date field.', Comment = '%';

                }
                field("Closed Time"; Rec."Closed Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Closed Time field.', Comment = '%';

                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';

                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';

                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';

                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';

                }
            }
            part(PayrollLines; PayrollSubform)
            {
                ApplicationArea = All;
                SubPageLink = "Payroll Period" = field("Payroll Period");
            }
        }
    }
}
