table 50550 "Stores Return"
{
    //Created by Salaam Azeez
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[60])
        {

            trigger OnValidate()
            BEGIN

                // IF "No." <> xRec."No." THEN BEGIN
                //     InventSetup.GET;
                //     NoSeriesMgt.TestManual(GetNoSeriesCode);
                //     "No. Series" := '';
                // END;
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
           OptionMembers = Open,Approved,"Pending Approval",Rejected;
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
        field(17; "Issue No."; Code[60])
        {
            //  TableRelation = "Pension Administrators"."Institution No";
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
            begin
                StoresRequisition.SETRANGE(Posted, TRUE);
                IF PAGE.RUNMODAL(50517, StoresRequisition) = ACTION::LookupOK THEN BEGIN
                    "Issue No." := StoresRequisition."No.";
                    Requester := StoresRequisition.Requester;
                    "Shortcut Dimension 1 Code" := StoresRequisition."Shortcut Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := StoresRequisition."Shortcut Dimension 2 Code";
                    Location := StoresRequisition.Location;
                    //  "Staff No." := StoresRequisition."Staff No.";
                    // "Staff Name" := StoresRequisition."Staff Name";
                    "Project/Job Description" := StoresRequisition."Project/Job Description";
                    "Sanction No./Allocation Code" := StoresRequisition."Sanction No./Allocation Code";
                    "Work Order No." := StoresRequisition."Work Order No.";

                    //StoresRequisitionLine.SETRANGE("Document No.", "Issue No.");
                    StoresRequisitionLine.SETRANGE("Document No.", StoresRequisition."No.");
                    IF StoresRequisitionLine.FINDFIRST THEN BEGIN

                        StoresReturnLine2.SETRANGE("Document No.", "No.");
                        StoresReturnLine2.DELETEALL;

                        REPEAT
                            StoresReturnLine.INIT;
                            StoresReturnLine."Document No." := "No.";
                            StoresReturnLine."Line No." := StoresRequisitionLine."Line No.";
                            StoresReturnLine."Stock Code" := StoresRequisitionLine."Stock Code";
                            StoresReturnLine.Description := StoresRequisitionLine.Description;
                            StoresReturnLine."Unit of Issue" := StoresRequisitionLine."Unit of Issue";
                            StoresReturnLine."Requested Qty." := StoresRequisitionLine."Requested Qty.";
                            // StoresReturnLine."Returned Qty." := StoresRequisitionLine."Issued Qty.";
                            StoresReturnLine."Issued Qty" := StoresRequisitionLine."Qty issued";
                            StoresReturnLine."Unit Price" := StoresRequisitionLine."Unit Price";
                            // StoresReturnLine.Value := StoresRequisitionLine.Value;
                            StoresReturnLine.Value := StoresReturnLine."Returned Qty." * StoresReturnLine."Unit Price";
                            StoresReturnLine."Location Code" := StoresRequisitionLine."Location Code";

                            StoresReturnLine.INSERT;
                        UNTIL StoresRequisitionLine.NEXT = 0;
                    END;
                END;


            end;
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
        // field(492; "Staff Name"; Text[50])
        // {
        //     DataClassification = ToBeClassified;
        // }
        // field(493; "Staff No."; Code[50])
        // {
        //     DataClassification = ToBeClassified;
        // }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        InventSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        // CustomSetup: Record "Custom Setup";
        ItemJournalLine2: Record "Item Journal Line";
        ItemJournalLine: Record "Item Journal Line";
        StoreRequisitionLine: Record "Store Requisition Line";
        ItemRec: Record Item;
        StoreRec: Record "Store Requisition";
        ReportPrint: Codeunit "Test Report-Print";
        GLEntry: Record "G/L Entry";
        PurchaSetup: Record "Purchases & Payables Setup";
        PurchReqNo: Decimal;
        StoresRequisition: Record "Store Requisition";
        DocumentApprovalEntrys: Record "Document Approval Entry";
        StoresRequisitionLine: Record "Store Requisition Line";
        UserSetup: Record "User Setup";
        StoresReturnLine: Record "Stores Return Line";
        StoresReturnLine2: Record "Stores Return Line";
        StoresReturnLine3: Record "Stores Return Line";

    trigger OnInsert()
    begin
        UserSetup.GET(USERID);
        //Requester := UserSetup."User ID";
        //VALIDATE("Shortcut Dimension 1 Code",UserSetup."Full Name"); 
        //VALIDATE("Shortcut Dimension 2 Code",UserSetup."Department Code");
        Date := TODAY;

        IF "No." = '' THEN BEGIN
            InventSetup.Get();
            InventSetup.TestField("Store Return Nos.");
            // NoSeriesMgt.InitSeries(CustomSetup."Store Return Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            "No." := NoSeriesMgt.GetNextNo(InventSetup."Store Return Nos.", WorkDate());
        END;

    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
        "Last Modified Date Time" := CURRENTDATETIME;
        "Last Modified By" := USERID;
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    LOCAL procedure GetNoSeriesCode(): Code[30]
    begin

    end;

    procedure PostIssue()
    begin
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'ISSUE');
        IF ItemJournalLine2.FINDFIRST THEN
            ItemJournalLine2.DELETEALL;
        StoresReturnLine.SETRANGE("Document No.", "No.");
        IF StoresReturnLine.FINDFIRST THEN BEGIN
            REPEAT
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'ISSUE';
                ItemJournalLine."Line No." := StoresReturnLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoresReturnLine."Stock Code");
                ItemJournalLine."Posting Date" := Date;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Document Date" := Date;
                ItemJournalLine."Location Code" := StoresReturnLine."Location Code";
                ItemJournalLine.VALIDATE("Gen. Bus. Posting Group", StoresReturnLine."Gen Bus. Posting Group");
                // ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                ItemJournalLine.VALIDATE(Quantity, StoresReturnLine."Qty to Return");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                if StoresReturnLine."Qty to Return" <> 0 then begin
                    ItemJournalLine.INSERT;
                    StoresReturnLine."Qty Returned" := StoresReturnLine."Qty Returned" + StoresReturnLine."Qty to Return";
                    StoresReturnLine.Modify();
                end
            UNTIL StoresReturnLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);
        END;
        CheckPostedJnl2
    end;

    procedure PostIssuePrint()
    begin
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'ISSUE');
        IF ItemJournalLine2.FINDFIRST THEN
            ItemJournalLine2.DELETEALL;

        StoresReturnLine.SETRANGE("Document No.", "No.");
        IF StoresReturnLine.FINDFIRST THEN BEGIN
            REPEAT
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'ISSUE';
                ItemJournalLine."Line No." := StoresReturnLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoresReturnLine."Stock Code");
                ItemJournalLine."Posting Date" := Date;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Document Date" := Date;
                ItemJournalLine."Location Code" := StoresReturnLine."Location Code";
                ItemJournalLine.VALIDATE("Gen. Bus. Posting Group", StoresReturnLine."Gen Bus. Posting Group");
                // ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                ItemJournalLine.VALIDATE(Quantity, StoresReturnLine."Qty to Return");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                if StoresReturnLine."Qty to Return" <> 0 then begin
                    ItemJournalLine.INSERT;
                    StoresReturnLine."Qty Returned" := StoresReturnLine."Qty Returned" + StoresReturnLine."Qty to Return";
                    StoresReturnLine.Modify();
                end
            UNTIL StoresReturnLine.NEXT = 0;
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post+Print", ItemJournalLine);
        END;
        CheckPostedJnl2
    end;

    procedure TestReport()
    begin
        ItemJournalLine2.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournalLine2.SETRANGE("Journal Batch Name", 'ISSUE');
        IF ItemJournalLine2.FINDFIRST THEN
            ItemJournalLine2.DELETEALL;

        StoresReturnLine.SETRANGE("Document No.", "No.");
        IF StoresReturnLine.FINDFIRST THEN BEGIN
            REPEAT
                ItemJournalLine."Journal Template Name" := 'ITEM';
                ItemJournalLine."Journal Batch Name" := 'ISSUE';
                ItemJournalLine."Line No." := StoresReturnLine."Line No.";
                ItemJournalLine.VALIDATE("Item No.", StoresReturnLine."Stock Code");
                ItemJournalLine."Posting Date" := Date;
                ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Positive Adjmt.";
                ItemJournalLine."Document No." := "No.";
                ItemJournalLine."Document Date" := Date;
                ItemJournalLine."Location Code" := StoresReturnLine."Location Code";
                ItemJournalLine."Gen. Bus. Posting Group" := 'STORE';
                ItemJournalLine.VALIDATE(Quantity, StoresReturnLine."Returned Qty.");
                ItemJournalLine."Dimension Set ID" := "Dimension Set ID";
                ItemJournalLine.INSERT;
                COMMIT;
            UNTIL StoresReturnLine.NEXT = 0;
            ReportPrint.PrintItemJnlLine(ItemJournalLine);
        END;
    end;


    procedure CheckPostedJnl2()
    var
        TotalIssued: Decimal;
    begin
        StoresReturnLine3.SetRange("Document No.", "No.");
        if StoresReturnLine3.FindFirst() then begin
            repeat
                // Message('TotalIssued=%1"Requested Qty."=%2', TotalIssued);
                if StoresReturnLine3."Issued Qty" <> StoresReturnLine3."Qty Returned" then begin
                    TotalIssued := StoresReturnLine3."Qty Returned";
                    // Message('TotalIssued=%1,Issued Qty=%2', TotalIssued, StoresReturnLine3."Issued Qty");
                    Posted := false;
                    MODIFY;
                    exit
                end;
            until StoresReturnLine3.Next() = 0
        end;
        Posted := true;
        MODIFY;

    end;


    // procedure CheckPostedJnl()
    // begin

    //     GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
    //     GLEntry.SETRANGE("Document No.", "No.");
    //     IF GLEntry.FINDFIRST THEN BEGIN
    //         Posted := TRUE;
    //         MODIFY;
    //     END;
    // end;

}