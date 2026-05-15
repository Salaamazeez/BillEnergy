table 50501 "Store Requisition Line"
{
    //Created by Salaam Azeez
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[60]) { }
        field(2; "Line No."; Integer)
        {
            // AutoIncrement = true;
        }

        // field(22; Type; Option)
        // {
        //     DataClassification = ToBeClassified;
        //     // OptionCaptionML = ENU =, Asset, Stock, Project;
        //     OptionMembers = " ",Asset,Stock,Service;

        //     trigger OnValidate()
        //     BEGIN
        //         TestStatusOpenLine;
        //     END;
        // }

        field(3; "Stock Code"; Code[50])
        {
            TableRelation = IF (Type = FILTER(Stock)) Item."No."
            ELSE
            IF (Type = FILTER(Asset)) "Fixed Asset"."No."
            ELSE
            IF (Type = FILTER(Service)) "G/L Account"."No.";

            trigger OnValidate()
            BEGIN
                TestStatusOpenLine;

                IF (Type = Type::Stock) THEN BEGIN
                    IF Item.GET("Stock Code") THEN
                        VALIDATE(Description, Item.Description);
                    VALIDATE("Unit Price", Item."Unit Cost");
                    "Unit of Issue" := Item."Base Unit of Measure";
                    Item.CALCFIELDS(Inventory);
                    "Qty in Store at Request" := Item.Inventory;

                END ELSE BEGIN
                    Description := '';
                    "Unit Price" := 0;
                    "Unit of Issue" := '';
                    Value := 0;
                    "Qty in Store at Request" := 0;
                END;

                IF (Type = Type::Asset) THEN BEGIN
                    IF FA.GET("Stock Code") THEN
                        VALIDATE(Description, FA.Description);
                    VALIDATE("Location Code", FA."Location Code");
                END;

                IF (Type = Type::Service) THEN BEGIN
                    IF "g/lacc".GET("Stock Code") THEN
                        VALIDATE(Description, "g/lacc".Name);
                END;
            END;

        }
        field(4; Description; Text[50])
        {
            Editable = false;
        }
        field(5; "Unit of Issue"; Code[50])
        {
            Editable = false;
        }
        field(6; "Requested Qty."; Decimal)
        {
            DecimalPlaces = 0 : 0;
            BlankZero = false;


            trigger OnValidate()
            begiN
                BEGIN
                    TestStatusOpenLine;
                    TESTFIELD("Location Code");
                    Item.SETCURRENTKEY("No.");
                    Item.SETRANGE("No.", "Stock Code");
                    Item.SETFILTER("Location Filter", '%1', "Location Code");
                    IF Item.FINDFIRST THEN BEGIN
                        Item.CALCFIELDS("Net Change");
                        "Qty in Store at Request" := Item."Net Change";
                        "Qty in Store at the moment" := Item."Net Change";
                        IF Item."Net Change" < "Requested Qty." THEN
                            MESSAGE(Text001);
                    END;

                    "Requested Value" := "Unit Price" * "Requested Qty.";
                END;


            END;

        }
        field(7; "Issued Qty."; Decimal)
        {
            //FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity where("Document No." = field("Document No."), "Item No." = field("Stock Code")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Qty. to Issue"; Decimal)
        {
            trigger OnValidate()
            BEGIN
                TESTFIELD("Location Code");
                ItemQty := "Qty. to Issue";

                Item.SETCURRENTKEY("No.");
                Item.SETRANGE("No.", "Stock Code");
                Item.SETFILTER("Location Filter", '%1', "Location Code");
                IF Item.FINDFIRST THEN BEGIN
                    Item.CALCFIELDS("Net Change");
                    IF Item."Net Change" < ItemQty THEN
                        ERROR(Text001);
                END;
                IF "Qty. to Issue" > "Requested Qty." THEN
                    ERROR('ISSUE QUANTITY CANNOT BE GREATER THAN REQUESTED QUANTITY');

                Value := "Unit Price" * "Qty. to Issue";
                //  "Requested Value" := "Unit Price" * "Requested Qty.";
            END;

        }
        field(8; "Unit Price"; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(9; Value; Decimal)
        {
            BlankZero = true;

        }
        field(10; "Location Code"; Code[50])
        {
            TableRelation = Location.Code;
        }
        field(11; "Qty in Store at Request"; Decimal)
        { Editable = false; }

        field(12; "Qty in Store at the moment"; Decimal)
        {
            //FieldClass = FlowField;
            //CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Stock Code"), "Location Code" = FIELD("Location Code")));
            Editable = false;
        }
        field(19; "Qty issued"; Decimal)
        {
            Editable = false;
        }
        field(13; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            //OptionCaptionML=ENU=G/L Account,Bank;
            OptionMembers = "G/L Account",Bank;
        }
        field(14; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"."No." WHERE(Blocked = FILTER(false), "Account Type" = CONST(Posting)) ELSE
            IF ("Account Type" = CONST(Bank)) "Bank Account"."No." WHERE(Blocked = CONST(false));
            Trigger OnValidate()
            BEGIN

                IF "Account No." <> '' THEN BEGIN
                    CASE "Account Type" OF
                        0:
                            BEGIN
                                "g/lacc".GET("Account No.");
                                "Account Description" := "g/lacc".Name;
                                StoresRequisition."Shortcut Dimension 1 Code" := "g/lacc"."Global Dimension 1 Code";
                                StoresRequisition."Shortcut Dimension 2 Code" := "g/lacc"."Global Dimension 2 Code";
                            END;
                    end;
                end;
            end;
        }
        field(15; "Account Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()

            BEGIN

                // "Transaction Description" := "Account Description";
            END;
        }

        field(16; "Cash/Cheque"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Cash,Cheque;
        }

        field(18;
        "Gen Bus. Posting Group"; Code[50])
        {
            TableRelation = "Gen. Business Posting Group";
            DataClassification = ToBeClassified;
        }
        // field(22; Type; Option)
        // {
        //     DataClassification = ToBeClassified;
        //     // OptionCaptionML = ENU =, Asset, Stock, Project;
        //     OptionMembers = " ",Asset,Stock,Service;

        //     trigger OnValidate()
        //     BEGIN
        //         TestStatusOpenLine;
        //     END;
        field(20; "Stock Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Stock,Consumables,Sample;

        }
        field(22; Type; Option)
        {
            DataClassification = ToBeClassified;
            // OptionCaptionML = ENU =, Asset, Stock, Project;
            OptionMembers = Stock,Asset,Service;

            trigger OnValidate()
            BEGIN
                TestStatusOpenLine;
            END;
        }//  }

        field(27; "Requested Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }




    keys
    {
        key(PK; "Document No.", "Location Code", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        Item: Record 27;
        ItemQty: Decimal;
        Text001: TextConst ENU = 'There is no sufficient quantity for this item!';
        "g/lacc": Record 15;
        bankrec: Record 270;
        StoresRequisition: Record 50500;
        StoresRequisitionLine: Record 50501;
        DimMgt: Codeunit 408;
        FA: Record 5600;

    trigger OnInsert()
    begin

    END;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    PROCEDURE TestStatusOpenLine();
    BEGIN
        StoresRequisition.GET("Document No.");
        StoresRequisition.TESTFIELD(Status, StoresRequisition.Status::Open);
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode(FieldNumber: Integer; VAR ShortcutDimCode: Code[20]);

    VAR
        OldDimSetID: Integer;
    begin
        BEGIN
            OldDimSetID := StoresRequisition."Dimension Set ID";
            DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, StoresRequisition."Dimension Set ID");
            IF "Stock Code" <> '' THEN
                MODIFY;
        END;
    end;

    PROCEDURE CheckIfQtyAttheMomentIsLessThanRequestedQty(): Boolean;
    BEGIN
        IF ("Qty in Store at the moment" < "Requested Qty.") OR ("Qty in Store at Request" < "Requested Qty.") THEN
            EXIT(StoresRequisitionLine.FINDFIRST);

    END;

    // PROCEDURE TestStatusOpenLine@1();
    // BEGIN
    //     StoresRequisition.GET("Document No.");
    //     StoresRequisition.TESTFIELD(Status, StoresRequisition.Status::" ");
    // END;


}