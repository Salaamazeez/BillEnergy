page 50028 "Store REquisition Card Dummy"
{
    //Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Store Requisition";
    //SourceTableView = WHERE(Status = CONST("Pending Approval"));

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
                    Editable = false;

                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    Editable = false;

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
                field("Requisition Amount "; Rec."Requisition Amount")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
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
            part("Pending Store  Requisition Sub"; "Pending Store  Requisition Sub")
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
            // action("Send Approval Request")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         StoresRequisition.SETRANGE("No.", "No.");
            //         IF StoresRequisition.FINDFIRST THEN
            //             RecID := StoresRequisition.RECORDID;
            //         DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, "No.", RecID, Limit);
            //         MESSAGE('Approval request has been sent');
            //         Status := Status::"Pending Approval";
            //         MODIFY;
            //     end;
            // }
            // action("Post")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         PostIssue()

            //     end;
            // }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    StoresRequisition.SETRANGE("No.", Rec."No.");
                    IF StoresRequisition.FINDFIRST THEN
                        RecID := StoresRequisition.RECORDID;
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
                    DocumentApprovalWorkflow.ApproveDocument(Rec."No.");
                    IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, Rec."No.", RecID) THEN BEGIN
                        DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, Rec."No.", RecID);
                        Rec.Status := Rec.Status::Approved;
                        Rec.MODIFY;
                    END;
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    DocumentApprovalWorkflow.RejectDocument(Rec."No.");
                    IF NOT DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, Rec."No.", RecID) THEN BEGIN
                        Rec.Status := Rec.Status::Rejected;
                        Rec.MODIFY;
                    END;
                end;
            }
            action(ReOpen)
            {
                trigger OnAction()
                begin
                    Rec.ReopenRequisition();
                end;
            }
            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    StoreReqTbl: Record "Store Requisition";
                begin
                    StoreReqTbl.SetRange("No.", Rec."No.");
                    if StoreReqTbl.FindFirst() then
                        Report.RunModal(50500, true, true, StoreReqTbl);
                end;
            }
        }
    }

    var
        myInt: Integer;
        StoresRequisitionLine: Record "Store Requisition Line";
        Text000: TextConst ENU = 'THE STORE REQUISITION  DOES NOT HAVE  INFORMATION ON THE LINE %1';
        StoresRequisition: Record "Store Requisition";
        RecID: RecordId;
        Limit: Decimal;
        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
    //DocumentApprovalWorkflow



    procedure StoreRequisitionLineExist(): Boolean
    begin
        StoresRequisitionLine.RESET;
        StoresRequisitionLine.SETRANGE("Document No.", Rec."No.");
        EXIT(StoresRequisitionLine.FINDFIRST);
    end;

}