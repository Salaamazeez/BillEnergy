page 50092 "Appr. Purch. Requisition Cards"
{//Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Purch. Requistion";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                // field("User Code 3"; Rec."User Code 3")
                // {
                //     ApplicationArea = All;
                // }
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
                // field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                // {
                //     ApplicationArea = All;

                // }
                // field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                // {
                //     ApplicationArea = All;

                // }
                // field("Prefered Vendor"; Rec."Prefered Vendor")
                // {
                //     ApplicationArea = All;
                //     ;
                // }
                // field("Prefered Vendor Name"; Rec."Prefered Vendor Name")
                // {
                //     ApplicationArea = All;
                // }
                // field("Purchase Order Posted"; Rec."Purchase Order Posted")
                // {
                //     ApplicationArea = All;
                // }
                field("Purch.Order Ref.No."; Rec."Purch.Order Ref.No.")
                {
                    ApplicationArea = All;
                }
                field("Purch. Order Created?"; Rec."Purch. Order Created?")
                {
                    ApplicationArea = All;
                }
                // field("Quote Code"; Rec."Quote Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("Quote Created"; Rec."Quote Created")
                // {
                //     ApplicationArea = All;
                // }
                field("SRQ Ref.No."; Rec."SRQ Ref.No.")
                {
                    ApplicationArea = All;
                }
                // field("Purchase Invoice Created"; Rec."Purchase Invoice Created")
                // {
                //     ApplicationArea = All;
                // }
                // field("Purchase Invoice Code"; Rec."Purchase Invoice Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("Purchase Invoice Posted"; Rec."Purchase Invoice Posted")
                // {
                //     ApplicationArea = All;
                // }
                field("Requisition Amount"; Rec."Requisition Amount")
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
                // field("Actual User 3"; Rec."Actual User 3")
                // {
                //     ApplicationArea = All;
                // }

            }
            part("Purchase Requisition Subform"; "App Purchase Req. Subform")
            {

                // ApplicationArea = Basic, Suite;
                // Editable = DynamicEditable;
                // Enabled = "Sell-to Customer No." <> '';
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;

                ApplicationArea = basic, suite;
                //  SubPageLink = "Document No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action("Create Purchase Quote")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         TESTFIELD(Status, Status::Approved);
            //         TESTFIELD("Purch. Quote Created?", FALSE);
            //         CreatePurchaseQuote;

            //     end;
            // }
            // action("Create Purchase Invoice")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         TESTFIELD(Status, Status::Approved);
            //         TESTFIELD("Purchase Invoice Created", FALSE);
            //         CreatePurchaseInvoice;

            //     end;
            // }
            action("Create Purchase Order")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //  TestField("User Code 3");
                    Rec.TESTFIELD(Status, Rec.Status::Approved);
                    Rec.TESTFIELD("Purch. Order Created?", FALSE);
                    Rec.CreatePurchaseOrder;

                end;
            }
            // action("ReOpen Requisition")
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         TestStatusOpen;
            //     end;
            // }
            action("Print")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurRequisition: Record "Purch. Requistion";
                begin
                    PurRequisition.SetRange("No.", Rec."No.");
                    if PurRequisition.FindFirst() then
                        //Report.Run(50130,);50102
                        // Report.RunModal(50102, true, true, PurRequisition);
                        Report.RunModal(50162, true, true, PurRequisition);
                end;
            }

        }
    }

    var
        myInt: Integer;

    trigger OnClosePage()
    begin
        // "User Code 3" := '';
        Rec.Modify();
    end;
}