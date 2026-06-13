page 50019 "Pending Purch. Requisition Car"
{
    //Created by Salaam Azeez

    PageType = Card;
    // ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Purch. Requistion";
    // SourceTableView = WHERE(Status = CONST(" "), "Purchase Order Posted" = CONST(false), "Purch. Order Created?" = CONST(false));
    layout
    {
        area(Content)
        {
            group(General)
            {
                // field("User Code 2"; "User Code 2")
                // {
                //     ApplicationArea = All;
                //     Visible = true;
                // }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = All;
                }
                field("Requester"; Rec."Requester")
                {
                    ApplicationArea = All;
                }
                // field("Budget Name"; "Budget Name")
                // {
                //     ApplicationArea = All;
                // }
                // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("Prefered Vendor"; "Prefered Vendor")
                // {
                //     ApplicationArea = All;

                // }
                // field("Prefered Vendor Name"; "Prefered Vendor Name")
                // {
                //     ApplicationArea = All;

                // }
                // field("Purch. Quote Created?"; "Purch. Quote Created?")
                // {
                //     ApplicationArea = All;

                // }
                // field("Purch. Quote Ref. No."; "Purch. Quote Ref. No.")
                // {
                //     ApplicationArea = All;

                // }
                field("Purch. Order Created?"; Rec."Purch. Order Created?")
                {
                    ApplicationArea = All;

                }
                field("Purchase Order Posted"; Rec."Purchase Order Posted")
                {
                    ApplicationArea = All;

                }
                field("SRQ Ref.No."; Rec."SRQ Ref.No.")
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
                // field("Actual User 2"; "Actual User 2")
                // {
                //     ApplicationArea = All;
                // }
                // field("User Code 2"; "User Code 2")
                // {
                //     ApplicationArea = All;
                // }


            }
            group(ListPart)
            {
                part("Purchase Requisition Subform"; "Purchase Requisition Subform")
                {
                    ApplicationArea = basic, suite;
                    SubPageLink = "Document No." = field("No.");
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {

            action("CancelApprovalRequest")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //  TestField("User Code 2");
                    PurchRequistion.SETRANGE("No.", Rec."No.");
                    IF PurchRequistion.FINDFIRST THEN
                        RecID := PurchRequistion.RECORDID;
                    DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, PurchRequistion."No.");
                    Rec.Status := Rec.Status::Open;
                    Rec.MODIFY;
                end;
            }

            action(Approve)
            {
                ApplicationArea = All;
                //  Caption = 'Caption', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //Image = Image;
                trigger OnAction()
                begin
                    //   TestField("User Code 2");
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
                //  Caption = 'Caption', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //Image = Image;
                trigger OnAction()
                begin
                    //    TestField("User Code 2");
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
        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        PurchaseRequisitionHeader: Record "Purch. Requistion";
        PurchRequistion: Record "Purch. Requistion";
        RecID: RecordId;

    trigger OnClosePage()
    begin
        // "User Code 2" := '';
        Rec.Modify();
    end;


}