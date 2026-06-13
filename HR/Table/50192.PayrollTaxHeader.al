table 50192 PayrollTaxHeader
{
    Caption = 'PayrollTaxHeader';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Tax Code"; Code[20])
        {
            Caption = 'Tax Code';
        }
        field(2; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(3; "Rent Relief Cap"; Decimal)
        {
            Caption = 'Rent Relief Cap';
        }
        field(4; Open; Boolean)
        {
            Caption = 'Open';
        }

        field(5; "Rent Relief%"; Decimal)
        {
            Caption = 'Rent Relief %';
        }
    }
    keys
    {
        key(PK; "Tax Code")
        {
            Clustered = true;
        }
    }
}
