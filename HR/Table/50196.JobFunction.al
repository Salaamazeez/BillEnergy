table 50196 JobFunction
{
    Caption = 'Job Function';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job Title Code"; Code[50])
        {
            Caption = 'Job Title Code';
        }
        field(2; "Job Title"; Text[50])
        {
            Caption = 'Job Title';
        }
    }
    keys
    {
        key(PK; "Job Title Code")
        {
            Clustered = true;
        }
    }
}
