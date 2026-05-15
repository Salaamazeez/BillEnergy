tableextension 50501 "Inventory Setup Ext" extends "Inventory Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Store Requisition Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50001; "Store Return Nos."; Code[20])
        {
            TableRelation = "No. Series";
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

    var
        myInt: Integer;
}