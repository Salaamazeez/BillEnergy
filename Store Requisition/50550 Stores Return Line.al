table 50551 "Stores Return Line"
{
    //Created by Salaam Azeez
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[60]) { }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
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

        field(3; "Stock Code"; Code[60])
        {

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
        }
        field(17; "Qty to Return"; Decimal)
        {
            trigger OnValidate()
            begin
                TESTFIELD("Location Code");
                Item.SETCURRENTKEY("No.");
                Item.SETRANGE("No.", "Stock Code");
                Item.SETFILTER("Location Filter", '%1', "Location Code");
                IF Item.FINDFIRST THEN BEGIN
                    Item.CALCFIELDS("Net Change");

                    IF "Issued Qty" < "Qty to Return" THEN
                        //MESSAGE(Text001);
                        ERROR(Text001);
                END;

                Value := "Unit Price" * "Qty to Return";
            end;
        }
        field(7; "Returned Qty."; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity where("Document No." = field("Document No."), "Item No." = field("Stock Code")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

        }
        field(12; "Qty Returned"; Decimal)
        {
            //FieldClass = FlowField;

        }
        field(8; "Unit Price"; Decimal)
        {
            BlankZero = true;
            Editable = false;
        }
        field(9; Value; Decimal) { BlankZero = true; }
        field(10; "Location Code"; Code[50])
        {
            TableRelation = Location.Code;
        }
        field(11; "Issued Qty"; Decimal)
        { Editable = false; }

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

                        1, 5:
                            BEGIN
                                bankrec.GET("Account No.");
                                "Account Description" := bankrec.Name;
                                //"Account Description2" := custrec.Address;
                                StoresRequisition."Shortcut Dimension 1 Code" := bankrec."Global Dimension 1 Code";
                                StoresRequisition."Shortcut Dimension 2 Code" := bankrec."Global Dimension 2 Code";
                            END;

                    END;
                END;

            END;
            //  END;
            //  end;
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

        field(18; "Gen Bus. Posting Group"; Code[50])
        {
            TableRelation = "Gen. Business Posting Group";
            DataClassification = ToBeClassified;
        }

    }




    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            //Clustered = true;
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
        TestStatusOpenLine;
        // DimMgt.UpdateDefaultDim(DATABASE::"Stores Requisition Line", "Stock Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

    END;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        TestStatusOpenLine;
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

    // PROCEDURE CheckIfQtyAttheMomentIsLessThanRequestedQty(): Boolean;
    // BEGIN
    //     IF ("Qty in Store at the moment" < "Requested Qty.") OR ("Qty in Store at Request" < "Requested Qty.") THEN
    //         EXIT(StoresRequisitionLine.FINDFIRST);

    // END;

    // PROCEDURE TestStatusOpenLine@1();
    // BEGIN
    //     StoresRequisition.GET("Document No.");
    //     StoresRequisition.TESTFIELD(Status, StoresRequisition.Status::" ");
    // END;


}