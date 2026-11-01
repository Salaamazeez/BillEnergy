tableextension 50003 VendorExt extends Vendor
{
    fields
    {
        field(50002; "No. 2"; Text[50]) { }
        
 field(50003; "Pushed to the Post"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Pushed to the Post';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnBeforeInsert()
    var
        UserSetup: Record "User Setup";
        Err0001: Label 'You must be a Master Record Admin or Procurement Admin to create or modify this record.';
    begin
        UserSetup.Get(UserId);
        if not (UserSetup."Master Record Admin" or UserSetup."Procurement Admin") then
            Error(Err0001);
    end;

    trigger OnBeforeModify()
    var
        UserSetup: Record "User Setup";
        Err0001: Label 'You must be a Master Record Admin or Procurement Admin to create or modify this record.';
    begin
        UserSetup.Get(UserId);
        if not (UserSetup."Master Record Admin" or UserSetup."Procurement Admin") then
            Error(Err0001);
    end;

}