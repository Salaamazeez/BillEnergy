table 50181 PayrollBank
{
    Caption = 'Payroll Bank';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Bank Code"; Code[50])
        {
            Caption = 'Bank Code';
        }
        field(2; "Bank Name"; Text[100])
        {
            Caption = 'Bank Name';
        }
        field(3; "Sort Code"; Code[10])
        {
            Caption = 'Sort Code';
        }
    }
    keys
    {
        key(PK; "Bank Code")
        {
            Clustered = true;
        }
    }
}
