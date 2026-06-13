table 50195 ReimbursableHeader
{
    Caption = 'ReimbursableHeader';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Period Code"; Code[50])
        {
            Caption = 'Period Code';
        }
        field(2; Description; Text[200])
        {
            Caption = 'Description';
        }
        field(3; "Approvall Status"; Option)
        {
            Caption = 'Approvall Status';
            OptionMembers = ,Open,"Pending Approval",Approved;
        }
        field(4; "Global Dimension 1 Code Filter"; Code[50])
        {
            Caption = 'Global Dimension 1 Code Filter';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(5; "Global Dimension 2 Code Filter"; Code[50])
        {
            Caption = 'Global Dimension 2 Code Filter';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(7; "Employee Code Filter"; Code[50])
        {
            Caption = 'Employee Code Filter';
            TableRelation = Employee."No.";
        }
    }
    keys
    {
        key(PK; "Period Code")
        {
            Clustered = true;
        }
    }
}
