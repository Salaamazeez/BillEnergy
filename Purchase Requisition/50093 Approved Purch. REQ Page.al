page 50093 "Approved Purch. REQ Page"
{
    //Created by Salaam Azeez
    PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Purch. Requistion";
    Caption = 'Converted Purc. Req. Card';

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
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
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
                field("Requisition Amount"; Rec."Requisition Amount")
                {
                    ApplicationArea = All;
                }
                field("Requester No."; Rec."Requester No.")
                {
                    ApplicationArea = All;
                }
                field("Quote Code"; Rec."Quote Code")
                {
                    ApplicationArea = All;

                }
                field("Quote Created"; Rec."Quote Created")
                {
                    ApplicationArea = All;

                }
                field("Sent Time"; Rec."Sent Time")
                {
                    ApplicationArea = All;

                }
                field("Purchase Order Posted"; Rec."Purchase Order Posted")
                {
                    ApplicationArea = All;

                }
                field("Purch. Order Created?"; Rec."Purch. Order Created?")
                {
                    ApplicationArea = All;

                }
                field("Purch. Invoice  Created"; Rec."Purch. Invoice  Created")
                {
                    ApplicationArea = All;

                }
                field("SRQ Ref.No."; Rec."SRQ Ref.No.")
                {
                    ApplicationArea = All;

                }
                field("Prefered Vendor"; Rec."Prefered Vendor")
                {
                    ApplicationArea = All;
                }
                field("Prefered Vendor Name"; Rec."Prefered Vendor Name")
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
            action("Print")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurRequisition: Record "Purch. Requistion";
                begin
                    PurRequisition.SetRange("No.", Rec."No.");
                    if PurRequisition.FindFirst() then
                        //Report.Run(50130,);
                        Report.Run(50102, true, true, PurRequisition);
                end;
            }
        }        // area(Processing)
        // {
        //     action("Create Purchase Quote")
        //     {
        //         ApplicationArea = All;

        //         trigger OnAction()
        //         begin
        //             CreatePurchaseQuote;
        //         end;
        //     }
        //     action("Create Purchase Invoice")
        //     {
        //         ApplicationArea = All;

        //         trigger OnAction()
        //         begin
        //             IF CONFIRM('This Action Will Create A Purchase Invoice for This requisition, Continue?', FALSE) THEN
        //                 CreatePurchaseInvoice ELSE
        //                 ERROR('No Purchase Invoice Created');
        //         end;
        //     }
        //     action("Create Purchase Order")
        //     {
        //         ApplicationArea = All;

        //         trigger OnAction()
        //         begin
        //             IF CONFIRM('This Action Will Create A Purchase Order for This requisition, Continue?', FALSE) THEN
        //                 CreatePurchaseOrder ELSE
        //                 ERROR('No Purchase Order Created');
        //         end;
        //     }
        // }
    }

    var
        myInt: Integer;

    trigger OnClosePage()
    begin
        // "User Code 3" := '';
        Rec.Modify();
    end;
}