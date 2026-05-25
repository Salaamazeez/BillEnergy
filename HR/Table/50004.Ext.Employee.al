tableextension 50004 EmployeeExt extends Employee
{
    fields
    {
        field(50002; "No. 2"; Text[50])
        {

        }
        field(50003; "Leave Setup Code"; code[20])
        {
            Caption = 'Leave Setup Code';
            DataClassification = ToBeClassified;
            TableRelation = LeaveSetup;
        }
        field(50004; PFA; code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'PFA';
            TableRelation = PensionFundAdmin."PFA Code";

        }
        field(50005; "RSA PIN"; Code[20])
        {
            trigger OnValidate()
            begin
                TestField(PFA);
            end;
        }
        field(50006; "PAYER ID"; code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'PAYER ID';

        }
        field(50007; "Payroll Bank"; code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payroll Bank';

        }
        modify("Bank Account No.")
        {
            Caption = 'Bank Code';
            trigger OnAfterValidate()
            begin
                TestField("Payroll Bank");
            end;
        }

    }
}
