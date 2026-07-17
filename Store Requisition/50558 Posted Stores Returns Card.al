
page 50558 "Posted Stores Returns Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Stores Return";
    RefreshOnActivate = true;
    ApplicationArea = All;
    //SourceTableView = WHERE(Status = CONST(Approved), Posted = CONST(false), "PRQ Processing?" = CONST(false));

    // AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    // Editable = false;

                }
                field("Issue No."; Rec."Issue No.")
                {
                    ApplicationArea = all;

                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                    // Editable = false;

                }

                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    //Editable = false;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field("Project/Job Description"; Rec."Project/Job Description")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Work Order No."; Rec."Work Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                // field("Staff No."; "Staff No.")
                // {
                //     ApplicationArea = All;
                //     Editable = false;

                // }
                // field("Staff Name"; "Staff Name")
                // {
                //     ApplicationArea = All;
                //     Editable = false;

                // }


                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;

                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
            }
            part("Stores Returns Subform"; "Stores Returns Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }

    }


    actions
    {
        area(Processing)
        {
            // action("Create Voucher")
            // {
            //     trigger OnAction()
            //     var
            //         CustSetup: Record "Custom Setup";
            //         CAdvHeader: Record "Cash Advance";
            //         PVHeader: Record "Payment Voucher Header";
            //         PVHeaderNo: Code[20];
            //         NoSeriesMgt: Codeunit NoSeriesManagement;
            //         CAdvLine: Record "Cash Advance Line";
            //         PVLine: Record "Payment Voucher Line";

            //     begin

            //         //Transfer Payment Requisition Header to Payment Voucher Header
            //         CustSetup.GET;
            //         CustSetup.TESTFIELD("Cash Advance Nos.");
            //         CAdvHeader.SetRange("No.", "No.");
            //         if CAdvHeader.FindFirst() then begin
            //             // PVHeader.TransferFields(CAdvHeader);
            //             PVHeaderNo := NoSeriesMgt.GetNextNo(CustSetup."Payment Voucher No.", TODAY, TRUE);
            //             PVHeader."No." := PVHeaderNo;
            //             PVHeader.Date := Date;
            //             PVHeader.Requester := Requester;
            //             PVHeader."No. Series" := "No. Series";
            //             PVHeader.Status := Status;
            //             PVHeader.Type := Type;
            //             PVHeader."Former PR No." := "No.";


            //             PVHeader.Insert();
            //         end;

            //         //Transfer Payment Requisition Line to Payment Voucher Line
            //         CAdvLine.SetRange("Document No.", "No.");
            //         if CAdvLine.FindFirst() then begin
            //             repeat
            //                 PVLine.TransferFields(CAdvLine);
            //                 // PVLine."Document No." := NoSeriesMgt.GetNextNo(CustSetup."Payment Voucher No.", TODAY, TRUE);
            //                 PVLine."Document No." := PVHeaderNo;
            //                 PVLine.Insert();
            //             until CAdvLine.Next() = 0;
            //         end;
            //         CAdvHeader.Treated := true;
            //         CAdvHeader.Modify();
            //     end;
            // }
            action(SendApprovalRequest)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Status <> Rec.Status::Open THEN
                        ERROR('You can not resend the document for approval!');

                    IF Rec.Status = Rec.Status::Approved THEN
                        ERROR('The document is already approved!');

                    DocumentApprovalEntryS.SETRANGE("Document No.", Rec."No.");
                    IF DocumentApprovalEntryS.FINDFIRST THEN
                        ERROR(Text0001, Rec."No.");

                    CAImprestMgt.SETRANGE("No.", Rec."No.");
                    IF CAImprestMgt.FINDFIRST THEN
                        RecID := CAImprestMgt.RECORDID;
                    //DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO,"No.",RecID,0,Date,"Amount (LCY)",Purpose);
                    DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, Rec."No.", RecID, Limit);
                    Rec.Status := Rec.Status::"Pending Approval";
                    Rec.MODIFY;

                end;

            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Status = Rec.Status::Approved THEN
                        ERROR('The document is already approved!');

                    CAImprestMgt.SETRANGE("No.", Rec."No.");
                    IF CAImprestMgt.FINDFIRST THEN
                        RecID := CAImprestMgt.RECORDID;
                    DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, Rec."No.");
                    Rec.Status := Rec.Status::Open;
                    Rec.MODIFY;
                end;

            }
            action(Approve)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Status = Rec.Status::Approved THEN
                        ERROR('The document is already approved!');

                    //DocumentApprovalWorkflow.ApproveDocument(RecID.TABLENO,"No.",RecID);
                    DocumentApprovalWorkflow.ApproveDocument(Rec."No.");
                    IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, Rec."No.", RecID) THEN BEGIN
                        Rec.Status := Rec.Status::Approved;
                        Rec.MODIFY;
                    END;
                    IF CONFIRM('Do you want to open Cash Advance %1?', FALSE, Rec."No.") THEN
                        Page.Run(60023, CashAdvHr)
                    ELSE
                        EXIT;
                end;

            }
            action(Reject)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Status = Rec.Status::Approved THEN
                        ERROR('The document is already approved!');

                    DocumentApprovalWorkflow.RejectDocument(Rec."No.");
                    IF NOT DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, Rec."No.", RecID) THEN BEGIN
                        Rec.Status := Rec.Status::Rejected;
                        Rec.MODIFY;
                    END;
                end;

            }
            // action("Test Report")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         TestReport;
            //     end;

            // }
            // action(Preview)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         PreviewPosting;
            //     end;

            // }
            // action(Post)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         IF Posted = TRUE THEN
            //             ERROR('The Document has been posted previuosly!');
            //         PostCashAdavanceImprest;
            //     end;

            // }
            // action("Post and Print")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         IF Posted = TRUE THEN
            //             ERROR('The Document has been posted previuosly!');
            //         PostPrint;
            //     end;

            // }
        }
    }
    trigger OnOpenPage()
    begin
        IF Rec.Status = Rec.Status::Approved THEN BEGIN
            Mypage := FALSE;
        END
        ELSE BEGIN
            Mypage := TRUE;
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF Rec.Status = Rec.Status::Approved THEN
            ERROR('Modification is not allowed after Approval!');
    end;

    var
        CashAdvHr: Record "Cash Advance";
        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        CAImprestMgt: Record "Cash Advance";
        RecRef: RecordRef;
        RecID: RecordID;
        DocumentApprovalEntryS: Record "Document Approval Entry1";
        Limit: Decimal;
        Mypage: Boolean;
        Text0001: TextConst ENU = 'The Document %1 has previously been sent for Approval';
}