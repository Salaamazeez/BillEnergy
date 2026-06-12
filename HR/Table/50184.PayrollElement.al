table 50184 PayrollElement
{
    Caption = 'Payroll Element';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Element Code"; Code[20])
        {
            Caption = 'Element Code';

            trigger OnValidate()
            begin
                Evaluate("Line No.", Format("Element Code"));
            end;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Element Name"; Code[50])
        {
            Caption = 'Element Name';
        }
        field(4; Earning; Boolean)
        {
            Caption = 'Earning';
        }
        field(5; Deduction; Boolean)
        {
            Caption = 'Deduction';
        }
        field(6; "Payslip Appearance"; Option)
        {
            Caption = 'Payslip Appearance';
            OptionMembers = ,Positive,Negative;
        }
        field(7; "Part of Net Payable"; Boolean)
        {
            Caption = 'Part of Net Payable';
        }
        field(8; "Appear in Payslip"; Boolean)
        {
            Caption = 'Appear in Payslip';
        }
        field(9; "Appear in Salary Setup"; Boolean)
        {
            Caption = 'Appear in Salary Setup';
        }

        field(11; "G/L Account"; Code[20])
        {
            Caption = 'G/L Account';
        }
        field(12; "Function of Pension"; Boolean)
        {
            Caption = 'Function of Pension';
        }
        field(13; "Function of Paye"; Boolean)
        {
            Caption = 'Function of Paye';
        }
        field(14; "Function of Poration"; Boolean)
        {
            Caption = 'Function of Poration';
        }
        field(15; "Is Paye"; Boolean)
        {
            Caption = 'Is Paye';
        }
        field(16; "Is Pension Employee"; Boolean)
        {
            Caption = 'Is Pension Employee';
        }
        field(17; "Is Pension Employer"; Boolean)
        {
            Caption = 'Is Pension Employer';
        }
        field(18; "Is Basic"; Boolean)
        {
            Caption = 'Is Basic';
        }
        field(19; "Is House"; Boolean)
        {
            Caption = 'Is House';
        }
        field(20; "Is Transport"; Boolean)
        {
            Caption = 'Is Transport';
        }
        field(21; "Is Utility"; Boolean)
        {
            Caption = 'Is Utility';
        }
        field(23; "Is Late"; Boolean)
        {
            Caption = 'Is Late';
        }
        field(24; "Is Absence"; Boolean)
        {
            Caption = 'Is Absence';
        }
        field(29; "Is Life"; Boolean)
        {
            Caption = 'Is Life';
        }
        field(30; "Is EVC"; Boolean)
        {
            Caption = 'Is EVC';
        }
        field(31; "Is Reimbursable"; Boolean)
        {
            Caption = 'Is Reimbursable';
        }

        field(32; "Is Gross"; Boolean)
        {
            Caption = 'Is Gross';
        }
        field(33; "Is Total Gross"; Boolean)
        {
            Caption = 'Is Total Gross';
        }
        field(34; "Is Total Deduction"; Boolean)
        {
            Caption = 'Is Total Deduction';
        }
        field(35; "Is Net"; Boolean)
        {
            Caption = 'Is Net';
        }
    }
    keys
    {
        key(PK; "Line No.", "Element Code")
        {
            Clustered = true;
        }
    }
}
