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
                    ToolTip = 'Specifies the value of the Payroll Period field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payroll Creation Date"; Rec."Payroll Creation Date")
                {
                    ToolTip = 'Specifies the value of the Payroll Creation Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Employee Filter"; Rec."Employee Filter")
                {
                    ToolTip = 'Specifies the value of the Employee Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Salary Code Filter"; Rec."Salary Code Filter")
                {
                    ToolTip = 'Specifies the value of the Salary Code Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Filter"; Rec."Shortcut Dimension 1 Filter")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Filter field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Filter"; Rec."Shortcut Dimension 2 Filter")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Filter field.', Comment = '%';
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
                field("Closed Time"; Rec."Closed Time")
                {
                    ToolTip = 'Specifies the value of the Closed Time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    ApplicationArea = All;
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
