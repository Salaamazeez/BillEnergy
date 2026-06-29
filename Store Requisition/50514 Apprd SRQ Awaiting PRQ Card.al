page 50514 "Apprd SRQ Awaiting PRQ Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Store Requisition";
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
                field("Staff No."; Rec."Staff No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Staff Name"; Rec."Staff Name")
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
            part("Apprv. Stores Req.s Subform"; "Apprv. Stores Req.s Subform")
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
            action("Post")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.PostIssue()

                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Visible = false;

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
                    Visible = false;

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
                    Visible = false;

                trigger OnAction()
                begin

                end;
            }
            action("CreatePurchRequisition")
            {
                Caption = 'Create PRQ';
                ApplicationArea = All;
                    Visible = false;

                trigger OnAction()
                begin
                    IF CONFIRM('This action will create a Purchase Requisition for this request continue?', FALSE) THEN
                        Rec.CreatePurchaseRequisition;
                    MESSAGE(Text50206, PurchReqHeaderRec.TABLECAPTION, PurchReqHeaderRec.FIELDCAPTION("No."), PurchReqHeaderRec."No.", StoreHeaderRec.TABLECAPTION, StoreHeaderRec.FIELDCAPTION("No."), Rec."No.")

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

        PurchReqHeaderRec: Record "Purch. Requistion";
        StoreHeaderRec: Record "Store Requisition";
        Text0001: TextConst ENU = 'PRQ %1  HAS ALREADY BEEN CREATED FOR THIS SRQ %2';
        Text50206: TextConst ENU = '%1  %2  %3  has been created for %4  %5  %6';
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