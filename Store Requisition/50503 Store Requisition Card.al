page 50503 "Store REquisition Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    SourceTable = "Store Requisition";
    SourceTableView = WHERE(Status = const(Open));

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

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;

                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;

                }

                field("Creation  Date"; Rec."Creation  Date")
                {
                    ApplicationArea = All;

                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;

                }
                field("Project/Job Description"; Rec."Project/Job Description")
                {
                    ApplicationArea = All;

                }
                field("Work Order No."; Rec."Work Order No.")
                {
                    ApplicationArea = All;

                }
                field("Requisition Amount "; Rec."Requisition Amount")
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;

                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;

                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;

                }
            }

            part("Stores Req"; "Stores Requisition Subforms")
            {
                Caption = 'Stores Req';
                ApplicationArea = All;
                UpdatePropagation = Both;
                SubPageLink = "Document No." = field("No."), "Location Code" = field(Location);
            }
        }

    }

    actions
    {
        area(Processing)
        {
            // action("Post")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin

            //         PostIssue;
            //         MODIFY;
            //         CheckPostedJnl2;

            //     end;
            // }

            action("Send Approval Request")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF NOT StoreRequisitionLineExist THEN
                        ERROR(Text000, StoresRequisition."No.");
                    StoresRequisitionLine.TESTFIELD("Stock Code");
                    // StoresRequisitionLine.TESTFIELD(Type);

                    StoresRequisition.SETRANGE("No.", Rec."No.");
                    IF StoresRequisition.FINDFIRST THEN
                        RecID := StoresRequisition.RECORDID;
                    DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, Rec."No.", RecID, Limit);
                    // procedure SendApprovalRequest(TableID : Integer;DocNo : Code[10];RecID : RecordID;Limit : Decimal)
                    //MESSAGE('Approval request has been sent');
                    Rec.Status := Rec.Status::"Pending Approval";
                    Rec.MODIFY;
                end;
            }

            action(TestCreateStore)
            {
                ApplicationArea = All;
                Caption = 'Test Create Store req';
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ESSManagement: Codeunit "ESS Management";
                    StoreReqLines: Text;
                    ResponseText: Text;
                begin
                    StoreReqLines := '[{"Type": 0, "StockCode": "ITEM-0001", "Description": "TEST", "UnitOfIssue": "PCS", "LocationCode": "TEST", "RequestedQty": 10, "UnitPrice": 4500, "GenBusPostingGroup": "DOMESTIC"}]';

                    ResponseText := ESSManagement.CreateOrEditStoreRequisition('', '2026-05-18', 'TRIBASE', 'TEST', '', '', StoreReqLines);

                    Message(ResponseText);
                end;
            }

            // action("Cancel Approval Request")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         TESTFIELD(Status, Status::"Pending Approval");
            //         StoresRequisition.SETRANGE("No.", "No.");
            //         IF StoresRequisition.FINDFIRST THEN
            //             RecID := StoresRequisition.RECORDID;
            //         DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, "No.");
            //         Status := Status::Open;
            //         MODIFY;
            //     end;
            // }
            // action(Approve)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         DocumentApprovalWorkflow.ApproveDocument("No.");
            //         IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID) THEN BEGIN
            //             DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID);
            //             Status := Status::Approved;
            //             MODIFY;
            //         END;

            //     end;
            // }
            // action(Reject)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         TESTFIELD(Status, Status::"Pending Approval");
            //         DocumentApprovalWorkflow.RejectDocument("No.");
            //         IF NOT DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID) THEN BEGIN
            //             Status := Status::Rejected;
            //             MODIFY;
            //         END;

            //     end;
            // }
        }
    }

    var
        myInt: Page "Sales Order";
        StoresRequisitionLine: Record "Store Requisition Line";
        Text000: TextConst ENU = 'THE STORE REQUISITION  DOES NOT HAVE  INFORMATION ON THE LINE %1';
        StoresRequisition: Record "Store Requisition";
        RecID: RecordId;
        Limit: Decimal;
        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";



    procedure StoreRequisitionLineExist(): Boolean
    begin
        StoresRequisitionLine.RESET;
        StoresRequisitionLine.SETRANGE("Document No.", Rec."No.");
        EXIT(StoresRequisitionLine.FINDFIRST);
    end;

}