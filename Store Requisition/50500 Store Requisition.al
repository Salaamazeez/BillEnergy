table 50500 "Store Requisition"
{
    //Created by Salaam Azeez

    DataClassification = ToBeClassified;
    LookupPageId = "Store Requisition List Dummy";
    fields
    {
        field(1; "No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            trigger OnValidate()
            BEGIN
                IF "No." <> xRec."No." THEN BEGIN
                    InventSetup.Get();
                    NoSeriesMgt.TestManual(InventSetup."Store Requisition Nos.");
                    "No. Series" := '';
                END;
            END;
        }
        field(2; Date; Date)
        {
            trigger OnValidate()
            BEGIN
                IF Date > WORKDATE THEN
                    ERROR('Posting Date cannot be a future date');
            END;
        }
        field(3; "Sanction No"; Code[60])
        {

        }
        field(4; Requester; Text[100]) { }
        field(5; "Shortcut Dimension 1 Code"; Code[60])
        {
            trigger OnValidate()
            BEGIN
                // ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            END;


        }
        field(6; "Shortcut Dimension 2 Code"; Code[30])
        {
            trigger OnValidate()
            BEGIN
                // ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            END;
        }
        field(7; "No. Series"; Code[60])
        {
            TableRelation = "No. Series".Code;

        }
        field(8; Status; Option)
        {
            Editable = false;
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }
        field(9; Posted; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(10; Location; Text[60])
        {
            TableRelation = Location;
        }
        field(11; "Project/Job Description"; Text[60])
        {

        }
        field(12; "Sanction No./Allocation Code"; Code[60])
        {
            Editable = false;
        }
        field(13; "Work Order No."; Code[60])
        {

        }
        field(17; Intercompany; Code[10])
        {
            //  TableRelation = "Pension Administrators"."Institution No";
            DataClassification = ToBeClassified;
        }
        field(18; "Allocation Code"; Code[50])
        {
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Editable = false;
            TableRelation = "Dimension Set Entry";
            trigger OnLookup()
            BEGIN
                //  ShowDocDim
            END;

            //   CaptionML=ENU=Dimension Set ID;
        }
        field(481; "Creation  Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(482; "Created By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(483; "Requisition Amount"; Decimal)
        {
            // FieldClass = FlowField;
            // CalcFormula = Sum("Stores Requisition Line".Value WHERE("Document No."=FIELD("No.")))
        }
        field(484; "PRQ Created"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(485; "Issued Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry".Quantity WHERE("Document No." = field("No.")));
        }
        field(486; "PRQ Processing?"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(487; "PRQ Reference No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(488; "Requested Qty."; Decimal)
        {
            // FieldClass = FlowField;
            //  CalcFormula = Lookup("Store Requisition Line"."Requested Qty." where());
            DecimalPlaces = 0 : 0;
            // BlankZero = false;
        }
        field(489; "Last Modified Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(490; "Last Date Modified"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(491; "Last Modified By"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(492; "Staff Name"; Text[50])
        {
            DataClassification = ToBeClassified;


        }
        field(493; "Staff No."; Code[50])
        {
            DataClassification = ToBeClassified;


        }
           

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        GLAccount: Record "G/L Account";
        Stock: Record Item;
        FixedAsset: Record "Fixed Asset";
        LineNo: Integer;
        PurchReqLineRec: Record "Purchase Requisition Line";
        //PurchReqHeaderRec:Record "Purch. Requistion";	
        PurchReqHeaderRec: Record "Purch. Requistion";
        PurchSetup: Record "Purchases & Payables Setup";
        InventSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        ItemJournalLine2: Record "Item Journal Line";
        ItemJournalLine: Record "Item Journal Line";
        StoreRequisitionLine: Record "Store Requisition Line";
        StoreRequisitionLine3: Record "Store Requisition Line";
        StoreRequisitionLine2: Record "Store Requisition Line";
        ItemRec: Record Item;
        StoreRec: Record "Store Requisition";
        ReportPrint: Codeunit "Test Report-Print";
        GLEntry: Record "G/L Entry";
        PurchReqNo: Decimal;
        StoresRequisition: Record "Store Requisition";
        DocumentApprovalEntrys: Record "Document Approval Entry";
        StoreLineRec: Record "Store Requisition Line";
        StoreLineRec2: Record "Store Requisition Line";
        StoreLineRec3: Record "Store Requisition Line";
        UserSetup: Record "User Setup";

    trigger OnInsert()
    begin
        UserSetup.GET(USERID);
        Requester := USERID;
        // VALIDATE("Shortcut Dimension 1 Code", UserSetup."Global Dimension 1 Code");
        // VALIDATE("Shortcut Dimension 2 Code", UserSetup."Shortcut Dimension 2 Code");
        Date := WORKDATE;
        "Creation  Date" := WORKDATE;

        "Created By" := USERID;

        IF "No." = '' THEN BEGIN
            InventSetup.Get();
            InventSetup.TESTFIELD("Store Requisition Nos.");
"No." := NoSeriesMgt.GetNextNo(InventSetup."Store Requisition Nos.");
        end;
    end;

    trigger OnModify()
    begin
        UserSetup.GET(USERID);
        Requester := USERID;
        // VALIDATE("Shortcut Dimension 1 Code", UserSetup."Global Dimension 1 Code");
        // VALIDATE("Shortcut Dimension 2 Code", UserSetup."Shortcut Dimension 2 Code");
        // Date := WORKDATE;
        "Last Modified Date Time" := CurrentDateTime;
        "Last Date Modified" := WORKDATE;

        "Last Modified By" := USERID;

    end;

    trigger OnDelete()
    begin
        StoreRequisitionLine3.Reset();
        StoreRequisitionLine3.SetRange("Document No.", "No.");
        if StoreRequisitionLine3.FindFirst() then
            StoreRequisitionLine3.DeleteAll();
    end;


    trigger OnRename()
    begin

    end;

    LOCAL procedure GetNoSeriesCode(): Code[30]
    begin

    end;

    procedure PostIssue()
    begin

        //CheckIssuedQuantityOnSRQLineNoNotZero;
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'ISSUE');
        IF ItemJournalLine2.FINDFIRST THEN
            ItemJournalLine2.DELETEALL;
        StoreRequisitionLine.SETRANGE("Document No.", "No.");
        IF StoreRequisitionLine.FINDFIRST THEN BEGIN
            REPEAT
                ItemJournalLine.Init();
                //  StoreRequisitionLine.TestField("Gen Bus. Posting Group");
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'ISSUE';
                // Message('%1&%2', StoreRequisitionLine."Qty. to Issue", Abs(StoreRequisitionLine."Issued Qty."));
                ItemJournalLine."Line No." := StoreRequisitionLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoreRequisitionLine."Stock Code");
                ItemRec.GET(StoreRequisitionLine."Stock Code");
                ItemJournalLine."Item No." := StoreRequisitionLine."Stock Code";
                ItemJournalLine.VALIDATE("Item No.", ItemRec."No.");
                ItemJournalLine."Posting Date" := TODAY;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Gen. Bus. Posting Group" := ItemJournalLine."Gen. Bus. Posting Group";
                //ItemJournalLine."Document No." := 'T00007';
                ItemJournalLine."Document Date" := Date;
                ItemJournalLine."Location Code" := StoreRequisitionLine."Location Code";
                ItemJournalLine."Gen. Bus. Posting Group" := StoreRequisitionLine."Gen Bus. Posting Group";
                // ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                ItemJournalLine.VALIDATE(Quantity, StoreRequisitionLine."Qty. to Issue");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                if StoreRequisitionLine."Qty. to Issue" <> 0 then begin
                    ItemJournalLine.INSERT;
                    StoreRequisitionLine."Qty issued" := StoreRequisitionLine."Qty issued" + StoreRequisitionLine."Qty. to Issue";
                    StoreRequisitionLine.Modify();
                end
            UNTIL StoreRequisitionLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);
        END;
        CheckPostedJnl2
        // StoreRequisitionLine2.SETRANGE("Document No.", "No.");
        // IF StoreRequisitionLine2.FINDFIRST THEN BEGIN
        //     REPEAT
        //         Message('%1', Abs(StoreRequisitionLine2."Issued Qty."));
        //         if StoreRequisitionLine2."Qty. to Issue" + Abs(StoreRequisitionLine2."Issued Qty.") = StoreRequisitionLine2."Requested Qty." then
        //             CheckPostedJnl;
        //     until StoreRequisitionLine2.Next() = 0;
        // end
    end;

    procedure PostIssuePrint()
    begin
        ;
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'ISSUE');
        IF ItemJournalLine2.FINDFIRST THEN
            ItemJournalLine2.DELETEALL;

        StoreRequisitionLine.SETRANGE("Document No.", "No.");
        IF StoreRequisitionLine.FINDFIRST THEN BEGIN
            REPEAT
                StoreRequisitionLine.TestField("Gen Bus. Posting Group");
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'ISSUE';
                ItemJournalLine."Line No." := StoreRequisitionLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoreRequisitionLine."Stock Code");
                ItemRec.GET(StoreRequisitionLine."Stock Code");
                ItemJournalLine."Item No." := StoreRequisitionLine."Stock Code";
                ItemJournalLine.VALIDATE("Item No.", ItemRec."No.");
                ItemJournalLine."Posting Date" := TODAY;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Gen. Bus. Posting Group" := ItemJournalLine."Gen. Bus. Posting Group";
                //ItemJournalLine."Document No." := 'T00007';
                ItemJournalLine."Document Date" := Date;
                ItemJournalLine."Location Code" := StoreRequisitionLine."Location Code";
                ItemJournalLine."Gen. Bus. Posting Group" := StoreRequisitionLine."Gen Bus. Posting Group";
                // ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                ItemJournalLine.VALIDATE(Quantity, StoreRequisitionLine."Qty. to Issue");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                ItemJournalLine.INSERT;
            UNTIL StoreRequisitionLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print", ItemJournalLine);
        END;
        //  CheckPostedJnl
    end;

    procedure TestReport()
    begin
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'ISSUE');
        IF ItemJournalLine2.FINDFIRST THEN
            ItemJournalLine2.DELETEALL;

        StoreRequisitionLine.SETRANGE("Document No.", "No.");
        IF StoreRequisitionLine.FINDFIRST THEN BEGIN
            REPEAT
                StoreRequisitionLine.TestField("Gen Bus. Posting Group");
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'ISSUE';
                ItemJournalLine."Line No." := StoreRequisitionLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoreRequisitionLine."Stock Code");
                ItemRec.GET(StoreRequisitionLine."Stock Code");
                ItemJournalLine."Item No." := StoreRequisitionLine."Stock Code";
                ItemJournalLine.VALIDATE("Item No.", ItemRec."No.");
                ItemJournalLine."Posting Date" := TODAY;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Gen. Bus. Posting Group" := ItemJournalLine."Gen. Bus. Posting Group";
                //ItemJournalLine."Document No." := 'T00007';
                ItemJournalLine."Document Date" := Date;
                ItemJournalLine."Location Code" := StoreRequisitionLine."Location Code";
                ItemJournalLine."Gen. Bus. Posting Group" := StoreRequisitionLine."Gen Bus. Posting Group";
                // ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                ItemJournalLine.VALIDATE(Quantity, StoreRequisitionLine."Qty. to Issue");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                ItemJournalLine.INSERT;
                COMMIT;
            UNTIL StoreRequisitionLine.NEXT = 0;
            ReportPrint.PrintItemJnlLine(ItemJournalLine);
        END;

    end;

    procedure CheckPostedJnl2()
    var
        TotalIssued: Decimal;
    begin
        StoreLineRec2.SetRange("Document No.", "No.");
        if StoreLineRec2.FindFirst() then begin
            repeat
                // Message('TotalIssued=%1&"Requested Qty."=%2', TotalIssued);
                if StoreLineRec2."Qty issued" <> StoreLineRec2."Requested Qty." then begin
                    TotalIssued := StoreLineRec2."Qty issued";
                    // Message('TotalIssued=%1&"Requested Qty."=%2', TotalIssued);
                    Posted := false;
                    MODIFY;
                    exit
                end;
            until StoreLineRec2.Next() = 0
        end;
        Posted := true;
        MODIFY;

    end;

    procedure AssitEdit(OldStore: Record "Store Requisition"): Boolean
    var
    StoreReq : Record "Store Requisition";
    begin
        StoreReq := Rec;
        InventSetup.GET;
        InventSetup.TESTFIELD("Store Requisition Nos.");
        // IF NoSeriesMgt.SelectSeries(CustomSetup."Store Requisition Nos.", OldStore."No. Series", StoreRec."No. Series") THEN BEGIN
        //     CustomSetup.GET;
        //     CustomSetup.TESTFIELD("Store Requisition Nos.");
        //     NoSeriesMgt.SetSeries(StoreRec."No.");
        //     Rec := StoreRec;
        //     EXIT(TRUE);
        // END;

        if NoSeriesMgt.LookupRelatedNoSeries(InventSetup."Store Requisition Nos.", OldStore."No. Series", "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo("No. Series");
            Rec := StoreReq;
            exit(true);
        end;
    end;

    procedure CreatePurchaseRequisition()
    var
        PurchReqNo2: Code[20];
    begin
        PurchSetup.Get();
        PurchSetup.TestField("Purchase Requisition Nos.");
        IF "PRQ Created" THEN
            ERROR('PRQ HAS ALREADY BEEN CREATED FOR THIS SRQ')
        ELSE BEGIN
            // Message('hello');
            //if not "PRQ Created" then
            ;
            // PurchaseSetup.GET;
            // PurchNo := NoSeriesMgt.GetNextNo(PurchaseSetup."Order Nos.", TODAY, TRUE);
            //PurchReqNo:= NoSeriesMgt.GetNextNo(PurchaSetup."Purch. Requisition Nos.",TODAY,TRUE);
            PurchReqNo2 := NoSeriesMgt.GetNextNo(PurchSetup."Purchase Requisition Nos.", TODAY, TRUE);
            // PVHeaderNo := NoSeriesMgt.GetNextNo(CustSetup."Payment Voucher No.", TODAY, TRUE);
            // Message(PurchReqNo2);
            PurchReqHeaderRec.INIT;
            PurchReqHeaderRec."No." := PurchReqNo2;
            PurchReqHeaderRec.Date := Date;
            PurchReqHeaderRec."SRQ Ref.No." := "No.";
            PurchReqHeaderRec."Requisition Amount" := "Requisition Amount";
            PurchReqHeaderRec.Requester := Requester;
            IF PurchReqHeaderRec.INSERT(TRUE) THEN
                "PRQ Created" := TRUE;
            "PRQ Reference No." := PurchReqHeaderRec."No.";
            PurchReqHeaderRec.VALIDATE("Request Description", "Project/Job Description");
            PurchReqHeaderRec.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
            PurchReqHeaderRec.VALIDATE("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
            PurchReqHeaderRec.MODIFY(TRUE);
            StoreLineRec.SETRANGE("Document No.", "No.");
            // PurchReqlines.SETRANGE(PurchReqlines."Document No.","No.");       
            IF StoreLineRec.FINDSET THEN
                REPEAT
                    PurchReqLineRec.INIT;
                    LineNo += 10000;
                    // PurchinvLines."Document Type":= PurchInv."Document Type";
                    PurchReqLineRec."Document No." := PurchReqNo2;
                    PurchReqLineRec."Line No." := LineNo;

                    //PurchinvLines.VALIDATE(PurchinvLines."Buy-from Vendor No.",PurchInv."Buy-from Vendor No.");
                    IF StoreLineRec.Type = StoreLineRec.Type::Stock THEN BEGIN
                        PurchReqLineRec.VALIDATE(Type, PurchReqLineRec.Type::Stock);
                        IF FixedAsset.GET(StoreLineRec."Stock Code") THEN
                            PurchReqLineRec.VALIDATE("No.", StoreLineRec."Stock Code");
                    END;// ELSE ERROR('Pleaase Register This Asset In Assets Register Before Invoice');
                    IF StoreLineRec.Type = StoreLineRec.Type::Stock THEN BEGIN
                        PurchReqLineRec.VALIDATE(Type, PurchReqLineRec.Type::Stock);
                        IF Stock.GET(StoreLineRec."Stock Code") THEN
                            PurchReqLineRec.VALIDATE("No.", StoreLineRec."Stock Code");
                    END;
                    IF StoreLineRec.Type = StoreLineRec.Type::Service THEN BEGIN
                        PurchReqLineRec.VALIDATE(Type, StoreLineRec.Type::Service);
                        IF GLAccount.GET(PurchReqLineRec."No.") THEN
                            PurchReqLineRec.VALIDATE("No.", StoreLineRec."Stock Code");
                    END;
                    //PurchReqLineRec.VALIDATE("Shortcut Dimension 1 Code",StoreLineRec."Shortcut Dimension 1 Code");
                    //PurchReqLineRec.VALIDATE("Shortcut Dimension 2 Code",StoreLineRec."Shortcut Dimension 2 Code");
                    PurchReqLineRec.VALIDATE(Quantity, StoreLineRec."Requested Qty.");
                    PurchReqLineRec.VALIDATE("Unit Cost", StoreLineRec."Unit Price");
                    // PurchReqLineRec.VALIDATE("Unit Cost",StoreLineRec."Unit Price");
                    PurchReqLineRec.VALIDATE(Amount, StoreLineRec."Requested Value");
                    PurchReqLineRec.INSERT;
                //PurchINVLines.VALIDATE("Location code",PurchReqlines."location code");
                // PurchReqLineRec.MODIFY;

                UNTIL StoreLineRec.NEXT = 0;

            COMMIT;
            //PAGE.RUN(50424,PurchReqHeaderRec);
            //END;
            //ELSE ERROR('Specify Prefered Vendor Before Invoice');
        END;

    end;

    procedure ReopenRequisition()
    begin
        IF Status = Status::"Pending Approval" THEN
            TESTFIELD(Status, Status::"Pending Approval");
        IF StoresRequisition.FINDFIRST THEN
            Status := Status::Open;
        DocumentApprovalEntrys.DELETEALL;
    end;

    procedure CheckIssuedQtyOnLine()
    begin

        StoreLineRec.GET("No.");
        StoreLineRec.TESTFIELD("Issued Qty.", 0);
    end;

    procedure CheckSRQLineRec(): Boolean
    begin
        StoreRequisitionLine.RESET;
        StoreRequisitionLine.SETRANGE("Document No.", "No.");

        EXIT(StoreRequisitionLine.FINDFIRST);
    end;

    procedure TestStatusOpen()
    begin

    end;

    // var 

}