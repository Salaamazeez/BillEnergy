table 50383 "Portal Mgt"
{

    fields
    {
        field(1; PK; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Base Url"; Text[100])
        {

        }
        field(3; "Employee Url"; Text[50])
        {
            
        }
        field(4; "Vendor Url"; Text[50])
        {

        }
        field(5; "Authorization Key"; Text[100])
        {

        }
    }

    keys
    {
        key(PK; PK)
        {
            Clustered = true;
        }
    }

}