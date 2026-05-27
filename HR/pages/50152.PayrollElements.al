namespace BILLENERGY.BILLENERGY;

page 50152 PayrollElements
{
    ApplicationArea = All;
    Caption = 'PayrollvElements';
    PageType = List;
    SourceTable = PayrollElement;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Element Code"; Rec."Element Code")
                {
                    ToolTip = 'Specifies the value of the Element Code field.', Comment = '%';
                }
                field("Element Name"; Rec."Element Name")
                {
                    ToolTip = 'Specifies the value of the Element Name field.', Comment = '%';
                }
                field(Earning; Rec.Earning)
                {
                    ToolTip = 'Specifies the value of the Earning field.', Comment = '%';
                }
                field(Deduction; Rec.Deduction)
                {
                    ToolTip = 'Specifies the value of the Deduction field.', Comment = '%';
                }
                field("Appear in Payslip"; Rec."Appear in Payslip")
                {
                    ToolTip = 'Specifies the value of the Appear in Payslip field.', Comment = '%';
                }
                field("Part of Net Payable"; Rec."Part of Net Payable")
                {
                    ToolTip = 'Specifies the value of the Part of Net Payable field.', Comment = '%';
                }
                field("Function of Paye"; Rec."Function of Paye")
                {
                    ToolTip = 'Specifies the value of the Function of Paye field.', Comment = '%';
                }
                field("Function of Pension"; Rec."Function of Pension")
                {
                    ToolTip = 'Specifies the value of the Function of Pension field.', Comment = '%';
                }
                field("Function of Poration"; Rec."Function of Poration")
                {
                    ToolTip = 'Specifies the value of the Function of Poration field.', Comment = '%';
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ToolTip = 'Specifies the value of the G/L Account field.', Comment = '%';
                }
                field("Is Absence"; Rec."Is Absence")
                {
                    ToolTip = 'Specifies the value of the Is Absence field.', Comment = '%';
                }
                field("Is Basic"; Rec."Is Basic")
                {
                    ToolTip = 'Specifies the value of the Is Basic field.', Comment = '%';
                }
                field("Is House"; Rec."Is House")
                {
                    ToolTip = 'Specifies the value of the Is House field.', Comment = '%';
                }
                field("Is Transport"; Rec."Is Transport")
                {
                    ToolTip = 'Specifies the value of the Is Transport field.', Comment = '%';
                }
                field("Is Utility"; Rec."Is Utility")
                {
                    ToolTip = 'Specifies the value of the Is Utility field.', Comment = '%';
                }
                field("Is Paye"; Rec."Is Paye")
                {
                    ToolTip = 'Specifies the value of the Is Paye field.', Comment = '%';
                }
                field("Is Pension Employee"; Rec."Is Pension Employee")
                {
                    ToolTip = 'Specifies the value of the Is Pension Employee field.', Comment = '%';
                }
                field("Is Company Pension"; Rec."Is Pension Employer")
                {
                    ToolTip = 'Specifies the value of the Pension Employer field.', Comment = '%';
                }
                field("Is EVC"; Rec."Is EVC")
                {
                    ToolTip = 'Specifies the value of the Is EVC field.', Comment = '%';
                }
                field("Is Gross"; Rec."Is Gross")
                {
                    ToolTip = 'Specifies the value of the Is Gross field.', Comment = '%';
                }

                field("Is Late"; Rec."Is Late")
                {
                    ToolTip = 'Specifies the value of the Is Late field.', Comment = '%';
                }
                field("Is Life"; Rec."Is Life")
                {
                    ToolTip = 'Specifies the value of the Is Life field.', Comment = '%';
                }
                field("Is Net"; Rec."Is Net")
                {
                    ToolTip = 'Specifies the value of the Is Net field.', Comment = '%';
                }

                field("Is Total Deduction"; Rec."Is Total Deduction")
                {
                    ToolTip = 'Specifies the value of the Is Total Deduction field.', Comment = '%';
                }
                field("Is Total Gross"; Rec."Is Total Gross")
                {
                    ToolTip = 'Specifies the value of the Is Total Gross field.', Comment = '%';
                }

                field("Payslip Appearance"; Rec."Payslip Appearance")
                {
                    ToolTip = 'Specifies the value of the Payslip Appearance field.', Comment = '%';
                }
            }
        }
    }
}
