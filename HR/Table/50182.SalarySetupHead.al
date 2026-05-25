table 50182 SalarySetupHeader
{
    Caption = 'Salary Setup Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Salary Code"; Code[10])
        {
            Caption = 'Salary Code';
            TableRelation = "Employment Contract".Code;
        }
        field(2; "Employee Cadre Code"; Code[50])
        {
            Caption = 'Employee Cadre Code';
        }

        field(3; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(4; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(5; "Created Time"; Time)
        {
            Caption = 'Created Time';
        }
        field(6; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
        }
        field(7; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
        }
        field(8; "Last Modified Time"; Time)
        {
            Caption = 'Last Modified Time';
        }
        field(9; "Gross Pay"; Decimal)
        {
            Caption = 'Gross Pay';
        }
        field(10; "Apply to"; Option)
        {
            Caption = 'Apply to';
            OptionMembers = ,"Rig Staff","Office Staff";
        }

        field(15; "Reimbursable Pay"; Decimal)
        {
            Caption = 'Reimbursable Pay';
        }
    }
    keys
    {
        key(PK; "Salary Code")

        {
            Clustered = true;
        }
    }
}
