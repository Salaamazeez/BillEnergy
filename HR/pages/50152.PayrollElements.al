namespace BILLENERGY.BILLENERGY;

page 50030 PayrollElements
{
    ApplicationArea = All;
    Caption = 'Payroll Elements';
    PageType = List;
    SourceTable = PayrollElement;
    UsageCategory = Lists;
    DataCaptionFields = "Element Name";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Element Code"; Rec."Element Code")
                {
                    ToolTip = 'Specifies the value of the Element Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Element Name"; Rec."Element Name")
                {
                    ToolTip = 'Specifies the value of the Element Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Earning; Rec.Earning)
                {
                    ToolTip = 'Specifies the value of the Earning field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Deduction; Rec.Deduction)
                {
                    ToolTip = 'Specifies the value of the Deduction field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Appear in Payslip"; Rec."Appear in Payslip")
                {
                    ToolTip = 'Specifies the value of the Appear in Payslip field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Appear in Salary Setup"; Rec."Appear in Salary Setup")
                {
                    ToolTip = 'Specifies the value of the Appear in Salary Setup field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Part of Net Payable"; Rec."Part of Net Payable")
                {
                    ToolTip = 'Specifies the value of the Part of Net Payable field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Function of Paye"; Rec."Function of Paye")
                {
                    ToolTip = 'Specifies the value of the Function of Paye field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Function of Pension"; Rec."Function of Pension")
                {
                    ToolTip = 'Specifies the value of the Function of Pension field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Function of Poration"; Rec."Function of Poration")
                {
                    ToolTip = 'Specifies the value of the Function of Poration field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ToolTip = 'Specifies the value of the G/L Account field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Absence"; Rec."Is Absence")
                {
                    ToolTip = 'Specifies the value of the Is Absence field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Basic"; Rec."Is Basic")
                {
                    ToolTip = 'Specifies the value of the Is Basic field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is House"; Rec."Is House")
                {
                    ToolTip = 'Specifies the value of the Is House field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Transport"; Rec."Is Transport")
                {
                    ToolTip = 'Specifies the value of the Is Transport field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Utility"; Rec."Is Utility")
                {
                    ToolTip = 'Specifies the value of the Is Utility field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Is Overtime"; Rec."Is Overtime")
                {
                    ToolTip = 'Specifies the value of the Is Overtime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Paye"; Rec."Is Paye")
                {
                    ToolTip = 'Specifies the value of the Is Paye field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Pension Employee"; Rec."Is Pension Employee")
                {
                    ToolTip = 'Specifies the value of the Is Pension Employee field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Company Pension"; Rec."Is Pension Employer")
                {
                    ToolTip = 'Specifies the value of the Pension Employer field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is EVC"; Rec."Is EVC")
                {
                    ToolTip = 'Specifies the value of the Is EVC field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Gross"; Rec."Is Gross")
                {
                    ToolTip = 'Specifies the value of the Is Gross field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Is Late"; Rec."Is Late")
                {
                    ToolTip = 'Specifies the value of the Is Late field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Life"; Rec."Is Life")
                {
                    ToolTip = 'Specifies the value of the Is Life field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Is Reimbursable"; Rec."Is Reimbursable")
                {
                    ToolTip = 'Specifies the value of the Is Reimbursable field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Net"; Rec."Is Net")
                {
                    ToolTip = 'Specifies the value of the Is Net field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Is Total Deduction"; Rec."Is Total Deduction")
                {
                    ToolTip = 'Specifies the value of the Is Total Deduction field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Is Total Gross"; Rec."Is Total Gross")
                {
                    ToolTip = 'Specifies the value of the Is Total Gross field.', Comment = '%';
                    ApplicationArea = All;
                }

                field("Payslip Appearance"; Rec."Payslip Appearance")
                {
                    ToolTip = 'Specifies the value of the Payslip Appearance field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}
