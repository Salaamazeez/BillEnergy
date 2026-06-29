table 50189 PayrollDetailLine
{
    Caption = 'Payroll Detail Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Payroll Period"; Code[10])
        {
            Caption = 'Payroll Period';
            TableRelation = PayrollPeriods."Period Code";
            
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee."No.";
        }
        field(3; "Element Code"; Code[10])
        {
            Caption = 'Element Code';
            TableRelation = PayrollElement."Element Code";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(6; "Payroll Creation Date"; Date)
        {
            Caption = 'Payroll Creation Date';
            Editable = false;
        }
        field(7; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
            Editable = false;
        }
        field(8; "Book Amount"; Decimal)
        {
            Caption = 'Book Amount';
            Editable = false;
        }
        field(9; "Element Name"; Code[50])
        {
            Caption = 'Element Name';
            Editable = false;
        }
        field(10; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            Editable = false;
        }
        field(11; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            Editable = false;
        }
        field(12; "Salary Code"; Code[10])
        {
            Caption = 'Salary Code';
            TableRelation = "Employment Contract".Code;
            Editable = false;
        }

        field(17; "Employee Type"; Option)
        {
            Caption = 'Employee Type';
            OptionMembers = ,Permanent,Contract;
            Editable = false;
        }

        field(19; "Pension Fund Manager"; Code[20])
        {
            Caption = 'PFA';
            Editable = false;
            TableRelation = PensionFundAdmin."PFA Code";
        }
        field(20; "Pension Fund No."; Code[20])
        {
            Caption = 'RSA PIN';
            Editable = false;
        }
        field(21; "Payroll Bank"; Code[20])
        {
            Caption = 'Payroll Bank';
            TableRelation = PayrollBank."Bank Code";
            Editable = false;
        }
        field(22; "Bank Account No."; Code[20])
        {
            Caption = 'Bank Account No.';
            Editable = false;
        }
        field(23; "Payslip Appearance"; Option)
        {
            Caption = 'Payslip Appearance';
            OptionMembers = ,Positive,Negative;
            Editable = false;
        }
        field(24; "Absent (Days)"; Integer)
        {
            Caption = 'Absent (Days)';
            Editable = false;
        }
        field(25; "Extra Days Worked"; Decimal)
        {
            Caption = 'Extra Days Worked';
            Editable = false;
        }
        field(26; "Late Days"; Integer)
        {
            Caption = 'Late Days';
            Editable = false;
        }
        field(27; "Part of Payable Value"; Boolean)
        {
            Caption = 'Part of Payable Value';
            Editable = false;
        }
        field(28; "Part of Book Value"; Boolean)
        {
            Caption = 'Part of Book Value';
            Editable = false;
        }

        field(30; "No of Late/Absent (Hr)"; Decimal)
        {
            Caption = 'No of Late/Absent (Hr)';
            Editable = false;
        }

        field(31; "Payable Amount"; Decimal)
        {
            Caption = 'Payable Amount';
            Editable = false;
        }
        field(32; "No of Overtime (Hours)"; Integer)
        {
            Caption = 'No of Overtime (Hours)';
            Editable = false;
        }
        field(33; "No of Worked Days"; Integer)
        {
            Caption = 'Extra Work Days';
            Editable = false;
        }
        field(34; "No of Days In the Month"; Integer)
        {
            Caption = 'No of Days In the Month';
            Editable = false;
        }
        field(35; " Employment Contract Code"; Code[50])
        {
            Caption = ' Employment Contract Code';
            Editable = false;
        }

    }
    keys
    {
        key(PK; "Payroll Period", "Employee No.", "Element Code")
        {
            Clustered = true;
        }
        key(SK1; "Line No.")
        {

        }

        key(SK3; "Element Code", "Payroll Period")
        {

        }
        key(SK4; "Global Dimension 1 Code", "Element Code")
        {

        }
    }
}
