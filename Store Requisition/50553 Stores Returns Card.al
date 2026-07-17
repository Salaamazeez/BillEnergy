page 50553 "Stores Returns Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    // ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Stores Return";
    RefreshOnActivate = true;
    SourceTableView = WHERE(Status = CONST(Open), Posted = CONST(false));
    ApplicationArea = All;

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

                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
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
            action("Send Approval Request")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    StoresReturn.SETRANGE("No.", Rec."No.");
                    IF StoresReturn.FINDFIRST THEN
                        RecID := StoresReturn.RECORDID;
                    DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, Rec."No.", RecID, Limit);
                    Rec.Status := Rec.Status::"Pending Approval";
                    Rec.MODIFY;
                end;
            }
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

                trigger OnAction()
                begin
                    StoresReturn.SETRANGE("No.", Rec."No.");
                    IF StoresReturn.FINDFIRST THEN
                        RecID := StoresReturn.RECORDID;
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
                    // DocumentApprovalWorkflow.ApproveDocument("No.");
                    // IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO,"No.",RecID) THEN BEGIN
                    //  Status := Status::Approved;
                    //  MODIFY;
                    // END;
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
        }
    }

    var
        myInt: Integer;
        StoresRequisitionLine: Record "Store Requisition Line";
        Text000: TextConst ENU = 'THE STORE REQUISITION  DOES NOT HAVE  INFORMATION ON THE LINE %1';
        StoresReturn: Record "Stores Return";
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