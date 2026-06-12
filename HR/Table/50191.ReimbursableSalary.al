table 50191 ReimbursableSalary
{
    Caption = 'Reimbursable Salary';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Payroll Period"; Code[10])
        {
            Caption = 'Payroll Period';
            editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            editable = false;
            TableRelation = Employee."No.";
        }
        field(3; "Element Code"; Code[10])
        {
            Caption = 'Element Code';
            editable = false;
            TableRelation = PayrollElement."Element Code";
        }
        field(4; "Employee Name"; Text[150])
        {
            Caption = 'Employee Name';
            editable = false;
        }
        field(5; "Element Name"; Code[50])
        {
            Caption = 'Element Name';
            editable = false;
        }
        field(6; "Global Dimension 1 Code"; Code[50])
        {

            editable = false;
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(7; "Global Dimension 2 Code"; Code[50])
        {

            editable = false;
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(8; "Document Date"; Date)
        {
            Caption = 'Document Date';
            editable = false;
        }
        field(9; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
            editable = false;
        }
        field(10; "Employment Contract Code"; Code[20])
        {
            Caption = 'Employment Contract Code';
            editable = false;
            TableRelation = "Employment Contract".Code;
        }
        field(11; "Job Title"; Code[50])
        {
            Caption = 'Job Title';
            editable = false;
        }
        field(12; "Payroll Bank"; Code[50])
        {
            Caption = 'Payroll Bank';
            editable = false;
        }
        field(13; "Payroll Bank Account No."; Code[20])
        {
            Caption = 'Payroll Bank Account No.';
            editable = false;
        }
        field(14; "Net Pay"; Decimal)
        {
            Caption = 'Net Pay';
            editable = false;
        }
        field(15; "Book Value"; Decimal)
        {
            Caption = 'Book Value';
            editable = false;
        }
        field(16; "No. of Days Worked"; Integer)
        {
            Caption = 'No. of Days Worked';
            editable = false;
        }
        field(17; "No. of Days In the Month"; Integer)
        {
            Caption = 'No. of Days In the Month';
            editable = false;
        }
        field(18; "Approval Status"; Option)
        {
            Caption = 'Approval Status';
            Editable = false;
            OptionMembers = Open,"Pending Approval",Approved,Closed;
        }
    }
    keys
    {
        key(PK; "Payroll Period", "Employee No.", "Element Code")
        {
            Clustered = true;
        }
    }
}
