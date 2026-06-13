page 50146 "Purch. Requisition Card"
{
    //Created by Salaam Azeez

    PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Purch. Requistion";
    SourceTableView = WHERE(Status = filter(Open | Rejected));
    layout
    {
        area(Content)
        {
            group(General)
            {
                // field("User Code"; "User Code")
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
                field("Requisition Amount"; Rec."Requisition Amount")
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
                // // field("Prefered Vendor Name"; "Prefered Vendor Name")
                // // {
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
                field(Beneficiary; Rec.Beneficiary)
                {
                    ApplicationArea = All;
                }
                // field("Actual User"; "Actual User")
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
            group(Action13)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                group(Release)
                {
                    action("Re&lease")
                    {
                        ApplicationArea = Basic;
                        Image = ReleaseDoc;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'Ctrl+F9';

                        trigger OnAction()
                        var
                            RecRef: RecordRef;
                            ReleaseDocument: Codeunit "Release Documents";
                        begin
                            PurchRequistion.SETRANGE("No.", Rec."No.");
                            IF PurchRequistion.FINDFIRST THEN
                                RecID := PurchRequistion.RECORDID;
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformanualManualDocRelease(RecRef);
                            CurrPage.Update;
                        end;
                    }
                    action("Re&open")
                    {
                        ApplicationArea = Basic;
                        Image = ReOpen;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        var
                            RecRef: RecordRef;
                            ReleaseDocument: Codeunit "Release Documents";
                        begin
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformManualReopen(RecRef);
                            CurrPage.Update;
                        end;
                    }
                }
            }

            action("Send Approval Request")
            {
                ApplicationArea = All;


                trigger OnAction()
                begin
                    //TestField("User Code");

                    // TotalAmount := "Requisition Amount";
                    PurchRequistion.SETRANGE("No.", Rec."No.");
                    IF PurchRequistion.FINDFIRST THEN
                        RecID := PurchRequistion.RECORDID;
                    // CALCFIELDS("Requisition Amount");
                    DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, Rec."No.", RecID, TotalAmount);
                    // DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO,"No.",RecID,"Requisition Amount");
                    //MESSAGE('Approval request has been sent');
                    //Rec.Status := Rec.Status::"Pending";
                    Rec.MODIFY;

                end;
            }
            action("Item Availability")
            {

            }
            action("CancelApprovalRequest")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PurchRequistion.SETRANGE("No.", Rec."No.");
                    IF PurchRequistion.FINDFIRST THEN
                        RecID := PurchRequistion.RECORDID;
                    DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, PurchRequistion."No.");
                    Rec.Status := Rec.Status::Open;
                    Rec.MODIFY;
                end;
            }

            // action(Approve)
            // {
            //     ApplicationArea = All;
            //     //  Caption = 'Caption', comment = 'NLB="YourLanguageCaption"';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     //Image = Image;
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
            action(Reject)
            {
                ApplicationArea = All;
                // Caption = 'Caption', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //Image = Image;
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
        TotalAmount: Decimal;
        //  LimDocumentApprovalWorkflow: Codeunit "Limited Doc. Approval Workflow";

        DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        PurchaseRequisitionHeader: Record "Purch. Requistion";
        PurchRequistion: Record "Purch. Requistion";
        RecID: RecordId;
        Limit: Decimal;

    trigger OnClosePage()
    begin
        // "User Code" := '';
        // Modify();
    end;

    // trigger OnOpenPage()
    // begin
    //     "User Code" := '';
    //     Modify();
    // end;
}