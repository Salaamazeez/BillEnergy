// page 50200 "Appr. Purch. Requis Cards Copy"
// {
//     //Created by Salaam Azeez
//     PageType = Card;
//     // ApplicationArea = All;
//     // UsageCategory = Administration;
//     SourceTable = "Purch. Requistion";

//     layout
//     {
//         area(Content)
//         {
//             group(GroupName)
//             {
//                 field("No."; "No.")
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(Date; Date)
//                 {
//                     ApplicationArea = All;

//                 }
//                 field(Requester; Requester)
//                 {
//                     ApplicationArea = All;

//                 }
//                 // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
//                 // {
//                 //     ApplicationArea = All;

//                 // }
//                 // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
//                 // {
//                 //     ApplicationArea = All;

//                 // }
//                 // field("Prefered Vendor"; "Prefered Vendor")
//                 // {
//                 //     ApplicationArea = All;
//                 //     ;
//                 // }
//                 // field("Prefered Vendor Name"; "Prefered Vendor Name")
//                 // {
//                 //     ApplicationArea = All;
//                 // }
//                 field("Purchase Order Posted"; "Purchase Order Posted")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Purch.Order Ref.No."; "Purch.Order Ref.No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Purch. Order Created?"; "Purch. Order Created?")
//                 {
//                     ApplicationArea = All;
//                 }
//                 // field("Quote Code"; "Quote Code")
//                 // {
//                 //     ApplicationArea = All;
//                 // }
//                 // field("Quote Created"; "Quote Created")
//                 // {
//                 //     ApplicationArea = All;
//                 // }
//                 field("SRQ Ref.No."; "SRQ Ref.No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 // field("Purchase Invoice Created"; "Purchase Invoice Created")
//                 // {
//                 //     ApplicationArea = All;
//                 // }
//                 // field("Purchase Invoice Code"; "Purchase Invoice Code")
//                 // {
//                 //     ApplicationArea = All;
//                 // }
//                 // field("Purchase Invoice Posted"; "Purchase Invoice Posted")
//                 // {
//                 //     ApplicationArea = All;
//                 // }
//                 field("Requisition Amount"; "Requisition Amount")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Last Modified Date Time"; "Last Modified Date Time")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Last Date Modified"; "Last Date Modified")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Last Modified By"; "Last Modified By")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Status; Status)
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//             part("Purchase Requisition Subform"; "Purchase Requisition Subform")
//             {

//                 // ApplicationArea = Basic, Suite;
//                 // Editable = DynamicEditable;
//                 // Enabled = "Sell-to Customer No." <> '';
//                 SubPageLink = "Document No." = FIELD("No.");
//                 UpdatePropagation = Both;

//                 ApplicationArea = basic, suite;
//                 //  SubPageLink = "Document No." = field("No.");
//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             // action("Create Purchase Quote")
//             // {
//             //     ApplicationArea = All;

//             //     trigger OnAction()
//             //     begin
//             //         TESTFIELD(Status, Status::Approved);
//             //         TESTFIELD("Purch. Quote Created?", FALSE);
//             //         CreatePurchaseQuote;

//             //     end;
//             // }
//             // action("Create Purchase Invoice")
//             // {
//             //     ApplicationArea = All;

//             //     trigger OnAction()
//             //     begin
//             //         TESTFIELD(Status, Status::Approved);
//             //         TESTFIELD("Purchase Invoice Created", FALSE);
//             //         CreatePurchaseInvoice;

//             //     end;
//             // }
//             action("Create Purchase Order")
//             {
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     // TESTFIELD(Status, Status::Approved);
//                     // TESTFIELD("Purch. Order Created?", FALSE);
//                     CreatePurchaseOrder;

//                 end;
//             }
//             // action("ReOpen Requisition")
//             // {
//             //     ApplicationArea = All;

//             //     trigger OnAction()
//             //     begin
//             //         TestStatusOpen;
//             //     end;
//             // }
//             action("Print")
//             {
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 var
//                     PurRequisition: Record "Purch. Requistion";
//                 begin
//                     PurRequisition.SetRange("No.", "No.");
//                     if PurRequisition.FindFirst() then
//                         //Report.Run(50130,);
//                         Report.Run(50102, true, true, PurRequisition);
//                 end;
//             }

//         }
//     }

//     var
//         myInt: Integer;
// }