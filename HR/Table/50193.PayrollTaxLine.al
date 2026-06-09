table 50193 PayrollTaxLine
{
    Caption = 'PayrollTaxLine';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Tax Code"; Code[20])
        {
            Caption = 'Tax Code';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Lower Limit"; Decimal)
        {
            Caption = 'Lower Limit';
        }
        field(4; "Upper Limit"; Decimal)
        {
            Caption = 'Upper Limit';
        }
        field(5; "Tax Slab%"; Decimal)
        {
            Caption = 'Tax Slab%';
        }
        field(6; "Limit Amount"; Decimal)
        {
            Caption = 'Limit Amount';
        }
    }
    keys
    {
        key(PK; "Tax Code", "Line No.")
        {
            Clustered = true;
        }
    }
}
