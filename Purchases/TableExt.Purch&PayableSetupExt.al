tableextension 50500 "Purch & Payable Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Purchase Requisition Nos."; Code[20])
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