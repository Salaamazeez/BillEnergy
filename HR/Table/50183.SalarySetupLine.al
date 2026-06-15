table 50183 SalarySetupLine
{
    Caption = 'Salary Setup Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Salary Code"; Code[10])
        {
            Caption = 'Salary Code';
            TableRelation = SalarySetupHeader."Salary Code";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Element Code"; Code[50])
        {
            Caption = 'Element Code';
            TableRelation = PayrollElement."Element Code";
        }
        field(4; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(5; Earning; Boolean)
        {
            Caption = 'Earning';
        }
        field(6; Deduction; Boolean)
        {
            Caption = 'Deduction';
        }
        field(7; Taxable; Boolean)
        {
            Caption = 'Taxable';
        }

        field(13; "Element Name"; Code[50])
        {
            Caption = 'Element Name';
        }
        field(14; "Calculation formula"; Text[100])
        {
            Caption = 'Calculation formula';
        }
        field(15; Calculated; Boolean)
        {
            Caption = 'Calculated';
        }
        field(16; "Use formula"; Boolean)
        {
            Caption = 'Use formula';
        }
        field(17; "Function of Pension"; Boolean)
        {
            Caption = 'Function of Pension';
        }

    }
    keys
    {
        key(PK; "Salary Code", "Line No.")
        {
            Clustered = true;
        }
        key(SK; "Line No.")
        {

        }

    }
}
