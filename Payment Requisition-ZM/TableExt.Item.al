tableextension 50020 ItemExt extends Item
{

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