table 50188 PayrollOthervariables
{
    Caption = 'Payroll Other Variables';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = employee."No.";
        }
        field(2; "Payroll Period"; Code[10])
        {
            Caption = 'Payroll Period';
            TableRelation = PayrollPeriods."Period Code";
        }
        field(3; "Element Code"; Code[10])
        {
            Caption = 'Element Code';
            TableRelation = PayrollElement."Element Code";
        }
        field(4; "Element Name"; Code[50])
        {
            Caption = 'Element Name';
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(6; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
        }

        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(11; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(13; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(14; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(15; "Created Time"; Time)
        {
            Caption = 'Created Time';
            Editable = false;
        }
        field(16; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            Editable = false;
        }
        field(17; "Modified Date"; Date)
        {
            Caption = 'Modified Date';
            Editable = false;
        }
        field(18; "Modified Time"; Time)
        {
            Caption = 'Modified Time';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Employee No.", "Payroll Period", "Element Code")
        {
            Clustered = true;
        }
    }
}
