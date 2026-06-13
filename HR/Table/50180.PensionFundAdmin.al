table 50180 PensionFundAdmin
{
    Caption = 'Pension Fund Administrator';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; "PFA Code"; Code[30])
        {
            Caption = 'PFA Code';

        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }

    }
    keys
    {
        key(PK; "PFA Code")
        {
            Clustered = true;
        }
    }
}
