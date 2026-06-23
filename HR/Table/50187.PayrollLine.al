table 50187 PayrollLine
{
    Caption = 'Payroll Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Payroll Period"; Code[10])
        {
            Caption = 'Payroll Period';
            TableRelation = PayrollPeriods."Period Code";
        }
        field(2; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            TableRelation = employee."No.";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(5; "Job Title"; Text[80])
        {
            Caption = 'Job Title';
            Editable = false;
        }
        field(6; "Salary Code"; Code[20])
        {
            Caption = 'Salary Code';
            Editable = false;
            TableRelation = "Employment Contract".Code;
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }

        field(9; "Book Amount"; Decimal)
        {
            Caption = 'Book Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum(SalarySetupLine.Amount where("Salary Code" = field("Employment Contract Code"), "Element Code" = filter(600)));
        }
        field(10; "Payable Amount"; Decimal)
        {
            Caption = 'Payable Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum(PayrollDetailLine."Payable Amount" where("Payroll Period" = field("Payroll Period"), "Employee No." = field("Employee Code"), "Part of Payable Value" = filter(true)));
        }
        field(11; "Late Days"; Integer)
        {
            Caption = 'Late Days';
            Editable = false;
        }
        field(14; "Extra Days Worked"; Decimal)
        {
            Caption = 'Extra Days Worked';
            Editable = false;
        }

        field(15; "Absent  (Days)"; Integer)
        {
            Caption = 'Absent  (Days)';
            Editable = false;
        }
        field(16; "Employee Type"; Option)
        {
            Caption = 'Employee Type';
            OptionMembers = ,Permanent,Contract;
            Editable = false;
        }

        field(22; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
            Editable = false;
        }
        field(23; "Employment Contract Code"; Code[50])
        {
            Caption = 'Employment Contract Code';
            Editable = false;
        }
        field(24; "Late/Absent Hour"; Decimal)
        {
            Caption = 'Late/Absent Hour';
            Editable = false;
        }

        field(25; "No. of Worked Days"; Integer)
        {
            Caption = 'No. of Worked Days';
            Editable = false;
        }
        field(26; "Working Days"; Integer)
        {
            Caption = 'Working Days';
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Payroll Period", "Employee Code", "Line No.")
        {
            Clustered = true;
        }
        key(SK1; "Payroll Period", "Line No.")
        { }
        key(SK2; "Global Dimension 2 Code", "Payroll Period")
        { }
    }
    trigger OnDelete()
    begin

        PayrollDetailLine.Reset();
        PayrollDetailLine.SetRange("Payroll Period", "Payroll Period");
        If PayrollDetailLine.FindSet() then
            PayrollDetailLine.DeleteAll();
    end;

    var

        PayrollDetailLine: Record PayrollDetailLine;

}
