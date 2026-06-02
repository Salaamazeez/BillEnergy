tableextension 50140 PurchHeader extends "Purchase Header"
{
    //Created by Akande

    fields
    {

        // modify("Sell-to Customer No.")
        // {
        //     trigger OnAfterValidate()
        //     begin
        //         TestField("User Code");
        //         Error('Fill the user code first');
        //     end;
        // }
        //modify()

        // Add changes to table fields here
        field(50109; "Purch REQ Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50000; Description; Text[250])
        {

        }
        field(50111; "Actual User"; Text[100])
        {

        }
        field(50112; Comments; Text[200])
        {

        }
        field(50001; "Posted No Series"; Code[20])
        {

        }
        field(50002; "PInv Order No"; Code[20])
        {
            // TableRelation = "Purchase Header"."No." where("Document Type" = filter(Order), Status = filter(Released));
        }
        field(52001; "Quantity Sum"; Decimal)
        {
            Editable = false;
            Caption = 'Quantity Sum';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Quantity" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
            // trigger OnValidate()
            // var
            //     salesline: Record "Sales Line";
            // begin
            //     "Partially Shipped" := salesline.Quantity - salesline."Quantity Shipped";
            // end;
        }
        field(52002; "Received Qty"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Quantity Received" where("Document Type" = field("Document Type"), "Document No." = field("No.")));
        }
        field(52003; "Remaining Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin

            end;
        }
        // Add changes to table fields here
    }
    procedure TestField()
    begin
        TestField("Shortcut Dimension 1 Code");
        TestField("Shortcut Dimension 2 Code");
    end;

    procedure CheckRemaingInvoice()
    var
        PurchLine: Record "Purchase Line";
        RemainingQty: Decimal;
    begin
        PurchLine.SetRange("Document No.", Rec."No.");
        if PurchLine.FindFirst() then
            repeat
                RemainingQty := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced";
                if PurchLine."Qty. to Invoice" > RemainingQty then
                    Error('You cannot invoice more than %1', RemainingQty);
            until PurchLine.Next() = 0
    end;


    procedure CalculateNewQtytoInvoice()
    var
        PurchLine: Record "Purchase Line";
    begin
        Commit();
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", Rec."No.");
        if PurchLine.FindFirst() then
            repeat
                PurchLine."Qty. to Invoice" := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced";
                PurchLine.Modify()
            until PurchLine.Next() = 0

    end;

    procedure CheckPurchaseAmount()
    var
        PurchaseHdr: Record "Purchase Header";
    begin
        Rec.CalcFields("Amount Including VAT");
        if not (Rec."Amount Including VAT" > 0) then
            Error('Amount must be greater than zero');
    end;

    var

        PurchHeader: Record "Purchase Header";

}