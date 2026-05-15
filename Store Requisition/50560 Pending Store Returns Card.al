
page 50560 "Pending Store Returns Card"

{

    //Created by Salaam Azeez
    PageType = Card;
    //ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Stores Return";
    RefreshOnActivate = true;
    SourceTableView = WHERE(Status = CONST("Pending Approval"));

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
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;

                }
                // field("Staff No."; "Staff No.")
                // {
                //     ApplicationArea = All;

                // }
                // field("Staff Name"; "Staff Name")
                // {
                //     ApplicationArea = All;

                // }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;

                }
                field("Project/Job Description"; Rec."Project/Job Description")
                {
                    ApplicationArea = All;

                }
                field("Issue No."; Rec."Issue No.")
                {
                    ApplicationArea = All;

                }
                field("Work Order No."; Rec."Work Order No.")
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
            }

            part("Stores Returns Subform"; "Stores Returns Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                // SubPageLink = "Document No." = field("No.");
            }
        }
    }




    actions
    {
        area(Processing)
        {
            // action("Test Report")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         TestReport;
            //     end;
            // }
            // action("Post")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         // TESTFIELD("PRQ Processing?", FALSE);

            //         PostIssue;
            //         Posted := TRUE;
            //         MODIFY;
            //         CheckPostedJnl;

            //     end;
            // }
            // action("Post and &Print")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         PostIssuePrint;
            //         Posted := TRUE;
            //         MODIFY;
            //         CheckPostedJnl;
            //     end;
            // }
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
        RecID: RecordId;
        Limit: Decimal;
        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        StoresReturn: Record "Stores Return";
}
